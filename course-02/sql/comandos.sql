
-- ########################################################
-- $$$$$$$$$$$$$$$$$$$$$$$ ETAPA 01 $$$$$$$$$$$$$$$$$$$$$$$
-- ########################################################

-- Stored Procedure
--     O nome da SP deve conter apenas letras, números, o símbolo do dólar ($) e o underscore ( _ ).
--     O nome não pode ultrapassar 64 caracteres.
--     O nome deve ser único no banco de dados.
--     O nome da SP é sensível a letras maiúsculas e minúsculas. Portanto, se você criar uma Stored Procedure 
--     com uma letra maiúscula e se referir a ela usando somente letras minúsculas, por exemplo, o MySQL não 
--     vai entender. Isso é o que chamamos de case sensitive.


-- Criando procedure para Listar clientes

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`listar_clientes`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_clientes`()
BEGIN
	SELECT * FROM clientes;
END$$

DELIMITER ;
;


-- chamando procedure
CALL listar_clientes;

-- ########################################################
-- $$$$$$$$$$$$$$$$$$$$$$$ ETAPA 02 $$$$$$$$$$$$$$$$$$$$$$$
-- ########################################################

-- DECLARE {nome da variável} {tipo}

-- DEFAULT {valor inicial}

-- 1. Cláusula DEFAULT é opcional.

-- 2. Nome deve ter apenas letras, números, $ e _.

-- 3. O número de caracteres não pode ultrapassar 255

-- 4. Nome é sensível a maiúsculas e minúsculas

-- 5. Tipos de variáveis:
-- VARCHAR(N)
-- INTEGER
-- DECIMAL (p, s)
-- DATE TIMESTAMP
-- etc...

-- Simulação de aluguel
CREATE PROCEDURE tiposDados ()
BEGIN
  DECLARE vAluguel VARCHAR(10) DEFAULT 10001;
  DECLARE vCliente VARCHAR(10) DEFAULT 1002;
  DECLARE vHospedagem VARCHAR(10) DEFAULT 8635;
  DECLARE vDataInicio DATE DEFAULT '2023-03-01';
  DECLARE vDataFinal DATE DEFAULT '2023-03-05';
  DECLARE vPrecoTotal DECIMAL(10,2) DEFAULT 550.23;
  SELECT vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal;
END

-- chamando procedure
CALL tiposDados;


-- Criando procedure para inserir aluguel

USE `insight_places`;
DROP PROCEDURE IF EXISTS `inserir_aluguel`;

DELIMITER $$
CREATE PROCEDURE `inserir_aluguel` (
	vAluguel VARCHAR(10), 
    vCliente VARCHAR(10), 
    vHospedagem VARCHAR(10),
    vDataInicio DATE,
    vDataFinal DATE,
    vPrecoTotal DECIMAL(10,2)
)
BEGIN
  INSERT INTO alugueis (aluguel_id, cliente_id, hospedagem_id, data_inicio, data_fim, preco_total) 
  VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$

DELIMITER ;

-- Testando a inserção
SET SQL_SAFE_UPDATES = 0;
DELETE FROM alugueis WHERE aluguel_id = 2 AND cliente_id = 2;
SET SQL_SAFE_UPDATES = 1;

CALL inserir_aluguel(2, 2, 1,'2024-03-05', '2024-03-06', 308.00);

-- Modificando procedure para aceitar valor da diária
USE `insight_places`;
DROP PROCEDURE IF EXISTS `inserir_aluguel_diaria`;

DELIMITER $$
CREATE PROCEDURE `inserir_aluguel_diaria` (
	vAluguel VARCHAR(10), 
    vCliente VARCHAR(10), 
    vHospedagem VARCHAR(10),
    vDataInicio DATE,
    vDataFinal DATE,
    vPrecoUnitario DECIMAL(10,2)
)
BEGIN
	DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    SET vDias = DATEDIFF(vDataFinal, vDataInicio);
    SET vPrecoTotal = vDias * vPrecoUnitario;
  INSERT INTO alugueis (aluguel_id, cliente_id, hospedagem_id, data_inicio, data_fim, preco_total) 
	VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$

DELIMITER ;
SELECT * FROM alugueis WHERE aluguel_id = 10003;
CALL inserir_aluguel_diaria(10003, 3, 1,'2024-03-10', '2024-03-15', 100);

-- Tratamento de erros
USE `insight_places`;
DROP PROCEDURE IF EXISTS `inserir_aluguel_diaria`;

DELIMITER $$
CREATE PROCEDURE `inserir_aluguel_diaria` (
	vAluguel VARCHAR(10), 
    vCliente VARCHAR(10), 
    vHospedagem VARCHAR(10),
    vDataInicio DATE,
    vDataFinal DATE,
    vPrecoUnitario DECIMAL(10,2)
)
BEGIN
	DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (255);
    DECLARE EXIT HANDLER FOR 1452
	BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
	END;
    SET vDias = DATEDIFF(vDataFinal, vDataInicio);
    SET vPrecoTotal = vDias * vPrecoUnitario;
  INSERT INTO alugueis (aluguel_id, cliente_id, hospedagem_id, data_inicio, data_fim, preco_total) 
	VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel incluído na base com sucesso.';
	SELECT vMensagem;
END$$

DELIMITER ;

CALL inserir_aluguel_diaria(10004, 5, 1,'2024-03-16', '2024-03-20', 100);

SELECT * FROM alugueis WHERE aluguel_id = 10004;

-- ########################################################
-- $$$$$$$$$$$$$$$$$$$$$$$ ETAPA 03 $$$$$$$$$$$$$$$$$$$$$$$
-- ########################################################

-- Formas de atribuição de valores as variáveis
USE `insight_places`;
DROP PROCEDURE IF EXISTS `inserir_aluguel_diaria_nomeCliente`;

DELIMITER $$
CREATE PROCEDURE `inserir_aluguel_diaria_nomeCliente` (
	vAluguel VARCHAR(10), 
    vClienteNome VARCHAR(150), 
    vHospedagem VARCHAR(10),
    vDataInicio DATE,
    vDataFinal DATE,
    vPrecoUnitario DECIMAL(10,2)
)
BEGIN
	DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (255);
    DECLARE vCliente VARCHAR (10);
    DECLARE EXIT HANDLER FOR 1452
	BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
	END;
    SET vDias = (SELECT DATEDIFF(vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
  INSERT INTO alugueis (aluguel_id, cliente_id, hospedagem_id, data_inicio, data_fim, preco_total) 
	VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel incluído na base com sucesso.';
	SELECT vMensagem;
END$$

DELIMITER ;

CALL inserir_aluguel_diaria_nomeCliente(10006, 'Luana Moura', 1,'2024-03-26', '2024-04-01', 100);

SELECT * FROM alugueis WHERE aluguel_id = 10006;

-- Atualizando Base para testes de IF/ELSE
SELECT * FROM clientes WHERE nome = 'Julia Pires';
SELECT * FROM clientes WHERE cliente_id = 100;
SELECT * FROM  clientes WHERE cliente_id = 8820;
SET SQL_SAFE_UPDATES = 0;
UPDATE clientes SET nome = 'Julia Pires' WHERE  cliente_id = 100 OR cliente_id = 8820;
UPDATE clientes SET contato = 'julia_388@dominio.com' WHERE cliente_id = 100;
UPDATE clientes SET contato = 'julia_919@example.com' WHERE cliente_id = 8820;
SET SQL_SAFE_UPDATES = 1;

-- Tratando o erro e adicionando estrutura de controle if/else

USE `insight_places`;
DROP PROCEDURE IF EXISTS `inserir_aluguel_diaria_nomeCliente`;

DELIMITER $$
CREATE PROCEDURE `inserir_aluguel_diaria_nomeCliente` (
	vAluguel VARCHAR(10), 
    vClienteNome VARCHAR(150), 
    vHospedagem VARCHAR(10),
    vDataInicio DATE,
    vDataFinal DATE,
    vPrecoUnitario DECIMAL(10,2)
)
BEGIN
	DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (255);
    DECLARE vCliente VARCHAR (10);
    DECLARE vNumeroClientes INTEGER DEFAULT 0;
    DECLARE EXIT HANDLER FOR 1452
	BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
	END;
    SET vNumeroClientes = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
		IF vNumeroClientes > 1 THEN
			SET vMensagem = 'Existem outros clientes com o mesmo nome, portanto a inserção do aluguel deste cliente por este método não é possível.';
			SELECT vMensagem;
		ELSE
			SET vDias = (SELECT DATEDIFF(vDataFinal, vDataInicio));
			SET vPrecoTotal = vDias * vPrecoUnitario;
			SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
			INSERT INTO alugueis (
					aluguel_id, 
					cliente_id, 
					hospedagem_id, 
					data_inicio, 
					data_fim, 
					preco_total
                ) 
				VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
			SET vMensagem = 'Aluguel incluído na base com sucesso.';
			SELECT vMensagem;
		END IF;
END$$

DELIMITER ;

CALL inserir_aluguel_diaria_nomeCliente(10007, 'Luana Moura', 1,'2024-04-02', '2024-04-05', 100);
SELECT * FROM alugueis WHERE aluguel_id = 10007;

-- Tratando caso do número de clientes ser 0 com o ELSEIF

USE `insight_places`;
DROP PROCEDURE IF EXISTS `inserir_aluguel_diaria_nomeCliente`;

DELIMITER $$
CREATE PROCEDURE `inserir_aluguel_diaria_nomeCliente` (
	vAluguel VARCHAR(10), 
    vClienteNome VARCHAR(150), 
    vHospedagem VARCHAR(10),
    vDataInicio DATE,
    vDataFinal DATE,
    vPrecoUnitario DECIMAL(10,2)
)
BEGIN
	DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (255);
    DECLARE vCliente VARCHAR (10);
    DECLARE vNumeroClientes INTEGER DEFAULT 0;
    DECLARE EXIT HANDLER FOR 1452
	BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
	END;
    SET vNumeroClientes = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
		IF vNumeroClientes > 1 THEN
			SET vMensagem = 'Existem outros clientes com o mesmo nome, portanto a inserção do aluguel deste cliente por este método não é possível.';
			SELECT vMensagem;
		ELSEIF vNumeroClientes = 0 THEN
			SET vMensagem = 'Cliente inexistente na base, portanto não é possível incluí-lo.';
			SELECT vMensagem;
		ELSE
			SET vDias = (SELECT DATEDIFF(vDataFinal, vDataInicio));
			SET vPrecoTotal = vDias * vPrecoUnitario;
			SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
			INSERT INTO alugueis (
					aluguel_id, 
					cliente_id, 
					hospedagem_id, 
					data_inicio, 
					data_fim, 
					preco_total
                ) 
				VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
			SET vMensagem = 'Aluguel incluído na base com sucesso.';
			SELECT vMensagem;
		END IF;
END$$

DELIMITER ;

CALL inserir_aluguel_diaria_nomeCliente(10008, 'Maria Joaquina', 1,'2024-04-06', '2024-04-10', 100);
SELECT * FROM alugueis WHERE aluguel_id = 10008;

-- Utilizando o Case para fazer a validação anterior
USE `insight_places`;
DROP PROCEDURE IF EXISTS `inserir_aluguel_diaria_nomeCliente`;

DELIMITER $$
CREATE PROCEDURE `inserir_aluguel_diaria_nomeCliente` (
	vAluguel VARCHAR(10), 
    vClienteNome VARCHAR(150), 
    vHospedagem VARCHAR(10),
    vDataInicio DATE,
    vDataFinal DATE,
    vPrecoUnitario DECIMAL(10,2)
)
BEGIN
	DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (255);
    DECLARE vCliente VARCHAR (10);
    DECLARE vNumeroClientes INTEGER DEFAULT 0;
    DECLARE EXIT HANDLER FOR 1452
	BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
	END;
    SET vNumeroClientes = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
		CASE vNumeroClientes
        WHEN 0 THEN
			SET vMensagem = 'Cliente inexistente na base, portanto não é possível incluí-lo.';
			SELECT vMensagem;
		WHEN 1 THEN
			SET vDias = (SELECT DATEDIFF(vDataFinal, vDataInicio));
			SET vPrecoTotal = vDias * vPrecoUnitario;
			SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
			INSERT INTO alugueis (
					aluguel_id, 
					cliente_id, 
					hospedagem_id, 
					data_inicio, 
					data_fim, 
					preco_total
                ) 
				VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
			SET vMensagem = 'Aluguel incluído na base com sucesso.';
			SELECT vMensagem;
		ELSE
				SET vMensagem = 'Existem outros clientes com o mesmo nome, portanto a inserção do aluguel deste cliente por este método não é possível.';
			SELECT vMensagem;
		END CASE;
END$$

DELIMITER ;

CALL inserir_aluguel_diaria_nomeCliente(10008, 'Maria Joaquina', 1,'2024-04-06', '2024-04-10', 100);
SELECT * FROM alugueis WHERE aluguel_id = 10008;

-- Case como uma estrutura condicional
USE `insight_places`;
DROP PROCEDURE IF EXISTS `inserir_aluguel_diaria_nomeCliente`;

DELIMITER $$
CREATE PROCEDURE `inserir_aluguel_diaria_nomeCliente` (
	vAluguel VARCHAR(10), 
    vClienteNome VARCHAR(150), 
    vHospedagem VARCHAR(10),
    vDataInicio DATE,
    vDataFinal DATE,
    vPrecoUnitario DECIMAL(10,2)
)
BEGIN
	DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (255);
    DECLARE vCliente VARCHAR (10);
    DECLARE vNumeroClientes INTEGER DEFAULT 0;
    DECLARE EXIT HANDLER FOR 1452
	BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
	END;
    SET vNumeroClientes = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
		CASE
        WHEN vNumeroClientes = 0 THEN
			SET vMensagem = 'Cliente inexistente na base, portanto não é possível incluí-lo.';
			SELECT vMensagem;
		WHEN vNumeroClientes = 1 THEN
			SET vDias = (SELECT DATEDIFF(vDataFinal, vDataInicio));
			SET vPrecoTotal = vDias * vPrecoUnitario;
			SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
			INSERT INTO alugueis (
					aluguel_id, 
					cliente_id, 
					hospedagem_id, 
					data_inicio, 
					data_fim, 
					preco_total
                ) 
				VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
			SET vMensagem = 'Aluguel incluído na base com sucesso.';
			SELECT vMensagem;
		WHEN vNumeroClientes > 1 THEN
				SET vMensagem = 'Existem outros clientes com o mesmo nome, portanto a inserção do aluguel deste cliente por este método não é possível.';
			SELECT vMensagem;
		END CASE;
END$$

DELIMITER ;

CALL inserir_aluguel_diaria_nomeCliente(10008, 'Maria Joaquina', 1,'2024-04-06', '2024-04-10', 100);
CALL inserir_aluguel_diaria_nomeCliente(10008, 'Julia Pires', 1,'2024-04-06', '2024-04-10', 100);
SELECT * FROM alugueis WHERE aluguel_id = 10008;

-- ########################################################
-- $$$$$$$$$$$$$$$$$$$$$$$ ETAPA 04 $$$$$$$$$$$$$$$$$$$$$$$
-- ########################################################

-- Usando o número de dias

USE `insight_places`;
DROP PROCEDURE IF EXISTS `inserir_aluguel_diaria_nomeCliente`;

DELIMITER $$
CREATE PROCEDURE `inserir_aluguel_diaria_nomeCliente` (
	vAluguel VARCHAR(10), 
    vClienteNome VARCHAR(150), 
    vHospedagem VARCHAR(10),
    vDataInicio DATE,
    vDias INTEGER,
    vPrecoUnitario DECIMAL(10,2)
)
BEGIN
	DECLARE vDataFinal DATE;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (255);
    DECLARE vCliente VARCHAR (10);
    DECLARE vNumeroClientes INTEGER DEFAULT 0;
    DECLARE EXIT HANDLER FOR 1452
	BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
	END;
    SET vNumeroClientes = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
		CASE
        WHEN vNumeroClientes = 0 THEN
			SET vMensagem = 'Cliente inexistente na base, portanto não é possível incluí-lo.';
			SELECT vMensagem;
		WHEN vNumeroClientes = 1 THEN
			SET vDataFinal = (SELECT vDataInicio + INTERVAL vDias DAY);
			SET vPrecoTotal = vDias * vPrecoUnitario;
			SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
			INSERT INTO alugueis (
					aluguel_id, 
					cliente_id, 
					hospedagem_id, 
					data_inicio, 
					data_fim, 
					preco_total
                ) 
				VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
			SET vMensagem = 'Aluguel incluído na base com sucesso.';
			SELECT vMensagem;
		WHEN vNumeroClientes > 1 THEN
				SET vMensagem = 'Existem outros clientes com o mesmo nome, portanto a inserção do aluguel deste cliente por este método não é possível.';
			SELECT vMensagem;
		END CASE;
END$$

DELIMITER ;

CALL inserir_aluguel_diaria_nomeCliente(10008, 'Luana Moura', 1,'2024-04-06', 5, 100);
SELECT * FROM alugueis WHERE aluguel_id = 10008;

-- Utilizando o WHILE LOOP

USE `insight_places`;
DROP PROCEDURE IF EXISTS `inserir_aluguel_diaria_nomeCliente`;

DELIMITER $$
CREATE PROCEDURE `inserir_aluguel_diaria_nomeCliente` (
	vAluguel VARCHAR(10), 
    vClienteNome VARCHAR(150), 
    vHospedagem VARCHAR(10),
    vDataInicio DATE,
    vDias INTEGER,
    vPrecoUnitario DECIMAL(10,2)
)
BEGIN
	DECLARE vDataFinal DATE;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (255);
    DECLARE vCliente VARCHAR (10);
    DECLARE vNumeroClientes INTEGER DEFAULT 0;
    DECLARE vContador INTEGER DEFAULT 1;
    DECLARE vDiaSemana INTEGER;
    DECLARE EXIT HANDLER FOR 1452
	BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
	END;
    SET vNumeroClientes = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
		CASE
        WHEN vNumeroClientes = 0 THEN
			SET vMensagem = 'Cliente inexistente na base, portanto não é possível incluí-lo.';
			SELECT vMensagem;
		WHEN vNumeroClientes = 1 THEN
			SET vDataFinal = vDataInicio;
			WHILE vContador < vDias
			DO
				SET vDiaSemana = (SELECT DAYOFWEEK(STR_TO_DATE(vDataFinal, '%Y-%m-%d')));
                IF (vDiaSemana <> 1 AND vDiaSemana <> 7) THEN
					SET vContador = vContador + 1;
                END IF;
                SET vDataFinal = (SELECT vDataFinal + INTERVAL 1 DAY);
            END WHILE;
			SET vPrecoTotal = vDias * vPrecoUnitario;
			SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
			INSERT INTO alugueis (
					aluguel_id, 
					cliente_id, 
					hospedagem_id, 
					data_inicio, 
					data_fim, 
					preco_total
                ) 
				VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
			SET vMensagem = 'Aluguel incluído na base com sucesso.';
			SELECT vMensagem;
		WHEN vNumeroClientes > 1 THEN
				SET vMensagem = 'Existem outros clientes com o mesmo nome, portanto a inserção do aluguel deste cliente por este método não é possível.';
			SELECT vMensagem;
		END CASE;
END$$

DELIMITER ;

-- R: 2024-04-24
CALL inserir_aluguel_diaria_nomeCliente(10009, 'Luana Moura', 1,'2024-04-18', 5, 100);
SELECT * FROM alugueis WHERE aluguel_id = 10009;


-- SUBPROCEDURE
USE `insight_places`;
DROP procedure IF EXISTS `calcula_data_final`;

DELIMITER $$
USE `insight_places`$$
CREATE PROCEDURE `calcula_data_final` (vDataInicio DATE, INOUT vDataFinal DATE, vDias INTEGER)
BEGIN
	DECLARE vContador INTEGER;
    DECLARE vDiaSemana INTEGER;
	SET vContador = 1;
	SET vDataFinal = vDataInicio;
	WHILE vContador < vDias
	DO
		SET vDiaSemana = (SELECT DAYOFWEEK(STR_TO_DATE(vDataFinal, '%Y-%m-%d')));
		IF (vDiaSemana <> 1 AND vDiaSemana <> 7) THEN
			SET vContador = vContador + 1;
		END IF;
		SET vDataFinal = (SELECT vDataFinal + INTERVAL 1 DAY);
	END WHILE;
END$$

DELIMITER ;

-- Chamando a subprocedure na procedure principal
USE `insight_places`;
DROP PROCEDURE IF EXISTS `inserir_aluguel_diaria_nomeCliente`;

DELIMITER $$
CREATE PROCEDURE `inserir_aluguel_diaria_nomeCliente` (
	vAluguel VARCHAR(10), 
    vClienteNome VARCHAR(150), 
    vHospedagem VARCHAR(10),
    vDataInicio DATE,
    vDias INTEGER,
    vPrecoUnitario DECIMAL(10,2)
)
BEGIN
	DECLARE vDataFinal DATE;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR (255);
    DECLARE vCliente VARCHAR (10);
    DECLARE vNumeroClientes INTEGER DEFAULT 0;
    DECLARE vContador INTEGER DEFAULT 1;
    DECLARE vDiaSemana INTEGER;
    DECLARE EXIT HANDLER FOR 1452
	BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
	END;
    SET vNumeroClientes = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
		CASE
        WHEN vNumeroClientes = 0 THEN
			SET vMensagem = 'Cliente inexistente na base, portanto não é possível incluí-lo.';
			SELECT vMensagem;
		WHEN vNumeroClientes = 1 THEN
			CALL calcula_data_final(vDataInicio, vDataFinal, vDias);
			SET vPrecoTotal = vDias * vPrecoUnitario;
			SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
			INSERT INTO alugueis (
					aluguel_id, 
					cliente_id, 
					hospedagem_id, 
					data_inicio, 
					data_fim, 
					preco_total
                ) 
				VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
			SET vMensagem = 'Aluguel incluído na base com sucesso.';
			SELECT vMensagem;
		WHEN vNumeroClientes > 1 THEN
				SET vMensagem = 'Existem outros clientes com o mesmo nome, portanto a inserção do aluguel deste cliente por este método não é possível.';
			SELECT vMensagem;
		END CASE;
END$$

DELIMITER ;

-- R: 2024-04-24
CALL inserir_aluguel_diaria_nomeCliente(10010, 'Luana Moura', 1,'2024-04-28', 5, 100);
SELECT * FROM alugueis WHERE aluguel_id = 10010;

-- Modificando procedure para autoincrementar o ID
SELECT * FROM alugueis;
SELECT aluguel_id, CAST(aluguel_id AS UNSIGNED) FROM alugueis;
SELECT MAX(aluguel_id), MAX(CAST(aluguel_id AS UNSIGNED)) FROM alugueis;
SELECT * FROM alugueis ORDER BY CAST(aluguel_id AS UNSIGNED);

-- CONVERTENDO A COLUNA PARA INTEIRO ENCONTRANDO O VALOR MÁXIMO E DEPOIS ACRESCENTANDO 1 PARA
-- SE TORNAR O PRÓXIMO ID E DEPOIS RETORNANDO PARA STRING

SELECT CAST(MAX(CAST(aluguel_id AS UNSIGNED)) + 1 AS CHAR) FROM alugueis;


USE `insight_places`;
DROP PROCEDURE IF EXISTS `inserir_aluguel_diaria_nome_cliente_auto_incremento`;

DELIMITER $$
CREATE PROCEDURE `inserir_aluguel_diaria_nome_cliente_auto_incremento` (
    vClienteNome VARCHAR(150), 
    vHospedagem VARCHAR(10),
    vDataInicio DATE,
    vDias INTEGER,
    vPrecoUnitario DECIMAL(10,2)
)
BEGIN
	DECLARE vDataFinal DATE;
    DECLARE vPrecoTotal DECIMAL (10,2);
    DECLARE vMensagem VARCHAR (255);
    DECLARE vCliente VARCHAR (10);
    DECLARE vNumeroClientes INTEGER DEFAULT 0;
    DECLARE vContador INTEGER DEFAULT 1;
    DECLARE vDiaSemana INTEGER;
    DECLARE vAluguel VARCHAR (10);
    DECLARE EXIT HANDLER FOR 1452
	BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
	END;
    SET vNumeroClientes = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
		CASE
        WHEN vNumeroClientes = 0 THEN
			SET vMensagem = 'Cliente inexistente na base, portanto não é possível incluí-lo.';
			SELECT vMensagem;
		WHEN vNumeroClientes = 1 THEN
			CALL calcula_data_final(vDataInicio, vDataFinal, vDias);
			SET vPrecoTotal = vDias * vPrecoUnitario;
			SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
            SET vAluguel = (SELECT CAST(MAX(CAST(aluguel_id AS UNSIGNED)) + 1 AS CHAR) FROM alugueis);
			INSERT INTO alugueis (
					aluguel_id, 
					cliente_id, 
					hospedagem_id, 
					data_inicio, 
					data_fim, 
					preco_total
                ) 
				VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
			SET vMensagem = CONCAT('Aluguel incluído na base com sucesso. ID: ', vAluguel);
			SELECT vMensagem;
		WHEN vNumeroClientes > 1 THEN
				SET vMensagem = 'Existem outros clientes com o mesmo nome, portanto a inserção do aluguel deste cliente por este método não é possível.';
			SELECT vMensagem;
		END CASE;
END$$

DELIMITER ;

-- R: 2024-04-24
CALL inserir_aluguel_diaria_nome_cliente_auto_incremento('Luana Moura', 1,'2024-05-20', 5, 100);
SELECT * FROM alugueis WHERE aluguel_id = 10011;

-- ########################################################
-- $$$$$$$$$$$$$$$$$$$$$$$ ETAPA 05 $$$$$$$$$$$$$$$$$$$$$$$
-- ########################################################

-- Criando procedure 
USE `insight_places`;
DROP procedure IF EXISTS `incluir_usuarios_lista`;

DELIMITER $$
USE `insight_places`$$
CREATE PROCEDURE `incluir_usuarios_lista` (lista VARCHAR (255))
BEGIN
DECLARE nome VARCHAR(255);
    DECLARE restante VARCHAR(255);
    DECLARE pos INTEGER;
    SET restante = lista;
    WHILE INSTR(restante,',') > 0 DO
        SET pos = INSTR(restante,',');
        SET nome = LEFT(restante, pos -1);
        INSERT INTO tempo_nomes VALUES(nome);
        SET restante = SUBSTRING(restante, pos + 1);
    END WHILE;
    IF TRIM(restante) <> '' THEN
        INSERT INTO tempo_nomes VALUES(TRIM(restante));
    END IF;
END$$

DELIMITER ;

-- Criando tabela temporaria e adicionando nomes
DROP TEMPORARY TABLE IF EXISTS tempo_nomes;
CREATE TEMPORARY TABLE tempo_nomes(nome VARCHAR(255));
CALL incluir_usuarios_lista('Luana Moura,Enrico Correia,Paulo Vieira,Marina Nunes');
SELECT * FROM tempo_nomes


-- Aplicando a lógica para adicionar múltiplos clientes com o usodos cursores
USE `insight_places`;
DROP procedure IF EXISTS `inserir_novos_alugueis`;

DELIMITER $$
USE `insight_places`$$
CREATE PROCEDURE `inserir_novos_alugueis` (lista VARCHAR(255), vHospedagem VARCHAR(10), vDataInicio DATE, vDias INTEGER, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vClienteNome VARCHAR(150);
    DECLARE fimCursor INTEGER DEFAULT 0;
    DECLARE vnome VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT nome FROM tempo_nomes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;
    DROP TEMPORARY TABLE IF EXISTS tempo_nomes;
    CREATE TEMPORARY TABLE tempo_nomes (nome VARCHAR(255));
    CALL incluir_usuarios_lista(lista);
    OPEN cursor1;
    FETCH cursor1 INTO vnome;
    WHILE fimCursor = 0 DO
        SET vClienteNome = vnome;
        CALL inserir_aluguel_diaria_nome_cliente_auto_incremento (vClienteNome, vHospedagem, vDataInicio, vDias, vPrecoUnitario);
        FETCH cursor1 INTO vnome;
    END WHILE;
    CLOSE cursor1;
    DROP TEMPORARY TABLE IF EXISTS tempo_nomes;
END$$

DELIMITER ;
SELECT * FROM clientes;
CALL inserir_novos_alugueis('Daniela Carvalho,Benjamin Rocha,Maysa Moraes,Mariana Araújo', '8635', '2023-06-03', 7, 45);

SELECT * FROM alugueis WHERE hospedagem_id = 8635;

