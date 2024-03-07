-- QUESTAO 3

-- a)
DELETE FROM SISTEMA WHERE ESTRELA = '123456';
/* A tabela sistema nao eh referenciada por nenhuma outra tabela */



-- b)
DELETE FROM PLANETA WHERE DESIGNACAO_ASTRONOMICA = 'Vênus';
/* A tabela Planeta eh referenciada pelas tabelas OrbinaPlaneta, Especie, Habitacao
e Dominancia. No entanto, a tupla que possui DESIGNACAO_ASTRONOMICA = 'Vênus' nao eh
referenciada em nenhuma tupla das tabelas citadas anteriormente, nao gerando nenhum
impacto em tuplas referentes a outras tabelas, configurando o caso proposto */


-- c)
DELETE FROM ESTRELA WHERE ID_CATALOGO = '123456';
/* A tabela Estrela eh referenciada por Sistema, OrbitaEstrela e OrbitaPlaneta.
Nessas tabelas, a constraints de foreign key direcionadas a Estrelas possuem
ON DELETE CASCADE como acao de remocao. Sendo assim, ao deletarmos a estrela 
com ID_CATALOGO = '123456' (sol), estamos deletando todas as tuplas que fazem
referencia a essa estrela nas tabelas de Sistema, OrbitaEstrela e OrbitaPlaneta */

