/* Pratica 7

Amanda Valukas Breviglieri Joioso - 4818232
Paulo Henrique Vedovatto Turquetti - 13750791
*/


-- Inserção de dados para testes: 

-- Para questão 1
INSERT INTO ORBITA_ESTRELA(ORBITANTE, ORBITADA) VALUES ('Alasia', 'Aiolos');
INSERT INTO ORBITA_ESTRELA(ORBITANTE, ORBITADA) VALUES ('Alp Ant', 'Aiolos');
INSERT INTO ORBITA_ESTRELA(ORBITANTE, ORBITADA) VALUES ('Alp Ara', 'Alp Aps');
INSERT INTO ORBITA_ESTRELA(ORBITANTE, ORBITADA) VALUES ('Alp Car', 'Alp Aps');
INSERT INTO ORBITA_ESTRELA(ORBITANTE, ORBITADA) VALUES ('Alp CrA', 'Alp Col');


-- Para questão 2
INSERT INTO FEDERACAO(NOME, DATA_FUND) VALUES ('FED1', TO_DATE('2024-04-29', 'YYYY-MM-DD'));
INSERT INTO FEDERACAO(NOME, DATA_FUND) VALUES ('FED2', TO_DATE('2024-04-29', 'YYYY-MM-DD'));



-- Para questão 3
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('A', 'COMUNIDADE 1', 600);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('A ab dolore', 'COMUNIDADE 2', 1200);



-- Para questão 4
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Nihil deserunt.', 'Gl 808', 0.3, 0.4, 30);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Quae possimus.', 'Gl 808', 1.8, 2, 160);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('In magni quas.', 'Gl 808', 2.3, 3, 510);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('At molestiae.', 'Gl 667C', 4.7, 4.8, 780);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('WD 1856+534 b', '7Zet1CrB', 0.3, 2, 30);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Modi sit harum.', '7Zet1CrB', 5.1, 5.3, 220);




-- QUESTÃO 1 -----------------------------------------------------------------------------------------------
DECLARE
    -- declaracao do cursor
    CURSOR C_ORBITA_ESTRELA IS
        SELECT OE.ORBITADA AS ID_ESTRELA, E.NOME AS NOME, COUNT(ORBITADA) AS ESTRELAS_ORBITANTES
        FROM ORBITA_ESTRELA OE JOIN ESTRELA E ON OE.ORBITADA = E.ID_ESTRELA
        GROUP BY ORBITADA, E.NOME
        ORDER BY ESTRELAS_ORBITANTES DESC, ID_ESTRELA;
    -- Order by DESC garante que as estrelas com mais orbitantes estarão no início
    V_RESULTADO C_ORBITA_ESTRELA%ROWTYPE;
    V_MAX_ORBITANTES NUMBER;
    
BEGIN
    --abre cursor
    OPEN C_ORBITA_ESTRELA;
    DBMS_OUTPUT.PUT_LINE('ESTRELAS COM MAIOR NUMERO DE ESTRELAS ORBITANTES:');
    
    FETCH C_ORBITA_ESTRELA INTO V_RESULTADO;
    V_MAX_ORBITANTES := V_RESULTADO.ESTRELAS_ORBITANTES;
    -- recebe o maior numero de orbitantes, já que busca foi ordenada com DESC
    
    LOOP
        DBMS_OUTPUT.PUT_LINE('ID_ETRELA: ' || V_RESULTADO.ID_ESTRELA || ' NOME: ' || V_RESULTADO.NOME);
        FETCH C_ORBITA_ESTRELA INTO V_RESULTADO;
        EXIT WHEN V_RESULTADO.ESTRELAS_ORBITANTES < V_MAX_ORBITANTES OR C_ORBITA_ESTRELA%NOTFOUND;
        -- Sai do loop quando o numero de orbitantes é menor que o máximo ou quando percorre todo o cursor
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('QUANTIDADE DE ESTRELAS ORBITANTES: ' || V_MAX_ORBITANTES);
    CLOSE C_ORBITA_ESTRELA;
    -- fecha cursor
    
-- tratamento de excessoes 
EXCEPTION
    -- busca do cursor nao encontrou nenhum valor correspondente
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhuma orbita de estrelas detectada');
    -- Outro erro inesperado
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocorreu um erro não especificado.');
END;

/* SAÍDA DBMS

ESTRELAS COM MAIOR NUMERO DE ESTRELAS ORBITANTES:
ID_ETRELA: Aiolos NOME: Aiolos
ID_ETRELA: Alp Aps NOME: 
QUANTIDADE DE ESTRELAS ORBITANTES: 2


Tabela utilizada no cursor (estrelas e o número de estrelas orbitantes):
ID_ESTRELA   NOME      ESTRELAS_ORBITANTES
Aiolos	     Aiolos	   2
Alp Aps		           2
Alp Col	     Phact	   1

*/

-- QUESTÃO 2 ------------------------------------------------------------------------------------------------------
DECLARE
    -- contador de tuplas removidas
    V_NUMERO_REMOVIDOS NUMBER;
BEGIN 
    -- Uso de cursor implícito no DELETE
    DELETE FROM FEDERACAO WHERE NOME IN (SELECT NOME FROM FEDERACAO
                                            MINUS
                                            SELECT F.NOME FROM
                                            FEDERACAO F JOIN NACAO N ON F.NOME = N.FEDERACAO);

    -- recebe o numero de tuplas removidas
    V_NUMERO_REMOVIDOS := SQL%ROWCOUNT;
    
    -- Se removeu alguma
    IF V_NUMERO_REMOVIDOS > 0 THEN
        DBMS_OUTPUT.PUT_LINE(V_NUMERO_REMOVIDOS || ' FEDERACOES FORAM REMOVIDAS');
    -- Se nao removeu nenhuma
    ELSE
        DBMS_OUTPUT.PUT_LINE('NENHUMA FEDERACAO FOI REMOVIDA');
    END IF;
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Algo deu errado');

END;

/* SAÍDA DBMS:
2 FEDERACOES FORAM REMOVIDAS 


Tabela de federacoes sem uma nacao associada antes de executar o programa:
FED1	29/04/24
FED2	29/04/24


Busca federacoes sem uma nacao associada antes de executar o programa:
(vazia)


Busca usada para achar federacoe sem nacoes associadas:
SELECT * FROM FEDERACAO 
MINUS
SELECT F.NOME, F.DATA_FUND FROM FEDERACAO F JOIN NACAO N ON F.NOME = N.FEDERACAO;
*/



-- QUESTÃO 3 -----------------------------------------------------------------------
DECLARE
    -- Entradas do usuário
    V_PLANETA PLANETA.ID_ASTRO%TYPE := 'Quae possimus.';
    V_COMUNIDADE_ESPECIE COMUNIDADE.ESPECIE%TYPE := 'A';
    V_COMUNIDADE_NOME COMUNIDADE.NOME%TYPE := 'COMUNIDADE 1';

    -- Datas
    V_DATA_INI DATE := TO_DATE(SYSDATE, 'DD/MM/YYYY');
    V_DATA_FIM DATE;
    
    V_HABITANTES NUMBER;
    V_ESPECIE_PLANETA_OR ESPECIE.PLANETA_OR%TYPE;
    V_ESPECIE_INTELIGENTE ESPECIE.INTELIGENTE%TYPE;

BEGIN 
    -- Recebe o numero de habitantes da comunidade
    SELECT QTD_HABITANTES INTO V_HABITANTES FROM COMUNIDADE
            WHERE NOME = V_COMUNIDADE_NOME AND ESPECIE = V_COMUNIDADE_ESPECIE; 
    
    -- se menor ou igual a  1000 habitantes
    IF V_HABITANTES <= 1000 THEN
        -- Adiciona 100 anos
        V_DATA_FIM := SYSDATE + INTERVAL '100' YEAR;
    -- se maior
    ELSE
        -- Adiciona 50 anos
        V_DATA_FIM := SYSDATE + INTERVAL '50' YEAR;
    END IF;

    -- Insere na tabela a nova habitacao
    INSERT INTO HABITACAO(PLANETA, ESPECIE, COMUNIDADE, DATA_INI, DATA_FIM)
        VALUES (V_PLANETA, V_COMUNIDADE_ESPECIE, V_COMUNIDADE_NOME, V_DATA_INI, V_DATA_FIM);
    
    DBMS_OUTPUT.PUT_LINE('HABITACAO ADICIONADA');

    -- Recebe informacoes da espécie dessa comunidade
    SELECT PLANETA_OR, INTELIGENTE 
    INTO V_ESPECIE_PLANETA_OR, V_ESPECIE_INTELIGENTE 
    FROM ESPECIE WHERE NOME = V_COMUNIDADE_ESPECIE;


    -- impressão de infos da especie
    DBMS_OUTPUT.PUT_LINE('Infos da Especie:');
    
    DBMS_OUTPUT.PUT_LINE('Especie: ' || V_COMUNIDADE_ESPECIE);
    DBMS_OUTPUT.PUT_LINE('Planeta Origem: ' || V_ESPECIE_PLANETA_OR);
    DBMS_OUTPUT.PUT_LINE('Inteligente: ' || V_ESPECIE_INTELIGENTE);

    -- impressões de datas de inicio e fim dessa habitacao
    DBMS_OUTPUT.PUT_LINE('Infos da habitacao dessa especie:');
    DBMS_OUTPUT.PUT_LINE('Data inicio: ' || V_DATA_INI);
    DBMS_OUTPUT.PUT_LINE('Data fim: ' || V_DATA_FIM);

    -- commitando
    COMMIT;

-- TRATAMENTO DE EXCESSOES
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Não há uma espécie ou comunidade equivalente');

    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('Existe mais de uma espécie ou comunidade correspondente');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Algo deu errado');

    
END;

/* SAIDA DBMS

HABITACAO ADICIONADA
Infos da Especie:
Especie: A
Planeta Origem: Magni ex rerum.
Inteligente: V
Infos da habitacao dessa especie:
Data inicio: 30/04/24
Data fim: 30/04/24


Tabela HABITACAO antes de executar o codigo:
(vazia)

Tabela HABITACAO depois de executar o codigo:
Quae possimus.	A	COMUNIDADE 1	30/04/24	30/04/24


OBS: A comunidade testada possui 600 habitantes. Sendo assim, sua habitação terá como
valor DATA_FIM uma data daqui a 100 anos. Como são impressos apenas as duas ultimas casas
referentes ao ano, DATA_INI e DATA_FIM acabam ficando com o mesmo valor nas impressões

*/

-- QUESTÃO 4 -----------------------------------------------------------------------------------
DECLARE
    -- Valores de entrada do usuario
    V_CLASSIFICACAO ESTRELA.CLASSIFICACAO%TYPE := 'A8III';
    V_DISTANCIA_MIN ORBITA_PLANETA.DIST_MIN%TYPE := 1;

    -- Criação do cursor
    CURSOR C_ORBITA_PLANETA IS
                -- seleciona as orbitas de planetas em estrelas com a classificacao fornecida pelo usuario
                SELECT OP.ESTRELA, OP.PLANETA, OP.DIST_MIN FROM ESTRELA E 
                JOIN ORBITA_PLANETA OP ON E.ID_ESTRELA = OP.ESTRELA
                WHERE E.CLASSIFICACAO = V_CLASSIFICACAO
            FOR UPDATE;
            -- trava as tuplas para alterações
                
    V_RESULTADO C_ORBITA_PLANETA%ROWTYPE;
    -- contador de tuplas a serem removidas
    V_CONTADOR NUMBER := 0;
    
BEGIN
    -- inicia cursor
    OPEN C_ORBITA_PLANETA;
    -- loop para manipulacao do cursor
    LOOP
        FETCH C_ORBITA_PLANETA INTO V_RESULTADO;
        -- Sai do loop quando passa por todo o cursor
        EXIT WHEN C_ORBITA_PLANETA%NOTFOUND;

        -- Se distancia minima é maior que a definida pelo usuário
        IF V_RESULTADO.DIST_MIN > V_DISTANCIA_MIN THEN
            --Removendo a orbita do planeta à estrela
            DELETE FROM ORBITA_PLANETA 
                WHERE PLANETA = V_RESULTADO.PLANETA
                AND ESTRELA = V_RESULTADO.ESTRELA;
            -- contador soma +1
            V_CONTADOR := V_CONTADOR + 1;
        END IF;
    END LOOP;
    -- imprime quantidade de tuplas removidas
    DBMS_OUTPUT.PUT_LINE(V_CONTADOR || ' TUPLAS DE ORBITA_PLANETA FORAM REMOVIDAS');
    -- Commitando alteracoes
    COMMIT;
    CLOSE C_ORBITA_PLANETA;
    -- encerra cursor

EXCEPTION
    -- usuário digitou distancia minima negativa
    WHEN E_DISTANCIA_NEGATIVA
        THEN dbms_output.put_line('Valor de distancia inválido');
    -- cursor vazio
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhuma óribta de planeta a uma estrela com essa classificacao foi encontrada');
    -- Outro erro inesperado
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocorreu um erro não especificado.');
    
END;

/*

-- SAÍDA DBMS:
3 TUPLAS DE ORBITA_PLANETA FORAM REMOVIDAS


-- Saída DBMS com distância negativa:
Valor de distancia inválido


-- TABELA ORBITA_PLANETA ANTES DA EXECUCAO:

PLANETA        ESTREA   MIN MAX PERIODO
Nihil deserunt.	Gl 808	0,3	0,4	30
Quae possimus.	Gl 808	1,8	2	160
In magni quas.	Gl 808	2,3	3	510
At molestiae.	Gl 667C	4,7	4,8	780
WD 1856+534 b	7Zet1CrB	0,3	2	30
Modi sit harum.	7Zet1CrB	5,1	5,3	220


TABELA ORBITA_PLANETA APÓS DA EXECUCAO:

PLANETA        ESTREA   MIN MAX PERIODO
Nihil deserunt.	Gl 808	0,3	0,4	30
WD 1856+534 b	7Zet1CrB	0,3	2	30
Modi sit harum.	7Zet1CrB	5,1	5,3	220

*/


