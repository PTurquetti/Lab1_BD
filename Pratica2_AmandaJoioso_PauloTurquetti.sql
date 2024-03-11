-- LABORATORIO 2

-- Amanda Valukas Breviglieri Joioso - 4818232
-- Paulo Henrique Vedovatto Turquetti - 13750791



/* OBS: Foram feitas algumas correcoes em relacao a contraints de foreign keys.
Segue abaixo o script de criação das tabelas (todas as estruturas foram mantidas
da pratica 1 */

--Criacao da tabela Federacao
CREATE TABLE FEDERACAO (
    NOME_FD VARCHAR2(50) NOT NULL,
    DATA_FUND DATE,
    CONSTRAINT PK_FEDERACAO PRIMARY KEY (NOME_FD)
);


--Criacao da tabela Nacao
CREATE TABLE NACAO(
    NOME_NC VARCHAR(50) NOT NULL,
    QTD_PLANETAS NUMBER,
    FEDERACAO VARCHAR(50),
    CONSTRAINT PK_NACAO PRIMARY KEY (NOME_NC),
    /* Como na descricao nao ha nenhuma afirmacao de que uma nacao nao pode existir sem uma federacao,
    ela nao deve ser excluida se uma federacao for, então apenas marcamos o campo de federacao como null nesse caso,
    por isso o uso do ON DELETE SET NULL*/
    CONSTRAINT FK_NACAO FOREIGN KEY (FEDERACAO) REFERENCES FEDERACAO (NOME_FD) ON DELETE SET NULL 
);


--Criacao da tabela Lider
CREATE TABLE LIDER (
    CPI NUMBER NOT NULL,
    NOME VARCHAR2(50),
    CARGO VARCHAR2(10) NOT NULL,
    NACAO VARCHAR2(50) NOT NULL,
    ESPECIE VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_LIDER PRIMARY KEY (CPI),
    /* Caso uma nacao deixe de exixstir, o registro de lider tambem deve ser apagado, pois ele nao pode ser o lider sem
    uma ncao para liderar, por isso o uso do ON DELETE CASCADE*/
    CONSTRAINT FK_LIDER FOREIGN KEY (NACAO) REFERENCES NACAO (NOME_NC) ON DELETE CASCADE,
    -- CHECK para conferir se o cargo do lider se encaixa em uma das categorias validas
    CONSTRAINT CK_CARGOLIDER CHECK (UPPER(CARGO) IN ('COMANDANTE', 'OFICIAL', 'CIENTISTA'))
);


--Criacao da tabela Faccao
CREATE TABLE FACCAO (
    NOME_FC VARCHAR2(50) NOT NULL,
    LIDER_FC NUMBER NOT NULL,
    IDEOLOGIA VARCHAR2(15),
    QTD_NACOES NUMBER,
    CONSTRAINT PK_FACCAO PRIMARY KEY (NOME_FC),
    CONSTRAINT UK_FACCAO UNIQUE (LIDER_FC),
    /* Nessa FOREIGN KEY nao foi colocado nenhum ON DELETE, pois nao faz sentido logicamente deletar toda 
    uma faccao ao se deletar apenas um lider e, como LIDER_FC  eh NOT NULL de acordo com o modelo, nao podemos
    fazer o ON DELETE SET NULL, entao o ideal seria fazer um update antes de se deletar o lider*/
    CONSTRAINT FK_FACCAO FOREIGN KEY (LIDER_FC) REFERENCES LIDER (CPI),
    -- CHECK para conferir se a ideologia se encaixa em uma das categorias validas
    CONSTRAINT CK_IDEOLOGIAFACCAO CHECK (UPPER(IDEOLOGIA) IN ('PROGRESSISTA', 'TOTALITARIA', 'TRADICIONALISTA'))
);


--Criacao da tabela NacaoFaccao
CREATE TABLE NACAOFACCAO (
    NACAO VARCHAR2(50) NOT NULL,
    FACCAO VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_NACAOFACCAO PRIMARY KEY (NACAO, FACCAO),
    /* Como essa tabela mapeia o relacionamento de uma nacao e uma faccao, se uma faccao deixa de existir,
    essa relacao tambem deixa e vice-versa, por isso o uso do ON DELETE CASCADE*/
    CONSTRAINT FK_NACAOFACCAO1 FOREIGN KEY (FACCAO) REFERENCES FACCAO (NOME_FC) ON DELETE CASCADE,
    CONSTRAINT FK_NACAOFACCAO2 FOREIGN KEY (NACAO) REFERENCES NACAO (NOME_NC) ON DELETE CASCADE
);

--Criacao da tabela Estrela
CREATE TABLE ESTRELA (
    ID_CATALOGO VARCHAR2(30) NOT NULL,
    NOME VARCHAR2(30),
    CLASSIFICACAO VARCHAR2(30),
    MASSA NUMBER,
    COORDENADA_X NUMBER NOT NULL,
    COORDENADA_Y NUMBER NOT NULL,
    COORDENADA_Z NUMBER NOT NULL,
    
    CONSTRAINT PK_ESTRELA PRIMARY KEY (ID_CATALOGO),
    CONSTRAINT SK_ESTRELA UNIQUE (COORDENADA_X, COORDENADA_y, COORDENADA_Z)
    /*Essa abordagem de ESTRELA não garante a obrigatoriedade compor um sistema ou orbitar direta/indiretamente uma estrela que compõe um sistema.
    Sendo assim, isso deve ser garantido em nível de aplicação*/
);    



--Criacao da tabela Sistema
CREATE TABLE SISTEMA (
    ESTRELA  VARCHAR2(30) NOT NULL,
    NOME VARCHAR2(30),
    
    CONSTRAINT PK_SISTEMA PRIMARY KEY (ESTRELA),
    CONSTRAINT FK_SISTEMA FOREIGN KEY (ESTRELA) 
                    REFERENCES ESTRELA(ID_CATALOGO)
                    ON DELETE CASCADE
);


--Criacao da tabela Planeta
CREATE TABLE PLANETA (
    DESIGNACAO_ASTRONOMICA VARCHAR2(30) NOT NULL,
    MASSA NUMBER,
    RAIO NUMBER,
    COMPOSICAO VARCHAR2(100),
    CLASSIFICACAO VARCHAR2(30),
    
    CONSTRAINT PK_PLANETA PRIMARY KEY (DESIGNACAO_ASTRONOMICA)
);


--Criacao da tabela OrbitaEstrela
CREATE TABLE ORBITAESTRELA (
    ORBITANTE VARCHAR2(30) NOT NULL,
    ORBITADA VARCHAR2(30) NOT NULL,
    DISTANCIA_MIN NUMBER,
    DISTANCIA_MAX NUMBER,
    PERIODO NUMBER,
    
    CONSTRAINT PK_ORBITAESTRELA PRIMARY KEY (ORBITANTE, ORBITADA),
    CONSTRAINT FK1_ORBITAESTRELA FOREIGN KEY (ORBITANTE)
                            REFERENCES ESTRELA (ID_CATALOGO)
                            ON DELETE CASCADE,
    CONSTRAINT FK2_ORBITAESTRELA FOREIGN KEY (ORBITADA)
                            REFERENCES ESTRELA (ID_CATALOGO)
                            ON DELETE CASCADE
);

--Criacao da tabela OrbitaPlaneta
CREATE TABLE ORBITAPLANETA (
    PLANETA VARCHAR2(30) NOT NULL,
    ESTRELA VARCHAR2(30) NOT NULL,
    DISTANCIA_MIN NUMBER,
    DISTANCIA_MAX NUMBER,
    PERIODO NUMBER,
    
    CONSTRAINT PK_ORBITAPLANETA PRIMARY KEY (PLANETA, ESTRELA),
    CONSTRAINT FK1_ORBITAPLANETA FOREIGN KEY (PLANETA)
                        REFERENCES PLANETA (DESIGNACAO_ASTRONOMICA)
                        ON DELETE CASCADE,
    CONSTRAINT FK2_ORBITAPLANETA FOREIGN KEY (ESTRELA)
                        REFERENCES ESTRELA (ID_CATALOGO)
                        ON DELETE CASCADE
);


--Criacao da tabela Especie
CREATE TABLE ESPECIE (
    NOME_CIENTIFICO VARCHAR2(30) NOT NULL,
    PLANETA_ORIGEM VARCHAR2(30) NOT NULL,
    EH_INTELIGENTE CHAR(1) NOT NULL,
    
    CONSTRAINT PK_ESPECIE PRIMARY KEY (NOME_CIENTIFICO),
    /* Como toda especie tem um planeta de origem e esse atributo eh NOT NULL, se um planeta deixar de
    existir, essa especie tambem deixara, por isso o uso do ON DELETE CASCADE*/
    CONSTRAINT FK_ESPECIE FOREIGN KEY (PLANETA_ORIGEM)
                        REFERENCES PLANETA (DESIGNACAO_ASTRONOMICA)
                        ON DELETE CASCADE,
    -- Checa se a especie eh inteligente ou nao
    CONSTRAINT CK_ESPECIE CHECK (UPPER(EH_INTELIGENTE) IN ('S', 'N'))
);


--Criacao da tabela Dominancia
CREATE TABLE DOMINANCIA (
    NACAO VARCHAR2(50) NOT NULL,
    PLANETA VARCHAR2(30) NOT NULL,
    DATA_INI DATE NOT NULL,
    DATA_FIM DATE,
    CONSTRAINT PK_DOMINANCIA PRIMARY KEY (NACAO, PLANETA, DATA_INI),
    /* Como essa tabela mapeia o relacionamento de um planeta e uma nacao, se um planeta deixa de existir,
    essa relacao tambem deixa e vice-versa, por isso o uso do ON DELETE CASCADE*/
    CONSTRAINT FK_DOMINANCIA1 FOREIGN KEY (NACAO) REFERENCES NACAO (NOME_NC) ON DELETE CASCADE,
    CONSTRAINT FK_DOMINANCIA2 FOREIGN KEY (PLANETA) REFERENCES PLANETA (DESIGNACAO_ASTRONOMICA) ON DELETE CASCADE
);


--Criacao da tabela Comunidade
CREATE TABLE COMUNIDADE (
    ESPECIE VARCHAR2(30) NOT NULL,
    NOME VARCHAR2(50) NOT NULL,
    QTD_HABITANTES NUMBER, 
    CONSTRAINT PK_COMUNIDADE PRIMARY KEY (ESPECIE, NOME),
    /* Se uma especie deixa e existir, a comunidade que era composta por essa especia tambem deixa,
    por isso o uso do ON DELETE CASCADE*/
    CONSTRAINT FK_COMUNIDADE FOREIGN KEY (ESPECIE) REFERENCES ESPECIE (NOME_CIENTIFICO) ON DELETE CASCADE
);


--Criacao da tabela Participa
CREATE TABLE PARTICIPA (
    FACCAO VARCHAR2(50) NOT NULL,
    COM_ESPECIE VARCHAR2(30) NOT NULL,
    COM_NOME VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_PARTICIPA PRIMARY KEY (FACCAO, COM_ESPECIE, COM_NOME),
    CONSTRAINT FK_PARTICIPA FOREIGN KEY (COM_ESPECIE, COM_NOME) 
                        REFERENCES COMUNIDADE (ESPECIE, NOME)
                        ON DELETE CASCADE
    /*Caso a comunidade seja deletada, nao faz sentido a participacao continuar exsitindo, ja que ela depende da comunidade para ser definida*/
);


--Criacao da tabela Habitacao
CREATE TABLE HABITACAO (
    PLANETA VARCHAR2(30) NOT NULL,
    COM_ESPECIE VARCHAR2(30) NOT NULL,
    COM_NOME VARCHAR2(30) NOT NULL,
    DT_INICIO DATE NOT NULL,
    DT_FIM DATE,
    
    CONSTRAINT PK_HABITACAO PRIMARY KEY (PLANETA, COM_ESPECIE, 
                                        COM_NOME, DT_INICIO),
    CONSTRAINT FK1_HABITACAO FOREIGN KEY (PLANETA)
                        REFERENCES PLANETA (DESIGNACAO_ASTRONOMICA)
                        ON DELETE CASCADE,
    /*Caso o planeta seja deletado, nao faz sentido a habitacao continuar exsitindo, ja que ela depende de planeta para ser definida*/
    CONSTRAINT FK2_HABITACAO FOREIGN KEY (COM_ESPECIE, COM_NOME)
                        REFERENCES COMUNIDADE (ESPECIE, NOME)
                        ON DELETE CASCADE
    /*Caso a comunidade seja deletada, nao faz sentido a habitacao continuar exsitindo, ja que ela depende da comunidade para ser definida*/
);

-- ----------------------------------------------------------------------------------------------------------------------------------------------------

-- INICIO PRATICA 2


-- EXERCICIO 1 - INSERCAO DE DADOS

-- Inserindo dados na tabela FEDERACAO
INSERT INTO FEDERACAO (NOME_FD, DATA_FUND) VALUES ('Aliança Galáctica', TO_DATE('01-01-2200', 'DD-MM-YYYY'));
INSERT INTO FEDERACAO (NOME_FD, DATA_FUND) VALUES ('Comando Estelar', TO_DATE('09-10-2199', 'DD-MM-YYYY'));

-- Inserindo dados na tabela NACAO
INSERT INTO NACAO (NOME_NC, QTD_PLANETAS, FEDERACAO) VALUES ('Terra Unida', 10, 'Aliança Galáctica');
INSERT INTO NACAO (NOME_NC, QTD_PLANETAS, FEDERACAO) VALUES ('Martianos Unidos', NULL, 'Comando Estelar');

-- Inserindo dados na tabela PLANETA
INSERT INTO PLANETA (DESIGNACAO_ASTRONOMICA, MASSA, RAIO, COMPOSICAO, CLASSIFICACAO) VALUES ('Terra', 5.972 * POWER(10, 24), 6371, 'Nitrogenio e Oxigenio', 'Terrestre');
INSERT INTO PLANETA (DESIGNACAO_ASTRONOMICA, MASSA, RAIO, COMPOSICAO, CLASSIFICACAO) VALUES ('Marte', 6.417 * POWER(10, 23), 3389.5, 'Dióxido de Carbono', 'Terrestre');
INSERT INTO PLANETA (DESIGNACAO_ASTRONOMICA, MASSA, RAIO, COMPOSICAO, CLASSIFICACAO) VALUES ('Venus', 4.867e24, 6051.8, 'Dióxido de Carbono, Nitrogênio', 'Terrestre');

-- Inserindo dados na tabela ESPECIE
INSERT INTO ESPECIE (NOME_CIENTIFICO, PLANETA_ORIGEM, EH_INTELIGENTE) VALUES ('Humanos', 'Terra', 'S');
INSERT INTO ESPECIE (NOME_CIENTIFICO, PLANETA_ORIGEM, EH_INTELIGENTE) VALUES ('Marcianos', 'Marte', 'N');

-- Inserindo dados na tabela LIDER
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES (1, 'Capitã Aria Nova', 'Comandante', 'Terra Unida', 'Humanos');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES (2, 'General Zorg', 'Comandante', 'Martianos Unidos', 'Marcianos');

-- Inserindo dados na tabela FACCAO
INSERT INTO FACCAO (NOME_FC, LIDER_FC, IDEOLOGIA, QTD_NACOES) VALUES ('Progressistas Celestiais', 1, 'Progressista', 3);
INSERT INTO FACCAO (NOME_FC, LIDER_FC, IDEOLOGIA, QTD_NACOES) VALUES ('Conservadores Cósmicos', 2, 'Tradicionalista', NULL);

-- Inserindo dados na tabela NACAOFACCAO
INSERT INTO NACAOFACCAO (NACAO, FACCAO) VALUES ('Terra Unida', 'Progressistas Celestiais');
INSERT INTO NACAOFACCAO (NACAO, FACCAO) VALUES ('Martianos Unidos', 'Conservadores Cósmicos');

-- Inserindo dados na tabela ESTRELA
INSERT INTO ESTRELA (ID_CATALOGO, NOME, CLASSIFICACAO, MASSA, COORDENADA_X, COORDENADA_Y, COORDENADA_Z) VALUES ('123456', 'Sol', 'Classe G', 1.989 * POWER(10, 30), 1, 2, 3);
INSERT INTO ESTRELA (ID_CATALOGO, NOME, CLASSIFICACAO, MASSA, COORDENADA_X, COORDENADA_Y, COORDENADA_Z) VALUES ('654321', 'Alpha Centauri A', 'Classe M', NULL, 4, 5, 6);


-- Inserindo dados na tabela SISTEMA
INSERT INTO SISTEMA (ESTRELA, NOME) VALUES ('123456', 'Sistema Solar');
INSERT INTO SISTEMA (ESTRELA, NOME) VALUES ('654321', 'Sistema Alpha');

-- Inserindo dados na tabela ORBITAESTRELA
INSERT INTO ORBITAESTRELA (ORBITANTE, ORBITADA, DISTANCIA_MIN, DISTANCIA_MAX, PERIODO) VALUES ('123456', '654321', 10, 20, 30);
INSERT INTO ORBITAESTRELA (ORBITANTE, ORBITADA, DISTANCIA_MIN, DISTANCIA_MAX, PERIODO) VALUES ('654321', '123456', 10, 20, 30);

-- Inserindo dados na tabela ORBITAPLANETA
INSERT INTO ORBITAPLANETA (PLANETA, ESTRELA, DISTANCIA_MIN, DISTANCIA_MAX, PERIODO) VALUES ('Terra', '123456', 50, 100, 365);
INSERT INTO ORBITAPLANETA (PLANETA, ESTRELA, DISTANCIA_MIN, DISTANCIA_MAX, PERIODO) VALUES ('Marte', '654321', 100, 200, 687);

-- Inserindo dados na tabela DOMINANCIA
INSERT INTO DOMINANCIA (NACAO, PLANETA, DATA_INI, DATA_FIM) VALUES ('Terra Unida', 'Terra', TO_DATE('2200-01-01', 'YYYY-MM-DD'), NULL);
INSERT INTO DOMINANCIA (NACAO, PLANETA, DATA_INI, DATA_FIM) VALUES ('Martianos Unidos', 'Marte', TO_DATE('2200-01-01', 'YYYY-MM-DD'), TO_DATE('2222-12-31', 'YYYY-MM-DD'));

-- Inserindo dados na tabela COMUNIDADE
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Humanos', 'Metropolis', 10000000);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Marcianos', 'Red Valley', 5000000);

-- Inserindo dados na tabela PARTICIPA
INSERT INTO PARTICIPA (FACCAO, COM_ESPECIE, COM_NOME) VALUES ('Progressistas Celestiais', 'Humanos', 'Metropolis');
INSERT INTO PARTICIPA (FACCAO, COM_ESPECIE, COM_NOME) VALUES ('Conservadores Cósmicos', 'Marcianos', 'Red Valley');

-- Inserindo dados na tabela HABITACAO
INSERT INTO HABITACAO (PLANETA, COM_ESPECIE, COM_NOME, DT_INICIO, DT_FIM) VALUES ('Terra', 'Humanos', 'Metropolis', TO_DATE('2200-01-01', 'YYYY-MM-DD'), NULL);
INSERT INTO HABITACAO (PLANETA, COM_ESPECIE, COM_NOME, DT_INICIO, DT_FIM) VALUES ('Marte', 'Marcianos', 'Red Valley', TO_DATE('2200-01-01', 'YYYY-MM-DD'), TO_DATE('2300-12-31', 'YYYY-MM-DD'));

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- EXERCICIO 2 - UPDATES

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


-- ---------------------------------------------------------------------------

-- EXERCICIO 3 - DELETES

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


-- ----------------------------------------------------------------------

-- EXERCICIO 4 - ALTERACOES

-- a)
/* Foi executada a seguinte alteracao, adicionando o atributo NIVEL_TECNOLOGICO  em especie,
como ele nao eh um atributo NOT NULL, eh atribuido o valor NULL a esse atributo nas tabelas ja existentes*/
ALTER TABLE ESPECIE
ADD NIVEL_TECNOLOGICO VARCHAR2(10);

-- b)
/* Alterando a tabela PLANETA, adicionamos o atributo EH_HABITADO, um booleano que admite S para SIM e N
para NAO, como foi estabelecido que o DEFAULT seria N, as tuplas ja existentes admitem o valor N nesse atributo*/
ALTER TABLE PLANETA
ADD EH_HABITADO CHAR(1) DEFAULT 'N' CHECK (EH_HABITADO IN ('S', 'N'));

-- c)
/* Foi dropada a constraint que checava o cargo do lider*/ 
ALTER TABLE LIDER
DROP CONSTRAINT CK_CARGOLIDER;

-- d)
/* Criando um novo CHECK exatamente para o atributo de cargo que acabamos de dropar, mas agora
testando para novos cargos, a primeira tentativa foi fazer da seguinte forma:*/
-- [VERSAO QUE DA ERRO] ALTER TABLE LIDER ADD CONSTRAINT CK_CARGO CHECK (UPPER(CARGO) IN ('EXPLORADOR', 'DIPLOMATA', 'ENGENHEIRO'));
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
-- [VERSAO QUE DA ERRO] INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES (4, 'Darth Vader', 'COMANDANTE', 'Martianos Unidos', 'Humano');
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



-- f)
-- i


-- g)
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











