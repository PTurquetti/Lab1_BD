/* Pratica 8

Amanda Valukas Breviglieri Joioso - 4818232
Paulo Henrique Vedovatto Turquetti - 13750791
*/


-- Inserção de dados para a Questão 1:
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

INSERT INTO DOMINANCIA (NACAO, PLANETA, DATA_INI, DATA_FIM) VALUES ('Ducimus odio.', '11 Com b', TO_DATE('01-01-2000', 'DD-MM-YYYY'), NULL);
INSERT INTO DOMINANCIA (NACAO, PLANETA, DATA_INI, DATA_FIM) VALUES ('Ducimus odio.', '11 Oph b', TO_DATE('01-01-2001', 'DD-MM-YYYY'), NULL);
INSERT INTO DOMINANCIA (NACAO, PLANETA, DATA_INI, DATA_FIM) VALUES ('Quam quia ad.', '11 Oph b', TO_DATE('01-01-2002', 'DD-MM-YYYY'), NULL);
INSERT INTO DOMINANCIA (NACAO, PLANETA, DATA_INI, DATA_FIM) VALUES ('Veniam est.', '11 UMi b', TO_DATE('01-01-2003', 'DD-MM-YYYY'), NULL);

INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Libero magni', 'Com Lib', 100);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Rerum optio', 'Com Rerum', 100);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Neque eaque ad', 'Com Neque', 1200);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Vero labore', 'Com Labore', 300);
INSERT INTO COMUNIDADE (ESPECIE, NOME, QTD_HABITANTES) VALUES ('Quam aut', 'Com Quam', 3400);

INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI, DATA_FIM)VALUES ('11 Com b', 'Libero magni', 'Com Lib', TO_DATE('01-01-2000', 'DD-MM-YYYY'), NULL);
INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI, DATA_FIM)VALUES ('11 Com b', 'Rerum optio', 'Com Rerum', TO_DATE('01-01-2000', 'DD-MM-YYYY'), NULL);
INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI, DATA_FIM)VALUES ('11 Com b', 'Neque eaque ad', 'Com Neque', TO_DATE('01-01-2000', 'DD-MM-YYYY'), NULL);
INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI, DATA_FIM)VALUES ('11 Oph b', 'Vero labore', 'Com Labore', TO_DATE('01-01-2000', 'DD-MM-YYYY'), NULL);
INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI, DATA_FIM)VALUES ('11 UMi b', 'Quam aut', 'Com Quam', TO_DATE('01-01-2000', 'DD-MM-YYYY'), NULL);

INSERT INTO PARTICIPA (FACCAO, ESPECIE, COMUNIDADE) VALUES ('Prog Celestiais', 'Libero magni', 'Com Lib');
INSERT INTO PARTICIPA (FACCAO, ESPECIE, COMUNIDADE) VALUES ('Cons Cósmicos', 'Quam aut', 'Com Quam');



-- QUESTÃO 1 -------------------------------------------------------------------------

-- a)
DECLARE
    -- FACCAO DE ENTRADA DO USUARIO
    V_FACCAO FACCAO.NOME%TYPE := 'Prog Celestiais';

    -- CURSOR - COMUNIDADES QUE HABITAM PLANETAS DOMINADOS POR NACOES ONDE FACCAO ESTA PRESENTE MAS NAO FAZEM PARTE DA FACCAO
    CURSOR C_COMUNIDADES IS
        SELECT DISTINCT C.NOME AS NOME_COMUNIDADE, C.ESPECIE AS ESPECIE_COMUNIDADE, C.QTD_HABITANTES AS HABITANTES  
        FROM NACAO_FACCAO NF
        JOIN NACAO N ON NF.NACAO = N.NOME
        JOIN DOMINANCIA D ON D.NACAO = N.NOME
        JOIN PLANETA P ON P.ID_ASTRO = D.PLANETA
        JOIN HABITACAO H ON P.ID_ASTRO = H.PLANETA
        JOIN COMUNIDADE C ON C.ESPECIE = H.ESPECIE AND C.NOME = H.COMUNIDADE
        WHERE NF.FACCAO = V_FACCAO AND (C.NOME, C.ESPECIE) NOT IN
        (SELECT C.NOME, C.ESPECIE FROM  
        PARTICIPA P JOIN COMUNIDADE C ON P.ESPECIE = C.ESPECIE AND P.COMUNIDADE = C.NOME
        WHERE FACCAO = V_FACCAO);

    --DECLARACAO DO TIPO DA NESTED TABLE
    TYPE T_COMUNIDADE_TYPE IS TABLE OF C_COMUNIDADES%ROWTYPE;

    --DECLARACAO E INICIACAO DA VARIAVEL DE NESTED TABLE
    T_COMUNIDADE T_COMUNIDADE_TYPE := T_COMUNIDADE_TYPE();

BEGIN
    FOR R_COMUNIDADE IN C_COMUNIDADES
    LOOP
        T_COMUNIDADE.EXTEND;
        T_COMUNIDADE(T_COMUNIDADE.LAST) := R_COMUNIDADE;
    END LOOP;

    
    DBMS_OUTPUT.PUT_LINE('Inserindo em PARTICIPA:');
    FOR I_INDEX IN T_COMUNIDADE.FIRST..T_COMUNIDADE.LAST
    LOOP
        INSERT INTO PARTICIPA (FACCAO, COMUNIDADE, ESPECIE) 
            VALUES (V_FACCAO, T_COMUNIDADE(I_INDEX).NOME_COMUNIDADE, T_COMUNIDADE(I_INDEX).ESPECIE_COMUNIDADE);
            DBMS_OUTPUT.PUT_LINE('Facção: ' || V_FACCAO);
            DBMS_OUTPUT.PUT_LINE('Nome da Comunidade: ' || T_COMUNIDADE(I_INDEX).NOME_COMUNIDADE);
            DBMS_OUTPUT.PUT_LINE('Espécie da Comunidade: ' || T_COMUNIDADE(I_INDEX).ESPECIE_COMUNIDADE);
            DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');

    END LOOP;
    COMMIT;
END;

/* RESULTADOS:

RESULTADO DA BUSCA FEITA NO CURSOR: COMUNIDADES QUE HABITAM PLANETAS DOMINADOS 
POR NACOES ONDE FACCAO ESCOLHIDA ESTA PRESENTE MAS NAO FAZEM PARTE DA FACCAO:

NOME_COMUNIDADE_____ESPECIE_COMUNIDADE_____HABITANTES
Com Rerum	         Rerum optio	        100
Com Neque	         Neque eaque ad	        1200
Com Labore         	 Vero labore	        300



TABELA PARTICIPA ANTES DA EXECUÇÃO:

___FACCAO_______ESPECIE________COMUNIDADE
Cons Cósmicos	Quam aut	   Com Quam
Prog Celestiais	Libero magni   Com Lib




TABELA PARTICIPA DEPOIS DA EXEÇÃO:

___FACCAO_______ESPECIE________COMUNIDADE
Cons Cósmicos	Quam aut	    Com Quam
Prog Celestiais	Libero magni	Com Lib
Prog Celestiais	Neque eaque ad	Com Neque
Prog Celestiais	Rerum optio	    Com Rerum
Prog Celestiais	Vero labore	    Com Labore




SAÍDA DBMS:

Inserindo em PARTICIPA:
Facção: Prog Celestiais
Nome da Comunidade: Com Rerum
Espécie da Comunidade: Rerum optio
------------------------------------------------------
Facção: Prog Celestiais
Nome da Comunidade: Com Neque
Espécie da Comunidade: Neque eaque ad
------------------------------------------------------
Facção: Prog Celestiais
Nome da Comunidade: Com Labore
Espécie da Comunidade: Vero labore
------------------------------------------------------
*/


-- b)

-- Voltando tabela PARTICIPA para o estado original
DELETE FROM PARTICIPA;

INSERT INTO PARTICIPA (FACCAO, ESPECIE, COMUNIDADE) VALUES ('Prog Celestiais', 'Libero magni', 'Com Lib');
INSERT INTO PARTICIPA (FACCAO, ESPECIE, COMUNIDADE) VALUES ('Cons Cósmicos', 'Quam aut', 'Com Quam');


-- Utilizando FORALL
DECLARE
    -- FACCAO DE ENTRADA DO USUARIO
    V_FACCAO FACCAO.NOME%TYPE := 'Prog Celestiais';

    -- CURSOR - COMUNIDADES QUE HABITAM PLANETAS DOMINADOS POR NACOES ONDE FACCAO ESTA PRESENTE MAS NAO FAZEM PARTE DA FACCAO
    CURSOR C_COMUNIDADES IS
        SELECT DISTINCT C.NOME AS NOME_COMUNIDADE, C.ESPECIE AS ESPECIE_COMUNIDADE, C.QTD_HABITANTES AS HABITANTES  
        FROM NACAO_FACCAO NF
        JOIN NACAO N ON NF.NACAO = N.NOME
        JOIN DOMINANCIA D ON D.NACAO = N.NOME
        JOIN PLANETA P ON P.ID_ASTRO = D.PLANETA
        JOIN HABITACAO H ON P.ID_ASTRO = H.PLANETA
        JOIN COMUNIDADE C ON C.ESPECIE = H.ESPECIE AND C.NOME = H.COMUNIDADE
        WHERE NF.FACCAO = V_FACCAO AND (C.NOME, C.ESPECIE) NOT IN
        (SELECT C.NOME, C.ESPECIE FROM  
        PARTICIPA P JOIN COMUNIDADE C ON P.ESPECIE = C.ESPECIE AND P.COMUNIDADE = C.NOME
        WHERE FACCAO = V_FACCAO);

    --DECLARACAO DO TIPO DA NESTED TABLE
    TYPE T_COMUNIDADE_TYPE IS TABLE OF C_COMUNIDADES%ROWTYPE;

    --DECLARACAO E INICIACAO DA VARIAVEL DE NESTED TABLE
    T_COMUNIDADE T_COMUNIDADE_TYPE := T_COMUNIDADE_TYPE();

BEGIN
    FOR R_COMUNIDADE IN C_COMUNIDADES
    LOOP
        T_COMUNIDADE.EXTEND;
        T_COMUNIDADE(T_COMUNIDADE.LAST) := R_COMUNIDADE;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Inserindo tuplas em PARTICIPA:');

    -- INSERINDO AS NOVAS TUPLAS
    FORALL I_INDEX IN T_COMUNIDADE.FIRST..T_COMUNIDADE.LAST
        INSERT INTO PARTICIPA (FACCAO, COMUNIDADE, ESPECIE) 
            VALUES (V_FACCAO, T_COMUNIDADE(I_INDEX).NOME_COMUNIDADE, T_COMUNIDADE(I_INDEX).ESPECIE_COMUNIDADE);

    FOR I_INDEX IN T_COMUNIDADE.FIRST..T_COMUNIDADE.LAST

    -- IMPRESSOES DO RESULTADO
    LOOP
        DBMS_OUTPUT.PUT_LINE('Facção: ' || V_FACCAO);
        DBMS_OUTPUT.PUT_LINE('Nome da Comunidade: ' || T_COMUNIDADE(I_INDEX).NOME_COMUNIDADE);
        DBMS_OUTPUT.PUT_LINE('Espécie da Comunidade: ' || T_COMUNIDADE(I_INDEX).ESPECIE_COMUNIDADE);
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
    END LOOP;

    COMMIT;
END;

/* RESULTADOS:

RESULTADO DA BUSCA FEITA NO CURSOR: COMUNIDADES QUE HABITAM PLANETAS DOMINADOS 
POR NACOES ONDE FACCAO ESCOLHIDA ESTA PRESENTE MAS NAO FAZEM PARTE DA FACCAO:

NOME_COMUNIDADE_____ESPECIE_COMUNIDADE_____HABITANTES
Com Rerum	         Rerum optio	        100
Com Neque	         Neque eaque ad	        1200
Com Labore         	 Vero labore	        300



TABELA PARTICIPA ANTES DA EXECUÇÃO:

___FACCAO_______ESPECIE________COMUNIDADE
Cons Cósmicos	Quam aut	   Com Quam
Prog Celestiais	Libero magni   Com Lib




TABELA PARTICIPA DEPOIS DA EXEÇÃO:

___FACCAO_______ESPECIE________COMUNIDADE
Cons Cósmicos	Quam aut	    Com Quam
Prog Celestiais	Libero magni	Com Lib
Prog Celestiais	Neque eaque ad	Com Neque
Prog Celestiais	Rerum optio	    Com Rerum
Prog Celestiais	Vero labore	    Com Labore




SAÍDA DBMS:

Inserindo em PARTICIPA:
Facção: Prog Celestiais
Nome da Comunidade: Com Rerum
Espécie da Comunidade: Rerum optio
------------------------------------------------------
Facção: Prog Celestiais
Nome da Comunidade: Com Neque
Espécie da Comunidade: Neque eaque ad
------------------------------------------------------
Facção: Prog Celestiais
Nome da Comunidade: Com Labore
Espécie da Comunidade: Vero labore
------------------------------------------------------



ANALISANDO DIFERENÇA DO USO DE FORALL

Quando dentro de um bloco PL/SQL executamos um comando
DML, teremos um fenômeno chamado TROCA DE CONTEXTO. Quando estamos trabalhando com um
pequeno número de dados (como no exemplo executado acima, com poucas tuplas nas tabelas),
essas trocas de contexto acabam não atrapalhando o desempenho. No entanto, a partir do
momento que temos uma grande quantidade de dados, essas várias trocas de contexto podem
fazer o desempenho cair drasticamente. Para resolver essa questão, implementamos o comando FORALL

A operação FORALL permite processamento em lotez. Isso significa que as operações de inserção serão realizada
numa única vez, sendo necessária apenas uma troca de contexto.Como resultado, teremos operações DML
com o desempenho e tempo de execução muito menores do que quando FORALL não é utilizado

*/


-- QUESTÃO 2 -------------------------------------------------------------------------
DECLARE
    TYPE PlanetInfoType IS RECORD (
        PlanetaID VARCHAR2(15),
        NacaoDominante VARCHAR2(15),
        DataInicioDom DATE,
        DataFimDom DATE,
        QtdComunidades NUMBER,
        QtdEspecies NUMBER,
        QtdHabitantes NUMBER,
        QtdFaccoes NUMBER,
        FaccaoMajoritaria VARCHAR2(15),
        QtdEspeciesOrigem NUMBER
    );
    
    TYPE PlanetInfoTableType IS TABLE OF PlanetInfoType INDEX BY PLS_INTEGER;

    PlanetInfo PlanetInfoTableType;
BEGIN
    FOR PlanetRec IN (SELECT p.ID_ASTRO AS PlanetaID,
                              d.NACAO AS NacaoDominante,
                              d.DATA_INI AS DataInicioDom,
                              d.DATA_FIM AS DataFimDom,
                              (SELECT COUNT(*) FROM HABITACAO h WHERE h.PLANETA = p.ID_ASTRO) AS QtdComunidades,
                              (SELECT COUNT(DISTINCT e.ESPECIE) FROM HABITACAO e WHERE e.PLANETA = p.ID_ASTRO) AS QtdEspecies,
                              (SELECT SUM(c.QTD_HABITANTES) FROM COMUNIDADE c WHERE c.ESPECIE IN (SELECT DISTINCT h.ESPECIE FROM HABITACAO h WHERE h.PLANETA = p.ID_ASTRO)) AS QtdHabitantes,
                              (SELECT COUNT(DISTINCT f.FACCAO) FROM PARTICIPA f JOIN FACCAO fac ON f.FACCAO = fac.NOME) AS QtdFaccoes,
                              (SELECT f.NOME FROM NACAO n JOIN NACAO_FACCAO nf ON n.NOME = nf.NACAO JOIN FACCAO f ON nf.FACCAO = f.NOME WHERE n.NOME = d.NACAO GROUP BY f.NOME ORDER BY COUNT(*) DESC FETCH FIRST 1 ROW ONLY) AS FaccaoMajoritaria,
                              (SELECT COUNT(DISTINCT e.NOME) FROM ESPECIE e WHERE e.PLANETA_OR = p.ID_ASTRO) AS QtdEspeciesOrigem
                       FROM PLANETA p
                       LEFT JOIN DOMINANCIA d ON p.ID_ASTRO = d.PLANETA
                       WHERE p.ID_ASTRO IS NOT NULL)
    LOOP
        PlanetInfo(PlanetInfo.COUNT + 1).PlanetaID := PlanetRec.PlanetaID;
        PlanetInfo(PlanetInfo.COUNT).NacaoDominante := PlanetRec.NacaoDominante;
        PlanetInfo(PlanetInfo.COUNT).DataInicioDom := PlanetRec.DataInicioDom;
        PlanetInfo(PlanetInfo.COUNT).DataFimDom := PlanetRec.DataFimDom;
        PlanetInfo(PlanetInfo.COUNT).QtdComunidades := PlanetRec.QtdComunidades;
        PlanetInfo(PlanetInfo.COUNT).QtdEspecies := PlanetRec.QtdEspecies;
        PlanetInfo(PlanetInfo.COUNT).QtdHabitantes := PlanetRec.QtdHabitantes;
        PlanetInfo(PlanetInfo.COUNT).QtdFaccoes := PlanetRec.QtdFaccoes;
        PlanetInfo(PlanetInfo.COUNT).FaccaoMajoritaria := PlanetRec.FaccaoMajoritaria;
        PlanetInfo(PlanetInfo.COUNT).QtdEspeciesOrigem := PlanetRec.QtdEspeciesOrigem;
    END LOOP;
    
    FOR i IN 1..PlanetInfo.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Planeta: ' || PlanetInfo(i).PlanetaID);
        DBMS_OUTPUT.PUT_LINE('Nação Dominante: ' || NVL(PlanetInfo(i).NacaoDominante, 'Nenhuma'));
        DBMS_OUTPUT.PUT_LINE('Data de Início da Última Dominação: ' || NVL(TO_CHAR(PlanetInfo(i).DataInicioDom, 'DD/MM/YYYY'), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Data de Fim da Última Dominação: ' || NVL(TO_CHAR(PlanetInfo(i).DataFimDom, 'DD/MM/YYYY'), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Quantidade de Comunidades: ' || PlanetInfo(i).QtdComunidades);
        DBMS_OUTPUT.PUT_LINE('Quantidade de Espécies: ' || PlanetInfo(i).QtdEspecies);
        DBMS_OUTPUT.PUT_LINE('Quantidade de Habitantes: ' || PlanetInfo(i).QtdHabitantes);
        DBMS_OUTPUT.PUT_LINE('Quantidade de Facções: ' || PlanetInfo(i).QtdFaccoes);
        DBMS_OUTPUT.PUT_LINE('Facção Majoritária: ' || NVL(PlanetInfo(i).FaccaoMajoritaria, 'Nenhuma'));
        DBMS_OUTPUT.PUT_LINE('Quantidade de Espécies de Origem: ' || PlanetInfo(i).QtdEspeciesOrigem);
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
END;

/* SAÍDA DBMS (alguns exemplos, já que a saída é muito grande)

Planeta: 11 Com b
Nação Dominante: Ducimus odio.
Data de Início da Última Dominação: 01/01/2000
Data de Fim da Última Dominação: N/A
Quantidade de Comunidades: 3
Quantidade de Espécies: 3
Quantidade de Habitantes: 1400
Quantidade de Facções: 2
Facção Majoritária: Prog Celestiais
Quantidade de Espécies de Origem: 0
 
Planeta: 11 Oph b
Nação Dominante: Ducimus odio.
Data de Início da Última Dominação: 01/01/2001
Data de Fim da Última Dominação: N/A
Quantidade de Comunidades: 1
Quantidade de Espécies: 1
Quantidade de Habitantes: 300
Quantidade de Facções: 2
Facção Majoritária: Prog Celestiais
Quantidade de Espécies de Origem: 1
 
Planeta: 11 Oph b
Nação Dominante: Quam quia ad.
Data de Início da Última Dominação: 01/01/2002
Data de Fim da Última Dominação: N/A
Quantidade de Comunidades: 1
Quantidade de Espécies: 1
Quantidade de Habitantes: 300
Quantidade de Facções: 2
Facção Majoritária: Prog Celestiais
Quantidade de Espécies de Origem: 1
 
Planeta: 11 UMi b
Nação Dominante: Veniam est.
Data de Início da Última Dominação: 01/01/2003
Data de Fim da Última Dominação: N/A
Quantidade de Comunidades: 1
Quantidade de Espécies: 1
Quantidade de Habitantes: 3400
Quantidade de Facções: 2
Facção Majoritária: Cons Cósmicos
Quantidade de Espécies de Origem: 0

*/


