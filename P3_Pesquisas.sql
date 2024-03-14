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

