/* Pratica 9

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




-- b) O	líder de uma facção	deve estar associado a uma nação em	que	a facção está presente.	






