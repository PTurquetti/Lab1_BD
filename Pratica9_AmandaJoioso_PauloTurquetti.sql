/* Pratica 9

Amanda Valukas Breviglieri Joioso - 4818232
Paulo Henrique Vedovatto Turquetti - 13750791
*/


-- QUESTÃO 1 --------------------------------------------------------------------------------------

-- FAZER TRATAMENTO DE EXCESSÕES

-- Criando função
CREATE OR REPLACE FUNCTION DIST_ESTRELAS (
                        X1 ESTRELA.X%TYPE,
                        Y1 ESTRELA.Y%TYPE, 
                        Z1 ESTRELA.Z%TYPE,
                        
                        X2 ESTRELA.X%TYPE,
                        Y2 ESTRELA.Y%TYPE, 
                        Z2 ESTRELA.Z%TYPE) RETURN NUMBER IS
                        
    -- RESULTADO
    V_DISTANCIA NUMBER;

    BEGIN 

        V_DISTANCIA := SQRT(POWER(X2 - X1, 2) + POWER(Y2 - Y1, 2) + POWER(Z2 - Z1, 2));
        RETURN V_DISTANCIA;

    END DIST_ESTRELAS;




-- Código PL/SQL para uso da função
DECLARE
    
    -- Usuário insere id das estrelas
    E1_ID ESTRELA.ID_ESTRELA%TYPE := 'GJ 9798';
    E2_ID ESTRELA.ID_ESTRELA%TYPE := 'GJ 4301';

    E1 ESTRELA%ROWTYPE;
    E2 ESTRELA%ROWTYPE;
    
    V_DISTANCIA NUMBER;
    
BEGIN 
    
    SELECT * INTO E1 FROM ESTRELA WHERE ID_ESTRELA = E1_ID;
    SELECT * INTO E2 FROM ESTRELA WHERE ID_ESTRELA = E2_ID;

    
    V_DISTANCIA := DIST_ESTRELAS( E1.X, E1.Y, E1.Z,
                                    E2.X, E2.Y, E2.Z);
    
    DBMS_OUTPUT.PUT_LINE('Distancia entre as estrelas: ' || V_DISTANCIA);
END;





-- QUESTÃO 2 --------------------------------------------------------------------------------------------

-- Inserção de dados para testes da questão 2:
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('111.111.111-11', 'Capitã Aria No', 'CIENTISTA', 'Quam quia ad.', 'Quidem quam');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('222.222.222-22', 'General Zorg', 'COMANDANTE', 'Veniam est.', 'Unde eius at');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('333.333.333-33', 'Buzz Lightyear', 'OFICIAL', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('444.444.444-44', 'Palpatine', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('555.555.555-55', 'Luke Sky', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('666.666.666-66', 'Spock', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('777.777.777-77', 'Groot', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');

INSERT INTO FACCAO (NOME, LIDER, IDEOLOGIA, QTD_NACOES) VALUES ('Prog Celestiais', '111.111.111-11', 'PROGRESSITA', 3);
INSERT INTO FACCAO (NOME, LIDER, IDEOLOGIA, QTD_NACOES) VALUES ('Cons Cósmicos', '222.222.222-22', 'TRADICIONALISTA', NULL);
INSERT INTO FACCAO (NOME, LIDER, IDEOLOGIA, QTD_NACOES) VALUES ('Prog e Além', '333.333.333-33', 'PROGRESSITA', NULL);

INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Quam quia ad.', 'Prog Celestiais');
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Veniam est.', 'Cons Cósmicos');
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Modi porro ut.', 'Prog e Além');
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Vel rerum unde.', 'Prog Celestiais');
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Ducimus odio.', 'Prog Celestiais');
INSERT INTO NACAO_FACCAO (NACAO, FACCAO) VALUES ('Veniam est.', 'Prog e Além');

-- Criacao do pacote
CREATE OR REPLACE PACKAGE FUNCIONALIDADES_LIDER AS
    PROCEDURE REMOVE_NACAO_FACCAO(
        V_FAC NACAO_FACCAO.FACCAO%TYPE, 
        V_NAC NACAO_FACCAO.NACAO%TYPE
    );
END FUNCIONALIDADES_LIDER;

-- Criando corpo do pacote
CREATE OR REPLACE PACKAGE BODY FUNCIONALIDADES_LIDER AS
    PROCEDURE REMOVE_NACAO_FACCAO(
        V_FAC NACAO_FACCAO.FACCAO%TYPE, 
        V_NAC NACAO_FACCAO.NACAO%TYPE
    ) AS
    BEGIN
        DELETE FROM NACAO_FACCAO 
        WHERE FACCAO = V_FAC AND NACAO = V_NAC;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nenhuma linha encontrada para deletar.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Ocorreu um erro: ' || SQLERRM);
    END;
END FUNCIONALIDADES_LIDER;



-- Código para execucao das funcionalidades do pacote
DECLARE
    v_fac NACAO_FACCAO.FACCAO%TYPE := 'Prog e Além';
    v_nac NACAO_FACCAO.NACAO%TYPE := 'Veniam est.';
BEGIN
    FUNCIONALIDADES_LIDER.REMOVE_NACAO_FACCAO(v_fac, v_nac);
    DBMS_OUTPUT.PUT_LINE('Procedimento executado com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao executar o procedimento');
END;





/*
 - Antes da execucao
NACAO               FACCAO
Ducimus odio.	      Prog Celestiais
Modi porro ut.	    Prog e Além
Quam quia ad.	      Prog Celestiais
Vel rerum unde.	    Prog Celestiais
Veniam est.	        Cons Cósmicos
Veniam est.	        Prog e Além

 - Depois da execucao
NACAO               FACCAO
Ducimus odio.	      Prog Celestiais
Modi porro ut.	    Prog e Além
Quam quia ad.	      Prog Celestiais
Vel rerum unde.    	Prog Celestiais
Veniam est.	        Cons Cósmicos

*/


-- QUESTÃO 3 --------------------------------------------------------------------------------------

-- INSERCAO DE DADOS PARA TESTE

-- Inserindo dados na tabela LIDER
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('111.111.111-11', 'Capitã Aria No', 'CIENTISTA', 'Quam quia ad.', 'Quidem quam');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('222.222.222-22', 'General Zorg', 'COMANDANTE', 'Veniam est.', 'Unde eius at');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('333.333.333-33', 'Buzz Lightyear', 'OFICIAL', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('444.444.444-44', 'Palpatine', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('555.555.555-55', 'Luke Sky', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('666.666.666-66', 'Spock', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');
INSERT INTO LIDER (CPI, NOME, CARGO, NACAO, ESPECIE) VALUES ('777.777.777-77', 'Groot', 'COMANDANTE', 'Modi porro ut.', 'Iure sunt quas');


-- DECLARACAO DO PACOTE
CREATE OR REPLACE PACKAGE FUNCIONALIDADES_LIDER AS

    PROCEDURE REMOVE_NACAO_FACCAO(
        V_FAC NACAO_FACCAO.FACCAO%TYPE, 
        V_NAC NACAO_FACCAO.NACAO%TYPE);
        
    PROCEDURE CRIA_FEDERACAO(
        V_NOME_NOVA_FEDERACAO FEDERACAO.NOME%TYPE,
        V_LIDER IN LIDER%ROWTYPE);
        
END FUNCIONALIDADES_LIDER;

-- REDECLARANDO CORPO DO PACOTE COM CRIA_FUNCIONALIDADE
CREATE OR REPLACE PACKAGE BODY FUNCIONALIDADES_LIDER AS

    PROCEDURE REMOVE_NACAO_FACCAO(
        V_FAC NACAO_FACCAO.FACCAO%TYPE, 
        V_NAC NACAO_FACCAO.NACAO%TYPE
    ) AS
    BEGIN
        DELETE FROM NACAO_FACCAO 
        WHERE FACCAO = V_FAC AND NACAO = V_NAC;
        
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Ocorreu um erro: ' || SQLERRM);
    END;
    
    PROCEDURE CRIA_FEDERACAO(
        V_NOME_NOVA_FEDERACAO FEDERACAO.NOME%TYPE,
        V_LIDER IN LIDER%ROWTYPE
    ) AS 
        
        V_FEDERACAO_EXISTENTE NUMBER;
    
    BEGIN
        IF V_LIDER.CARGO = 'COMANDANTE' THEN
            BEGIN
                SELECT COUNT(*) INTO V_FEDERACAO_EXISTENTE FROM FEDERACAO 
                WHERE NOME = V_NOME_NOVA_FEDERACAO;
                
                IF V_FEDERACAO_EXISTENTE = 0 THEN
                    INSERT INTO FEDERACAO (NOME, DATA_FUND) VALUES (V_NOME_NOVA_FEDERACAO, SYSDATE);
                    UPDATE NACAO SET FEDERACAO = V_NOME_NOVA_FEDERACAO WHERE NOME = V_LIDER.NACAO;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('O nome inserido já está sendo usado');
                END IF;
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Ocorreu um erro ao criar a federação: ' || SQLERRM);
            END;
        ELSE
            DBMS_OUTPUT.PUT_LINE('O líder não possui o cargo necessário para executar essa tarefa. Cargo necessário: COMANDANTE');
        END IF;
    END;
    
END FUNCIONALIDADES_LIDER;


-- COMANDO PL/SQL QUE EXECUTA CRIA_FEDERACAO
DECLARE
    V_LIDER LIDER%ROWTYPE;
    V_NOME_NOVA_FEDERACAO FEDERACAO.NOME%TYPE := 'NOVA FED';
    
BEGIN
    BEGIN
        SELECT * INTO V_LIDER FROM LIDER WHERE CPI = '222.222.222-22';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nenhum líder encontrado com o CPI fornecido.');
            RETURN; 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Ocorreu um erro ao buscar o líder: ');
            RETURN;
    END;
    
    FUNCIONALIDADES_LIDER.CRIA_FEDERACAO(V_NOME_NOVA_FEDERACAO, V_LIDER);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocorreu um erro ao executar CRIA_FEDERACAO: ' || SQLERRM);
END;

-- TESTE: BUSCANDO NOVA FEDERACAO
SELECT * FROM FEDERACAO WHERE NOME = 'NOVA FED';
/* RESULTADO DA BUSCA
NOVA FED	21/05/24
*/

-- QUESTÃO 3 --------------------------------------------------------------------------------------


-- a) CRIANDO PACOTE DE FUNCIONALIDADES PARA O CIENTISTA


-- CRIANDO PACKAGE
CREATE OR REPLACE PACKAGE FUNCIONALIDADES_CIENTISTA AS
    
    -- ADICIONA NOVA ESTRELA
    PROCEDURE ADICIONAR_ESTRELA(V_ESTRELA IN ESTRELA%ROWTYPE);
    
    -- LE INFOS DA ESTRELA
    PROCEDURE LER_ESTRELA(V_ESTRELA IN ESTRELA%ROWTYPE);
    
    -- UPDATE DE ESTRELA
    PROCEDURE ATUALIZAR_ESTRELA(V_ESTRELA IN ESTRELA%ROWTYPE);
    
    -- DELETA ESTRELA
    PROCEDURE DELETAR_ESTRELA(V_ESTRELA IN ESTRELA%ROWTYPE);
    
END FUNCIONALIDADES_CIENTISTA;

-- DEFININDO BODY DO PACKAGE
CREATE OR REPLACE PACKAGE BODY FUNCIONALIDADES_CIENTISTA AS
    
    
    PROCEDURE ADICIONAR_ESTRELA(V_ESTRELA IN ESTRELA%ROWTYPE) AS
    BEGIN
        INSERT INTO ESTRELA VALUES V_ESTRELA;
        DBMS_OUTPUT.PUT_LINE('ESTRELA INSERIDA');

    END;
    
    
    PROCEDURE LER_ESTRELA(V_ESTRELA IN ESTRELA%ROWTYPE) AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('EXIBINDO INFOS DA ESTRELA:');
        DBMS_OUTPUT.PUT_LINE('Id: ' || V_ESTRELA.ID_ESTRELA);
        DBMS_OUTPUT.PUT_LINE('Nome: ' || V_ESTRELA.NOME);
        DBMS_OUTPUT.PUT_LINE('Classificacao: ' || V_ESTRELA.CLASSIFICACAO);
        DBMS_OUTPUT.PUT_LINE('Massa: ' || V_ESTRELA.MASSA);
        DBMS_OUTPUT.PUT_LINE('Coordenadas X ' || V_ESTRELA.X || ' Y ' || V_ESTRELA.Y || ' Z ' || V_ESTRELA.Z);
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
    END; 
    
    
    
    PROCEDURE ATUALIZAR_ESTRELA(V_ESTRELA IN ESTRELA%ROWTYPE) AS
    BEGIN
        UPDATE ESTRELA SET
            NOME = V_ESTRELA.NOME,
            CLASSIFICACAO = V_ESTRELA.CLASSIFICACAO,
            MASSA = V_ESTRELA.MASSA,
            X = V_ESTRELA.X,
            Y = V_ESTRELA.Y,
            Z = V_ESTRELA.Z
        WHERE ID_ESTRELA = V_ESTRELA.ID_ESTRELA;
        DBMS_OUTPUT.PUT_LINE('ESTRELA ATUALIZADA');
    END;

    PROCEDURE DELETAR_ESTRELA(V_ESTRELA IN ESTRELA%ROWTYPE) AS
    BEGIN
        DELETE FROM ESTRELA WHERE ID_ESTRELA = V_ESTRELA.ID_ESTRELA;
        DBMS_OUTPUT.PUT_LINE('ESTRELA DELETADA');
    END;


END FUNCIONALIDADES_CIENTISTA;


-- CODIGO PL/SQL PARA TESTES
DECLARE
    V_ESTRELA ESTRELA%ROWTYPE;
BEGIN
    V_ESTRELA.ID_ESTRELA := 'NOVA';
    V_ESTRELA.NOME := 'SUPERNOVA';
    V_ESTRELA.CLASSIFICACAO := 'K8';
    V_ESTRELA.MASSA := 1500;
    V_ESTRELA.X := 0;
    V_ESTRELA.Y := 0;
    V_ESTRELA.Z := 0;
    
    -- ADICIONANDO
    FUNCIONALIDADES_CIENTISTA.ADICIONAR_ESTRELA(V_ESTRELA);
    
    -- LENDO
    FUNCIONALIDADES_CIENTISTA.LER_ESTRELA(V_ESTRELA);
    
    -- ATUALIZANDO
    V_ESTRELA.CLASSIFICACAO := 'K0';
    FUNCIONALIDADES_CIENTISTA.ATUALIZAR_ESTRELA(V_ESTRELA);
        --lendo para testar atualizacao
    FUNCIONALIDADES_CIENTISTA.LER_ESTRELA(V_ESTRELA);
    
    -- DELETANDO
    FUNCIONALIDADES_CIENTISTA.DELETAR_ESTRELA(V_ESTRELA);

END;




-- b)

-- INSERCAO DE DADOS PARA TESTE
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Nihil deserunt.', '7Zet1CrB', 0.3, 0.4, 30);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Quae possimus.', '7Zet1CrB', 1.8, 2, 160);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('In magni quas.', '7Zet1CrB', 2.3, 3, 510);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('At molestiae.', '7Zet1CrB', 4.7, 4.8, 780);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('WD 1856+534 b', '7Zet1CrB', 0.3, 2, 30);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Modi sit harum.', '7Zet1CrB', 5.1, 5.3, 220);




-- REDEFININDO PACKAGE
CREATE OR REPLACE PACKAGE FUNCIONALIDADES_CIENTISTA AS
    PROCEDURE GERAR_RELATORIO(V_ESTRELA IN ESTRELA%ROWTYPE);
END FUNCIONALIDADES_CIENTISTA;

-- REDEFININDO BODY DO PACKAGE
CREATE OR REPLACE PACKAGE BODY FUNCIONALIDADES_CIENTISTA AS
    
    PROCEDURE GERAR_RELATORIO(V_ESTRELA IN ESTRELA%ROWTYPE) AS
    
        CURSOR C_PLANETAS IS
            SELECT P.ID_ASTRO AS PLANETA, P.MASSA AS MASSA, P.RAIO AS RAIO, P.CLASSIFICACAO AS CLASSIFICACAO, OP.DIST_MIN AS DIST_MIN, OP.DIST_MAX AS DIST_MAX, OP.PERIODO AS PERIODO FROM
            ORBITA_PLANETA OP JOIN PLANETA P ON OP.PLANETA = P.ID_ASTRO
            WHERE OP.ESTRELA = V_ESTRELA.ID_ESTRELA
            ORDER BY OP.DIST_MIN;
        
        V_RESULTADO C_PLANETAS%ROWTYPE;
        
    BEGIN 
        OPEN C_PLANETAS;
        DBMS_OUTPUT.PUT_LINE('--- GERANDO INFOS DA ESTRELA ---');
        DBMS_OUTPUT.PUT_LINE('Id: ' || V_ESTRELA.ID_ESTRELA);
        DBMS_OUTPUT.PUT_LINE('Nome: ' || V_ESTRELA.NOME);
        DBMS_OUTPUT.PUT_LINE('Classificacao: ' || V_ESTRELA.CLASSIFICACAO);
        DBMS_OUTPUT.PUT_LINE('Massa: ' || V_ESTRELA.MASSA);
        DBMS_OUTPUT.PUT_LINE('Coordenadas X ' || V_ESTRELA.X || ' Y ' || V_ESTRELA.Y || ' Z ' || V_ESTRELA.Z);
        DBMS_OUTPUT.PUT_LINE('');
        
        DBMS_OUTPUT.PUT_LINE('A estrela ' || V_ESTRELA.ID_ESTRELA || ' configura o seguinte sistema solar:');

        LOOP
            FETCH C_PLANETAS INTO V_RESULTADO;
            EXIT WHEN C_PLANETAS%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE('Planeta: ' || V_RESULTADO.PLANETA);
            DBMS_OUTPUT.PUT_LINE('Massa: ' || V_RESULTADO.MASSA);
            DBMS_OUTPUT.PUT_LINE('Raio: ' || V_RESULTADO.RAIO);
            DBMS_OUTPUT.PUT_LINE('Classificacao: ' || V_RESULTADO.CLASSIFICACAO);
                        DBMS_OUTPUT.PUT_LINE('Orbita na estrela ');
            DBMS_OUTPUT.PUT_LINE('Distância mínima: ' || V_RESULTADO.DIST_MIN);
            DBMS_OUTPUT.PUT_LINE('Distância máxima: ' || V_RESULTADO.DIST_MAX);
            DBMS_OUTPUT.PUT_LINE('Período: ' || V_RESULTADO.PERIODO);
            DBMS_OUTPUT.PUT_LINE('-----------');

        END LOOP;
        
        CLOSE C_PLANETAS;    
    END;
END FUNCIONALIDADES_CIENTISTA;


-- CODIGO PL/SQL PARA TESTE DE GERAR_RELATORIO
DECLARE
    V_ID_ESTRELA ESTRELA.ID_ESTRELA%TYPE := '7Zet1CrB';
    V_ESTRELA ESTRELA%ROWTYPE;
    
BEGIN    
    -- GERANDO RELATORIO 
    SELECT * INTO V_ESTRELA FROM ESTRELA WHERE ID_ESTRELA = V_ID_ESTRELA;
    FUNCIONALIDADES_CIENTISTA.GERAR_RELATORIO(V_ESTRELA);

END;

/* Resultado - SAÍDA DBMS

--- GERANDO INFOS DA ESTRELA ---
Id: 7Zet1CrB
Nome: 
Classificacao: B7V+...
Massa: 255,6230427112548
Coordenadas X -67,060303 Y -95,220854 Z 86,607536

A estrela 7Zet1CrB configura o seguinte sistema solar:
Planeta: WD 1856+534 b
Massa: 
Raio: ,928
Classificacao: Confirmed
Orbita na estrela 
Distância mínima: ,3
Distância máxima: 2
Período: 30
-----------
Planeta: Nihil deserunt.
Massa: 41563,31
Raio: 55325,85
Classificacao: Iste reprehenderit ratione qui.
Orbita na estrela 
Distância mínima: ,3
Distância máxima: ,4
Período: 30
-----------
Planeta: Quae possimus.
Massa: 46992,34
Raio: 54123
Classificacao: In perspiciatis soluta.
Orbita na estrela 
Distância mínima: 1,8
Distância máxima: 2
Período: 160
-----------
Planeta: In magni quas.
Massa: 6510,15
Raio: 97746,96
Classificacao: Error repellat quisquam molestias.
Orbita na estrela 
Distância mínima: 2,3
Distância máxima: 3
Período: 510
-----------
Planeta: At molestiae.
Massa: 87036,25
Raio: 31742,2
Classificacao: Iste impedit fugiat optio.
Orbita na estrela 
Distância mínima: 4,7
Distância máxima: 4,8
Período: 780
-----------
Planeta: Modi sit harum.
Massa: 16616,73
Raio: 95243,45
Classificacao: Hic perferendis ut fuga. Perferendis culpa esse.
Orbita na estrela 
Distância mínima: 5,1
Distância máxima: 5,3
Período: 220
-----------


*/


