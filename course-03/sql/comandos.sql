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
