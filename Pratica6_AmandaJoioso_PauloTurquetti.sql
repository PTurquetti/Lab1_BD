/* Pratica 6

Amanda Valukas Breviglieri Joioso - 4818232
Paulo Henrique Vedovatto Turquetti - 13750791
*/


/*

USUÁRIOS:

User 1 - a13750791 - Paulo
User 2 - a4818232 - Amanda
User 3 -  a12682435 - Darlam

*/

-- QUESTÃO 1 --------------------------------------------------------------------------------------------------------

-- a)
GRANT SELECT ON ESTRELA TO a4818232;
/*Esse comando dá ao USER2 permissão de leitura (SELECT) na tabela ESTRELA do USER1. 
Como não foi usado o GRANT OPTION, o USER2 não pode conceder essa permissão a outros usuários.
*/

-- i. 
-- Usuário 2 fazendo busca:
SELECT * FROM a13750791.ESTRELA;
-- A busca foi realizada com sucesso
/*O USER2 conseguiu realizar uma consulta na tabela ESTRELA do USER1, o que indica que
a permissão de leitura foi concedida com sucesso.
*/

-- ii.
-- User 2 fazendo insercao:

INSERT INTO a13750791.ESTRELA (ID_ESTRELA, NOME, CLASSIFICACAO, MASSA, X, Y, Z) VALUES ('654321', 'Alpha Centauri A', 'M11', NULL, 4.0, 5.0, 6.0);
-- Erro de SQL: ORA-01031: privilégios insuficientes
/*Quando o USER2 tentou inserir um registro na tabela ESTRELA do USER1, recebeu um erro de privilégios insuficientes. 
Isso ocorre porque a permissão dada ao USER 2 era apenas para leitura (SELECT), não para inserção (INSERT).*/

-- iii.
-- User 3 tentando fazer consulta na tabela de user 1 sem ter permissão:
SELECT * FROM a13750791.ESTRELA;
-- ORA-00942: a tabela ou view não existe
/*Quando o USER3 tentou realizar uma consulta na tabela ESTRELA do USER1, recebeu um erro indicando que a tabela ou view não existe. 
Isso ocorre porque o USER3 não recebeu nenhuma permissão para acessar essa tabela do USER1.*/


-- iv.
-- Removendo privilerio de user 2
REVOKE SELECT ON ESTRELA FROM a4818232;
/*Esse comando tira a permissão de leitura (SELECT) do USER2 na tabela ESTRELA do USER1.*/

-- v.
select * from a13750791.ESTRELA;
/*
ORA-00942: a tabela ou view não existe
00942. 00000 -  "table or view does not exist"
*/
/*Quando o USER2 tentou realizar uma consulta na tabela ESTRELA do USER1 após a permissão de leitura ter sido retirada, 
ele recebeu um erro indicando que a tabela ou view não existe. Isso confirma que a permissão de leitura foi retirada com sucesso.*/


--b)
GRANT SELECT ON ESTRELA TO a4818232 WITH GRANT OPTION;
/*Esse comando dá ao USER2 permissão de leitura (SELECT) na tabela ESTRELA do USER1 e, com a opção WITH GRANT OPTION,
o USER2 pode conceder essa permissão a outros usuários.*/

-- i.
select * from a13750791.ESTRELA;
-- Busca executada com sucesso
/*O USER2 conseguiu realizar uma consulta na tabela ESTRELA do USER1, o que indica
que a permissão de leitura foi concedida com sucesso.*/

-- ii.
GRANT SELECT ON ESTRELA TO a12682435;
-- Grant bem-sucedido.
/*O USER2 deu ao USER3 permissão de leitura (SELECT) na tabela ESTRELA do USER1, mas sem
o GRANT OPTION, o USER3 não pode dar essa permissão a outros usuários.*/

-- iii.
-- User 3 tentando fazer consulta na tabela de user 1 sem ter permissão:
SELECT * FROM a13750791.ESTRELA;
-- Busca executada com sucesso
/*O USER3 conseguiu realizar uma consulta na tabela ESTRELA do USER1, o que indica que
a permissão de leitura foi concedida com sucesso.*/


-- iv.
REVOKE SELECT ON ESTRELA FROM a4818232;
-- Revoke bem-sucedido.
/*Esse comando tira a permissão de leitura (SELECT) do USER2 na tabela ESTRELA do USER1. 
Como a permissão foi concedida com a opção GRANT OPTION, a permissão do USER3 também é revogada.*/


-- v.
-- user 2:
select * from a13750791.ESTRELA;
--ORA-00942: a tabela ou view não existe



-- User 3:
select * from a13750791.ESTRELA;
--ORA-00942: a tabela ou view não existe

/*Após a permissão de leitura ter sido retirada, quando foi tentado realizar a busca, ambos receberam um
erro indicando que a tabela ou view não existe, o que confirma que a permissão de leitura foi retirada com sucesso.*/




-- Removendo o privilégio para as questões a seguir:
REVOKE SELECT ON ESTRELA FROM a4818232

-- QUESTÃO 2 ---------------------------------------------------------------------------------------------------------

-- Criando privilegio
GRANT SELECT, INSERT (ID_ESTRELA, NOME, X, Y, Z) ON ESTRELA TO a4818232 WITH GRANT OPTION;
/*Esse comando concede ao USER2 permissão de leitura (SELECT) e inserção (INSERT) em alguns atributos da tabela
ESTRELA do USER1 e, com o GRANT OPTION, permite que o USER2 conceda essas permissões a outros usuários.*/


-- a)

INSERT INTO a13750791.ESTRELA (ID_ESTRELA, NOME, X, Y, Z) VALUES ('654321', 'Alpha Centauri A', 4.0, 5.0, 6.0);
-- 1 linha inserido.

/*O USER2 conseguiu inserir uma tupla na tabela ESTRELA do USER1, o que indica 
que a permissão de inserção foi concedida com sucesso.*/

-- b)
-- i.
-- Antes do commit:
-- User 1 fazendo busca:
SELECT * FROM ESTRELA WHERE ID_ESTRELA = '654321';
-- Nenhuma tupla corresponde foi encontrada

-- User 2 fazendo busca
SELECT * FROM a13750791.ESTRELA WHERE ID_ESTRELA = '654321';
-- A tupla foi encontrada



-- Depois do commit:

-- User 1 fazendo busca:
SELECT * FROM ESTRELA WHERE ID_ESTRELA = '654321';
-- A tupla foi encontrada


-- User 2 fazendo busca
SELECT * FROM a13750791.ESTRELA WHERE ID_ESTRELA = '654321';
-- A tupla foi encontrada

/* 
Antes do commit, o USER1 não conseguiu encontrar a tupla inserida pelo USER2, pois a transação ainda não foi confirmada. 
Já o USER2 conseguiu encontrar a tupla, pois a inserção já tinha sido realizada 'localmente'.
Após o commit, tanto o USER1 quanto o USER2 conseguiram encontrar a tupla, pois a transação foi confirmada e se torna visível
para todos os usuários que têm permissão para ver a tabela.
*/

-- ii.
/*Antes do commit, apenas o USER2 pode ver as alterações feitas na transação atual. Após o commit, todas as 
alterações são permanentes e visíveis para todos os usuários que têm permissão para ver a tabela.*/

-- iii.
/*Os atributos para os quais o USER2 não tem permissão de inserção permanecem inalterados na tupla na tabela do USER1, com valores NULL no caso*/

-- c)
GRANT SELECT, INSERT (ID_ESTRELA, NOME, X, Y, Z) ON ESTRELA TO a12682435;
-- Grant bem-sucedido.
/*O USER2 concedeu ao USER3 as mesmas permissões que recebeu do USER1, mas sem o GRANT OPTION, 
então o USER3 não poderá conceder essas permissões a outros usuários.*/

-- d)
-- Refazer item a e b com user 3
-- user 3 inserindo tupla na tabela:
INSERT INTO a13750791.ESTRELA (ID_ESTRELA, NOME, X, Y, Z) VALUES ('98765', 'Alpha Centauri B', 5.0, 6.0, 7.0);
-- Tupla inserida com sucesso


--Busca antes do commit
-- user 1 fazendo busca:
SELECT * FROM ESTRELA WHERE ID_ESTRELA = '98765';
-- Nunhuma tupla encontrada

-- user 2 fazendo busca
SELECT * FROM a13750791.ESTRELA WHERE ID_ESTRELA = '98765';
-- Nenhuma tupla encontrada

-- user 3 fazendo busca:
SELECT * FROM a13750791.ESTRELA WHERE ID_ESTRELA = '98765';
-- 98765	Alpha Centauri B			5	6	7

--Busca depois do commit

-- user 1 fazendo busca:
SELECT * FROM ESTRELA WHERE ID_ESTRELA = '98765';
-- tupla encontrada

-- user 2 fazendo busca
SELECT * FROM a13750791.ESTRELA WHERE ID_ESTRELA = '98765';
-- tupla encontrada

-- user 3 fazendo busca:
SELECT * FROM a13750791.ESTRELA WHERE ID_ESTRELA = '98765';
-- tupla encontrada

-- e) 
REVOKE SELECT, INSERT ON ESTRELA FROM a4818232;
-- Revoke bem-sucedido.
/*Esse comando retira as permissões de leitura (SELECT) e inserção (INSERT) do USER2 na tabela ESTRELA do USER1. 
Como a permissão foi concedida com a opção GRANT OPTION, a permissão do USER3 também é revogada.*/


-- QUESTÃO 3 ---------------------------------------------------------------------------------------------------------


-- a) User 1 conedendo privilégio de busca, referência e delete para user 2 sobre a tabela COMUNIDADE
GRANT SELECT, REFERENCES(especie, nome), DELETE ON COMUNIDADE TO a4818232 WITH GRANT OPTION;
-- Privilégios concedidos


-- b)   User 2 criando a tabela CURIOSIDADES_COMUNIDADE referenciando a tabela COMUNIDADE de User 1

CREATE TABLE CURIOSIDADES_COMUNIDADE(
    NOME_COMUNIDADE VARCHAR2(15) NOT NULL,
    ESPECIE_COMUNIDADE VARCHAR(15) NOT NULL,
    CURIOSIDADE VARCHAR2(150) NOT NULL,
    CONSTRAINT PK_CURIOSIDADES PRIMARY KEY(NOME_COMUNIDADE, ESPECIE_COMUNIDADE),
    CONSTRAINT FK_CURIOSIDADES FOREIGN KEY(NOME_COMUNIDADE, ESPECIE_COMUNIDADE) REFERENCES a13750791.COMUNIDADE (NOME, ESPECIE) ON DELETE CASCADE
);
-- Tabela criada


-- c) inserindo na tabela curiosidade uma tupla referente a uma comunidade existente de user1:
INSERT INTO CURIOSIDADES_COMUNIDADE(NOME_COMUNIDADE, ESPECIE_COMUNIDADE, CURIOSIDADE) VALUES('Ordem Jedi', 'Humano', 'Os Jedi são treinados desde a infância, usam sabres de luz e têm uma conexão especial com a Força, guiando-se pelos ensinamentos do Código Jedi.');
--Tupla inserida

-- inserindo na tabela curiosidade uma tupla referente a uma comunidade não existente:
-- INSERT INTO CURIOSIDADES_COMUNIDADE(NOME_COMUNIDADE, ESPECIE_COMUNIDADE, CURIOSIDADE) VALUES('Sithans', 'Sith', 'Os Siths abraçam o lado sombrio da Força, buscam poder absoluto e seguem o Código Sith, desafiando os Jedi em busca de domínio galáctico.');

/*Relatório de erros -
ORA-02291: restrição de integridade (A4818232.FK_CURIOSIDADES) violada - chave mãe não localizada

Não foi possível inserir essa tupla já que foi tentado referenciar uma comunidade que não existe na tabela COMUNIDADE do usuário 1
*/

-- d) User 2 removendo da tabela COMUNIDADE do user 1 uma tupla referenciada na tabela CURIOSIDADES_COMUNIDADE
--DELETE FROM a13750791.COMUNIDADE WHERE NOME = 'Ordem Jedi';

/*Erro a partir da linha : 15 no comando -
DELETE FROM a13750791.COMUNIDADE WHERE NOME = 'Ordem Jedi'
Relatório de erros -
ORA-02292: restrição de integridade (A13750791.FK_HABITACAO_COMUNIDADE) violada - registro filho localizado*/

/*
Mesmo que o user 2 tenha o privilégio de remoção, ela não será permitida.Isso ocorre porque quando o user 2 tenta 
remover uma tupla da tabela COMUNIDADE do user 1 que está sendo referenciada, a constraint de FOREIGN KEY irá 
barrar a remoção.
*/




-- QUESTÃO 4 -----------------------------------------------------------------------------------------------------------


-- a) User 1 concedendo privilégio de busca e de criação de index sobre ESPECIE para user 2
GRANT SELECT, INDEX ON ESPECIE TO a4818232;
-- Privilégio concedido


-- b) User 2 criando um bitmap em cima da tabela 
create bitmap index idx_especie on a13750791.especie(inteligente);
-- Índice criado


-- c) User 2 fazendo consulta na tabela de user 1
explain plan for
select * from a13750791.especie where inteligente = 'V';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/*
Plan hash value: 139595281
 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         | 24940 |   706K|    70   (3)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESPECIE | 24940 |   706K|    70   (3)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("INTELIGENTE"='V')


Nesse exemplo, podemos identificar que o bitmap criado não foi utilizado

*/



-- d) User 1 fazendo a mesma consulta na própria tabela
explain plan for
select * from especie where inteligente = 'V';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/*
Plan hash value: 139595281
 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         | 24940 |   706K|    70   (3)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESPECIE | 24940 |   706K|    70   (3)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("INTELIGENTE"='V')

O índice criado por user 2 não é utilizado
*/

-- e) User 2 forçando o uso do bitmap na consulta

ALTER SESSION SET OPTIMIZER_MODE = FIRST_ROWS;


-- f) User 2 refazendo a consulta utilizando o bitmap

explain plan for
select * from a13750791.especie where inteligente = 'V';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/*
Plan hash value: 4140203513
 
---------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |             | 24940 |   706K|   223   (1)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| ESPECIE     | 24940 |   706K|   223   (1)| 00:00:01 |
|   2 |   BITMAP CONVERSION TO ROWIDS       |             |       |       |            |          |
|*  3 |    BITMAP INDEX SINGLE VALUE        | IDX_ESPECIE |       |       |            |          |
---------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("INTELIGENTE"='V')

Agora, o índice bitmap criado está sendo utilizado. No entanto, não houve nenhum ganho de desempenho
da consulta. Inclusive, o custo em % da CPU ainda aumentou. Isso ocorre porque esse índice não
agrega valor à consulta por utilizar um bitmap em um ambiente desfavorável
*/



-- g)
explain plan for
select * from a13750791.especie where inteligente = 'V';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/*
Plan hash value: 139595281
 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         | 24940 |   706K|    70   (3)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESPECIE | 24940 |   706K|    70   (3)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("INTELIGENTE"='V')
*/

/*
 Isso ocorre porque o índice criado pelo USER2 pode não ser reconhecido ou priorizado da mesma 
forma que o índice existente no esquema do USER1, a menos que o otimizador seja explicitamente 
instruído a priorizar os índices, como foi feito no caso de USER2.
*/


-- QUESTÃO 5 -------------------------------------------------------------------------------------------

-- Implementando cenário proposto

-- User 1 garantindo privilegios para user 2:
GRANT SELECT ON FACCAO TO a4818232 WITH GRANT OPTION;
GRANT SELECT ON LIDER TO a4818232 WITH GRANT OPTION;
-- Grants bem sucedidos

-- User 2 criando view em cima das tabelas de User 1:
CREATE VIEW VIEW_FACCAO_LIDER_PRATICA6 AS
SELECT F.NOME AS NOME_FACCAO, F.LIDER AS CPI_LIDER, L.NOME AS NOME_LIDER, F.IDEOLOGIA AS IDEOLOGIA
FROM a13750791.FACCAO F
JOIN a13750791.LIDER L ON F.LIDER = L.CPI;

--View VIEW_FACCAO_LIDER_PRATICA6 criado.

-- User 2 dando acesso de leitura da sua view para user 3
GRANT SELECT ON VIEW_FACCAO_LIDER_PRATICA6 TO a12682435;

-- a)

/* Primeiramente, o User 1 precisa conceder o acesso às tabelas FACCAO e LIDER para  que
o user 2 possa criar uma view com base nelas. É necessário que o privilégio seja passado 
com GRANT OPTION para que o user 2 possa dar acesso à essa view para o user 3.
Obs: os users já tem privilégio de criação de views.

Após isso, o User 2 faz a criação da view com base nas tabelas FACCAO e LIDER do user 1.

Em seguida, user 2 dará privilégio de leitura da view para o user 3. Nesse caso, não será
necessário utilizar WITH GRANT OPTION, já que o papel de user 3 será apenas fazer leituras
na view.
*/


-- b) Realizando testes:


-- Testando acesso de user 2 às tabelas FACCAO e LIDER do user 1
SELECT * FROM a13750791.FACCAO;
SELECT * FROM a13750791.LIDER;


-- Testando acesso de user 3 às tabelas FACCAO e LIDER do user 1
SELECT * FROM a13750791.FACCAO;
SELECT * FROM a13750791.LIDER;
-- Erro. tabela ou view não existe. Isso ocorre porque não foi dada permissão de busca dessas tabelas ao user 3



-- Testando busca do User 2 em sua view:
SELECT * FROM VIEW_FACCAO_LIDER_PRATICA6;
-- É possível fazer busca na view que ele mesmo criou


-- Testando busca do User 3 na view de user 2:
SELECT * FROM a4818232.VIEW_FACCAO_LIDER_PRATICA6;
-- É possível fazer busca na view do user 2

-- Testando user 3 fazendo operações de inserção na view do user 2
INSERT INTO a4818232.VIEW_FACCAO_LIDER_PRATICA6(NOME_FACCAO, CPI_LIDER, NOME_LIDER, IDEOLOGIA) VALUES ();



-- c) User 1 removendo de user 2 os privilégios de busca nas tabelas FACCAO e LIDER:
REVOKE SELECT ON FACCAO FROM a4818232;
REVOKE SELECT ON LIDER FROM a4818232;


-- User 2 tentando acessar a sua view criada em cima das tabelas de user 1
SELECT * FROM VIEW_FACCAO_LIDER_PRATICA6;
-- ORA-04063: view "A4818232.VIEW_FACCAO_LIDER_PRATICA6" contém erros


-- User 3 tentando acessar a view de user 2
SELECT * FROM a4818232.VIEW_FACCAO_LIDER_PRATICA6;
/*
Erro: tabela ou view não existe. Isso ocorre porque o user 2 perdeu o acesso das tabelas em que sua
view foi baseada. Sendo assim, o user 3 também perde o acesso à view

















