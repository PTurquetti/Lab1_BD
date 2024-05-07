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



-- QUESTÃO 1 -------------------------------------------------------------------------


SELECT N.NOME AS NACAO, F.NOME AS FACCAO, D.PLANETA AS PLANETA_DOMINADO FROM 
FACCAO F JOIN NACAO_FACCAO NF ON F.NOME = NF.FACCAO
JOIN NACAO N ON NF.NACAO = N.NOME
JOIN DOMINANCIA D ON D.NACAO = N.NOME;












-- QUESTÃO 2 -------------------------------------------------------------------------
-- Ta dando erro pq da dando overflow, nem eu nem o gpt sabemos como corrigir :) tbm ta falando q nenhum planeta tem informacao, n sei oq fz (:
DECLARE
  -- Declaração de tipos e variáveis
  TYPE t_planeta_info IS TABLE OF PLANETA%ROWTYPE INDEX BY PLS_INTEGER; -- Define um tipo de tabela baseado na estrutura da tabela PLANETA
  v_planeta_info t_planeta_info; -- Variável que vai armazenar os dados dos planetas
  v_index NUMBER; -- Variável para o índice do loop
  v_nacao_dominante DOMINANCIA.NACAO%TYPE; -- Variável para armazenar a nação dominante
  v_data_ini DOMINANCIA.DATA_INI%TYPE; -- Variável para armazenar a data de início da dominação
  v_data_fim DOMINANCIA.DATA_FIM%TYPE; -- Variável para armazenar a data de fim da dominação
  v_qtd_comunidades NUMBER; -- Variável para armazenar a quantidade de comunidades
  v_qtd_especies NUMBER; -- Variável para armazenar a quantidade de espécies
  v_qtd_habitantes NUMBER; -- Variável para armazenar a quantidade de habitantes
  v_qtd_faccoes NUMBER; -- Variável para armazenar a quantidade de facções
  v_facao_majoritaria FACCAO.NOME%TYPE; -- Variável para armazenar a facção majoritária
  v_qtd_especies_origem NUMBER; -- Variável para armazenar a quantidade de espécies que tiveram origem no planeta
BEGIN
  -- Coleta de dados dos planetas
  SELECT * BULK COLLECT INTO v_planeta_info FROM PLANETA; -- Usa BULK COLLECT para coletar todos os dados dos planetas de uma vez

  -- Loop através dos planetas
  FOR v_index IN 1..v_planeta_info.COUNT LOOP
    BEGIN
      -- Coleta de informações do planeta
      SELECT NACAO, DATA_INI, DATA_FIM INTO v_nacao_dominante, v_data_ini, v_data_fim
      FROM DOMINANCIA
      WHERE PLANETA = v_planeta_info(v_index).ID_ASTRO
      AND DATA_FIM IS NULL; -- Seleciona a nação dominante atual e as datas de início e fim da dominação

      SELECT COUNT(*) INTO v_qtd_comunidades
      FROM COMUNIDADE
      WHERE ESPECIE IN (SELECT NOME FROM ESPECIE WHERE PLANETA_OR = v_planeta_info(v_index).ID_ASTRO); -- Conta a quantidade de comunidades

      SELECT COUNT(DISTINCT ESPECIE), SUM(QTD_HABITANTES) INTO v_qtd_especies, v_qtd_habitantes
      FROM COMUNIDADE
      WHERE ESPECIE IN (SELECT NOME FROM ESPECIE WHERE PLANETA_OR = v_planeta_info(v_index).ID_ASTRO); -- Conta a quantidade de espécies e habitantes

      SELECT COUNT(DISTINCT FACCAO) INTO v_qtd_faccoes
      FROM PARTICIPA
      WHERE ESPECIE IN (SELECT NOME FROM ESPECIE WHERE PLANETA_OR = v_planeta_info(v_index).ID_ASTRO); -- Conta a quantidade de facções

      SELECT FACCAO INTO v_facao_majoritaria
      FROM PARTICIPA
      WHERE ESPECIE IN (SELECT NOME FROM ESPECIE WHERE PLANETA_OR = v_planeta_info(v_index).ID_ASTRO)
      GROUP BY FACCAO
      ORDER BY COUNT(*) DESC
      FETCH FIRST ROW ONLY; -- Seleciona a facção majoritária

      SELECT COUNT(*) INTO v_qtd_especies_origem
      FROM ESPECIE
      WHERE PLANETA_OR = v_planeta_info(v_index).ID_ASTRO; -- Conta a quantidade de espécies que tiveram origem no planeta

      -- Impressão das informações
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
      -- Tratamento de exceções
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhuma informação encontrada para o planeta: ' || v_planeta_info(v_index).ID_ASTRO); -- Imprime uma mensagem se não houver informações para o planeta
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao processar o planeta: ' || v_planeta_info(v_index).ID_ASTRO); -- Imprime uma mensagem se ocorrer um erro ao processar o planeta
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM); -- Imprime a mensagem de erro
    END;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro ao executar o programa PL/SQL'); -- Imprime uma mensagem se ocorrer um erro ao executar o programa
    DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM); -- Imprime a mensagem de erro
END;
/
