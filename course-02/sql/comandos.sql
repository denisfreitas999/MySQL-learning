-- ########################################################
-- $$$$$$$$$$$$$$$$$$$$$$$ ETAPA 01 $$$$$$$$$$$$$$$$$$$$$$$
-- ########################################################

USE insight_places;
-- Verificando dados das tabelas
SELECT * FROM  avaliacoes;
SELECT * FROM clientes;
SELECT * FROM enderecos;
SELECT * FROM hospedagens;
SELECT * FROM proprietarios;
SELECT * FROM alugueis;

-- Subconsulta: contando a quantidade de itens de cada tabela
SELECT
  (SELECT COUNT(*) FROM proprietarios) AS total_proprietarios,
  (SELECT COUNT(*) FROM clientes) AS total_clientes,
  (SELECT COUNT(*) FROM enderecos) AS total_enderecos,
  (SELECT COUNT(*) FROM hospedagens) AS total_hospedagens,
  (SELECT COUNT(*) FROM alugueis) AS total_alugueis,
  (SELECT COUNT(*) FROM avaliacoes) AS total_avaliacoes;


-- Uma das métricas que pensamos em explorar, baseada na exploração que fizemos nos dados, é entender a 
-- taxa de ocupação. Isso significa, desde que um imóvel ficou disponível, quantos desses dias ele ficou 
-- alugado e quantos ficou vago.

SELECT
    hospedagem_id,
    MIN(data_inicio) AS primeira_data,
    SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
    DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias,
    ROUND((SUM(DATEDIFF(data_fim, data_inicio)) / DATEDIFF(MAX(data_fim), MIN(data_inicio))) * 100) AS taxa_ocupacao
FROM
    alugueis
GROUP BY
    hospedagem_id
ORDER BY taxa_ocupacao DESC;

--

SELECT
    hospedagem_id,
    MIN(data_inicio) AS primeira_data,
    SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
    DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias,
    ROUND((SUM(DATEDIFF(data_fim, data_inicio)) / DATEDIFF(MAX(data_fim), MIN(data_inicio))) * 100) AS taxa_ocupacao
FROM
    alugueis
GROUP BY
    hospedagem_id
ORDER BY taxa_ocupacao ASC;

-- Busque
-- primeira_data da hospedagem
-- ultima_data da hospedagem
-- dias_ocupados
-- total_de_dias
-- taxa_de_ocupacao
SELECT * FROM alugueis;

SELECT 
	hospedagem_id,
	MIN(data_inicio) AS primeira_data,
    MAX(data_fim) AS ultima_data,
    SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
	DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_de_dias,
    ROUND(
		(SUM(DATEDIFF(data_fim, data_inicio)) / DATEDIFF(MAX(data_fim), MIN(data_inicio)) * 100), 2
    ) AS taxa_ocupacao
	FROM alugueis
    GROUP BY hospedagem_id
    ORDER BY taxa_ocupacao DESC;

    