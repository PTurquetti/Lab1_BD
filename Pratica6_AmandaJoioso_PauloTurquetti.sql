/* Pratica 6

Amanda Valukas Breviglieri Joioso - 4818232
Paulo Henrique Vedovatto Turquetti - 13750791
*/


/*

USUÁRIOS:

User 1 - a13750791
User 2 - a4818232 
User 3 - Darlam

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





--b)
GRANT SELECT ON ESTRELA TO a4818232 WITH GRANT OPTION; -- não executado







-- Removendo o privilégio para as questões a seguir:
REVOKE SELECT ON ESTRELA FROM a4818232

-- QUESTÃO 2 ---------------------------------------------------------------------------------------------------------









