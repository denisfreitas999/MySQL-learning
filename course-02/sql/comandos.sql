
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


