-- QUEATAO 2 ---------------------------------------------------------------------------------------------------------





-- QUEATAO 3 ---------------------------------------------------------------------------------------------------------

-- a)
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
*/

/*
Na primeira consulta, o banco de dados pode encontrar a linha desejada rapidamente porque a comparação é
feita diretamente com a coluna 'nome'.
Já na segunda consulta, onde a função UPPER() é aplicada à coluna 'nome', o banco de dados precisa verificar
cada linha da tabela para ver se a condição é atendida, mas primeiro transformando todos os nomes em letras 
maiúsculas antes de começar a procurar.
Portanto, quando usamos funções em consultas, o banco de dados pode não ser capaz de usar índices eficientemente,
o que torna a busca mais lenta e menos eficiente.
*/

-- b)
CREATE INDEX idx_upper_nome ON nacao (UPPER(nome));

explain plan for
select * from nacao where upper(nome) = 'MINUS MAGNI.';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/* 
Para a consulta SELECT * FROM nacao WHERE UPPER(nome) = 'MINUS MAGNI.', considerando que estamos fazendo uma
comparação exata e que o valor a ser comparado é fixo e em maiúsculas (uma função), o tipo de índice mais
apropriado é o Function-based index.
Como a busca tinha uma função, foi criado um function-based index na expressão UPPER(nome), já que assim o 
banco de dados pode pré-calcular e armazenar os valores em maiúsculas da coluna nome, permitindo que ele os
utilize diretamente na consulta sem a necessidade de aplicar a função UPPER() durante a execução da consulta. 
Isso resulta em uma busca mais rápida e eficiente, pois o banco de dados pode usar o índice funcional para
encontrar rapidamente as linhas correspondentes ao valor 'MINUS MAGNI.' em maiúsculas na coluna nome.
*/

-- c)

/* 
Plan hash value: 2752779757
 
------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name           | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                |   498 | 14940 |    67   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| NACAO          |   498 | 14940 |    67   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | IDX_UPPER_NOME |   199 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access(UPPER("NOME")='MINUS MAGNI.')
*/

/* 
Agora, o banco de dados está utilizando o índice IDX_UPPER_NOME através da operação INDEX RANGE SCAN, indicando uma
busca direta e eficiente das linhas correspondentes ao valor 'MINUS MAGNI.' em maiúsculas na coluna nome. Isso substitui
a leitura completa da tabela (TABLE ACCESS FULL) no plano anterior, resultando em uma execução mais rápida da consulta. 
Além disso, o custo total de execução foi reduzido para 67 unidades de custo em comparação com 69 unidades de custo 
anteriormente, indicando uma melhoria na eficiência da consulta. Com menos bytes lidos, o volume de dados acessados durante
a execução da consulta também foi reduzido.
*/

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






