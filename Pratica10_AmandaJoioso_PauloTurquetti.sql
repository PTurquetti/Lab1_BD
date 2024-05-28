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
/*






