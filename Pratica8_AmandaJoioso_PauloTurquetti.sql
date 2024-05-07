/* Pratica 8

Amanda Valukas Breviglieri Joioso - 4818232
Paulo Henrique Vedovatto Turquetti - 13750791
*/

-- QUESTÃO 1 -------------------------------------------------------------------------


SELECT N.NOME AS NACAO, F.NOME AS FACCAO, D.PLANETA AS PLANETA_DOMINADO FROM 
FACCAO F JOIN NACAO_FACCAO NF ON F.NOME = NF.FACCAO
JOIN NACAO N ON NF.NACAO = N.NOME
JOIN DOMINANCIA D ON D.NACAO = N.NOME;












-- QUESTÃO 2 -------------------------------------------------------------------------
-- Ta dando erro pq da dando overflow, nem eu nem o gpt sabemos como corrigir :) tbm ta falando q nenhum planeta tem informacao, n sei oq fz (:
DECLARE
  TYPE t_planeta_info IS TABLE OF PLANETA%ROWTYPE INDEX BY PLS_INTEGER;
  v_planeta_info t_planeta_info;
  v_index NUMBER;
  v_nacao_dominante DOMINANCIA.NACAO%TYPE;
  v_data_ini DOMINANCIA.DATA_INI%TYPE;
  v_data_fim DOMINANCIA.DATA_FIM%TYPE;
  v_qtd_comunidades NUMBER;
  v_qtd_especies NUMBER;
  v_qtd_habitantes NUMBER;
  v_qtd_faccoes NUMBER;
  v_facao_majoritaria FACCAO.NOME%TYPE;
  v_qtd_especies_origem NUMBER;
BEGIN
  SELECT * BULK COLLECT INTO v_planeta_info FROM PLANETA;

  FOR v_index IN 1..v_planeta_info.COUNT LOOP
    BEGIN
      SELECT NACAO, DATA_INI, DATA_FIM INTO v_nacao_dominante, v_data_ini, v_data_fim
      FROM DOMINANCIA
      WHERE PLANETA = v_planeta_info(v_index).ID_ASTRO
      AND DATA_FIM IS NULL;

      SELECT COUNT(*) INTO v_qtd_comunidades
      FROM COMUNIDADE
      WHERE ESPECIE IN (SELECT NOME FROM ESPECIE WHERE PLANETA_OR = v_planeta_info(v_index).ID_ASTRO);

      SELECT COUNT(DISTINCT ESPECIE), SUM(QTD_HABITANTES) INTO v_qtd_especies, v_qtd_habitantes
      FROM COMUNIDADE
      WHERE ESPECIE IN (SELECT NOME FROM ESPECIE WHERE PLANETA_OR = v_planeta_info(v_index).ID_ASTRO);

      SELECT COUNT(DISTINCT FACCAO) INTO v_qtd_faccoes
      FROM PARTICIPA
      WHERE ESPECIE IN (SELECT NOME FROM ESPECIE WHERE PLANETA_OR = v_planeta_info(v_index).ID_ASTRO);

      SELECT FACCAO INTO v_facao_majoritaria
      FROM PARTICIPA
      WHERE ESPECIE IN (SELECT NOME FROM ESPECIE WHERE PLANETA_OR = v_planeta_info(v_index).ID_ASTRO)
      GROUP BY FACCAO
      ORDER BY COUNT(*) DESC
      FETCH FIRST ROW ONLY;

      SELECT COUNT(*) INTO v_qtd_especies_origem
      FROM ESPECIE
      WHERE PLANETA_OR = v_planeta_info(v_index).ID_ASTRO;

      DBMS_OUTPUT.PUT_LINE('Planeta: ' || v_planeta_info(v_index).ID_ASTRO);
      DBMS_OUTPUT.PUT_LINE('Nação dominante atual: ' || v_nacao_dominante);
      DBMS_OUTPUT.PUT_LINE('Data de início da última dominação: ' || v_data_ini);
      DBMS_OUTPUT.PUT_LINE('Data de fim da última dominação: ' || v_data_fim);
      DBMS_OUTPUT.PUT_LINE('Quantidade de comunidades: ' || v_qtd_comunidades);
      DBMS_OUTPUT.PUT_LINE('Quantidade de espécies: ' || v_qtd_especies);
      DBMS_OUTPUT.PUT_LINE('Quantidade de habitantes: ' || v_qtd_habitantes);
      DBMS_OUTPUT.PUT_LINE('Quantidade de facções: ' || v_qtd_faccoes);
      DBMS_OUTPUT.PUT_LINE('Facção majoritária: ' || v_facao_majoritaria);
      DBMS_OUTPUT.PUT_LINE('Quantidade de espécies que tiveram origem no planeta: ' || v_qtd_especies_origem);
      DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhuma informação encontrada para o planeta: ' || v_planeta_info(v_index).ID_ASTRO);
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao processar o planeta: ' || v_planeta_info(v_index).ID_ASTRO);
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
    END;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro ao executar o programa PL/SQL');
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;
/
