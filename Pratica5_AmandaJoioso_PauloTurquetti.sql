/* Pratica 4

Amanda Valukas Breviglieri Joioso - 4818232
Paulo Henrique Vedovatto Turquetti - 13750791
*/

-- Inserindo dados novos para a realização e teste das buscas:




-- QUESTAO 1 -------------------------------------------------------------------------------------------------------------

-- 1)

--Criando view:
CREATE OR REPLACE VIEW VIEW_FACCAO AS
    SELECT NOME, LIDER 
    FROM FACCAO
    WHERE UPPER(IDEOLOGIA) = 'PROGRESSITA'
WITH READ ONLY;

-- a) Consulta que retorna o número de facções progressistas;
SELECT COUNT(*)FROM VIEW_FACCAO;



-- b) Usando a view, teste uma operação de inserção. Explique o resultado.
INSERT INTO VIEW_FACCAO VALUES ('Uspianos', '111.111.111-11');

/* Ao tentar rodar essa inserção, recebemos uma mesnsagem dizendo que não é possível realizar essa operação. Isso porque
essa view não é atualizável, já que possui WITH READ ONLY. Sendo assim, não será possível fazer operações de inserção,
alteração ou remoção de dados. */

-- QUESTAO 2 -------------------------------------------------------------------------------------------------------------

-- Crie duas views atualizáveis das faccoes (nome, lider, ideologia)

-- a) View que permite a insercao de faccoes nao tradicionalistas:
CREATE OR REPLACE VIEW VIEW_FACCAO_2 AS
    SELECT NOME, LIDER, IDEOLOGIA
    FROM FACCAO
    WHERE UPPER(IDEOLOGIA) = 'TRADICIONALISTA';

-- Inserindo uma faccao tradicionalista:
