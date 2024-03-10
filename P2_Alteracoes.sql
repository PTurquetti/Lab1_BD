-- Exercício 4
-- 4.a)
/* Foi executada a seguinte alteracao, adicionando o atributo NIVEL_TECNOLOGICO  em especie,
como ele nao eh um atributo NOT NULL, eh atribuido o valor NULL a esse atributo nas tabelas ja existentes*/
ALTER TABLE ESPECIE
ADD NIVEL_TECNOLOGICO VARCHAR2(10);

-- 4.b)
/* Alterando a tabela PLANETA, adicionamos o atributo EH_HABITADO, um booleano que admite S para SIM e N
para NAO, como foi estabelecido que o DEFAULT seria N, as tuplas ja existentes admitem o valor N nesse atributo*/
ALTER TABLE PLANETA
ADD EH_HABITADO CHAR(1) DEFAULT 'N' CHECK (EH_HABITADO IN ('S', 'N'));

-- 4.c)
/* Foi dropada a constraint que checava o cargo do lider*/ 
ALTER TABLE LIDER
DROP CONSTRAINT CK_CARGOLIDER;

-- 4.d)
/* Criando um novo CHECK exatamente para o atributo de cargo que acabamos de dropar, mas agora
testando para novos cargos, a primeira tentativa foi fazer da seguinte forma:*/
ALTER TABLE LIDER
ADD CONSTRAINT CK_CARGO CHECK (UPPER(CARGO) IN ('EXPLORADOR', 'DIPLOMATA', 'ENGENHEIRO'));
/* Entretanto, como ja existem dados nas tuplas para cargo e eles nao se adequam aos dados novos, ocorreu um erro
que nao deixou com que nos mudassemos o CHECK assim. Para contornar a situacao, procuramos o uso do NOVALIDATE. 
Então, agora o script inclui a opção NOVALIDATE ao criar a restrição CK_CARGO, que implica que os dados existentes 
não serão validados, mas futuras inserções ou atualizações serão verificadas pela nova restrição. Assim, ficamos com o seguinte:*/
ALTER TABLE LIDER
ADD CONSTRAINT CK_CARGO CHECK (UPPER(CARGO) IN ('EXPLORADOR', 'DIPLOMATA', 'ENGENHEIRO')) NOVALIDATE;
/* Agora, se tentamos incluir um dado com um dos cargos anteriores eh apresentado erro, mas os que ja existiam
continuam inalterados. Dessa forma, uma insercao que daria erro e umaa que rodaria normalmente sao, respectivamente:*/
-- !ERRO! 
-- Tentativa de insercao de dado que nao atende a nova restricao
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES (4, 'Darth Vader', 'COMANDANTE', 'Martianos Unidos', 'Humano');
-- Tentativa de inserção de dado que atende à nova restrição
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES (5, 'Luke Skywalker', 'EXPLORADOR', 'Terra Unida', 'Humano');

-- 4.e)
-- i.
/* Aqui foi alterada a tabela FEDERACAO para que o DEFAULT da DATA_FUND fosse SYSDATE, que eh a data atual no sistema*/ 
ALTER TABLE FEDERACAO
MODIFY (DATA_FUND DEFAULT SYSDATE);
-- ii.
/* Aqui o atributo EH_INTELIGENTE da tabela ESPECIE foi modificado para admitir o valor NULL em insercoes futuras*/ 
ALTER TABLE ESPECIE
MODIFY EH_INTELIGENTE CHAR;

-- 4.g)
-- i
/* Vamos remover a tabela FEDERACAO do sistema. Esta tabela é referenciada pela tabela NACAO. 
Analisando a estrutura e dados da tabela FEDERACAO:*/
-- Visualizar a estrutura da tabela FEDERACAO e NACAO
DESCRIBE FEDERACAO;
DESCRIBE NACAO;

-- Visualizar as constraints e índices de FEDERACAO e depois NACAO
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM ALL_CONSTRAINTS
WHERE TABLE_NAME IN ('FEDERACAO');

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM ALL_CONSTRAINTS
WHERE TABLE_NAME IN ('NACAO');

-- Visualizar dados na tabela NACAO e FEDERACAO
SELECT * FROM NACAO;
SELECT * FROM FEDERACAO;

-- ii.
/* Para dropar a tabela FEDERACAO, primeiro temos que dropar a FK de NACAO, que a referencia:*/
ALTER TABLE NACAO DROP CONSTRAINT FK_NACAO;
DROP TABLE FEDERACAO;

-- Visualizar a estrutura da tabela NACAO
DESCRIBE NACAO;

-- Visualizar as constraints e índices de NACAO
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM ALL_CONSTRAINTS
WHERE TABLE_NAME IN ('NACAO');

-- Visualizar dados na tabela NACAO
SELECT * FROM NACAO;

/* Após a remocao da FK de NACAO e, posteriormente da tabela FEDERACAO, os dados ja
inseridos no atributo FEDERACAO de nacao continuam la, nao afetando os dados anteriores*/

