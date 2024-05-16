/* Pratica 8

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

-- FUNÇÃO
CREATE OR REPLACE FUNCTION REMOVE_NACAO_FACCAO(
    V_FAC NACAO_FACCAO.FACCAO%TYPE, 
    V_NAC NACAO_FACCAO.NACAO%TYPE
) RETURN NUMBER IS
    V_RESULTADO NUMBER := 0; -- Inicialize para indicar falha
BEGIN
    DELETE FROM NACAO_FACCAO 
    WHERE FACCAO = V_FAC AND NACAO = V_NAC;
    
    -- Verifique se alguma linha foi afetada pela operação de exclusão
    IF SQL%ROWCOUNT > 0 THEN
        V_RESULTADO := 1; -- Indica sucesso
    END IF;
    
    RETURN V_RESULTADO;
END;


    
    
DECLARE
    V_NACAO_FACCAO NACAO_FACCAO%ROWTYPE;
    V_NAC NACAO.NOME%TYPE := 'Veniam est.';
    V_FAC FACCAO.NOME%TYPE := 'Prog e Além';
BEGIN
    -- Consulta para obter os detalhes da relação entre a facção e a nação
    SELECT * INTO V_NACAO_FACCAO 
    FROM NACAO_FACCAO 
    WHERE FACCAO = V_FAC AND NACAO = V_NAC;
    
    -- Chama a função para remover a relação
    IF REMOVE_NACAO_FACCAO(V_NACAO_FACCAO.FACCAO, V_NACAO_FACCAO.NACAO) = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Relação removida com sucesso.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Falha ao remover a relação.');
    END IF;
END;


/*

NACAO               FACCAO
Ducimus odio.	      Prog Celestiais
Modi porro ut.	    Prog e Além
Quam quia ad.	      Prog Celestiais
Vel rerum unde.	    Prog Celestiais
Veniam est.	        Cons Cósmicos
Veniam est.	        Prog e Além


NACAO               FACCAO
Ducimus odio.	      Prog Celestiais
Modi porro ut.	    Prog e Além
Quam quia ad.	      Prog Celestiais
Vel rerum unde.    	Prog Celestiais
Veniam est.	        Cons Cósmicos

*/


-- QUESTÃO 3 --------------------------------------------------------------------------------------


