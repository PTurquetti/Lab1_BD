-- Drop da FK existente
ALTER TABLE LIDER
DROP CONSTRAINT FK_LIDER;

-- Adicionar a nova FK
ALTER TABLE LIDER
ADD CONSTRAINT FK_LIDER FOREIGN KEY (NACAO) REFERENCES NACAO(NOME_NC) ON DELETE CASCADE;

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
