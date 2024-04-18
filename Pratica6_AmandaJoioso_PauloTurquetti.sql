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
GRANT SELECT, REFERENCES(especie, nome) ON COMUNIDADE TO a4818232 WITH GRANT OPTION;

-- b)







