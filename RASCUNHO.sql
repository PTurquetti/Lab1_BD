
-- QUEATAO 2 ---------------------------------------------------------------------------------------------------------

-- a) Fazendo as buscas e analisando o Plano de Execucoes
explain plan for
select * from planeta
where classificacao = 'Dolores autem maxime fuga.';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/*
Plan hash value: 2930980072
 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |     1 |    59 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |     1 |    59 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("CLASSIFICACAO"='Dolores autem maxime fuga.')

*/


explain plan for
select * from planeta where classificacao = 'Confirmed';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());


/*
Plan hash value: 2930980072
 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |     1 |    59 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |     1 |    59 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("CLASSIFICACAO"='Confirmed')

*/



-- b) Criando indice para o atributo classificacao:
create index idx_classificacao on planeta (classificacao);



-- c) Analisando novamente o desemprenho das buscas apos a criacao do index:
explain plan for
select * from planeta
where classificacao = 'Dolores autem maxime fuga.';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());
/*
Plan hash value: 1267387943
 
---------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                   |     1 |    59 |     3   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| PLANETA           |     1 |    59 |     3   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | IDX_CLASSIFICACAO |     1 |       |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
2 - access("CLASSIFICACAO"='Dolores autem maxime fuga.')
*/

explain plan for
select * from planeta where classificacao = 'Confirmed';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());


/*
Plan hash value: 1267387943
 
---------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                   |     1 |    59 |     3   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| PLANETA           |     1 |    59 |     3   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | IDX_CLASSIFICACAO |     1 |       |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("CLASSIFICACAO"='Confirmed')
*/


/*
Analisando os resultados obitidos:

Como foi possível observar, após a criacao da estrutura de indice para o atributo Classificacao da tabela Planeta,
as buscas passaram a operar com um custo muito menor e com uma diminuição do uso da CPU.
O uso da indexacao nesse caso foi de alta eficiência devido ao aparecimento do atributo classificacao na clausula 
WHERE em ambas as pesquisas.
Como o formato do atributo aceita uma ampla quantidade de valores possiveis, o uso de indices regulares eh o mais
eficiente.

*/

-- QUEATAO 3 ---------------------------------------------------------------------------------------------------------

-- a) Fazendo as buscas e analisando o Plano de Execucoes
explain plan for
select * from nacao where nome = 'Minus magni.';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/*
Plan hash value: 718961691
 
----------------------------------------------------------------------------------------
| Id  | Operation                   | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |          |     1 |    30 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| NACAO    |     1 |    30 |     2   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_NACAO |     1 |       |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("NOME"='Minus magni.')
*/



explain plan for
select * from nacao where upper(nome) = 'MINUS MAGNI.';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());
/*
Plan hash value: 2698598799
 
---------------------------------------------------------------------------
| Id  | Operation         | Name  | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |       |   498 | 14940 |    69   (2)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| NACAO |   498 | 14940 |    69   (2)| 00:00:01 |
---------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(UPPER("NOME")='MINUS MAGNI.')
*/

 /* Na primeira consulta, onde a comparação é direta entre a coluna 'nome' e 'Minus magni.',
o otimizador escolheu usar um índice único para acessar os dados, resultando em uma operação 
eficiente e acesso direto à linha desejada na tabela 'nacao'. Já na segunda consulta, onde é 
aplicada a função UPPER() na coluna 'nome' e comparada com 'MINUS MAGNI.', o otimizador optou 
por uma leitura completa da tabela ('TABLE ACCESS FULL') devido ao uso da função, que impede 
a utilização eficiente de índices. Essa diferença ocorre porque o uso de funções em predicados
de consulta pode invalidar o uso de índices existentes, levando a uma abordagem menos eficiente
em termos de desempenho. */



-- QUEATAO 4 ---------------------------------------------------------------------------------------------------------
-- a) Fazendo as buscas e analisando o Plano de Execucoes
explain plan for
select * from planeta where massa between 0.1 and 10;

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/*
Plan hash value: 2930980072
 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |     6 |   354 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |     6 |   354 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("MASSA"<=10 AND "MASSA">=0.1)
*/

explain plan for
select * from planeta where massa between 0.1 and 3000;

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/*
Plan hash value: 2930980072
 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |  1580 | 93220 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |  1580 | 93220 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("MASSA"<=3000 AND "MASSA">=0.1)
*/

-- b) Criando indice para o atributo classificacao:
create index idx_massa on planeta (massa);


-- c) Analisando novamente o desemprenho das buscas apos a criacao do index:

explain plan for
select * from planeta where massa between 0.1 and 10;

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());
/*
Plan hash value: 1147402337
 
-------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |           |     6 |   354 |     9   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| PLANETA   |     6 |   354 |     9   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | IDX_MASSA |     6 |       |     2   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("MASSA">=0.1 AND "MASSA"<=10)
*/



explain plan for
select * from planeta where massa between 0.1 and 3000;

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/*
Plan hash value: 2930980072
 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |  1580 | 93220 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |  1580 | 93220 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("MASSA"<=3000 AND "MASSA">=0.1)
*/



/*
ANALISANDO:
Na primeira pesquisa, 


Na segunda pesquisa, a estrutura de indice nao foi utilizada na busca




