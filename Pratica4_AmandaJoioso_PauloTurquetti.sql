-- QUEATAO 5 ---------------------------------------------------------------------------------------------------------


-- a)
explain plan for
select * from especie where inteligente = 'V';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());
/*
Plan hash value: 139595281
 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         | 24997 |   707K|    70   (3)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESPECIE | 24997 |   707K|    70   (3)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("INTELIGENTE"='V')
*/

explain plan for
select * from especie where inteligente = 'F';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/*
Plan hash value: 139595281
 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         | 24997 |   707K|    70   (3)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESPECIE | 24997 |   707K|    70   (3)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("INTELIGENTE"='F')
*/

/* Observacoes: a operacao, os custos e o uso da CPU sao iguais em ambas as consultas */



-- b) Criando indice bitmap para a tabela especie
create bitmap index idx_especie on especie(inteligente);


-- c) analisando resultados das consultas apos criacao do bitmap:
explain plan for
select * from especie where inteligente = 'V';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());
/*
Plan hash value: 139595281
 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         | 24997 |   707K|    70   (3)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESPECIE | 24997 |   707K|    70   (3)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("INTELIGENTE"='V')
*/
explain plan for
select * from especie where inteligente = 'F';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());
/*
Plan hash value: 139595281
 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         | 24997 |   707K|    70   (3)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESPECIE | 24997 |   707K|    70   (3)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("INTELIGENTE"='F')
*/

/*
A partir desses resultados, podemos perceber que, apesar de criado um bitmap index para o atributo inteligente, 
presente na clausula WHERE, o SGBD não otilizou o bitmap para fazer a pesquisa. O bitmap sera utilizando apenas
quando a consulta apresenta um count(), ja que seria mais eficiente realizar essa operacao contando os dados do
bitmap do que acessando a tabela. Como vantajens do uso do bitmap, pesquisas que envolve count() são bem mais
eficientes. Como contrapeso, há o custo de espaco do bitmap.
*/






