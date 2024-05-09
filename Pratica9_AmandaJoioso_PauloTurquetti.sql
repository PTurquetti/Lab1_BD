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


-- FUNÇÃO
create or replace FUNCTION REMOVE_NACAO_FACCAO(V_FAC NACAO_FACCAO.FACCAO%TYPE, 
                                                V_NAC NACAO_FACCAO.NACAO%TYPE)
                                               RETURN NUMBER IS
                                                
    V_RESULTADO NUMBER;
    V_NACAO_FACCAO_TUPLA NACAO_FACCAO%ROWTYPE;

    BEGIN

    SELECT * INTO V_NACAO_FACCAO_TUPLA FROM NACAO_FACCAO WHERE NACAO_FACCAO.FACCAO = V_FAC 
                                                            AND NACAO_FACCAO.NACAO = V_NAC;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nao foi encontrada nenhuma tupla NACAO_FACCAO correspondente');
            RETURN V_RESULTADO;

        DELETE FROM NACAO_FACCAO WHERE NACAO_FACCAO.FACCAO = V_NACAO_FACCAO_TUPLA.FACCAO 
                                    AND NACAO_FACCAO.NACAO = V_NACAO_FACCAO_TUPLA.NACAO;

        DBMS_OUTPUT.PUT_LINE('Tupla de NACAO_FACCAO removida: ');
        DBMS_OUTPUT.PUT_LINE('Faccao: ' || V_NACAO_FACCAO_TUPLA.FACCAO || '  Nacao: ' || V_NACAO_FACCAO_TUPLA.NACAO);
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------');

        COMMIT;
        V_RESULTADO := 1;
        RETURN V_RESULTADO;
    END;

-- CODIGO CHAMANDO A FUNCAO
