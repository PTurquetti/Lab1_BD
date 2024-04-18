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

-- i. 
-- Usuário 2 fazendo busca:
SELECT * FROM a13750791.ESTRELA;
-- A busca foi realizada com sucesso

-- ii.
-- User 2 fazendo insercao:

INSERT INTO a13750791.ESTRELA (ID_ESTRELA, NOME, CLASSIFICACAO, MASSA, X, Y, Z) VALUES ('654321', 'Alpha Centauri A', 'M11', NULL, 4.0, 5.0, 6.0);
-- Erro de SQL: ORA-01031: privilégios insuficientes


-- iii.
-- precis de usa=er 3



-- iv.
-- Removendo privilerio de user 2
REVOKE SELECT ON ESTRELA FROM a4818232;


-- v.
select * from a13750791.ESTRELA;
/*
ORA-00942: a tabela ou view não existe
00942. 00000 -  "table or view does not exist"
*Cause:    
*Action:
Erro na linha: 5 Coluna: 25
*/


--b)
GRANT SELECT ON ESTRELA TO a4818232 WITH GRANT OPTION;

-- i.
select * from a13750791.ESTRELA;
-- Busca executada com sucesso

-- ii.
GRANT SELECT ON ESTRELA TO a12682435;
-- Grant bem-sucedido.


-- iii.
-- User 3


-- iv.
REVOKE SELECT ON ESTRELA FROM a4818232;
-- Revoke bem-sucedido.



-- v.
-- user 2:
select * from a13750791.ESTRELA;
/*
ORA-00942: a tabela ou view não existe
00942. 00000 -  "table or view does not exist"
*Cause:    
*Action:
Erro na linha: 5 Coluna: 25
*/

-- User 3:







-- Removendo o privilégio para as questões a seguir:
REVOKE SELECT ON ESTRELA FROM a4818232

-- QUESTÃO 2 ---------------------------------------------------------------------------------------------------------

-- Criando privilegio
GRANT SELECT, INSERT (ID_ESTRELA, NOME, X, Y, Z) ON ESTRELA TO a4818232 WITH GRANT OPTION;


-- a)

INSERT INTO a13750791.ESTRELA (ID_ESTRELA, NOME, X, Y, Z) VALUES ('654321', 'Alpha Centauri A', 4.0, 5.0, 6.0);

-- 1 linha inserido.

-- b)

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

/* EXPLICAR

*/

-- c)
GRANT SELECT, INSERT (ID_ESTRELA, NOME, X, Y, Z) ON ESTRELA TO a12682435;
-- Grant bem-sucedido.


-- d)
-- Refazer item a e b com user 3



-- e) 
REVOKE SELECT, INSERT ON ESTRELA FROM a4818232;
-- Revoke bem-sucedido.


-- QUESTÃO 3 ---------------------------------------------------------------------------------------------------------


-- a) User 1 DANDO PRIVILEGIO
GRANT SELECT, REFERENCES(especie, nome), DELETE ON COMUNIDADE TO a4818232 WITH GRANT OPTION;

-- b)

CREATE TABLE CURIOSIDADES_COMUNIDADE(
    NOME_COMUNIDADE VARCHAR2(15) NOT NULL,
    ESPECIE_COMUNIDADE VARCHAR(15) NOT NULL,
    CURIOSIDADE VARCHAR2(150) NOT NULL,
    CONSTRAINT PK_CURIOSIDADES PRIMARY KEY(NOME_COMUNIDADE, ESPECIE_COMUNIDADE),
    CONSTRAINT FK_CURIOSIDADES FOREIGN KEY(NOME_COMUNIDADE, ESPECIE_COMUNIDADE) REFERENCES a13750791.COMUNIDADE (NOME, ESPECIE) ON DELETE CASCADE
);


-- c)
-- inserindo na tabela curiosidade uma tupla referente a uma comunidade existente de user1:
INSERT INTO CURIOSIDADES_COMUNIDADE(NOME_COMUNIDADE, ESPECIE_COMUNIDADE, CURIOSIDADE) VALUES('Ordem Jedi', 'Humano', 'Os Jedi são treinados desde a infância, usam sabres de luz e têm uma conexão especial com a Força, guiando-se pelos ensinamentos do Código Jedi.');

-- inserindo na tabela curiosidade uma tupla referente a uma comunidade não existente:
-- INSERT INTO CURIOSIDADES_COMUNIDADE(NOME_COMUNIDADE, ESPECIE_COMUNIDADE, CURIOSIDADE) VALUES('Sithans', 'Sith', 'Os Siths abraçam o lado sombrio da Força, buscam poder absoluto e seguem o Código Sith, desafiando os Jedi em busca de domínio galáctico.');

/*Relatório de erros -
ORA-02291: restrição de integridade (A4818232.FK_CURIOSIDADES) violada - chave mãe não localizada


Não foi possível inserir essa tupla já que foi tentado referenciar uma comunidade que não existe na tabela COMUNIDADE do usuário 1
*/

-- d)
--DELETE FROM a13750791.COMUNIDADE WHERE NOME = 'Ordem Jedi';

/*Erro a partir da linha : 15 no comando -
DELETE FROM a13750791.COMUNIDADE WHERE NOME = 'Ordem Jedi'
Relatório de erros -
ORA-02292: restrição de integridade (A13750791.FK_HABITACAO_COMUNIDADE) violada - registro filho localizado*/




-- QUESTÃO 4 -----------------------------------------------------------------------------------------------------------


-- a)
GRANT SELECT, INDEX ON ESPECIE TO a4818232;


-- b)
create bitmap index idx_especie on a13750791.especie(inteligente);


-- c)
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



-- d)
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

-- e)

ALTER SESSION SET OPTIMIZER_MODE = FIRST_ROWS;


-- f)

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










