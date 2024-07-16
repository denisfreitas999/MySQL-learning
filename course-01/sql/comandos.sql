-- ########################################################
-- $$$$$$$$$$$$$$$$$$$$$$$ ETAPA 01 $$$$$$$$$$$$$$$$$$$$$$$
-- ########################################################

-- Acessando MySQL por linha de comando
/*
C:\Users\Usuário>cd C:\Program Files\MySQL\MySQL Server 8.0\bin
Enter password: ********
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.37 MySQL Community Server - GPL

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE DATABASE alura;
Query OK, 1 row affected (0.05 sec)

mysql>
*/

-- ########################################################
-- $$$$$$$$$$$$$$$$$$$$$$$ ETAPA 02 $$$$$$$$$$$$$$$$$$$$$$$
-- ########################################################

USE insight_places;

CREATE TABLE proprietarios (
proprietario_id VARCHAR(255) PRIMARY KEY,
nome VARCHAR(255),
cpf_cnpj VARCHAR(20),
contato VARCHAR(255)
);

CREATE TABLE clientes (
    cliente_id VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    cpf VARCHAR(14),
    contato VARCHAR(255)
);

CREATE TABLE enderecos (
    endereco_id VARCHAR(255) PRIMARY KEY,
    rua VARCHAR(255),
    numero INT,
    bairro VARCHAR(255),
    cidade VARCHAR(255),
    estado VARCHAR(2),
    cep VARCHAR(10)
);

CREATE TABLE hospedagens (
    hospedagem_id VARCHAR(255) PRIMARY KEY,
    tipo VARCHAR(50),
    endereco_id VARCHAR(255),
    proprietario_id VARCHAR(255),
        ativo bool,
    FOREIGN KEY (endereco_id) REFERENCES enderecos(endereco_id),
    FOREIGN KEY (proprietario_id) REFERENCES proprietarios(proprietario_id)
);

CREATE TABLE alugueis (
    aluguel_id VARCHAR(255) PRIMARY KEY,
    cliente_id VARCHAR(255),
    hospedagem_id VARCHAR(255),
    data_inicio DATE,
    data_fim DATE,
    preco_total DECIMAL(10, 2),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (hospedagem_id) REFERENCES hospedagens(hospedagem_id)
);

CREATE TABLE avaliacoes (
    avaliacao_id VARCHAR(255) PRIMARY KEY,
    cliente_id VARCHAR(255),
    hospedagem_id VARCHAR(255),
    nota INT,
    comentario TEXT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (hospedagem_id) REFERENCES hospedagens(hospedagem_id)
);

-- Verificando dados das tabelas
SELECT * FROM insight_places.alugueis;
SELECT * FROM insight_places.avaliacoes;
SELECT * FROM insight_places.clientes;
SELECT * FROM insight_places.enderecos;
SELECT * FROM insight_places.hospedagens;
SELECT * FROM insight_places.proprietarios;

-- ########################################################
-- $$$$$$$$$$$$$$$$$$$$$$$ ETAPA 03 $$$$$$$$$$$$$$$$$$$$$$$
-- ########################################################

-- Conhecendo o modelo físico das tabelas EER

-- ########################################################
-- $$$$$$$$$$$$$$$$$$$$$$$ ETAPA 04 $$$$$$$$$$$$$$$$$$$$$$$
-- ########################################################

-- Buscando avalações com notas maior ou igual que 4
SELECT * FROM avaliacoes WHERE nota >= 4;

-- Busque as hospedagens do tipo hotel que estão ativas
SELECT * FROM hospedagens WHERE tipo LIKE 'hotel' AND ativo = 1;

-- A primeira demanda que a empresa nos trouxe é que gostaria de saber o ticket médio, ou seja, 
-- quanto cada pessoa usuária gasta na plataforma com os aluguéis, com as reservas das hospedagens.
SELECT cliente_id, AVG(preco_total) AS ticket_medio FROM alugueis
	GROUP BY cliente_id;

-- Descobrindo a média de tempo de cada reserva
SELECT cliente_id, AVG(DATEDIFF(data_fim, data_inicio)) AS media_dias_estadia
	FROM alugueis
    GROUP BY cliente_id
    ORDER BY media_dias_estadia DESC;


-- Descobrindo a média de tempo de cada reserva
SELECT 
    media_dias_estadia,
    COUNT(*) AS numero_clientes,
    (COUNT(*) / (SELECT COUNT(DISTINCT cliente_id) FROM alugueis) * 100) AS porcentagem_clientes
FROM (
    SELECT 
        cliente_id, 
        AVG(DATEDIFF(data_fim, data_inicio)) AS media_dias_estadia
    FROM 
        alugueis
    GROUP BY 
        cliente_id
) AS medias
GROUP BY 
    media_dias_estadia
ORDER BY 
    media_dias_estadia DESC;

-- A primeira informação que ela solicitou foi que buscássemos os 10 perfis com mais hospedagens ativas na plataforma. 
SELECT p.nome AS nome_proprietario, COUNT(h.hospedagem_id) AS hospedagens_ativas
	FROM hospedagens h
    JOIN proprietarios p ON (h.proprietario_id = p.proprietario_id)
	WHERE h.ativo = 1
    GROUP BY nome_proprietario
    ORDER BY hospedagens_ativas DESC
    LIMIT 10;

-- A primeira informação que ela solicitou foi que buscássemos os 10 perfis com mais hospedagens inativas na plataforma. 
SELECT p.nome AS nome_proprietario, COUNT(h.hospedagem_id) AS hospedagens_inativas
	FROM hospedagens h
    JOIN proprietarios p ON (h.proprietario_id = p.proprietario_id)
	WHERE h.ativo = 0
    GROUP BY nome_proprietario
    ORDER BY hospedagens_inativas DESC
    LIMIT 10;

-- meses com maior e menor demanda de aluguéis
SELECT YEAR(data_inicio) AS ano, MONTH(data_inicio) AS mes, COUNT(*) AS total_alugueis
	FROM alugueis
    GROUP BY ano, mes
    ORDER BY total_alugueis DESC;

-- ########################################################
-- $$$$$$$$$$$$$$$$$$$$$$$ ETAPA 05 $$$$$$$$$$$$$$$$$$$$$$$
-- ########################################################
-- Adicionando coluna a uma tabela
ALTER TABLE proprietarios ADD COLUMN qtd_hospedagens INT;

-- Renomeando uma tabela
ALTER TABLE alugueis RENAME TO reservas;

-- Renomeando uma coluna
ALTER TABLE reservas RENAME COLUMN aluguel_id TO reserva_id;

-- Atualizando dados
UPDATE hospedagens SET ativo = 1 WHERE hospedagem_id IN ('1', '10', '100');
SELECT * FROM hospedagens WHERE hospedagem_id IN ('1', '10', '100');

UPDATE proprietarios SET contato = 'daniela_glubglub@example.com' WHERE proprietario_id = '1009';
SELECT * FROM proprietarios WHERE proprietario_id = '1009';

-- Deletando dados
DELETE FROM avaliacoes
	WHERE hospedagem_id IN ('10000', '1001');

DELETE FROM reservas
	WHERE hospedagem_id IN ('10000', '1001');
    
DELETE FROM hospedagens
	WHERE hospedagem_id IN ('10000', '1001');