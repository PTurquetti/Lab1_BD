/* Pratica 4

Amanda Valukas Breviglieri Joioso - 4818232
Paulo Henrique Vedovatto Turquetti - 13750791
*/


-- QUEATAO 2 ---------------------------------------------------------------------------------------------------------
-- a)
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

/* 
Analisando os planos de execução gerados pelo otimizador para as consultas fornecidas, podemos observar
que ambas as consultas estão realizando uma leitura completa da tabela PLANETA (TABLE ACCESS FULL), a consulta
está examinando todas as linhas da tabela para encontrar as que correspondem ao critério de busca.
*/

-- b)
CREATE INDEX idx_classificacao ON planeta (classificacao);

/* 
Utilizamos a indexação por B-tree para as consultas fornecidas, pois estamos buscando valores específicos na
coluna classificacao, assim, ele é a escolha mais apropriada devido à sua eficiência na busca por igualdades exatas.
*/

-- c)
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
Após a criação do índice, ambos os planos de execução mostram que o banco de dados está utilizando o
índice IDX_CLASSIFICACAO através de uma operação INDEX RANGE SCAN. Isso indica uma busca direta e eficiente
das linhas correspondentes aos valores específicos da coluna classificacao por meio do índice, em vez de 
percorrer todas as linhas da tabela. Como resultado, o custo total de execução das consultas foi drasticamente 
reduzido para apenas 3 unidades de custo.
*/


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

explain plan for
select * from nacao where upper(nome) = 'MINUS MAGNI.';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

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

-- QUEATAO 4 ---------------------------------------------------------------------------------------------------------
-- a)
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
|   0 | SELECT STATEMENT  |         |  1579 | 93161 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |  1579 | 93161 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("MASSA"<=3000 AND "MASSA">=0.1)
*/

/*
Analisando os planos de execução gerados pelo otimizador para as consultas fornecidas, podemos observar
que ambas as consultas estão realizando uma leitura completa da tabela PLANETA (TABLE ACCESS FULL), a consulta
está examinando todas as linhas da tabela para encontrar as que correspondem ao critério de busca independentemente
dos valores específicos do intervalo de massa fornecido.
*/

-- b)
create index idx_massa on planeta (massa);

/*
Optamos por um índice B-tree porque ele é eficiente para consultas que envolvem intervalos. Um índice B-tree organiza
os valores em uma estrutura de árvore balanceada, permitindo que o banco de dados localize rapidamente as linhas que
correspondem aos valores especificados no intervalo. Apesar de no início parecer ideal o uso de um function-based index,
pois parece realizar uma função na busca, não seria tão eficaz quanto um índice do tipo B-tree, porque um function-based index
é útil quando a função aplicada na coluna é determinística e sempre produz o mesmo resultado para um determinado valor de entrada.
*/

-- c)
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
|   0 | SELECT STATEMENT  |         |  1579 | 93161 |   137   (1)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| PLANETA |  1579 | 93161 |   137   (1)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("MASSA"<=3000 AND "MASSA">=0.1)
*/

/* 
 Para a consulta com o intervalo mais restrito (0.1 a 10), o otimizador optou por uma busca eficiente usando o 
índice de intervalo na coluna massa, resultando em baixo custo de execução e operação rápida. No entanto, para 
o intervalo mais amplo (0.1 a 3000), o otimizador escolheu manter a leitura completa da tabela, evitando o uso
do índice devido à amplitude do intervalo, resultando em um custo de execução maior e potencialmente em uma 
operação mais lenta. Essa decisão demonstra a importância de considerar a distribuição dos dados e a seletividade 
dos valores ao otimizar consultas com intervalos.
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


-- QUEATAO 6 ---------------------------------------------------------------------------------------------------------

-- a)
explain plan for
select * from estrela where classificacao = 'M3' and massa < 1;

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

-- Performance antes da criação do índice
/* 
Plan hash value: 1653849300
 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |     1 |    46 |    15   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESTRELA |     1 |    46 |    15   (0)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("MASSA"<1 AND "CLASSIFICACAO"='M3')
*/

/*
No caso, as colunas classificacao e massa foram escolhidas como chaves do índice. A escolha desse tipo de índice foi 
feita porque a consulta envolve uma filtragem simultânea nessas duas colunas. Ao criar um índice de chave composta nessas
colunas, o banco de dados pode encontrar rapidamente as linhas que correspondem aos critérios da consulta, pois o índice 
estará organizado de forma a facilitar a busca por valores específicos de classificacao e massa. Isso resultará em uma melhoria 
significativa no desempenho da consulta, pois o banco de dados pode usar o índice para localizar diretamente as linhas relevantes, 
em vez de percorrer toda a tabela.
*/

CREATE INDEX idx_class_massa ON estrela (classificacao, massa);

explain plan for
select * from estrela where classificacao = 'M3' and massa < 1;

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

-- Performance depois da criação do índice
/*
Plan hash value: 2258764018
 
-------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name            | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                 |     1 |    46 |     3   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| ESTRELA         |     1 |    46 |     3   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | IDX_CLASS_MASSA |     1 |       |     2   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("CLASSIFICACAO"='M3' AND "MASSA"<1)
*/

/* 
Agora, o otimizador de consultas utiliza o índice IDX_CLASS_MASSA por meio de uma operação de varredura de 
intervalo (INDEX RANGE SCAN). Isso significa que o banco de dados está acessando diretamente as linhas relevantes 
usando o índice, em vez de realizar uma leitura completa da tabela ESTRELA. Como resultado, o custo de execução da 
consulta foi reduzido para apenas 3 unidades, indicando uma operação mais eficiente e um tempo de execução mais rápido. 
A utilização do índice de chave composta permitiu ao banco de dados localizar rapidamente as linhas que correspondem 
aos critérios da consulta.
*/

-- b)
explain plan for
select * from estrela where classificacao = 'M3' or massa < 1;

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/* 
Plan hash value: 1653849300
 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |     6 |   276 |    15   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESTRELA |     6 |   276 |    15   (0)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("CLASSIFICACAO"='M3' OR "MASSA"<1)
*/

explain plan for
select * from estrela where classificacao = 'M3';

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/* 
Plan hash value: 2258764018
 
-------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name            | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                 |     5 |   230 |     8   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| ESTRELA         |     5 |   230 |     8   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | IDX_CLASS_MASSA |     5 |       |     2   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("CLASSIFICACAO"='M3')
*/

explain plan for
select * from estrela where massa < 1;

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/*
Plan hash value: 1653849300
 
-----------------------------------------------------------------------------
| Id  | Operation         | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |     1 |    46 |    15   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| ESTRELA |     1 |    46 |    15   (0)| 00:00:01 |
-----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("MASSA"<1)
*/

/* 
1. Consulta 1: select * from estrela where classificacao = 'M3' or massa < 1;
O banco de dados optou por não utilizar o índice nesta consulta e fazer uma leitura completa da tabela. 
Isso acontece devido à presença da operação OR na cláusula WHERE. O uso do operador OR pode dificultar a 
utilização eficiente de índices, pois o banco precisa considerar duas condições separadas. Neste caso, para 
satisfazer a condição classificacao = 'M3', o índice pode ser útil, mas para a condição massa < 1, o índice 
não é tão eficaz

2. Consulta 2: select * from estrela where classificacao = 'M3';
O banco de dados optou por utilizar o índice IDX_CLASS_MASSA nesta consulta, porque a consulta tem uma única condição 
na coluna classificacao, e o índice na coluna classificacao é eficiente para localizar rapidamente as linhas correspondentes. 
Portanto, o banco optou por realizar uma varredura no índice (INDEX RANGE SCAN), o que torna a operação mais eficiente.

3. Consulta 3 (select * from estrela where massa < 1;);
O banco de dados optou por não utilizar o índice nesta consulta, provavelmente porque a condição massa < 1 por si só não é tão
seletiva, o que significa que muitas linhas da tabela podem atender a essa condição. Como resultado, o otimizador de consultas 
considerou que o uso de um índice não seria tão eficiente quanto uma leitura completa da tabela. Diferentemente do que aconteceu
na consulta 2 e na consulta inicial, já que a condição classificação = M3 deve ser mais seletiva e por isso o banco de dados
encara como mais eficiente usar o índice.
*/



-- QUEATAO 7 ---------------------------------------------------------------------------------------------------------

-- Analisando o desempenho da consulta sem a utilização do index:
EXPLAIN PLAN FOR 
SELECT CLASSIFICACAO, COUNT(*) FROM ESTRELA
    GROUP BY CLASSIFICACAO;
    
SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/*
Plan hash value: 2618708603
 
------------------------------------------------------------------------------
| Id  | Operation          | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |         |  1235 |  6175 |    16   (7)| 00:00:01 |
|   1 |  HASH GROUP BY     |         |  1235 |  6175 |    16   (7)| 00:00:01 |
|   2 |   TABLE ACCESS FULL| ESTRELA |  6586 | 32930 |    15   (0)| 00:00:01 |
------------------------------------------------------------------------------
*/

--Criando o indice:
CREATE BITMAP INDEX IDX_CLASSIFICACAO ON ESTRELA(classificacao);

--Analisando o desempepnho da busca após a criação do index:
EXPLAIN PLAN FOR 
SELECT CLASSIFICACAO, COUNT(*) FROM ESTRELA
    GROUP BY CLASSIFICACAO;
    
SELECT plan_table_output
FROM TABLE(dbms_xplan.display());
/*Plan hash value: 3865298374
 
---------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |                   |  1235 |  6175 |     8  (25)| 00:00:01 |
|   1 |  HASH GROUP BY                |                   |  1235 |  6175 |     8  (25)| 00:00:01 |
|   2 |   BITMAP CONVERSION COUNT     |                   |  6586 | 32930 |     6   (0)| 00:00:01 |
|   3 |    BITMAP INDEX FAST FULL SCAN| IDX_CLASSIFICACAO |       |       |            |          |
---------------------------------------------------------------------------------------------------
*/

/*

Explicando o raciocínio utilizado:

Quando nos deparamos com a pesquisa, pensamos logo que, por se tratar do atributo  classificação, 
haveriam vários valores repetidos e, sendo assim, uma baixa cardinalidade. No entanto, ao realizar
a busca, vimos várias classificações, de modo que na grande maioria delas somente um astro se encaixa, 
passando a ideia de que a baixa cardinalidade poderia não ser verdade.

Pensando nisso, implementamos primeiramente um índice por árvore B (comum), pensando inclusive que o 
sgbd teria maior facilidade de realizar a operação count já que os elementos nessa estrutura são organizados
em sequência. Porém, ao analiar o desempenho da busca, vimos que a estrutura de índice não estava sendo
utilizada, de modo a apresentar um desempenho idêntico à pesquisa sem índice.

Foi então que revivemos a ideia de utilizar o bitmap index, e dessa vez a pesquisa foi mais eficiente, com
um custo reduzido pela metade, apesar de maior uso da CPU. Isso nos fez perceber que a teoria da baixa cardinalidade
pode ser aplicada nesse atributo, apesar de visualmente parecer o contrário. Além disso, outro fator que contribuiu 
com essa melhora de desempenho foi a redução do acesso à tabela e a alta eficiência do índice na realização da
operação GROUP BY.

*/


-- QUEATAO 8 ---------------------------------------------------------------------------------------------------------

-- Consulta a ser analisada: mostra a quantidade de especies em cada categoria de planeta
EXPLAIN PLAN FOR
SELECT P.CLASSIFICACAO, COUNT(E.NOME)
FROM ESPECIE E
RIGHT JOIN PLANETA P ON E.planeta_or = P.id_astro
GROUP BY CLASSIFICACAO;

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());

/*
-------------------------------------------------------------------------------------------
| Id  | Operation              | Name     | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT       |          | 49896 |  3605K|       |  1116   (1)| 00:00:01 |
|   1 |  HASH GROUP BY         |          | 49896 |  3605K|  4560K|  1116   (1)| 00:00:01 |
|*  2 |   HASH JOIN RIGHT OUTER|          | 55155 |  3985K|       |   210   (3)| 00:00:01 |
|   3 |    VIEW                | VW_GBC_5 | 32668 |   861K|       |    72   (6)| 00:00:01 |
|   4 |     HASH GROUP BY      |          | 32668 |   446K|       |    72   (6)| 00:00:01 |
|   5 |      TABLE ACCESS FULL | ESPECIE  | 49994 |   683K|       |    69   (2)| 00:00:01 |
|   6 |    TABLE ACCESS FULL   | PLANETA  | 55155 |  2531K|       |   137   (1)| 00:00:01 |
-------------------------------------------------------------------------------------------*/

-- Criando um bitmap join index
CREATE BITMAP INDEX BJI_ESPECIE_PLANETA
ON ESPECIE(P.CLASSIFICACAO)
FROM ESPECIE E, PLANETA P
WHERE E.PLANETA_OR = P.ID_ASTRO;

/* Aqui estamos criando um bitmap na tabela especie onde será indexado a coluna PLANETA.CLASSIFICACAO.
Esse indice faz com que não haja a necessidade de acessar completamente a tabela de Planeta, já que a única
informação que demanda o acesso à essa tabela estará indexada na tabela Especie.

Vamos agora analisar o resultado da busca após a criação do bitmap join index:
*/

EXPLAIN PLAN FOR
SELECT P.CLASSIFICACAO, COUNT(E.NOME)
FROM ESPECIE E
RIGHT JOIN PLANETA P ON E.planeta_or = P.id_astro
GROUP BY CLASSIFICACAO;

SELECT plan_table_output
FROM TABLE(dbms_xplan.display());
/*-------------------------------------------------------------------------------------------
| Id  | Operation              | Name     | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT       |          | 49896 |  3605K|       |  1116   (1)| 00:00:01 |
|   1 |  HASH GROUP BY         |          | 49896 |  3605K|  4560K|  1116   (1)| 00:00:01 |
|*  2 |   HASH JOIN RIGHT OUTER|          | 55155 |  3985K|       |   210   (3)| 00:00:01 |
|   3 |    VIEW                | VW_GBC_5 | 32668 |   861K|       |    72   (6)| 00:00:01 |
|   4 |     HASH GROUP BY      |          | 32668 |   446K|       |    72   (6)| 00:00:01 |
|   5 |      TABLE ACCESS FULL | ESPECIE  | 49994 |   683K|       |    69   (2)| 00:00:01 |
|   6 |    TABLE ACCESS FULL   | PLANETA  | 55155 |  2531K|       |   137   (1)| 00:00:01 |
-------------------------------------------------------------------------------------------*/

/* Observações:

A criação do bitmap join index facilita a busca devido à indexação do atributo Classificacao na
tabela de especie, já que tanto atributos de espécie e Planeta.Classificação serão utilizados na busca,
configurando a necessidade de uma junção entre essas tabelas. No entanto, podemos observar que o
otimizador optou por acessar as duas tabelas inteiramente. Isso provavelmente acontece devidoà complexidade
da pesquisa ou então devido à grande diversidade de valores permitidos por Planeta.Classificação. */









