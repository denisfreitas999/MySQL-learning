
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