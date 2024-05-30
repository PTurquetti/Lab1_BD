/* Pratica 10

Amanda Valukas Breviglieri Joioso - 4818232
Paulo Henrique Vedovatto Turquetti - 13750791
*/


-- QUESTÃO 1 --------------------------------------------------------------------------------------

-- a) Federacoes sem faccao

CREATE OR REPLACE TRIGGER FEDERACAO_SEM_NACAO
BEFORE INSERT ON FEDERACAO
BEGIN
    
    DELETE FROM FEDERACAO WHERE NOME NOT IN (SELECT F.NOME FROM FEDERACAO F JOIN NACAO N ON F.NOME = N.FEDERACAO);

END;

/*   ANALISANDO 
    Quando vamos inserir uma nova federação, ela não terá nenhuma nação associada devido à implementacao da FK em nacao.
com isso, mesmo se logo após da inserção da dfederacao fizermos a inserçao da nova nacao associada a ela, a existencia de um
trigger que apaga federacoes sem nacao associada executada após cada inserção de uma federação nao permitiria que federeções novas
fossem inseridas. 

    Sendo assim, o que podemos fazer é verificar se alguma federação não possui nação associada antes de cada inserção em FEDERACAO.
Isso irá permitir a existência de uma federação sem nacao a cada inserção,, permitindo que seja inserida a nação associada a ele.

    No entanto. essa solução enfrenta problemas. Caso ocorram updates ou deletes na tabela de nacao que deixem mais federações sem nacao,
elas continuarão existindo até que uma nova inserção de federação seja realizada, possibilitando múltiplas fererações sem nação simultaneamente.

Vamos agora testar o funcionamento do trigger:
*/

-- Inserindo a primeira federação
INSERT INTO FEDERACAO (NOME, DATA_FUND) VALUES ('NOVA FED', SYSDATE);

-- Consulta que mostra federacoes sem nacao associada
SELECT * FROM FEDERACAO WHERE NOME NOT IN (SELECT F.NOME FROM FEDERACAO F JOIN NACAO N ON F.NOME = N.FEDERACAO);
-- NOVA FED	 28/05/24

-- Inserindo uma nova federacao (ativacao do trigger)
INSERT INTO FEDERACAO (NOME, DATA_FUND) VALUES ('MAIS NOVA', SYSDATE);

-- Consulta que mostra federacoes sem nacao associada
SELECT * FROM FEDERACAO WHERE NOME NOT IN (SELECT F.NOME FROM FEDERACAO F JOIN NACAO N ON F.NOME = N.FEDERACAO);
-- MAIS NOVA	28/05/24

-- Consulta mostrando as federacoes teste que estamos utilizando
SELECT * FROM FEDERACAO WHERE NOME IN ('NOVA FED', 'MAIS NOVA');
--MAIS NOVA 	28/05/24

/* Portanto, podemos notar que antes de inserirmos MAIS NOVA, a federacao NOVA FED pode existir sem nacao associada.
No entando, NOVA FED foi deletada quando a inserção de MAIS NOVA ativou o trigger, tornando MAIS NOVA a unica federacao sem nacao
( lembrando que deletes e updates en NACAO podem deixar mais federacoes sem nacao enquanto não houver outra insercao em federacao.

*/
-- Apagando dados de teste
DELETE FROM FEDERACAO WHERE NOME = 'MAIS NOVA';




-- b)O líder de uma facção deve estar associado a uma nação em	que	a facção está presente.	
CREATE OR REPLACE TRIGGER LIDER_NACAO_FACCAO
BEFORE INSERT OR UPDATE ON NACAO_FACCAO
FOR EACH ROW
DECLARE
    V_COUNT INTEGER;
BEGIN
    -- VERIFICA SE O LIDER VEM DE UMA NACAO DOMINADA PELA FACCAO QUE CONTROLA
    SELECT COUNT(*) INTO V_COUNT FROM 
        LIDER L JOIN FACCAO F ON L.CPI = F.LIDER
        WHERE :NEW.NACAO = L.NACAO;

    -- SE 0, LIDER NAO EH DE NACAO DOMINADA PELA FACCAO
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'O líder da facção deve estar associado à nação em que a facção está presente.');
    END IF;
END;

/* ANALISANDO

De acordo com a implementação dos relacionamentos entre as tabelas envolvidas nesse caso, percebemos que as inserções
de dados consistentes deverão obrigatoriamente seguir a odem NACAO -> LIDER -> FACCAO -> NACAO_FACCAO. Por isso, optamos por
verificar a consistencia de LIDER.NACAO e NACAO_FACCAO.NACAO antes de cada inserção ou update na tabela NACAO_FACCAO. Isso irá garantir
que a nação do lider seja controlada por uma faccao que ele comanda

*/

--INSERCAO DE DADOS PARA TESTE

-- Caso 1 - Insercões de dados que cumprem o requisito - LIDER.NACAO = NACAO_FACCAO.NACAO
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('111.111.111-11', 'Capitã Aria No', 'CIENTISTA', 'Quam quia ad.', 'Quidem quam');
INSERT INTO FACCAO (NOME, LIDER, IDEOLOGIA, QTD_NACOES) VALUES ('Prog Celestiais', '111.111.111-11', 'PROGRESSITA', 3);
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Quam quia ad.', 'Prog Celestiais');
-- A inserção da tupla de NAÇÃO_FACCAO foi permitida

-- Caso 2 - Inserção de dados que não cumprem o requisito - LIDER.NACAO != NACAO_FACCAO.NACAO
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('222.222.222-22', 'General Zorg', 'COMANDANTE', 'Veniam est.', 'Unde eius at');
INSERT INTO FACCAO (NOME, LIDER, IDEOLOGIA, QTD_NACOES) VALUES ('Cons Cósmicos', '222.222.222-22', 'TRADICIONALISTA', NULL);
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Modi porro ut.', 'Cons Cósmicos');

/*
Erro a partir da linha : 11 no comando -
UPDATE NACAO_FACCAO SET NACAO = 'Vel rerum unde.' WHERE FACCAO = 'Prog Celestiais'
Erro na Linha de Comandos : 11 Coluna : 8
Relatório de erros -
Erro de SQL: ORA-20001: O líder da facção deve estar associado à nação em que a facção está presente.
ORA-06512: em "A13750791.LIDER_NACAO_FACCAO", line 11
ORA-04088: erro durante a execução do gatilho 'A13750791.LIDER_NACAO_FACCAO'

OBS: Recebemos o bloqueio esperado!
*/

-- Caso 3 - Update de NACAO_FACCAO fazendo com que o requisito não seja mais cumprido - LIDER.NACAO != :NEW.NACAO
UPDATE NACAO_FACCAO SET NACAO = 'Vel rerum unde.' WHERE FACCAO = 'Prog Celestiais';
/*
Erro a partir da linha : 11 no comando -
UPDATE NACAO_FACCAO SET NACAO = 'Vel rerum unde.' WHERE FACCAO = 'Prog Celestiais'
Erro na Linha de Comandos : 11 Coluna : 8
Relatório de erros -
Erro de SQL: ORA-20001: O líder da facção deve estar associado à nação em que a facção está presente.
ORA-06512: em "A13750791.LIDER_NACAO_FACCAO", line 11
ORA-04088: erro durante a execução do gatilho 'A13750791.LIDER_NACAO_FACCAO'

OBS: Recebemos o bloqueio esperado!

SELECT * FROM NACAO_FACCAO;
Quam quia ad.	Prog Celestiais

Vemos que a operacao UPDATE não foi realizada
*/



-- c) A	quantidade	de	nações,	na	tabela	Faccao dever	estar	sempre	atualizada.	

CREATE OR REPLACE TRIGGER FACCAO_QTDNACOES
AFTER INSERT OR UPDATE OR DELETE ON NACAO_FACCAO
BEGIN
    -- Atualiza a quantidade de nações na tabela FACCAO
    UPDATE FACCAO F
    SET QTD_NACOES = (SELECT COUNT(*) FROM NACAO_FACCAO NF WHERE NF.FACCAO = F.NOME);
END;

-- Insercao de dados para teste

-- Inserindo lideres para cumprir FK de faccao
    INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('111.111.111-11', 'Capitã Aria No', 'CIENTISTA', 'Quam quia ad.', 'Quidem quam');
    INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('222.222.222-22', 'General Zorg', 'COMANDANTE', 'Veniam est.', 'Unde eius at');
    INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('333.333.333-33', 'Buzz Lightyear', 'OFICIAL', 'Modi porro ut.', 'Iure sunt quas');

-- Inserindo faccoes com valor null em qtd_nacoes
    INSERT INTO FACCAO (NOME, LIDER, IDEOLOGIA, QTD_NACOES) VALUES ('Prog Celestiais', '111.111.111-11', 'PROGRESSITA', NULL);
    INSERT INTO FACCAO (NOME, LIDER, IDEOLOGIA, QTD_NACOES) VALUES ('Cons Cósmicos', '222.222.222-22', 'TRADICIONALISTA', NULL);
    INSERT INTO FACCAO (NOME, LIDER, IDEOLOGIA, QTD_NACOES) VALUES ('Prog e Além', '333.333.333-33', 'PROGRESSITA', NULL);


-- buscando quantidade de nacoes de cada faccao
    SELECT NOME, QTD_NACOES FROM FACCAO;

/*
NOME             QTD_NACOES
Prog Celestiais	    0
Cons Cósmicos	    0
Prog e Além	        0
*/

-- Inserindo dados em NACAO_FACCAO
    INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Quam quia ad.', 'Prog Celestiais');
    INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Veniam est.', 'Cons Cósmicos');
    INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Modi porro ut.', 'Prog e Além');
    INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Veniam est.', 'Prog e Além');

-- Nova busca
    SELECT NOME, QTD_NACOES FROM FACCAO;

/*
NOME             QTD_NACOES
Prog Celestiais	    1
Cons Cósmicos	    1
Prog e Além	        2
*/

-- Deletando dados de NACAO_FACAO
DELETE FROM NACAO_FACCAO;
-- buscando quantidade de nacoes de cada faccao
    SELECT NOME, QTD_NACOES FROM FACCAO;

/*
NOME             QTD_NACOES
Prog Celestiais	    0
Cons Cósmicos	    0
Prog e Além	        0
*/




-- d) Na tabela Nacao, o atributo qtd_planetas deve considerar somente dominâncias atuais.
CREATE OR REPLACE TRIGGER NACAO_QTDPLANETAS
AFTER INSERT OR UPDATE OR DELETE ON DOMINANCIA
BEGIN
    -- Atualiza a quantidade de nações na tabela FACCAO
    UPDATE NACAO N
    SET QTD_PLANETAS = (SELECT COUNT(*) FROM DOMINANCIA WHERE NACAO = N.NOME AND DATA_FIM IS NULL);
END;



-- Inserindo dados para teste do trigger
INSERT INTO DOMINANCIA (PLANETA, NACAO, DATA_INI, DATA_FIM) VALUES ('Quae possimus.', 'Quo labore.', TO_DATE('2021-10-28', 'YYYY-MM-DD'), NULL);
INSERT INTO DOMINANCIA (PLANETA, NACAO, DATA_INI, DATA_FIM) VALUES ('In magni quas.', 'Quo labore.', TO_DATE('2021-10-28', 'YYYY-MM-DD'), NULL);
INSERT INTO DOMINANCIA (PLANETA, NACAO, DATA_INI, DATA_FIM) VALUES ('Quia eum.', 'Quo labore.', TO_DATE('2021-10-28', 'YYYY-MM-DD'), TO_DATE('2024-05-18', 'YYYY-MM-DD'));


SELECT NOME, QTD_PLANETAS FROM NACAO WHERE NOME = 'Quo labore.';
--Quo labore.	2

-- Trocando a primeira dominancia inserida
UPDATE DOMINANCIA SET NACAO = 'Iure ex rem.' WHERE NACAO = 'Quo labore.' AND PLANETA = 'Quae possimus.';


SELECT NOME, QTD_PLANETAS FROM NACAO WHERE NOME IN ('Iure ex rem.', 'Quo labore.');
/*
Iure ex rem.	1
Quo labore.	    1
*/

-- Deletando dados de dominancia
DELETE FROM DOMINANCIA;

-- Buscando novamente as nacoes
SELECT NOME, QTD_PLANETAS FROM NACAO WHERE NOME IN ('Iure ex rem.', 'Quo labore.');
/*
Iure ex rem.	0
Quo labore.	    0
*/



-- QUESTÃO 2 --------------------------------------------------------------------------------------

--FAZENDO DROP DO TRIGGER CRIADO ANTERIORMENTE POIS HA CONFLITO COM OS DADOS A SEREM INSERIDOS
DROP TRIGGER LIDER_NACAO_FACCAO;

-- INSERCAO DE DADOS PARA TESTE


INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('111.111.111-11', 'Capitã Aria No', 'CIENTISTA', 'Quam quia ad.', 'Quidem quam');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('222.222.222-22', 'General Zorg', 'COMANDANTE', 'Veniam est.', 'Unde eius at');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('333.333.333-33', 'Buzz Lightyear', 'OFICIAL', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('444.444.444-44', 'Palpatine', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('555.555.555-55', 'Luke Sky', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('666.666.666-66', 'Spock', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('777.777.777-77', 'Groot', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');


-- Inserindo dados na tabela FACCAO
INSERT INTO FACCAO (NOME, LIDER, IDEOLOGIA, QTD_NACOES) VALUES ('Prog Celestiais', '111.111.111-11', 'PROGRESSITA', 3);
INSERT INTO FACCAO (NOME, LIDER, IDEOLOGIA, QTD_NACOES) VALUES ('Cons Cósmicos', '222.222.222-22', 'TRADICIONALISTA', NULL);
INSERT INTO FACCAO (NOME, LIDER, IDEOLOGIA, QTD_NACOES) VALUES ('Prog e Além', '333.333.333-33', 'PROGRESSITA', NULL);

-- Inserindo dados na tabela NACAOFACCAO
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Quam quia ad.', 'Prog Celestiais');
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Veniam est.', 'Cons Cósmicos');
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Modi porro ut.', 'Prog e Além');
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Vel rerum unde.', 'Prog Celestiais');
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Ducimus odio.', 'Prog Celestiais');
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Veniam est.', 'Prog e Além');

INSERT INTO DOMINANCIA (NACAO, PLANETA, DATA_INI) VALUES ('Quam quia ad.', 'Quae possimus.', SYSDATE);
INSERT INTO DOMINANCIA (NACAO, PLANETA, DATA_INI) VALUES ('Veniam est.', 'Quae possimus.', SYSDATE);
INSERT INTO DOMINANCIA (NACAO, PLANETA, DATA_INI) VALUES ('Modi porro ut.', 'Quae possimus.', SYSDATE);
INSERT INTO DOMINANCIA (NACAO, PLANETA, DATA_INI) VALUES ('Vel rerum unde.', 'Quae possimus.', SYSDATE);
INSERT INTO DOMINANCIA (NACAO, PLANETA, DATA_INI) VALUES ('Ducimus odio.', 'Quae possimus.', SYSDATE);


INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Id illum fugit', 'COMUNIDADE 1', 100);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Libero magni', 'COMUNIDADE 2', 100);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Rerum optio', 'COMUNIDADE 3', 100);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Neque eaque ad', 'COMUNIDADE 4', 100);


INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI) VALUES ('Quae possimus.',  'Id illum fugit', 'COMUNIDADE 1', SYSDATE);
INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI) VALUES ('Quae possimus.',  'Libero magni', 'COMUNIDADE 2', SYSDATE);
INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI) VALUES ('Quae possimus.',  'Rerum optio', 'COMUNIDADE 3', SYSDATE);
INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI) VALUES ('Quae possimus.',  'Neque eaque ad', 'COMUNIDADE 4', SYSDATE);

INSERT INTO PARTICIPA (FACCAO, ESPECIE, COMUNIDADE) VALUES ( 'Prog Celestiais', 'Id illum fugit', 'COMUNIDADE 1');
INSERT INTO PARTICIPA (FACCAO, ESPECIE, COMUNIDADE) VALUES ( 'Prog Celestiais', 'Libero magni', 'COMUNIDADE 2');
INSERT INTO PARTICIPA (FACCAO, ESPECIE, COMUNIDADE) VALUES ( 'Cons Cósmicos', 'Rerum optio', 'COMUNIDADE 3');



-- CRIANDO VIEW
CREATE OR REPLACE VIEW VIEW_LIDER AS
 SELECT 
    L.NOME AS LIDER,
    F.NOME AS FACCAO,
    N.NOME AS NACAO,
    D.PLANETA AS PLANETA,
    H.COMUNIDADE AS COMUNIDADE,
    H.ESPECIE AS ESPECIE,
    
    CASE WHEN EXISTS 
        (SELECT * FROM PARTICIPA P 
        WHERE P.ESPECIE = H.ESPECIE AND P.COMUNIDADE = H.COMUNIDADE)
    THEN 'SIM'
    ELSE 'NAO'
    END AS PERTENCE_A_FACCAO
    
    FROM 
    LIDER L JOIN FACCAO F ON L.CPI = F.LIDER 
    JOIN NACAO_FACCAO NF ON F.NOME = NF.FACCAO
    JOIN NACAO N ON NF.NACAO = N.NOME
    JOIN DOMINANCIA D ON D.NACAO = N.NOME
    LEFT JOIN HABITACAO H ON H.PLANETA = D.PLANETA;


-- TENTANDO INSERIR NA VIEW
INSERT INTO VIEW_LIDER (FACCAO, COMUNIDADE, ESPECIE) VALUES ('Prog e Além', 'COMUNIDADE 3', 'Rerum optio'); 

/*
Erro a partir da linha : 3 no comando -
INSERT INTO VIEW_LIDER (FACCAO, COMUNIDADE, ESPECIE) VALUES ('Prog e Além', 'COMUNIDADE 3', 'Rerum optio')
Erro na Linha de Comandos : 3 Coluna : 25
Relatório de erros -
Erro de SQL: ORA-01779: não é possível modificar uma coluna que mapeie uma tabela não preservada pela chave
01779. 00000 -  "cannot modify a column which maps to a non key-preserved table"
*Cause:    An attempt was made to insert or update columns of a join view which
           map to a non-key-preserved table.
*Action:   Modify the underlying base tables directly.
*/

-- CRIANDO TRIGGER PARA FAZER INSERCAO
CREATE OR REPLACE TRIGGER INSERE_PARTICIPA_VIEW
INSTEAD OF INSERT ON VIEW_LIDER

BEGIN
    INSERT INTO PARTICIPA (FACCAO, ESPECIE, COMUNIDADE) VALUES (:NEW.FACCAO, :NEW.ESPECIE, :NEW.COMUNIDADE);
    
END INSERE_PARTICIPA_VIEW;

-- iNSERINDO O DADO
INSERT INTO VIEW_LIDER (FACCAO, COMUNIDADE, ESPECIE) VALUES ('Prog e Além', 'COMUNIDADE 3', 'Rerum optio'); 
--1 linha inserido.

-- EXIBINDO DADO INSERIDO NA TABELA PARTICIPA
SELECT * FROM PARTICIPA WHERE FACCAO = 'Prog e Além' AND COMUNIDADE = 'COMUNIDADE 3' AND ESPECIE = 'Rerum optio';
-- Prog e Além	Rerum optio	COMUNIDADE 3






