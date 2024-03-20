-- Excluindo a base de dados existente:
DROP TABLE COMUNIDADE CASCADE CONSTRAINTS;
DROP TABLE DOMINANCIA CASCADE CONSTRAINTS;
DROP TABLE ESPECIE CASCADE CONSTRAINTS;
DROP TABLE ESTRELA CASCADE CONSTRAINTS;
DROP TABLE FACCAO CASCADE CONSTRAINTS;
DROP TABLE FEDERACAO CASCADE CONSTRAINTS;
DROP TABLE HABITACAO CASCADE CONSTRAINTS;
DROP TABLE LIDER CASCADE CONSTRAINTS;
DROP TABLE NACAO CASCADE CONSTRAINTS;
DROP TABLE NACAOFACCAO CASCADE CONSTRAINTS;
DROP TABLE ORBITAESTRELA CASCADE CONSTRAINTS;
DROP TABLE ORBITAPLANETA CASCADE CONSTRAINTS;
DROP TABLE PARTICIPA CASCADE CONSTRAINTS;
DROP TABLE PLANETA CASCADE CONSTRAINTS;
DROP TABLE SISTEMA CASCADE CONSTRAINTS;






-- Criando as tabelas
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






-- Inserindo dados
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



-- -----------------------------------------------------------------------------------------------------------


-- INICIP PRATICA 3 - BUSCAS




-- 3.A)
SELECT F.NOME_FC AS NOME_FACCAO, F.IDEOLOGIA AS IDEOLODIA_FACCAO, L.NOME AS LIDER, L.ESPECIE AS ESPECIE_LIDER, L.NACAO AS NACAO_LIDER
FROM FACCAO F JOIN LIDER L
ON F.LIDER_FC = L.CPI;

 
-- 3.B)
-- inserindo um lider que nao eh responsavel por nenhuma faccao, para testar o left join
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES (3, 'Anakin Skywalker', 'Comandante', 'Terra Unida', 'Humanos');

SELECT L.CPI, L.NOME, L.NACAO, L.ESPECIE, E.PLANETA_ORIGEM, F.NOME_FC
FROM LIDER L
JOIN ESPECIE E ON L.ESPECIE = E.NOME_CIENTIFICO
LEFT JOIN FACCAO F ON L.CPI = F.LIDER_FC;

-- 3.C)
-- insercao de mais estrelas e relacao orbitaestrela para teste
INSERT INTO ESTRELA (ID_CATALOGO, NOME, CLASSIFICACAO, MASSA, COORDENADA_X, COORDENADA_Y, COORDENADA_Z) VALUES ('78910', 'Sirius', 'Classe A', 2.0 * POWER(10, 30), 100, 200, 300);
INSERT INTO ESTRELA (ID_CATALOGO, NOME, CLASSIFICACAO, MASSA, COORDENADA_X, COORDENADA_Y, COORDENADA_Z) VALUES ('10987', 'Aldebaran', 'Classe B', 1.5 * POWER(10, 30), 150, 250, 350);
INSERT INTO ESTRELA (ID_CATALOGO, NOME, CLASSIFICACAO, MASSA, COORDENADA_X, COORDENADA_Y, COORDENADA_Z) VALUES ('11121', 'Vega', 'Classe F', 1.8 * POWER(10, 30), 200, 300, 400);

INSERT INTO ORBITAESTRELA (ORBITANTE, ORBITADA, DISTANCIA_MIN, DISTANCIA_MAX, PERIODO) VALUES ('78910', '10987', 75, 125, 400);
INSERT INTO ORBITAESTRELA (ORBITANTE, ORBITADA, DISTANCIA_MIN, DISTANCIA_MAX, PERIODO) VALUES ('11121', '10987', 150, 200, 500);

SELECT E1.NOME AS NOME_ORBITANTE, E1.CLASSIFICACAO AS CLASSIFICACAO_ORBITANTE,
E2.NOME AS NOME_ORBITADA, E2.CLASSIFICACAO AS CLASSIFICACAO_ORBITADA
FROM ORBITAESTRELA OE
JOIN ESTRELA E1 ON OE.ORBITANTE = E1.ID_CATALOGO
JOIN ESTRELA E2 ON OE.ORBITADA = E2.ID_CATALOGO;


-- 3.D)
-- insercao de planetas, especies, comunidades e habitacoes para teste

-- Planetas
INSERT INTO PLANETA (DESIGNACAO_ASTRONOMICA, MASSA, RAIO, COMPOSICAO, CLASSIFICACAO) 
    VALUES ('Terra', 5.972 * POWER(10, 24), 6371, 'Nitrogenio e Oxigenio', 'Terrestre');
INSERT INTO PLANETA (DESIGNACAO_ASTRONOMICA, MASSA, RAIO, COMPOSICAO, CLASSIFICACAO) 
    VALUES ('Marte', 6.417 * POWER(10, 23), 3389.5, 'Dióxido de Carbono', 'Terrestre');


-- Especies
INSERT INTO ESPECIE (NOME_CIENTIFICO, PLANETA_ORIGEM, EH_INTELIGENTE) 
    VALUES ('Humanos', 'Terra', 'S');
INSERT INTO ESPECIE (NOME_CIENTIFICO, PLANETA_ORIGEM, EH_INTELIGENTE) 
    VALUES ('FEDERUPAS', 'Terra', 'N');
INSERT INTO ESPECIE (NOME_CIENTIFICO, PLANETA_ORIGEM, EH_INTELIGENTE) 
    VALUES ('USPIANOS', 'Terra', 'S');
INSERT INTO ESPECIE (NOME_CIENTIFICO, PLANETA_ORIGEM, EH_INTELIGENTE) 
    VALUES ('Computeiros', 'Terra', 'S');
INSERT INTO ESPECIE (NOME_CIENTIFICO, PLANETA_ORIGEM, EH_INTELIGENTE) 
    VALUES ('Marcianos', 'Marte', 'N');


-- Comunidades
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) 
    VALUES ('Humanos', 'Metropolis', 10000000);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) 
    VALUES ('FEDERUPAS', 'UFSCAR', 200);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) 
    VALUES ('USPIANOS', 'USP', 1500);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) 
    VALUES ('Computeiros', 'BSI', 1500);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) 
    VALUES ('Marcianos', 'Red Valley', 5000000);


-- Habitacoes
INSERT INTO HABITACAO (PLANETA, COM_ESPECIE, COM_NOME, DT_INICIO, DT_FIM) 
    VALUES ('Terra', 'Humanos', 'Metropolis', TO_DATE('2200-01-01', 'YYYY-MM-DD'), NULL);
INSERT INTO HABITACAO (PLANETA, COM_ESPECIE, COM_NOME, DT_INICIO, DT_FIM) 
    VALUES ('Terra', 'FEDERUPAS', 'UFSCAR', TO_DATE('2200-01-01', 'YYYY-MM-DD'), NULL);
INSERT INTO HABITACAO (PLANETA, COM_ESPECIE, COM_NOME, DT_INICIO, DT_FIM) 
    VALUES ('Terra', 'USPIANOS', 'USP', TO_DATE('2200-01-01', 'YYYY-MM-DD'), TO_DATE('2300-12-31', 'YYYY-MM-DD'));
INSERT INTO HABITACAO (PLANETA, COM_ESPECIE, COM_NOME, DT_INICIO, DT_FIM) 
    VALUES ('Terra', 'Computeiros', 'BSI', TO_DATE('2200-01-01', 'YYYY-MM-DD'), NULL);
INSERT INTO HABITACAO (PLANETA, COM_ESPECIE, COM_NOME, DT_INICIO, DT_FIM) 
    VALUES ('Marte', 'Marcianos', 'Red Valley', TO_DATE('2200-01-01', 'YYYY-MM-DD'), NULL);


/* 
Logica dos casos de teste:
A partir dos dados inseridos, temos os seguintes casos

Planeta Terra




Para fazer essa busca, sera feito um LEFT JOIN entre as duas tabelas seguintes: 

TABELA 1 - PLANETAS HABITADOS ATUALMENTE:
SELECT DISTINCT PLANETA FROM HABITACAO WHERE DT_FIM IS NULL;

TABELA 2 - COMUNIDADES DE ESPECIES INTELIGENTES ATUALMENTE:
SELECT H.PLANETA, E.NOME_CIENTIFICO FROM
COMUNIDADE C JOIN ESPECIE E ON C.ESPECIE = E.NOME_CIENTIFICO
JOIN HABITACAO H ON H.COM_ESPECIE = C.ESPECIE AND H.COM_NOME = C.NOME
WHERE E.EH_INTELIGENTE = 'S' AND H.DT_FIM IS NULL;

Com isso, temos: */

-- Busca: Planetas atualmente habitados e a quantidade de comunidades formadas por especies inteligentes em cada um deles

SELECT PLA.PLANETA, COUNT(COMU.NOME_CIENTIFICO) FROM 
    (SELECT DISTINCT PLANETA FROM HABITACAO WHERE DT_FIM IS NULL) PLA LEFT JOIN
    (SELECT H.PLANETA, E.NOME_CIENTIFICO FROM
        COMUNIDADE C JOIN ESPECIE E ON C.ESPECIE = E.NOME_CIENTIFICO
        JOIN HABITACAO H ON H.COM_ESPECIE = C.ESPECIE AND H.COM_NOME = C.NOME
        WHERE E.EH_INTELIGENTE = 'S' AND H.DT_FIM IS NULL) COMU 
    ON PLA.PLANETA = COMU.PLANETA
GROUP BY PLA.PLANETA;




-- 3.E)
-- insercao de algumas comunidades e habitacoes para testar o count
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Humanos', 'Nova Terra', 10000000);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Humanos', 'Torradinhos', 5000000);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Humanos', 'Terra 2.0', 5000000);

INSERT INTO HABITACAO (PLANETA, COM_ESPECIE, COM_NOME, DT_INICIO, DT_FIM) VALUES ('Marte', 'Humanos', 'Nova Terra', TO_DATE('2216-03-20', 'YYYY-MM-DD'), NULL);
INSERT INTO HABITACAO (PLANETA, COM_ESPECIE, COM_NOME, DT_INICIO, DT_FIM) VALUES ('Venus', 'Humanos', 'Torradinhos', TO_DATE('2200-01-01', 'YYYY-MM-DD'), TO_DATE('2200-01-02', 'YYYY-MM-DD'));
INSERT INTO HABITACAO (PLANETA, COM_ESPECIE, COM_NOME, DT_INICIO, DT_FIM) VALUES ('Marte', 'Humanos', 'Terra 2.0', TO_DATE('2310-01-01', 'YYYY-MM-DD'), NULL);

SELECT H.PLANETA, H.COM_ESPECIE AS ESPECIE,
COUNT(*) AS QTD_COMUNIDADES
FROM HABITACAO H
GROUP BY H.PLANETA, H.COM_ESPECIE;





-- 3.F)
-- insercao de mais um planeta que orbita o Sol, que eh a estrela escolhida nesse exercicio
INSERT INTO ORBITAPLANETA (PLANETA, ESTRELA, DISTANCIA_MIN, DISTANCIA_MAX, PERIODO) VALUES ('Venus', '123456', 10, 50, 225);
-- insercao dos 2 planetas que orbitam o Sol orbitando tambem Aldebaran, ela que deve aparecer no select
INSERT INTO ORBITAPLANETA (PLANETA, ESTRELA, DISTANCIA_MIN, DISTANCIA_MAX, PERIODO) VALUES ('Venus', '10987', 10, 50, 225);
INSERT INTO ORBITAPLANETA (PLANETA, ESTRELA, DISTANCIA_MIN, DISTANCIA_MAX, PERIODO) VALUES ('Terra', '10987', 10, 50, 225);
-- insercao de 1 dos planetas que orbita o Sol orbitando tambem Sirius, ela nao deve aparecer no select
INSERT INTO ORBITAPLANETA (PLANETA, ESTRELA, DISTANCIA_MIN, DISTANCIA_MAX, PERIODO) VALUES ('Terra', '78910', 10, 50, 225);

/* A subconsulta aqui verifica se para cada planeta orbitando a estrela selecionada,
existe uma relacao na tabela ORBITAPLANETA para o Sol e esse planeta.
Se nao existir essa relacao para algum planeta orbitando a estrela, ela nao
eh selecionada na consulta principal*/

SELECT DISTINCT E.NOME, E.CLASSIFICACAO
FROM ESTRELA E
WHERE NOT EXISTS (
    SELECT P.DESIGNACAO_ASTRONOMICA
    FROM ORBITAPLANETA OP1
    JOIN PLANETA P ON OP1.PLANETA = P.DESIGNACAO_ASTRONOMICA
    WHERE OP1.ESTRELA = '123456'
    AND NOT EXISTS (
        SELECT 1
        FROM ORBITAPLANETA OP2
        WHERE OP2.ESTRELA = E.ID_CATALOGO
        AND OP2.PLANETA = P.DESIGNACAO_ASTRONOMICA
    )
);

