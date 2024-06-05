/* Pratica 11

Amanda Valukas Breviglieri Joioso - 4818232
Paulo Henrique Vedovatto Turquetti - 13750791

*/

-- QUESTÃO 1 -------------------------------------------------------------------------------
-- INSERCAO DE DADOS
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Nihil deserunt.', '7Zet1CrB', 0.3, 0.4, 30);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Quae possimus.', '7Zet1CrB', 1.8, 2, 160);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('In magni quas.', '7Zet1CrB', 2.3, 3, 510);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('At molestiae.', '7Zet1CrB', 4.7, 4.8, 780);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Modi sit harum.', '7Zet1CrB', 5.1, 5.3, 220);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('WD 1856+534 b', '7Zet1CrB', 5.1, 5.3, 220);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Eum iure animi.', 'Gl 539', 0.3, 2, 30);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Deserunt aut.', 'Zet2Mus', 100, 200, 687);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Autem beatae.', '21    Mon', 100, 200, 687);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Autem beatae.', 'GJ 3579', 100, 200, 687);



-- Utilizando READ COMMITED

-- i - Sessão 1 ligada
-- ii. sessão 2 ligada
-- iii. iniciando transação na sessão 2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- iv. Sessão 2 - busca usando junção
SELECT 
    P.ID_ASTRO AS PLANETA,
    OP.ESTRELA AS ESTRELA_ORBITADA,
    P.CLASSIFICACAO
FROM PLANETA P JOIN ORBITA_PLANETA OP ON P.ID_ASTRO = OP.PLANETA;
/* RESULTADO DA BUSCA
PLANETA     ESTRELA_ORBITADA     CLASSIFICACAO
At molestiae.	7Zet1CrB	Iste impedit fugiat optio.
Autem beatae.	21    Mon	Culpa quasi omnis temporibus.
Autem beatae.	GJ 3579	Culpa quasi omnis temporibus.
Deserunt aut.	Zet2Mus	Corporis rerum eius. Velit ratione et quisquam.
Eum iure animi.	Gl 539	Odit beatae illo earum quod ipsam accusamus.
In magni quas.	7Zet1CrB	Error repellat quisquam molestias.
Modi sit harum.	7Zet1CrB	Hic perferendis ut fuga. Perferendis culpa esse.
Nihil deserunt.	7Zet1CrB	Iste reprehenderit ratione qui.
Quae possimus.	7Zet1CrB	In perspiciatis soluta.
WD 1856+534 b	7Zet1CrB	Confirmed
*/

-- v. Sessão 1 - executa comando DML que afeta resultado
DELETE FROM ORBITA_PLANETA WHERE ESTRELA = '7Zet1CrB';

-- vi. Sessão 2 - executando novamente a busca
SELECT 
    P.ID_ASTRO AS PLANETA,
    OP.ESTRELA AS ESTRELA_ORBITADA,
    P.CLASSIFICACAO
FROM PLANETA P JOIN ORBITA_PLANETA OP ON P.ID_ASTRO = OP.PLANETA;
/* RESULTADO DA BUSCA
PLANETA     ESTRELA_ORBITADA     CLASSIFICACAO
At molestiae.	7Zet1CrB	Iste impedit fugiat optio.
Autem beatae.	21    Mon	Culpa quasi omnis temporibus.
Autem beatae.	GJ 3579	Culpa quasi omnis temporibus.
Deserunt aut.	Zet2Mus	Corporis rerum eius. Velit ratione et quisquam.
Eum iure animi.	Gl 539	Odit beatae illo earum quod ipsam accusamus.
In magni quas.	7Zet1CrB	Error repellat quisquam molestias.
Modi sit harum.	7Zet1CrB	Hic perferendis ut fuga. Perferendis culpa esse.
Nihil deserunt.	7Zet1CrB	Iste reprehenderit ratione qui.
Quae possimus.	7Zet1CrB	In perspiciatis soluta.
WD 1856+534 b	7Zet1CrB	Confirmed


Explicacao: Podemos perceber que o resultado da busca se manteve o mesmo, representando um caso de inconsistência.
Isso ocorre porque, como o commit não foi realizado na sessão 1, a remoção dos dados não foi concretizada na transação da
sessão 2, já que READ COMMITED faz com que os dados "enxergados" sejam apenas os commitados
    
*/


-- vii. Sessão 1 - fazendo commit
COMMIT;

-- viii. Sessão 2 - Fazendo busca novamente
SELECT 
    P.ID_ASTRO AS PLANETA,
    OP.ESTRELA AS ESTRELA_ORBITADA,
    P.CLASSIFICACAO
FROM PLANETA P JOIN ORBITA_PLANETA OP ON P.ID_ASTRO = OP.PLANETA;

/* RESULTADO DA BUSCA
PLANETA     ESTRELA_ORBITADA     CLASSIFICACAO
Autem beatae.	21    Mon	Culpa quasi omnis temporibus.
Autem beatae.	GJ 3579	Culpa quasi omnis temporibus.
Deserunt aut.	Zet2Mus	Corporis rerum eius. Velit ratione et quisquam.
Eum iure animi.	Gl 539	Odit beatae illo earum quod ipsam accusamus.

Explicação:

Agora podemos perceber que os dados removidos na sessão 1 também foram removidos na sessão 2. Isso porque, como a sessão 1 fez o 
commit, a transação da sessão 2 com READ COMMIT conseguirá enxergar os dados que foram alterados (no caso removidos)


*/

-- ix. Sessão 2 - Fazendo COMMIT
COMMIT;


-- X. Sessão 2 - Fazendo busca novamente
SELECT 
    P.ID_ASTRO AS PLANETA,
    OP.ESTRELA AS ESTRELA_ORBITADA,
    P.CLASSIFICACAO
FROM PLANETA P JOIN ORBITA_PLANETA OP ON P.ID_ASTRO = OP.PLANETA;

/* RESULTADO DA BUSCA
PLANETA     ESTRELA_ORBITADA     CLASSIFICACAO
Autem beatae.	21    Mon	Culpa quasi omnis temporibus.
Autem beatae.	GJ 3579	Culpa quasi omnis temporibus.
Deserunt aut.	Zet2Mus	Corporis rerum eius. Velit ratione et quisquam.
Eum iure animi.	Gl 539	Odit beatae illo earum quod ipsam accusamus.

Explicação:

Quando sessão 2 faz COMMIT, a transação está sendo encerrada. Sendo assim, essa busca representa o estado das tabelas fora
de uma transição. Logo, os dados serão compatíveis com o último COMMIT que realizou alterações, ou seja, é consistente com 
as alterações feitas em sessão 1

*/

-- UTILIZANDO SERIALIZABLE
-- Inserindo dados que foram deletados
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Nihil deserunt.', '7Zet1CrB', 0.3, 0.4, 30);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Quae possimus.', '7Zet1CrB', 1.8, 2, 160);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('In magni quas.', '7Zet1CrB', 2.3, 3, 510);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('At molestiae.', '7Zet1CrB', 4.7, 4.8, 780);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('Modi sit harum.', '7Zet1CrB', 5.1, 5.3, 220);
INSERT INTO ORBITA_PLANETA (PLANETA, ESTRELA, DIST_MIN, DIST_MAX, PERIODO) VALUES ('WD 1856+534 b', '7Zet1CrB', 5.1, 5.3, 220);
COMMIT;

-- i - Sessão 1 ligada
-- ii. sessão 2 ligada
-- iii. iniciando transação na sessão 2
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- iv. Sessão 2 - Fazendo busca
SELECT 
    P.ID_ASTRO AS PLANETA,
    OP.ESTRELA AS ESTRELA_ORBITADA,
    P.CLASSIFICACAO
FROM PLANETA P JOIN ORBITA_PLANETA OP ON P.ID_ASTRO = OP.PLANETA;
/* RESULTADO DA BUSCA
PLANETA     ESTRELA_ORBITADA     CLASSIFICACAO
At molestiae.	7Zet1CrB	Iste impedit fugiat optio.
Autem beatae.	21    Mon	Culpa quasi omnis temporibus.
Autem beatae.	GJ 3579	Culpa quasi omnis temporibus.
Deserunt aut.	Zet2Mus	Corporis rerum eius. Velit ratione et quisquam.
Eum iure animi.	Gl 539	Odit beatae illo earum quod ipsam accusamus.
In magni quas.	7Zet1CrB	Error repellat quisquam molestias.
Modi sit harum.	7Zet1CrB	Hic perferendis ut fuga. Perferendis culpa esse.
Nihil deserunt.	7Zet1CrB	Iste reprehenderit ratione qui.
Quae possimus.	7Zet1CrB	In perspiciatis soluta.
WD 1856+534 b	7Zet1CrB	Confirmed
*/

-- v. Sessão 1 - executando DML que  afeta consulta:
DELETE FROM ORBITA_PLANETA WHERE ESTRELA = '7Zet1CrB';

-- vi. Sessão 2 - Executando consulta novamente
SELECT 
    P.ID_ASTRO AS PLANETA,
    OP.ESTRELA AS ESTRELA_ORBITADA,
    P.CLASSIFICACAO
FROM PLANETA P JOIN ORBITA_PLANETA OP ON P.ID_ASTRO = OP.PLANETA;
/* RESULTADO DA BUSCA
PLANETA     ESTRELA_ORBITADA     CLASSIFICACAO
At molestiae.	7Zet1CrB	Iste impedit fugiat optio.
Autem beatae.	21    Mon	Culpa quasi omnis temporibus.
Autem beatae.	GJ 3579	Culpa quasi omnis temporibus.
Deserunt aut.	Zet2Mus	Corporis rerum eius. Velit ratione et quisquam.
Eum iure animi.	Gl 539	Odit beatae illo earum quod ipsam accusamus.
In magni quas.	7Zet1CrB	Error repellat quisquam molestias.
Modi sit harum.	7Zet1CrB	Hic perferendis ut fuga. Perferendis culpa esse.
Nihil deserunt.	7Zet1CrB	Iste reprehenderit ratione qui.
Quae possimus.	7Zet1CrB	In perspiciatis soluta.
WD 1856+534 b	7Zet1CrB	Confirmed

EXPLICAÇÃO:

Do mesmo modo que ocorreu anteriormente, como as alterações feitas na sessão 1 não sofreram commit, elas não terão nenhum impacto
sobre os dados dessa transação, independente do isolation level.


*/


-- vii. Sessão 1 - fazendo commit:
COMMIT;

-- viii. Sessão 2 - Executando consulta novamente
SELECT 
    P.ID_ASTRO AS PLANETA,
    OP.ESTRELA AS ESTRELA_ORBITADA,
    P.CLASSIFICACAO
FROM PLANETA P JOIN ORBITA_PLANETA OP ON P.ID_ASTRO = OP.PLANETA;
/* RESULTADO DA BUSCA
PLANETA     ESTRELA_ORBITADA     CLASSIFICACAO
At molestiae.	7Zet1CrB	Iste impedit fugiat optio.
Autem beatae.	21    Mon	Culpa quasi omnis temporibus.
Autem beatae.	GJ 3579	Culpa quasi omnis temporibus.
Deserunt aut.	Zet2Mus	Corporis rerum eius. Velit ratione et quisquam.
Eum iure animi.	Gl 539	Odit beatae illo earum quod ipsam accusamus.
In magni quas.	7Zet1CrB	Error repellat quisquam molestias.
Modi sit harum.	7Zet1CrB	Hic perferendis ut fuga. Perferendis culpa esse.
Nihil deserunt.	7Zet1CrB	Iste reprehenderit ratione qui.
Quae possimus.	7Zet1CrB	In perspiciatis soluta.
WD 1856+534 b	7Zet1CrB	Confirmed

EXPLICAÇÃO:

Vemos agora um comportamento diferente devido ao tipo de isolamento da transação. Como essa transação é do tipo SERIALIZABLE,
ela leva em consideração o ultimo estado dos dados antes do inicio da transação. Sendo assim, como o commit na sessão 1 ocorreu enquanto
a transação já estava ativa, as operações na transação de sessão 2 não irão enxergar as remoções realizadas, configurando um caso de inconsistência


*/


-- ix. Sessão 2 - Fazendo COMMIT
COMMIT;


-- X. Sessão 2 - Fazendo busca novamente
SELECT 
    P.ID_ASTRO AS PLANETA,
    OP.ESTRELA AS ESTRELA_ORBITADA,
    P.CLASSIFICACAO
FROM PLANETA P JOIN ORBITA_PLANETA OP ON P.ID_ASTRO = OP.PLANETA;
/* RESULTADO DA BUSCA
PLANETA     ESTRELA_ORBITADA     CLASSIFICACAO
Autem beatae.	21    Mon	Culpa quasi omnis temporibus.
Autem beatae.	GJ 3579	Culpa quasi omnis temporibus.
Deserunt aut.	Zet2Mus	Corporis rerum eius. Velit ratione et quisquam.
Eum iure animi.	Gl 539	Odit beatae illo earum quod ipsam accusamus.

EXPLICAÇÃO:

Quando fazemos COMMIT em sessão 2, temos o término da transação. Sendo assim, a cláusula SERIALIZABLE deixará de fazer efeito.
Com isso, agora o estado do sistema acessado na sessão 2 leva em conta o último commit realizado, ou seja, o commit feito na sessão 1.
Em decorrência disso, agora percebemos a remoção dos dados

*/


-- QUESTÃO 2 -------------------------------------------------------------------------------

-- a)
CREATE TABLE DML_LOG (
    LOG_ID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    USUARIO VARCHAR2(30),
    OPERACAO VARCHAR2(20),
    DATA_OPERACAO TIMESTAMP,
    ESTRELA VARCHAR2(31 BYTE),
    SISTEMA VARCHAR2(31 BYTE)
);


CREATE OR REPLACE TRIGGER SISTEMA_DML_LOG_TRIGGER
AFTER INSERT OR UPDATE OR DELETE ON SISTEMA
FOR EACH ROW
DECLARE
    V_USUARIO VARCHAR2(30);
BEGIN
    -- Obtém o nome do usuário que realizou a operação
    SELECT USER INTO V_USUARIO FROM dual;
    
    -- Insere um registro na tabela de log
    IF INSERTING THEN
        INSERT INTO DML_LOG (USUARIO, OPERACAO, DATA_OPERACAO, ESTRELA, SISTEMA)
        VALUES (V_USUARIO, 'INSERT', SYSTIMESTAMP, :NEW.ESTRELA, :NEW.NOME);
    ELSIF UPDATING THEN
        INSERT INTO DML_LOG (USUARIO, OPERACAO, DATA_OPERACAO, ESTRELA, SISTEMA)
        VALUES (V_USUARIO, 'UPDATE', SYSTIMESTAMP, :NEW.ESTRELA, :NEW.NOME);
    ELSIF DELETING THEN
        INSERT INTO DML_LOG (USUARIO, OPERACAO, DATA_OPERACAO, ESTRELA, SISTEMA)
        VALUES (V_USUARIO, 'DELETE', SYSTIMESTAMP, :OLD.ESTRELA, :OLD.NOME);
    END IF;
END;


-- INSERINDO DADOS PARA TESTE
INSERT INTO SISTEMA (ESTRELA, NOME) VALUES ('GJ 9798', 'SISTEMA 1');
UPDATE SISTEMA SET NOME = 'SISTEMA 2' WHERE ESTRELA = 'GJ 9798';
DELETE FROM SISTEMA WHERE ESTRELA = 'GJ 9798';

-- ANALISANDO RESULTADO
SELECT * FROM DML_LOG;

/*
LOG_ID      USUARIO      OPERACAO      DATA_OPERACAO                        ESTRELA      SISTEMA
6	       A13750791	 INSERT	    04/06/24 17:17:56,106000000        	GJ 9798	SISTEMA     1
7	       A13750791	 UPDATE	    04/06/24 17:17:56,246000000	        GJ 9798	SISTEMA     2
8	       A13750791	 DELETE    	04/06/24 17:17:56,387000000	        GJ 9798	SISTEMA     2
*/






-- b) PARA FAZERMOS TESTES, AS OPERAÇÕES SERÃO REALIZADAS EM BLOCOS PL/SQL

-- TESTANDO OPERACAO COM COMMIT
BEGIN
    INSERT INTO SISTEMA (ESTRELA, NOME) VALUES ('GJ 1234', 'SISTEMA 3');

    COMMIT;

    DECLARE
        CURSOR C_LOG IS
            SELECT * FROM DML_LOG;
        V_RESULTADO DML_LOG%ROWTYPE;
    BEGIN
        OPEN C_LOG;
        
        LOOP
            FETCH C_LOG INTO V_RESULTADO;
            EXIT WHEN C_LOG%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('LOG_ID: ' || V_RESULTADO.LOG_ID || 
                                 ', USUARIO: ' || V_RESULTADO.USUARIO || 
                                 ', OPERACAO: ' || V_RESULTADO.OPERACAO || 
                                 ', DATA_OPERACAO: ' || V_RESULTADO.DATA_OPERACAO || 
                                 ', ESTRELA: ' || V_RESULTADO.ESTRELA || 
                                 ', SISTEMA: ' || V_RESULTADO.SISTEMA);
        END LOOP;
        
        -- Fecha o cursor
        CLOSE C_LOG;
    END;
END;


/* SAIDA DBMS

LOG_ID: 17, USUARIO: A13750791, OPERACAO: INSERT, DATA_OPERACAO: 04/06/24 17:32:23,283000, ESTRELA: GJ 1234, SISTEMA: SISTEMA 3

*/


-- TESTANDO OPERACAO COM ROLLBACK
BEGIN
    INSERT INTO SISTEMA (ESTRELA, NOME) VALUES ('5Ups Boo', 'SISTEMA 55');
    ROLLBACK;

    DECLARE
        CURSOR C_LOG IS
            SELECT * FROM DML_LOG;
        V_RESULTADO DML_LOG%ROWTYPE;
    BEGIN

        OPEN C_LOG;
        
        
        LOOP
            FETCH C_LOG INTO V_RESULTADO;
            EXIT WHEN C_LOG%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE('LOG_ID: ' || V_RESULTADO.LOG_ID || 
                                 ', USUARIO: ' || V_RESULTADO.USUARIO || 
                                 ', OPERACAO: ' || V_RESULTADO.OPERACAO || 
                                 ', DATA_OPERACAO: ' || V_RESULTADO.DATA_OPERACAO || 
                                 ', ESTRELA: ' || V_RESULTADO.ESTRELA || 
                                 ', SISTEMA: ' || V_RESULTADO.SISTEMA);
        END LOOP;
        
        CLOSE C_LOG;
    END;
END;

/* SAIDA DBMS

OBS: Continua a mesma, ou seja, a inserção não foi realizada
LOG_ID: 17, USUARIO: A13750791, OPERACAO: INSERT, DATA_OPERACAO: 04/06/24 17:32:23,283000, ESTRELA: GJ 1234, SISTEMA: SISTEMA 3

*/

-- TESTANDO OPERACAO COM  COMMIT E ROLLBACK NO MESMO BLOCO PL/SQL

-- LIMPANDO TABELA SISTEMA E DML_LOG
DELETE FROM SISTEMA;
DELETE FROM DML_LOG;

-- BLOCO PL/SQL
BEGIN
    -- INSERT COM COMMIT
    INSERT INTO SISTEMA (ESTRELA, NOME) VALUES ('5Ups Boo', 'SISTEMA 3');
    COMMIT;
    
    -- UPDATE COM ROLLBACK
    UPDATE SISTEMA SET NOME = 'SISTEMA 3A' WHERE ESTRELA = '5Ups Boo';
    ROLLBACK;
    
    -- DELETE COM COMMIT
    DELETE FROM SISTEMA WHERE ESTRELA = '5Ups Boo';
    COMMIT;


    DECLARE
        CURSOR C_LOG IS
            SELECT * FROM DML_LOG;
        V_RESULTADO DML_LOG%ROWTYPE;
    BEGIN

        OPEN C_LOG;
        
        
        LOOP
            FETCH C_LOG INTO V_RESULTADO;
            EXIT WHEN C_LOG%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE('LOG_ID: ' || V_RESULTADO.LOG_ID || 
                                 ', USUARIO: ' || V_RESULTADO.USUARIO || 
                                 ', OPERACAO: ' || V_RESULTADO.OPERACAO || 
                                 ', DATA_OPERACAO: ' || V_RESULTADO.DATA_OPERACAO || 
                                 ', ESTRELA: ' || V_RESULTADO.ESTRELA || 
                                 ', SISTEMA: ' || V_RESULTADO.SISTEMA);
        END LOOP;
        
        CLOSE C_LOG;
    END;
END;

/* SAIDA DBMS
LOG_ID: 25, USUARIO: A13750791, OPERACAO: INSERT, DATA_OPERACAO: 04/06/24 17:44:20,684000, ESTRELA: 5Ups Boo, SISTEMA: SISTEMA 3
LOG_ID: 27, USUARIO: A13750791, OPERACAO: DELETE, DATA_OPERACAO: 04/06/24 17:44:20,684000, ESTRELA: 5Ups Boo, SISTEMA: SISTEMA 3



 -- ANALISANDO RESULTADOS --


No bloco PL/SQL fornecido, são realizadas operações INSERT, UPDATE E DELETE na tabela SISTEMA.
Cada operação é acompanhada de um COMMIT ou ROLLBACK, dependendo do resultado esperado.

Ao analisar a saída do DBMS, percebemos que apenas as operações de INSERT e DELETE são registradas na tabela DML_LOG,
refletindo as mudanças permanentes na tabela SISTEMA. Isso porque essas operações foram seguidas de COMMIT.

Já o UPDATE não é registrado no log porque foi desfeito pelo ROLLBACK, que restaurou o estado do banco ao último COMMIT realizado,
ou seja, o banco voltou ao estado que tava quando foi executado o COMMIT após o INSERT.

*/




-- C)

-- ATUALIZANDO CURSOR PARA REGISTRAR ATE OPERACOES QUE SOFREM ROLLBACK
CREATE OR REPLACE TRIGGER SISTEMA_DML_LOG_TRIGGER
BEFORE INSERT OR UPDATE OR DELETE ON SISTEMA
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
    
    PROCEDURE REGISTRAR_LOG(OPERACAO VARCHAR2, ESTRELA VARCHAR2, NOME VARCHAR2) IS
    BEGIN
        INSERT INTO DML_LOG (USUARIO, OPERACAO, DATA_OPERACAO, ESTRELA, SISTEMA)
        VALUES (USER, OPERACAO, SYSTIMESTAMP, ESTRELA, NOME);
        COMMIT;
    END;
    
BEGIN
    IF INSERTING THEN
        REGISTRAR_LOG('INSERT', :NEW.ESTRELA, :NEW.NOME);
    ELSIF UPDATING THEN
        REGISTRAR_LOG('UPDATE', :NEW.ESTRELA, :NEW.NOME);
    ELSIF DELETING THEN
        REGISTRAR_LOG('DELETE', :OLD.ESTRELA, :OLD.NOME);
    END IF;
END;





-- TEXTANDO TRIGGER COM COMMITS E ROLLBACKS
BEGIN
    -- INSERT COM COMMIT
    INSERT INTO SISTEMA (ESTRELA, NOME) VALUES ('5Ups Boo', 'SISTEMA 3');
    COMMIT;
    
    -- UPDATE COM ROLLBACK
    UPDATE SISTEMA SET NOME = 'SISTEMA 3A' WHERE ESTRELA = '5Ups Boo';
    ROLLBACK;
    
    -- DELETE COM COMMIT
    DELETE FROM SISTEMA WHERE ESTRELA = '5Ups Boo';
    COMMIT;


    DECLARE
        CURSOR C_LOG IS
            SELECT * FROM DML_LOG;
        V_RESULTADO DML_LOG%ROWTYPE;
    BEGIN

        OPEN C_LOG;
        
        
        LOOP
            FETCH C_LOG INTO V_RESULTADO;
            EXIT WHEN C_LOG%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE('LOG_ID: ' || V_RESULTADO.LOG_ID || 
                                 ', USUARIO: ' || V_RESULTADO.USUARIO || 
                                 ', OPERACAO: ' || V_RESULTADO.OPERACAO || 
                                 ', DATA_OPERACAO: ' || V_RESULTADO.DATA_OPERACAO || 
                                 ', ESTRELA: ' || V_RESULTADO.ESTRELA || 
                                 ', SISTEMA: ' || V_RESULTADO.SISTEMA);
        END LOOP;
        
        CLOSE C_LOG;
    END;
END;

/* SAÍDA DBMS

LOG_ID: 13, USUARIO: A13750791, OPERACAO: INSERT, DATA_OPERACAO: 04/06/24 18:07:29,301000, ESTRELA: 5Ups Boo, SISTEMA: SISTEMA 3
LOG_ID: 14, USUARIO: A13750791, OPERACAO: UPDATE, DATA_OPERACAO: 04/06/24 18:07:29,301000, ESTRELA: 5Ups Boo, SISTEMA: SISTEMA 3A
LOG_ID: 15, USUARIO: A13750791, OPERACAO: DELETE, DATA_OPERACAO: 04/06/24 18:07:29,301000, ESTRELA: 5Ups Boo, SISTEMA: SISTEMA 3


Vemos agora que a operação de UPDATE foi registrada na tabela mesmo que tenha sofrido rollback. Essa operação tentou definir
SISTEMA = SISTEMA 3A, no entando na operação de DELETE vemos que SISTEMA = SISTEMA 3, o que significa que a operação de UPDATE
não foi concretizada, ou seja, sofreu ROLLBACK

*/


-- QUESTÃO 3 -------------------------------------------------------------------------------

/*

Analisando o documento do projeto, poderemos implementar por meio de transações as funcionalidades
do usuário do tipo COMANDANTE

3. Comandante:
    a. Pode alterar aspectos da própria nação:
    i. Incluir/excluir a própria nação de uma federação existente
    ii. Criar nova federação, com a própria nação
    b. Insere nova dominância de um planeta que não está sendo dominado por ninguém



a) Quais	 operações	 estão	 incluídas	 na	 transação (incluindo	 operações	 em	 triggers)?	Justifique.	

Desntre as operações incluidas nessa transação, podemos ditar as seguintes operações nas tabelas envolvidas:
- Inserções: Criação da nova federação, criação da nova dominancia
- Updates: Alterar aspectos das proprias nacoes
- Remoções: Excluir a nação de uma federação existente
- Consultas: Pesquisar aspectos relativos às suas nações e federações

teremos que aplicar triggers para garantir que os dados que estão sendo manipulados são referentes
às nações e federações referentes ao comandante


b) Qual	o	nível	de	isolamento	da	transção?	Justifique.	

Essa transação terá o nível de transação READ COMMITED. Com ela, a operação irá enxergar
apeas os dados que foram efetivados antes do início da operação. Com isso, podemos garantir maior
consistência de dados. A opção SERIALIZABLE não é recomendada pois pode impactar a visualização das
consultas a serem realizadas. A opção READ ONLY terá maior inconsistência. Já que no READ ONLY os dados vistos
são apenas os efetivados antes do inicio da operação, caso outras operações sejam executadas durante a operaçõa,
eles não serão levados em conta, podendo gerar inconsistências


c) Será	necessário	utilizar	savepoints	e/ou	transações	autônomas?	Justifique.		

O uso de savepoits pode ser utilizado quando vamos criar nova federação, com a própria nação. Como serão necessários 
inserções em duas tabelas diferentes, podemos salvar o nosso progresso após a inserção na primeira.
Com isso, mesmo que situações inusitadas aconteçam, teremos concretizado parte do processo.

Poderemos dividir nossa transação em duas transações autônomas, sendo uma para a letra
'a' (Alterar aspectos da própria nação) e uma para a letra 'b' (Inserção de dominancia em planetas não dominados)
Ao usar transações autônomas para essas operações, garantimos que elas sejam tratadas de forma independente e segura, 
preservando a integridade dos dados e mantendo a consistência do sistema.

*/


