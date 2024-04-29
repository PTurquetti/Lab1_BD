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

DECLARE
    CURSOR C_ORBITA_ESTRELA IS
        SELECT OE.ORBITADA AS ID_ESTRELA, E.NOME AS NOME, COUNT(ORBITADA) AS ESTRELAS_ORBITANTES
        FROM ORBITA_ESTRELA OE JOIN ESTRELA E ON OE.ORBITADA = E.ID_ESTRELA
        GROUP BY ORBITADA, E.NOME
        ORDER BY ESTRELAS_ORBITANTES DESC;

    V_RESULTADO C_ORBITA_ESTRELA%ROWTYPE;
    V_MAX_ORBITANTES NUMBER;
    
BEGIN
    OPEN C_ORBITA_ESTRELA;
    
    DBMS_OUTPUT.PUT_LINE('ESTRELAS COM MAIOR NUMERO DE ESTRELAS EM SUA ORBITA:');
    
    FETCH C_ORBITA_ESTRELA INTO V_RESULTADO;
    V_MAX_ORBITANTES := V_RESULTADO.ESTRELAS_ORBITANTES;
    
    LOOP
        DBMS_OUTPUT.PUT_LINE('ID_ETRELA: ' || V_RESULTADO.ID_ESTRELA ||
            ' NOME: ' || V_RESULTADO.NOME);
    
        FETCH C_ORBITA_ESTRELA INTO V_RESULTADO;
        EXIT WHEN V_RESULTADO.ESTRELAS_ORBITANTES < V_MAX_ORBITANTES;
        
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('QUANTIDADE DE ESTRELAS ORBITANTES: ' || V_MAX_ORBITANTES);
    
    CLOSE C_ORBITA_ESTRELA;
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





