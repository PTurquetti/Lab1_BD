-- QUESTAO 3

-- a)
DELETE FROM SISTEMA WHERE ESTRELA = '123456';
/* A tabela sistema nao eh referenciada por nenhuma outra tabela */



-- b)
DELETE FROM PLANETA WHERE DESIGNACAO_ASTRONOMICA = 'Vênus';
/* A tabela Planeta eh referenciada pelas tabelas OrbinaPlaneta, Especie, Habitacao
e Dominancia. No entanto, a tupla que possui DESIGNACAO_ASTRONOMICA = 'Vênus' nao eh
referenciada em nenhuma tupla das tabelas citadas anteriormente, configurando o caso
proposto pelo enunciado
*/
