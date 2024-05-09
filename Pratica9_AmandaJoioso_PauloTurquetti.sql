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
