/* Pratica 4

Amanda Valukas Breviglieri Joioso - 4818232
Paulo Henrique Vedovatto Turquetti - 13750791
*/

-- Inserindo dados novos para a realização e teste das buscas:

-- Inserindo dados na tabela LIDER
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('111.111.111-11', 'Capitã Aria No', 'CIENTISTA', 'Quam quia ad.', 'Quidem quam');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('222.222.222-22', 'General Zorg', 'COMANDANTE', 'Veniam est.', 'Unde eius at');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('333.333.333-33', 'Buzz Lightyear', 'OFICIAL', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('444.444.444-44', 'Darth Vader', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('555.555.555-55', 'Luke Sky', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('666.666.666-66', 'Spok', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('777.777.777-77', 'Groot', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');


-- Inserindo dados na tabela FACCAO
INSERT INTO FACCAO (NOME, LIDER, IDEOLOGIA, QTD_NACOES) VALUES ('Prog Celestiais', '111.111.111-11', 'PROGRESSITA', 3);
INSERT INTO FACCAO (NOME, LIDER, IDEOLOGIA, QTD_NACOES) VALUES ('Cons Cósmicos', '222.222.222-22', 'TRADICIONALISTA', NULL);
INSERT INTO FACCAO (NOME, LIDER, IDEOLOGIA, QTD_NACOES) VALUES ('Prog e Além', '333.333.333-33', 'PROGRESSITA', NULL);

-- Inserindo dados na tabela NACAOFACCAO
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Quam quia ad.', 'Prog Celestiais');
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Veniam est.', 'Cons Cósmicos');
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Modi porro ut.', 'Prog e Além');

-- Inserindo dados na tabela ORBITAPLANETA
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Eum iure animi.', 'Gl 539', 50, 100, 365);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Deserunt aut.', 'Zet2Mus', 100, 200, 687);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Autem beatae.', '21    Mon', 100, 200, 687);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Autem beatae.', 'GJ 3579', 100, 200, 687);


-- QUESTAO 1 -------------------------------------------------------------------------------------------------------------

-- 1)

--Criando view:
CREATE OR REPLACE VIEW VIEW_FACCAO AS
    SELECT NOME, LIDER 
    FROM FACCAO
    WHERE UPPER(IDEOLOGIA) = 'PROGRESSITA'
WITH READ ONLY;

-- a) Consulta que retorna o número de facções progressistas;
SELECT COUNT(*)FROM VIEW_FACCAO;



-- b) Usando a view, teste uma operação de inserção. Explique o resultado.
INSERT INTO VIEW_FACCAO VALUES ('Uspianos', '111.111.111-11');

/* Ao tentar rodar essa inserção, recebemos uma mesnsagem dizendo que não é possível realizar essa operação. Isso porque
essa view não é atualizável, já que possui WITH READ ONLY. Sendo assim, não será possível fazer operações de inserção,
alteração ou remoção de dados. */




-- QUESTAO 2 -------------------------------------------------------------------------------------------------------------

-- Crie duas views atualizáveis das faccoes (nome, lider, ideologia)

-- a) View que permite a insercao de faccoes nao tradicionalistas:
CREATE OR REPLACE VIEW VIEW_FACCAO_2 AS
    SELECT NOME, LIDER, IDEOLOGIA
    FROM FACCAO
    WHERE UPPER(IDEOLOGIA) = 'TRADICIONALISTA';

-- Inserindo uma faccao tradicionalista na viwe:
INSERT INTO VIEW_FACCAO_2 VALUES ('Uspianos', '444.444.444-44', 'TRADICIONALISTA');


-- Inserindo uma facção não tradicionalista na view:
INSERT INTO VIEW_FACCAO_2 VALUES ('Jedis do Bem', '555.555.555-55', 'PROGRESSITA');

/* 

Tabela FACCAO:
Prog Celestiais	111.111.111-11	PROGRESSITA	3
Cons Cósmicos	222.222.222-22	TRADICIONALISTA	
Prog e Além	333.333.333-33	PROGRESSITA	
Uspianos	444.444.444-44	TRADICIONALISTA	
Jedis do Bem	555.555.555-55	PROGRESSITA	

Tabela VIEW_FACCAO_2
Cons Cósmicos	222.222.222-22	TRADICIONALISTA
Uspianos	444.444.444-44	TRADICIONALISTA

Podemos analisar que, ao fazermos o insert na nossa view, ambas as tuplas foram inseridas na tabela FACCAO.
No entanto, ao vizualizar a nossa view, iremos encontrar somente a tupla correspondente à faccao TRADICIONALISTA.
Isso acontece devido a clausula WHERE UPPER(IDEOLOGIA) = 'TRADICIONALISTA' na nossa view.

*/


-- b)  View que não permite a insercao de faccoes nao tradicionalistas:
CREATE OR REPLACE VIEW VIEW_FACCAO_3 AS
    SELECT NOME, LIDER, IDEOLOGIA
    FROM FACCAO
    WHERE UPPER(IDEOLOGIA) = 'TRADICIONALISTA'
WITH CHECK OPTION;

-- Inserindo uma faccao tradicionalista na view:
INSERT INTO VIEW_FACCAO_3 VALUES ('StarTrack', '666.666.666-66', 'TRADICIONALISTA');
-- INSERIDO COM SUCESSO

-- Inserindo uma faccao tradicionalista na view:
INSERT INTO VIEW_FACCAO_3 VALUES ('G. Galaxias', '777.777.777-77', 'PROGRESSITA');
-- ERRO: violação da cláusula where da view WITH CHECK OPTION

/* Nessa view, adicionamos o comando WITH CHECK OPTION, responsavel por permitir somente atualizações que respeitem
a cláusula WHERE. Com isso, serão permitidos inserções apenas de facções tradicionalistas.

Tabela FACCAO
Prog Celestiais	111.111.111-11	PROGRESSITA	3
Cons Cósmicos	222.222.222-22	TRADICIONALISTA	
Prog e Além	333.333.333-33	PROGRESSITA	
Uspianos	444.444.444-44	TRADICIONALISTA	
Jedis do Bem	555.555.555-55	PROGRESSITA	
StarTrack	666.666.666-66	TRADICIONALISTA	

Tabela VIEQ_FACCAO_3
Cons Cósmicos	222.222.222-22	TRADICIONALISTA
Uspianos	444.444.444-44	TRADICIONALISTA
StarTrack	666.666.666-66	TRADICIONALISTA

Podemos ver que tanto na tabela FACCAO quanto na nossa view foi inserido somente a tupla referente à facção tradicionalista

*/






























