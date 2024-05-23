/* Pratica 9

Amanda Valukas Breviglieri Joioso - 4818232
Paulo Henrique Vedovatto Turquetti - 13750791
*/


-- QUESTÃO 1 --------------------------------------------------------------------------------------

-- a)

-- Buscas para apoio
SELECT * FROM FEDERACAO WHERE NOME = 'NOVA FED';
SELECT * FROM FEDERACAO F JOIN NACAO N ON F.NOME = N.FEDERACAO WHERE F.NOME = 'NOVA FED';


CREATE OR REPLACE TRIGGER FEDERACAO_SEM_NACAO
BEFORE INSERT ON FEDERACAO
BEGIN
    
    DELETE FROM FEDERACAO WHERE NOME NOT IN (SELECT NOME FROM FEDERACAO 
                                        MINUS 
                                        SELECT F.NOME FROM FEDERACAO F JOIN NACAO N ON F.NOME = N.FEDERACAO);

END;

/* ANALISANDO RESULTADOS

Obs: Quando vamos inserir uma nova federação, ela não terá nenhuma nação associada devido à implementacao da FK em nacao.
com isso, mesmo se logo após da inserção da dfederacao fizermos a inserçao da nova nacao associada a ela, a existencia de um
trigger que apaga federacoes sem nacao associada executada após cada inserção de uma federação nao permitiria que federeções novas
fossem inseridas. 
Sendo assim, o que podemos fazer é, após um insert, update ou delete de uma nação, verificar se alguma federação ficou sem nação associada.
Isso permite a inserção de uma nova federação seguida da inserção sua nova nacao, além de garantir que a federação que perder suas
nações devido à updates ou deletes será excluída
*/
INSERT INTO FEDERACAO (NOME, DATA_FUND) VALUES ('NOVA FED', SYSDATE);
INSERT INTO FEDERCAO (NOME, DATA_FUND) VALUES ('MAIS NOVA', SYSDATE);

-- DELETE FROM FEDERACAO WHERE NOME = 'NOVA FED';
-- DELETE FROM FEDERACAO WHERE NOME = 'MAIS NOVA';






