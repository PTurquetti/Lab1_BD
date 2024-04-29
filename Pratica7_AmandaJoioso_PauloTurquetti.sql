/* Pratica 7

Amanda Valukas Breviglieri Joioso - 4818232
Paulo Henrique Vedovatto Turquetti - 13750791
*/


-- Inserção de dados para testes: 
INSERT INTO ORBITA_ESTRELA(ORBITANTE, ORBITADA) VALUES ('Alasia', 'Aiolos');
INSERT INTO ORBITA_ESTRELA(ORBITANTE, ORBITADA) VALUES ('Alp Ant', 'Aiolos');
INSERT INTO ORBITA_ESTRELA(ORBITANTE, ORBITADA) VALUES ('Alp Ara', 'Alp Aps');
INSERT INTO ORBITA_ESTRELA(ORBITANTE, ORBITADA) VALUES ('Alp Car', 'Alp Aps');
INSERT INTO ORBITA_ESTRELA(ORBITANTE, ORBITADA) VALUES ('Alp CrA', 'Alp Col');




-- 1.

-- BUSCA DO CURSOR:
SELECT ORBITADA, COUNT(ORBITADA) AS ESTRELAS_ORBITANTES
        FROM ORBITA_ESTRELA
        GROUP BY ORBITADA
        ORDER BY ESTRELAS_ORBITANTES DESC;


DECLARE
  CURSOR c IS
    SELECT orbitada, COUNT(*) AS num_orbitantes
    FROM ORBITA_ESTRELA
    GROUP BY orbitada
    HAVING COUNT(*) = (
      SELECT MAX(COUNT(*))
      FROM ORBITA_ESTRELA
      GROUP BY orbitada
    );
BEGIN
  FOR r IN c LOOP
    DBMS_OUTPUT.PUT_LINE('Estrela: ' || r.orbitada || ', Número de estrelas orbitantes: ' || r.num_orbitantes);
  END LOOP;
END;


-- 2.
DECLARE
  num_federacoes_removidas NUMBER;
BEGIN
  DELETE FROM FEDERACAO WHERE NOME NOT IN (SELECT FEDERACAO FROM NACAO);
  num_federacoes_removidas := SQL%ROWCOUNT;
  DBMS_OUTPUT.PUT_LINE('Número de federações removidas: ' || num_federacoes_removidas);
END;

-- 3.
DECLARE
  v_planeta PLANETA.ID_ASTRO%TYPE := 'nome_do_planeta';
  v_comunidade COMUNIDADE.NOME%TYPE := 'nome_da_comunidade';
  v_especie COMUNIDADE.ESPECIE%TYPE := 'nome_da_especie';
  v_qtd_habitantes COMUNIDADE.QTD_HABITANTES%TYPE;
  v_data_ini HABITACAO.DATA_INI%TYPE := SYSDATE;
  v_data_fim HABITACAO.DATA_FIM%TYPE;
BEGIN
  SELECT QTD_HABITANTES INTO v_qtd_habitantes FROM COMUNIDADE WHERE NOME = v_comunidade AND ESPECIE = v_especie;
  IF v_qtd_habitantes <= 1000 THEN
    v_data_fim := v_data_ini + INTERVAL '100' YEAR;
  ELSE
    v_data_fim := v_data_ini + INTERVAL '50' YEAR;
  END IF;
  INSERT INTO HABITACAO (PLANETA, ESPECIE, COMUNIDADE, DATA_INI, DATA_FIM) VALUES (v_planeta, v_especie, v_comunidade, v_data_ini, v_data_fim);
  DBMS_OUTPUT.PUT_LINE('Comunidade ' || v_comunidade || ' da espécie ' || v_especie || ' agora habita o planeta ' || v_planeta || ' de ' || v_data_ini || ' até ' || v_data_fim);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Comunidade ou espécie não encontrada.');
END;


-- 4.
DECLARE
  v_classificacao ESTRELA.CLASSIFICACAO%TYPE := 'classificacao_da_estrela';
  v_distancia_minima NUMBER := valor_da_distancia_minima;
  v_num_orbitas_removidas NUMBER;
BEGIN
  DELETE FROM ORBITA_PLANETA WHERE ESTRELA IN (SELECT ID_ESTRELA FROM ESTRELA WHERE CLASSIFICACAO = v_classificacao) AND DIST_MIN > v_distancia_minima;
  v_num_orbitas_removidas := SQL%ROWCOUNT;
  DBMS_OUTPUT.PUT_LINE('Número de órbitas removidas: ' || v_num_orbitas_removidas);
END;





