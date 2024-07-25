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
