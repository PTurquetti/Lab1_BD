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
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Vel rerum unde.', 'Prog Celestiais');
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Ducimus odio.', 'Prog Celestiais');
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Veniam est.', 'Prog e Além');

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




-- QUESTAO 3 -------------------------------------------------------------------------------------------------------------


/* A view VIEW_ORBITA_PLANETA_ESTRELA seleciona o nome, as coordenadas da estrela e o ID e classificação dos planetas que a
orbitam, combinando dados das tabelas ORBITA_PLANETA, ESTRELA e PLANETA por meio de joins. */

CREATE VIEW VIEW_ORBITA_PLANETA_ESTRELA AS
SELECT E.NOME AS NOME_ESTRELA, E.X AS COORD_X, E.Y AS COORD_Y, E.Z AS COORD_Z,
    OP.PLANETA AS ID_PLANETA, P.CLASSIFICACAO AS CLASSIFICACAO_PLANETA
FROM ORBITA_PLANETA OP
JOIN ESTRELA E ON OP.ESTRELA = E.ID_ESTRELA
JOIN PLANETA P ON OP.PLANETA = P.ID_ASTRO;

-- a)

-- Para determinar se a view é atualizavel ou não, foram realizadas as seguintes operações:

INSERT INTO VIEW_ORBITA_PLANETA_ESTRELA (NOME_ESTRELA, COORD_X, COORD_Y, COORD_Z, ID_PLANETA, CLASSIFICACAO_PLANETA)
VALUES ('Estrela da Morte', 10, 20, 30, 'Alderaan', 'Destruido');

UPDATE VIEW_ORBITA_PLANETA_ESTRELA
SET NOME_ESTRELA = 'Estrela da Morte'
WHERE NOME_ESTRELA = 'Menkent';

DELETE FROM VIEW_ORBITA_PLANETA_ESTRELA
WHERE NOME_ESTRELA = 'Menkent';

/* Para as operações de insert e update foi retornado um erro, pois a view VIEW_ORBITA_PLANETA_ESTRELA é baseada
em um JOIN de três tabelas (ORBITA_PLANETA, ESTRELA e PLANETA). Cada uma dessas tabelas tem sua própria chave primária
(ID_ESTRELA para ESTRELA, ID_ASTRO para PLANETA e a combinação de PLANETA e ESTRELA para ORBITA_PLANETA). No entanto, a
view não preserva essas chaves primárias porque uma única linha na view pode corresponder a várias linhas nas tabelas base
devido ao JOIN, o que pode ser percebido claramente na falha em tentar fazer um insert ou update. Já no caso do delete, ele
funcionou e excluiu a tupla correspondente da tabela ORBITA_PLANETA, o delete, diferente do insert e do update, funcionou
pois  a operação de delete pode ser mapeada de forma única para uma operação de delete em uma das tabelas base. Nesse caso,
a tabela que aparece primeiro na lista FROM do comando CREATE VIEW, que é a tabela ORBITA_PLANETA. Assim, a view não é completamente
atualizável. */

-- b)

SELECT NOME_ESTRELA, COUNT(ID_PLANETA) AS QUANTIDADE_PLANETAS
FROM VIEW_ORBITA_PLANETA_ESTRELA
GROUP BY NOME_ESTRELA;

/* 
Essa consulta agrupa os registros na view pelo nome da estrela e conta o número de planetas (ID_PLANETA) para cada grupo, que é
o nome da estrela (NOME_ESTRELA). O resultado é a quantidade de planetas que orbitam cada estrela, no caso 3 (depois do delete no
item anterior).
*/

-- QUESTAO 4 -------------------------------------------------------------------------------------------------------------

/* A view VIEW_LIDER seleciona o CPI, o nome, cargo, nação, espécie e planeta do líder,
combinando dados das tabelas LIDER, NACAO e ESPECIE por meio de joins. */

CREATE VIEW VIEW_LIDER AS
SELECT L.CPI, L.NOME, L.CARGO, L.NACAO, N.FEDERACAO, L.ESPECIE, E.PLANETA_OR
FROM LIDER L
JOIN NACAO N ON L.NACAO = N.NOME
JOIN ESPECIE E ON L.ESPECIE = E.NOME;

-- a)
/* A view VIEW_LIDER é baseada em um JOIN de três tabelas (LIDER, NACAO e ESPECIE). Cada uma 
dessas tabelas tem sua própria chave primária (CPI para LIDER, NOME para NACAO e NOME para ESPECIE). 
A view preserva essas chaves primárias e portanto, a view é atualizável para operações de 
INSERT, UPDATE e DELETE.
*/

-- b)

INSERT INTO VIEW_LIDER (CPI, NOME, CARGO, NACAO, FEDERACAO, ESPECIE, PLANETA_OR)
VALUES ('444.444.444-44', 'Anakin Sky.', 'COMANDANTE', 'Mustafar', 'Lado Negro', 'Humano', 'Tatooine');

-- Erro de SQL: ORA-01776: não é possível modificar mais de uma vez uma tabela de base através da view de junção
/* 
A view VIEW_LIDER é baseada em um JOIN de três tabelas (LIDER, NACAO e ESPECIE). Quando tentamos inserir um novo registro na view,
foi obtido um erro diferente da questão anterior, agora ao invés de acusar que não foram preservadas as chaves da tabela base, ele
acusa que não é possível modificar mais de uma tabela de base através da view. O banco de dados precisa saber em qual tabela base
o novo registro deve ser inserido. No entanto, a instrução INSERT criada tenta inserir valores que pertencem a mais de uma tabela 
base (LIDER, NACAO e ESPECIE), o que causa o erro.
*/

/* Entretanto, se dividimos os inserts, como feito abaixo, funciona normalmente. Percebemos que dividindo os inserts de forma que
quando atualizamos a view agora estamos apenas inserindo dados da tabela LIDER e não das três tabelas base ao mesmo tempo. Dessa forma
o resultado de SELECT * FROM VIEW_LIDER mostra o novo lider adicionado e, a partir dos JOINS entre as tabelas, os dados que ficaram de fora
do insert direto na view puderam ser adicionados a tabela normalmente. Isso foi possível pois para a criação dessa view as chaves foram
preservadas.*/

INSERT INTO planeta (id_astro,massa,raio,classificacao) VALUES ('Tatooine',58431.15,25999.94,'Modi eos quisquam officiis ratione iure.');
INSERT INTO especie (nome,planeta_or,inteligente) VALUES ('Humano','Tatooine','V');
INSERT INTO federacao (nome,data_fund) VALUES ('Lado Negro',TO_DATE('1976-10-21 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO nacao (NOME, FEDERACAO) VALUES ('Mustafar', 'Lado Negro');

INSERT INTO VIEW_LIDER (CPI, NOME, CARGO, NACAO, ESPECIE)
VALUES ('444.444.444-44', 'Anakin Sky.', 'COMANDANTE', 'Mustafar', 'Humano');

/* 
CPI            | NOME           | CARGO    | NACAO        | FEDERACAO        | ESPECIE    | PLANETA_OR
444.444.444-44	Anakin Sky.	    COMANDANTE	Mustafar	    Lado Negro	    Humano	        Tatooine
111.111.111-11	Capitã Aria No	CIENTISTA 	Quam quia ad.	Cum eum ex.	    Quidem quam	    HATS-8 b
222.222.222-22	General Zorg	COMANDANTE	Veniam est.	    Quo est amet.	Unde eius at	In vero.
333.333.333-33	Buzz Lightyear	OFICIAL   	Modi porro ut.	Sunt fuga ex.	Iure sunt quas	Est ab in.

As colunas FEDERACAO e PLANETA_OR foram adicionadas pelo JOIN a partir dos dados que adicionamos lidando apenas com os atributos da
tabela LIDER na VIEW_LIDER
*/

-- Com a chave preservada, conseguimos fazer o update e o delete normalmente também

UPDATE VIEW_LIDER
SET NOME = 'Darth Vader'
WHERE CPI = '444.444.444-44';

/* 
CPI            | NOME           | CARGO    | NACAO        | FEDERACAO        | ESPECIE    | PLANETA_OR
444.444.444-44	Darth Vader	    COMANDANTE	Mustafar	    Lado Negro	    Humano	        Tatooine
111.111.111-11	Capitã Aria No	CIENTISTA 	Quam quia ad.	Cum eum ex.	    Quidem quam	    HATS-8 b
222.222.222-22	General Zorg	COMANDANTE	Veniam est.	    Quo est amet.	Unde eius at	In vero.
333.333.333-33	Buzz Lightyear	OFICIAL   	Modi porro ut.	Sunt fuga ex.	Iure sunt quas	Est ab in.
*/

DELETE FROM VIEW_LIDER WHERE CPI = '444.444.444-44';

/* 
CPI            | NOME           | CARGO    | NACAO        | FEDERACAO        | ESPECIE    | PLANETA_OR
111.111.111-11	Capitã Aria No	CIENTISTA 	Quam quia ad.	Cum eum ex.	    Quidem quam	    HATS-8 b
222.222.222-22	General Zorg	COMANDANTE	Veniam est.	    Quo est amet.	Unde eius at	In vero.
333.333.333-33	Buzz Lightyear	OFICIAL   	Modi porro ut.	Sunt fuga ex.	Iure sunt quas	Est ab in.
*/

-- QUESTAO 5 -------------------------------------------------------------------------------------------------------------

/* A view VIEW_FACCAO seleciona o nome e ideologia da faccao, assim como o CPI e nome do seu líder,
combinando dados das tabelas LIDER, NACAO e ESPECIE por meio de joins.*/

CREATE VIEW VIEW_FACCAO AS
SELECT F.NOME AS NOME_FACCAO, F.LIDER AS CPI_LIDER, L.NOME AS NOME_LIDER, F.IDEOLOGIA
FROM FACCAO F
JOIN LIDER L ON F.LIDER = L.CPI;

-- a)
-- Inserindo os dados deletados anteriormente para fazer os testes
INSERT INTO VIEW_LIDER (CPI, NOME, CARGO, NACAO, ESPECIE)
VALUES ('444.444.444-44', 'Anakin Sky.', 'COMANDANTE', 'Mustafar', 'Humano');

UPDATE VIEW_LIDER
SET NOME = 'Darth Vader'
WHERE CPI = '444.444.444-44';

/* 
Assim como no exercício anterior, recebemos o seguinte erro ao tentar fazer o inset abaixo:
Erro de SQL: ORA-01776: não é possível modificar mais de uma vez uma tabela de base através da view de junção
*/
INSERT INTO VIEW_FACCAO (NOME_FACCAO, CPI_LIDER, NOME_LIDER, IDEOLOGIA) VALUES ('Lado Negro', '444.444.444-44', 'Darth Vader', 'TRADICIONALISTA');

-- Dessa forma, vamos testar dividir esse insert de forma que lidamos apenas com a tabela FACCAO e os outros dados são obtidos através do JOIN:

INSERT INTO VIEW_FACCAO(NOME_FACCAO, CPI_LIDER, IDEOLOGIA) VALUES ('Lado Negro', '444.444.444-44', 'TRADICIONALISTA');

/*
NOME_FACCAO    | CPI_LIDER        | NOME_LIDER    | IDEOLOGIA
Prog Celestiais	111.111.111-11	    Capitã Aria No	PROGRESSITA
Cons Cósmicos	222.222.222-22	    General Zorg	TRADICIONALISTA
Prog e Além	    333.333.333-33	    Buzz Lightyear	PROGRESSITA
Lado Negro	    444.444.444-44	    Darth Vader	    TRADICIONALISTA

Dessa forma, pudemos fazer a inserção normalmente, pois as chaves foram preservadas e agora lidamos com apenas uma tabela por vez para
realizar o insert.
*/

UPDATE VIEW_FACCAO
SET NOME_FACCAO = 'Galactic Empire'
WHERE NOME_FACCAO = 'Lado Negro';

/*
NOME_FACCAO    | CPI_LIDER        | NOME_LIDER    | IDEOLOGIA
Prog Celestiais	111.111.111-11	    Capitã Aria No	PROGRESSITA
Cons Cósmicos	222.222.222-22	    General Zorg	TRADICIONALISTA
Prog e Além	    333.333.333-33	    Buzz Lightyear	PROGRESSITA
Galatic Empire	444.444.444-44	    Darth Vader	    TRADICIONALISTA
*/

DELETE FROM VIEW_FACCAO WHERE NOME_FACCAO = 'Galactic Empire';

/*
NOME_FACCAO    | CPI_LIDER        | NOME_LIDER    | IDEOLOGIA
Prog Celestiais	111.111.111-11	    Capitã Aria No	PROGRESSITA
Cons Cósmicos	222.222.222-22	    General Zorg	TRADICIONALISTA
Prog e Além	    333.333.333-33	    Buzz Lightyear	PROGRESSITA
*/

/* A view VIEW_FACCAO tambem é atualizavel, o que pode ser visto atraves dos testes e se deve à preservação de chaves*/

-- QUESTAO 6 -------------------------------------------------------------------------------------------------------------

-- VISAO MATERIALIZADA COM JUNCAO --------------------------------
/* 
Primeiro, foi necessário criar um log de visão materializada na tabela NACAO_FACCAO, para que o Oracle possa rastrear
as alterações nesta tabela e aplicá-las de forma eficiente na visão materializada.
*/
-- Criando o log de visão materializada para a tabela NACAO_FACCAO
CREATE MATERIALIZED VIEW LOG ON NACAO_FACCAO WITH ROWID;
/* 
Em seguida, adicionamos as colunas NACAO e FACCAO ao log de visão materializada, incluindo a captura de novos valores,
o que permite que o Oracle registre quaisquer novas inserções ou atualizações nessas colunas na tabela NACAO_FACCAO.
*/
-- Adicionar a captura de novos valores ao log de visão materializada na tabela NACAO_FACCAO
ALTER MATERIALIZED VIEW LOG ON NACAO_FACCAO
  ADD (NACAO, FACCAO) INCLUDING NEW VALUES;

/* 
A visão MV_JUNCAO serve para contar quantas nações estão associadas a cada facção, o que pode ser útil para entender a
distribuição de poder entre as facções com base no número de nações sob sua influência.
*/

CREATE MATERIALIZED VIEW MV_JUNCAO
BUILD IMMEDIATE
REFRESH FAST ON COMMIT
AS
SELECT F.NOME AS FACCAO, COUNT(*) AS QTD_NACOES
FROM FACCAO F
JOIN NACAO_FACCAO NF ON F.NOME = NF.FACCAO
GROUP BY F.NOME;

/*
A visão foi criada com BUILD IMMEDIATE, o que significa que ela foi populada imediatamente após sua criação. Utilizamos isso nessa visão,
pois queremos que ela esteja disponível para consulta imediatamente após sua criação.

Além disso, a visão foi configurada para ser atualizada com REFRESH FAST ON COMMIT, que indica ao Oracle que a visão deve ser atualizada de
forma rápida e eficiente após cada operação de commit no banco de dados. Dado que a tabela NACAO_FACCAO pode ser frequentemente atualizada, 
essa configuração garante que a visão seja mantida atualizada com as alterações mais recentes de forma automatizada, sem a necessidade de 
intervenção manual, o que é importante para garantir que as análises feitas com base na visão reflitam sempre os dados mais recentes disponíveis.
*/




