-- QUESTAO 2

-- a)
UPDATE FEDERACAO SET
    NOME_FD = 'Nova Aliança Galática',
    DATA_FUND = TO_DATE('22/03/3200','dd/mm/yyyy')
WHERE NOME_FD = 'Aliança Galáctica';
/* Para que o update afete somente uma tupla, a condicao de busca deve estar
relacionada a chave primaria de uma tabela. Nesse caso, a federacao alterada sera
a de NOME_FD = 'Aliança Galáctica'. Como NOME_FD eh Chave Primaria, somente essa
tupla sera afetada */


--b)
UPDATE ESPECIE SET
    EH_INTELIGENTE = 'N'
WHERE PLANETA_ORIGEM = 'Terra';
/* Para que o update afete mais de uma tupla, a condicao de busca nao pode estar 
relacionada a chave primaria da tabela. Nesse caso, todas as especies que possuem
PLANETA_ORIGEM = 'Terra' terao o atributo EH_INTELIGENTE alterado para 'N' */



--c)
UPDATE PLANETA SET
    CLASSIFICACAO = NULL;
/*Para que o update afete todas as tuplas de uma tabela, nao utilizamos a clausula
WHERE. Sendo assim, todas as tuplas de PLANETA terao o atributo CLASSIFICACAO alterado
para NULL */

