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

-- ########################################################
-- $$$$$$$$$$$$$$$$$$$$$$$ ETAPA 02 $$$$$$$$$$$$$$$$$$$$$$$
-- ########################################################
use insight_places;

-- AGRUPE O TOTAL DE HOSPEDAGEM POR PROPRIETARIO DO MAIOR PARA O MENOR
SELECT p.nome, COUNT(DISTINCT h.hospedagem_id) AS total_hospedagens
	FROM proprietarios p
	JOIN hospedagens h ON(p.proprietario_id = h.proprietario_id)
    GROUP BY p.proprietario_id
    ORDER BY total_hospedagens DESC;

use insight_places;

-- taxa de ocupação por proprietário
SELECT
    p.nome AS Proprietario,
    MIN(primeira_data) AS primeira_data,
    SUM(total_dias) AS total_dias,
    SUM(dias_ocupados) AS dias_ocupados,
    ROUND((SUM(dias_ocupados) / SUM(total_dias)) * 100) AS taxa_ocupacao
FROM(
    SELECT 
        hospedagem_id,
        MIN(data_inicio) AS primeira_data,
        SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
        DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias
    FROM 
        alugueis
    GROUP BY 
        hospedagem_id
    ) tabela_taxa_ocupacao
JOIN
    hospedagens h ON tabela_taxa_ocupacao.hospedagem_id = h.hospedagem_id
JOIN
    proprietarios p ON h.proprietario_id = p.proprietario_id
GROUP BY
    p.proprietario_id
ORDER BY
    total_dias DESC;

-- TOTAL DE ALUGUEIS ANO/MÊS

SELECT
    YEAR(data_inicio) AS ano,
    MONTH(data_inicio) AS mes,
    COUNT(*) AS total_alugueis
FROM
    alugueis
GROUP BY
    ano, mes
ORDER BY
    ano, mes;
    
-- TOTAL DE ALUGUEIS POR MÊS

SELECT
    MONTH(data_inicio) AS mes,
    COUNT(*) AS total_alugueis
FROM
    alugueis
GROUP BY
    mes
ORDER BY
    total_alugueis DESC;


-- Média de aluguéis por estado

SELECT
    e.estado,
    ROUND(AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)), 2) AS media_preco_aluguel,
    ROUND(MAX(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)), 2) AS max_preco_dia,
    ROUND(MIN(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)), 2) AS min_preco_dia,
    ROUND(AVG(DATEDIFF(a.data_fim, a.data_inicio))) AS media_dias_aluguel
FROM
    alugueis a
JOIN
    hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN
    enderecos e ON h.endereco_id = e.endereco_id
GROUP BY
    e.estado;

-- Média de aluguel por região
SELECT
    r.regiao,
	ROUND(AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)), 2) AS media_preco_aluguel,
    ROUND(MAX(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)), 2) AS max_preco_dia,
    ROUND(MIN(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)), 2) AS min_preco_dia,
    ROUND(AVG(DATEDIFF(a.data_fim, a.data_inicio))) AS media_dias_aluguel
FROM
    alugueis a
JOIN
    hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN
    enderecos e ON h.endereco_id = e.endereco_id
JOIN 
    regioes_geograficas r ON r.estado = e.estado
GROUP BY
    r.regiao; 

-- ########################################################
-- $$$$$$$$$$$$$$$$$$$$$$$ ETAPA 03 $$$$$$$$$$$$$$$$$$$$$$$
-- ########################################################

-- Criando uma procedure para capturar dados por região
DELIMITER //
DROP PROCEDURE IF EXISTS get_dados_por_regiao;

CREATE PROCEDURE get_dados_por_regiao(regiao_nome VARCHAR(255))
BEGIN
    SELECT
        YEAR(data_inicio) AS ano,
        MONTH(data_inicio) AS mes,
        COUNT(*) AS total_alugueis
    FROM
        alugueis a
    JOIN
        hospedagens h ON a.hospedagem_id = h.hospedagem_id   
    JOIN
        enderecos e ON h.endereco_id = e.endereco_id
    JOIN
        regioes_geograficas r ON e.estado = r.estado
    WHERE
        r.regiao = regiao_nome
    GROUP BY
        ano, mes
    ORDER BY
        ano, mes;
END//
DELIMITER ;

-- Testando procedure
CALL get_dados_por_regiao("Nordeste");

-- Procedure para calcular a taxa de ocupação por ID do cliente

USE insight_places;

DROP PROCEDURE IF EXISTS calcular_taxa_ocupacao;

DELIMITER //

CREATE PROCEDURE calcular_taxa_ocupacao(ID VARCHAR(255))
BEGIN
    SELECT
        p.nome AS Proprietario,
        MIN(primeira_data) AS primeira_data,
        SUM(total_dias) AS total_dias,
        SUM(dias_ocupados) AS dias_ocupados,
        ROUND((SUM(dias_ocupados) / SUM(total_dias)) * 100) AS taxa_ocupacao
    FROM(
        SELECT
            hospedagem_id,
            MIN(data_inicio) AS primeira_data,
            SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
            DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias
        FROM
            alugueis
        GROUP BY
            hospedagem_id
        ) tabela_taxa_ocupacao
    JOIN
        hospedagens h ON a.hospedagem_id = h.hospedagem_id
    JOIN
        enderecos e ON h.endereco_id = e.endereco_id
    JOIN
        regioes_geograficas r ON e.estado = r.estado
    WHERE
        r.regiao = "Sudeste"
    GROUP BY
        ano, mes
    ORDER BY
        ano, mes;
END//
DELIMITER ;

-- ########################################################
-- $$$$$$$$$$$$$$$$$$$$$$$ ETAPA 04 $$$$$$$$$$$$$$$$$$$$$$$
-- ########################################################

-- Criando view de dados por região
CREATE VIEW view_dados_regiao AS
SELECT
    r.regiao,
    AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS media_preco_aluguel,
    MAX(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS max_preco_dia,
    MIN(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS min_preco_dia,
    AVG(DATEDIFF(a.data_fim, a.data_inicio)) AS media_dias_aluguel
FROM
    alugueis a
JOIN
    hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN
    enderecos e ON h.endereco_id = e.endereco_id
JOIN
    regioes_geograficas r ON r.estado = e.estado
GROUP BY
    r.regiao;

-- Verificando dados da view_dados_regiao
SELECT * FROM view_dados_regiao;

-- Criando view de dados por região/tempo
CREATE VIEW vw_ocupacao_por_regiao_tempo AS
SELECT
    r.regiao,
    YEAR(data_inicio) AS ano,
    MONTH(data_inicio) AS mes,
    COUNT(*) AS total_alugueis
FROM
    alugueis a
JOIN
    hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN
    enderecos e ON h.endereco_id = e.endereco_id
JOIN
    regioes_geograficas r ON r.estado = e.estado
GROUP BY
    r.regiao, YEAR(data_inicio), MONTH(data_inicio)
ORDER BY
    r.regiao, ano, mes;
    
-- Verificando dados da vw_ocupacao_por_regiao_tempo
SELECT * FROM vw_ocupacao_por_regiao_tempo;