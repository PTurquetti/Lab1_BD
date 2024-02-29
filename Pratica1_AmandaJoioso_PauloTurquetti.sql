-- LABORATORIO 1

-- Amanda Valukas Breviglieri Joioso - 4818232
-- Paulo Henrique Vedovatto Turquetti - 13750791


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
    CONSTRAINT FK_LIDER FOREIGN KEY (NACAO) REFERENCES FEDERACAO (NOME_FD) ON DELETE CASCADE,
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
