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
    CONSTRAINT FK_LIDER FOREIGN KEY (NACAO) REFERENCES FEDERACAO (NOME_FD) ON DELETE CASCADE,
    CONSTRAINT CK_CARGOLIDER CHECK (UPPER(CARGO) IN ('COMANDANTE', 'OFICIAL', 'CIENTISTA'))
);


----Criacao da tabela Faccao
CREATE TABLE FACCAO (
    NOME_FC VARCHAR2(50) NOT NULL,
    LIDER_FC NUMBER NOT NULL,
    IDEOLOGIA VARCHAR2(15),
    QTD_NACOES NUMBER,
    CONSTRAINT PK_FACCAO PRIMARY KEY (NOME_FC),
    CONSTRAINT UK_FACCAO UNIQUE (LIDER_FC),
    CONSTRAINT FK_FACCAO FOREIGN KEY (LIDER_FC) REFERENCES LIDER (CPI),
    CONSTRAINT CK_IDEOLOGIAFACCAO CHECK (UPPER(IDEOLOGIA) IN ('PROGRESSISTA', 'TOTALITARIA', 'TRADICIONALISTA'))
);


--Criacao da tabela NacaoFaccao
CREATE TABLE NACAOFACCAO (
    NACAO VARCHAR2(50) NOT NULL,
    FACCAO VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_NACAOFACCAO PRIMARY KEY (NACAO, FACCAO),
    CONSTRAINT FK_NACAOFACCAO FOREIGN KEY (FACCAO) REFERENCES FACCAO (NOME_FC) ON DELETE CASCADE
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
);    
-- Essa abordagem de ESTRELA não garante a obrigatoriedade compor um sistema ou orbitar direta/indiretamente uma estrela que compõe um sistema


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
    CONSTRAINT FK_ESPECIE FOREIGN KEY (PLANETA_ORIGEM)
                        REFERENCES PLANETA (DESIGNACAO_ASTRONOMICA)
                        ON DELETE CASCADE,
    CONSTRAINT CK_ESPECIE CHECK (UPPER(EH_INTELIGENTE) IN ('S', 'N'))
);


--Criacao da tabela Dominancia
CREATE TABLE DOMINANCIA (
    NACAO VARCHAR2(50) NOT NULL,
    PLANETA VARCHAR2(30) NOT NULL,
    DATA_INI DATE NOT NULL,
    DATA_FIM DATE,
    CONSTRAINT PK_DOMINANCIA PRIMARY KEY (NACAO, PLANETA, DATA_INI),
    CONSTRAINT FK_DOMINANCIA1 FOREIGN KEY (NACAO) REFERENCES NACAO (NOME_NC),
    CONSTRAINT FK_DOMINANCIA2 FOREIGN KEY (PLANETA) REFERENCES PLANETA (DESIGNACAO_ASTRONOMICA)
);


--Criacao da tabela Comunidade
CREATE TABLE COMUNIDADE (
    ESPECIE VARCHAR2(30) NOT NULL,
    NOME VARCHAR2(50) NOT NULL,
    QTD_HABITANTES NUMBER, 
    CONSTRAINT PK_COMUNIDADE PRIMARY KEY (ESPECIE, NOME),
    CONSTRAINT FK_COMUNIDADE FOREIGN KEY (ESPECIE) REFERENCES ESPECIE (NOME_CIENTIFICO) ON DELETE CASCADE
);


--Criacao da tabela Participa
CREATE TABLE PARTICIPA (
    FACCAO VARCHAR2(50) NOT NULL,
    COM_ESPECIE VARCHAR2(30) NOT NULL,
    COM_NOME VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_PARTICIPA PRIMARY KEY (FACCAO, COM_ESPECIE, COM_NOME),
    CONSTRAINT FK_PARTICIPA FOREIGN KEY (COM_ESPECIE, COM_NOME) REFERENCES COMUNIDADE (ESPECIE, NOME) ON DELETE CASCADE
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
    CONSTRAINT FK2_HABITACAO FOREIGN KEY (COM_ESPECIE, COM_NOME)
                        REFERENCES COMUNIDADE (ESPECIE, NOME)
                        ON DELETE CASCADE
);
