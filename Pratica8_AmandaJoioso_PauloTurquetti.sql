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
