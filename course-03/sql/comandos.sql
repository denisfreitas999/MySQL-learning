-- ############################################
-- ################## Etapa 01 ################
-- ############################################

-- Função de agregação COUNT

-- Verificando quantidade de registros das tabelas
SELECT * FROM alugueis;
SELECT * FROM avaliacoes;
SELECT * FROM clientes;
SELECT * FROM enderecos;
SELECT * FROM hospedagens;
SELECT * FROM proprietarios;

-- verificando a quantidade de registros das tabelas utilizando subconsultas
SELECT
  (SELECT COUNT(*) FROM alugueis),
  (SELECT COUNT(*) FROM avaliacoes),
  (SELECT COUNT(*) FROM clientes),
  (SELECT COUNT(*) FROM enderecos),
  (SELECT COUNT(*) FROM hospedagens),
  (SELECT COUNT(*) FROM proprietarios);

-- Colocando alias
SELECT
  (SELECT COUNT(*) FROM alugueis) as alugueis,
  (SELECT COUNT(*) FROM avaliacoes) as avaliacoes,
  (SELECT COUNT(*) FROM clientes) as clientes,
  (SELECT COUNT(*) FROM enderecos) as enderecos,
  (SELECT COUNT(*) FROM hospedagens) as hospedagens,
  (SELECT COUNT(*) FROM proprietarios) as proprietarios;

-- ############################################
-- ################## Etapa 02 ################
-- ############################################

-- Média de aluguéis

SELECT AVG(nota) media_alugueis, tipo
	FROM avaliacoes a
	JOIN hospedagens h
	ON h.hospedagem_id = a.hospedagem_id
	GROUP BY tipo;

--Buscando preço máximo e mínimo ordenando pelo tipo

SELECT tipo, SUM(preco_total) ValorTotal, MAX(preco_total) MaiorValor, MIN(preco_total) MenorValor
	FROM alugueis a
	JOIN hospedagens h
	ON h.hospedagem_id = a.hospedagem_id
	GROUP BY tipo;

SELECT nome, contato FROM clientes;
SELECT CONCAT(nome, contato) FROM clientes;
SELECT CONCAT('O(A) cliente ', nome, ' possui como email: ' , contato) FROM clientes;
SELECT CONCAT('O(A) cliente ', TRIM(nome), ' possui como email: ' , contato) AS Info_Cliente FROM clientes;
SELECT
  TRIM(nome) AS Nome,
  CONCAT(
    SUBSTRING(cpf, 1, 3), '.', 
    SUBSTRING(cpf, 4, 3), '.', 
    SUBSTRING(cpf, 7, 3), '-', 
    SUBSTRING(cpf, 10, 2)
  ) AS CPF_Mascarado
FROM clientes;

SELECT
  TRIM(nome) AS Nome,
  CONCAT(
    SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), ' ', ''), '/', ''), 1, 3), '.', 
    SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), ' ', ''), '/', ''), 4, 3), '.', 
    SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), ' ', ''), '/', ''), 7, 3), '-', 
    SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), ' ', ''), '/', ''), 10, 2)
  ) AS CPF_Mascarado
FROM clientes;


SELECT 
    UPPER(e.cidade) AS Cidade,
    COUNT(a.avaliacao_id) AS TotalAvaliacoes,
    AVG(a.nota) AS MediaNotas
  FROM 
      avaliacoes a
  JOIN 
      hospedagens h ON a.hospedagem_id = h.hospedagem_id
  JOIN 
      enderecos e ON h.endereco_id = e.endereco_id
  GROUP BY 
      e.cidade
  ORDER BY 
      MediaNotas DESC, TotalAvaliacoes DESC;

SELECT * FROM alugueis;

SELECT NOW() DATA_ATUAL;

SELECT data_fim, data_inicio FROM alugueis;

SELECT DATEDIFF(data_fim, data_inicio) AS TotalDias FROM alugueis;

SELECT TRIM(nome) AS Nome, DATEDIFF(data_fim, data_inicio) AS TotalDias
	FROM alugueis a
	JOIN clientes c ON a.cliente_id = c.cliente_id;
    
SELECT tipo, SUM(DATEDIFF(data_fim, data_inicio)) AS TotalDias
	FROM alugueis a
	JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
	GROUP BY tipo
    ORDER BY TotalDias DESC;

-- Funções numéricas
-- Corta o número
SELECT TRUNCATE(AVG(nota), 2) media, tipo
	FROM avaliacoes a 
    JOIN hospedagens h ON h.hospedagem_id = a.hospedagem_id
	GROUP BY tipo;
 
-- Arredonda para cima ou para baixo
SELECT ROUND(AVG(nota), 2) media, tipo
	FROM avaliacoes a
	JOIN hospedagens h ON h.hospedagem_id = a.hospedagem_id
	GROUP BY tipo;
    
-- Retorna o valor absoluto de um número.
SELECT ABS(-123);

-- Arredonda um número para cima, para o menor inteiro maior ou igual ao número.
SELECT CEILING(123.45);

-- Arredonda um número para baixo, para o maior inteiro menor ou igual ao número.
SELECT FLOOR(123.45);

-- Retorna o resto da divisão de um número por outro.
SELECT MOD(10, 3);

-- Retorna o valor de um número elevado a uma potência especificada.
SELECT POW(2, 3);

-- Retorna a raiz quadrada de um número positivo.
SELECT SQRT(16);

-- Gera um número aleatório entre 0 e 1.
SELECT RAND();

-- Retorna o sinal de um número (-1 para negativos, 0 para zero, 1 para positivos).
SELECT SIGN(-123);

-- Funções Condicionais
SELECT hospedagem_id, nota,
CASE nota
        WHEN 5 THEN 'Excelente'
        WHEN 4 THEN 'Ótimo'
        WHEN 3 THEN 'Muito Bom'
        WHEN 2 THEN 'Bom'
        ELSE 'Ruim'
END AS StatusNota
FROM avaliacoes;

-- ############################################
-- ################## Etapa 03 ################
-- ############################################
SELECT ROUND(AVG(NOTA), 2) MediaNotas FROM avaliacoes;

DELIMITER $$
CREATE FUNCTION MediaAvalicoes()
RETURNS FLOAT DETERMINISTIC
BEGIN
DECLARE media FLOAT;

SELECT ROUND (AVG (nota), 2) MediaNotas 
INTO media
FROM avaliacoes;

RETURN media;
END$$

DELIMITER ;

SELECT MediaAvalicoes();


DROP FUNCTION IF EXISTS FormatandoCPF;

DELIMITER $$

CREATE FUNCTION FormatandoCPF (ClienteID INT)
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE NovoCPF VARCHAR(50);

    SELECT CONCAT(
        SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), ' ', ''), '/', ''), 1, 3), '.', 
        SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), ' ', ''), '/', ''), 4, 3), '.', 
        SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), ' ', ''), '/', ''), 7, 3), '-', 
        SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cpf, '.', ''), '-', ''), ' ', ''), '/', ''), 10, 2)
    )
    INTO NovoCPF
    FROM clientes
    WHERE cliente_id = ClienteID;

    RETURN NovoCPF;
END$$

DELIMITER ;

-- Exemplo de chamada da função
SELECT TRIM(nome) AS Nome, FormatandoCPF(1) AS CPF FROM clientes WHERE cliente_id = 1;

DELIMITER $$

CREATE FUNCTION InfoAluguel(IdAluguel INT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
    DECLARE NomeCliente VARCHAR(100);
    DECLARE PrecoTotal DECIMAL(10,2);
    DECLARE Dias INT;
    DECLARE ValorDiaria DECIMAL(10,2);
    DECLARE Resultado VARCHAR(255);

    SELECT c.nome, a.preco_total, DATEDIFF(a.data_fim, a.data_inicio)
    INTO NomeCliente, PrecoTotal, Dias
    FROM alugueis a
    JOIN clientes c ON a.cliente_id = c.cliente_id
    WHERE a.aluguel_id = IdAluguel;

    SET ValorDiaria = PrecoTotal / Dias;

    SET Resultado = CONCAT('Nome: ', NomeCliente, ', Valor Diário: R$ ', FORMAT(ValorDiaria, 2));

    RETURN Resultado;
END$$

DELIMITER ;

-- Exemplo de chamada da função
SELECT InfoAluguel(2);


-- ############################################
-- ################## Etapa 04 ################
-- ############################################

-- Categorizando clientes por desconto

DELIMITER $$
CREATE FUNCTION CalcularDescontoPorDias(AluguelID INT)
RETURNS INT DETERMINISTIC

BEGIN
DECLARE Desconto INT;
SELECT
        CASE
                WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 4 AND 6 THEN 5
                WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 7 AND 9 THEN 10
                WHEN DATEDIFF(data_fim, data_inicio) >= 10 THEN 15
                ELSE 0
        END
        INTO Desconto
FROM alugueis
WHERE aluguel_id = AluguelID;
RETURN Desconto;
END$$

DELIMITER ;

SELECT CalcularDescontoPorDias(4);


DROP FUNCTION IF EXISTS CalcularValorFinalComDesconto;
DELIMITER $$

CREATE FUNCTION CalcularValorFinalComDesconto(AluguelID INT)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE ValorTotal DECIMAL(10,2);
    DECLARE Desconto INT;
    DECLARE ValorFinal DECIMAL(10,2);

    -- Obter o valor total do aluguel
    SELECT preco_total INTO ValorTotal
    FROM alugueis
    WHERE aluguel_id = AluguelID;

    -- Calcular o desconto com base no ID do aluguel
    SET Desconto = CalcularDescontoPorDias(AluguelID);

    -- Calcular o valor final após desconto
    SET ValorFinal = ValorTotal - (ValorTotal * Desconto / 100);

    RETURN ValorFinal;
END$$

DELIMITER ;

-- Exemplo de chamada da função com um argumento
SELECT CalcularValorFinalComDesconto(1);

CREATE TABLE resumo_aluguel (
    aluguel_id VARCHAR(255),
    cliente_id VARCHAR(255),
    valor_total DECIMAL(10,2),
    desconto_aplicado DECIMAL(10,2),
    valor_final DECIMAL(10,2),
     PRIMARY KEY (aluguel_id, cliente_id);
    FOREIGN KEY (aluguel_id) REFERENCES alugueis(aluguel_id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

-- Criando a Trigger
DROP TRIGGER IF EXISTS AtualizarResumoAluguel;

DELIMITER $$

CREATE TRIGGER AtualizarResumoAluguel
AFTER INSERT ON alugueis
FOR EACH ROW
BEGIN
    DECLARE Desconto INT;
    DECLARE ValorFinal DECIMAL(10,2);

    -- Calcular desconto e valor final
    SET Desconto = CalcularDescontoPorDias(NEW.aluguel_id);
    SET ValorFinal = CalcularValorFinalComDesconto(NEW.aluguel_id);

    -- Inserir resumo do aluguel na tabela resumo_aluguel
    INSERT INTO resumo_aluguel (aluguel_id, cliente_id, valor_total, desconto_aplicado, valor_final)
    VALUES (NEW.aluguel_id, NEW.cliente_id, NEW.preco_total, Desconto, ValorFinal);

END$$

DELIMITER ;

SELECT * FROM resumo_aluguel;

INSERT INTO alugueis (aluguel_id, cliente_id, hospedagem_id, data_inicio, data_fim, preco_total)
VALUES (10020, 42, 15, '2024-01-01', '2024-01-08', 3000.00);

SELECT * FROM resumo_aluguel;


-- ############################################
-- ################## Etapa 05 ################
-- ############################################

CREATE DEFINER=`root`@`localhost` FUNCTION `InfoAluguel`(IdAluguel INT) RETURNS varchar(255) CHARSET utf8mb4
DETERMINISTIC
BEGIN

  DECLARE NomeCliente VARCHAR(100);
  DECLARE PrecoTotal DECIMAL(10,2);
  DECLARE Dias INT;
  DECLARE ValorDiaria DECIMAL(10,2);
  DECLARE Resultado VARCHAR(255);

  SELECT c.nome, a.preco_total, DATEDIFF(data_fim, data_inicio)
  INTO NomeCliente, PrecoTotal, Dias
  FROM alugueis a
  JOIN clientes c
  ON a.cliente_id = c.cliente_id
  WHERE a.aluguel_id = IdAluguel;

  SET ValorDiaria = PrecoTotal / Dias;
  SET Resultado = CONCAT('Nome: ', NomeCliente, ', Valor Diário: R$', FORMAT(ValorDiaria,2));
    
  RETURN Resultado;
END

DROP FUNCTION IF EXISTS CalcularValorFinalComDesconto;
