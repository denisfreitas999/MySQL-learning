# Projeto: Formação MySQL - Alura Courses Overview

#### Course 01 - MySQL: Conhecendo a Ferramenta (01 - 05) 
#### Course 02 - MySQL: Executando Procedures (06 - 10) 
#### Course 03 - MySQL: Trabalhando com Funções (11 - 15)
#### Course 04 - MySQL: Aplicado para Análise de Dados (16 - 20)

## Tecnologias Envolvidas
<div style="display: inline_block">
  <img align="center" alt="MySQL" src="https://img.shields.io/badge/MySQL-00000F?style=for-the-badge&logo=mysql&logoColor=white"/>
</div>

## Índice

1. [Projeto Insight Places e Instalação](#01-projeto-insight-places-e-instalação)
2. [Criando Banco de Dados e Tabelas](#02-criando-banco-de-dados-e-tabelas)
3. [Tipos de Dados e Modelo Físico](#03-tipos-de-dados-e-modelo-físico)
4. [Operadores, Consultas e JOIN](#04-operadores-consultas-e-join)
5. [Alterações, Atualizações e Exclusões](#05-alterações-atualizações-e-exclusões)
6. [Configurando a Base e Compreendendo o Projeto](#06-configurando-a-base-e-compreendendo-o-projeto)
7. [Criando Procedures e Tratamento de Erros](#07-criando-procedures-e-tratamento-de-erros)
8. [Utilizando SELECT INTO e Condicionais](#08-utilizando-select-into-e-condicionais)
9. [Cálculos com Data e Subprocedures](#09-cálculos-com-data-e-subprocedures)
10. [Gerenciamento de Múltiplos Clientes e Cursores](#10-gerenciamento-de-múltiplos-clientes-e-cusores)
11. [Criando Banco de Dados e Consultas Básicas](#11-criando-banco-de-dados-e-consultas-básicas)
12. [Funções de Agregação e Manipulação de Dados](#12-funções-de-agregação-e-manipulação-de-dados)
13. [Criação e Execução de Funções](#13-criação-e-execução-de-funções)
14. [Chamando Funções e Criando Triggers](#14-chamando-funções-e-criando-triggers)
15. [Tratamento de Erros e Alterações em Funções](#15-tratamento-de-erros-e-alterações-em-funções)
16. [Carregamento e Exploração de Dados](#16-carregamento-e-exploração-de-dados)
17. [Modificação e Análise de Métricas](#17-modificação-e-análise-de-métricas)
18. [Exploração e Procedimentos Avançados](#18-exploração-e-procedimentos-avançados)
19. [Criação e Consulta de Views](#19-criação-e-consulta-de-views)
20. [Análise e Relatórios de Projeto](#20-análise-e-relatórios-de-projeto)


## 01. Projeto Insight Places e Instalação

Nesta etapa, foco no projeto e instalação inicial:

- **Conhecendo o projeto da Insight Places**: Contexto e objetivo do projeto.
- **Fazendo a instalação do MySQL**: Processo de instalação do MySQL.
- **Conhecendo o MySQL Workbench**: Introdução à ferramenta MySQL Workbench.
- **Acessando o MySQL pela linha de comando**: Conexão e uso básico via terminal.

## 02. Criando Banco de Dados e Tabelas

Nesta etapa, foco na criação de banco de dados e tabelas:

- **Criando um banco de dados utilizando o comando CREATE ou pelo atalho da interface**: Passos para criação de um banco de dados.
- **Criando tabelas utilizando o comando CREATE**: Estruturação de tabelas no MySQL.
- **Inserindo dados nessas tabelas criadas utilizando o comando INSERT**: Adição de dados nas tabelas.
- **Conhecendo os dados das tabelas, suas colunas e seus tipos**: Exploração e entendimento dos dados armazenados.

## 03. Tipos de Dados e Modelo Físico

Nesta etapa, foco nos tipos de dados e no modelo físico:

- **Conhecendo os tipos de dados**: Tipos de dados disponíveis no MySQL.
- **Entendendo quais dados são utilizados nas chaves primárias**: Uso e importância das chaves primárias.
- **Acessando o modelo físico do banco de dados**: Visualização e compreensão do modelo físico das tabelas.

## 04. Operadores, Consultas e JOIN

Nesta etapa, foco em operadores, consultas e JOIN:

- **Utilizando operadores lógicos e de comparação**: Aplicação de operadores para filtragem de dados.
- **Criando consultas aplicando as funções AVG e COUNT**: Uso das funções AVG e COUNT em consultas.
- **Utilizando o comando JOIN**: Combinação de dados de múltiplas tabelas.
- **Aplicando funções específicas para dados do tipo DATE**: Manipulação e consulta de dados de data.

## 05. Alterações, Atualizações e Exclusões

Nesta etapa, foco em alterações, atualizações e exclusões de dados:

- **Fazendo alterações no banco de dados**: Modificação da estrutura do banco de dados.
- **Realizando atualizações no banco de dados**: Atualização de registros existentes.
- **Apagando registros do banco de dados**: Remoção de dados de tabelas do MySQL.

## 06. Configurando a Base e Compreendendo o Projeto

Nesta etapa, foco na configuração inicial e compreensão do projeto:

- **Configurando a base de dados inicial da Insight Places**: Setup da base de dados.
- **Compreendendo o propósito e os desafios enfrentados pela empresa Insight Places**: Análise de objetivos e problemas.
- **Identificando o problema principal da empresa: gerenciar a entrada de novos aluguéis**: Foco no problema-chave.
- **Introduzindo os conceitos fundamentais de uma stored procedure no MySQL**: Conceitos básicos de stored procedures.
- **Desenvolvendo e executando a primeira stored procedure: "listar_clientes"**: Criação e execução da primeira procedure.

## 07. Criando Procedures e Tratamento de Erros

Nesta etapa, foco na criação de procedures e tratamento de erros:

- **Criando uma procedure que exibe dados necessários para a inclusão de hospedagens na tabela de aluguéis**: Exibição de dados essenciais.
- **Substituindo o comando de exibição por um INSERT para efetivar a inclusão dos dados na base**: Alteração de exibição para inserção.
- **Utilizando a função DATEDIFF para calcular automaticamente a data final a partir do número de dias de hospedagem**: Cálculo automático de datas.
- **Alterando o parâmetro de custo total para valor diário, permitindo que o custo total seja calculado dentro da procedure**: Ajuste de custo total para diário.
- **Implementando tratamento de erros para evitar inserções duplicadas que violariam a chave primária**: Prevenção de inserções duplicadas.

## 08. Utilizando SELECT INTO e Condicionais

Nesta etapa, foco na utilização de SELECT INTO e estruturas condicionais:

- **Utilizando o comando SELECT INTO para atribuir valores a variáveis através de SQL**: Atribuição de valores a variáveis.
- **Tratando erros decorrentes de clientes com nomes duplicados**: Gerenciamento de duplicações de clientes.
- **Implementando desvios condicionais com IF-THEN-ELSE para duas opções**: Uso de condicionais simples.
- **Evoluindo o gerenciamento de desvios com IF-THEN-ELSE-IF, adicionando uma terceira condição**: Adição de condições intermediárias.
- **Substituindo o IF-THEN-ELSE-IF por CASE-END CASE para gerenciamento de condições**: Uso de CASE-END CASE.
- **Finalizando com CASE-END CASE, empregando expressões lógicas nos testes, além de comparações diretas com variáveis**: Aplicação avançada de CASE-END CASE.

## 09. Cálculos com Data e Subprocedures

Nesta etapa, foco em cálculos com data e otimização com subprocedures:

- **Avançando no cálculo da data final utilizando a data de início e o número de dias, com a adição via INTERVAL DAY**: Cálculo de datas com INTERVAL DAY.
- **Adaptando a procedure para excluir finais de semana do cálculo de dias de hospedagem, usando um loop WHILE DO - END WHILE**: Exclusão de finais de semana.
- **Segmentando a procedure em subprocedures para otimizar o código, isolando, por exemplo, o cálculo da data final**: Otimização com subprocedures.
- **Melhorando a obtenção do identificador de aluguel, convertendo valores de texto para inteiro, calculando o próximo identificador e revertendo para texto**: Gestão de identificadores.

## 10. Gerenciamento de Múltiplos Clientes e Cursores

Nesta etapa, foco no gerenciamento de múltiplos clientes e uso de cursores:

- **Gerenciando a inclusão de múltiplos clientes em uma hospedagem usando uma tabela temporária, devido à limitação estrutural da base de dados**: Inclusão de múltiplos clientes.
- **Utilizando a estrutura de cursor para iterar sobre os registros da tabela temporária**: Uso de cursores para iteração.
- **Compreendendo o funcionamento do cursor no MySQL**: Funcionamento de cursores.
- **Implementando a inclusão de aluguéis baseando-se nos dados dos clientes armazenados na tabela temporária**: Inclusão baseada em dados de tabela temporária.

## 11. Criando Banco de Dados e Consultas Básicas

Nesta etapa, o foco está na criação e execução básica:

- **Criando um banco de dados e tabelas no MySQL**: Criação inicial de banco e tabelas.
- **Realizando a importação de dados**: Importação de dados para as tabelas.
- **Executando consultas com a função de agregação COUNT**: Uso da função COUNT para agregação de dados.

## 12. Funções de Agregação e Manipulação de Dados

Aqui, exploramos funções de agregação e manipulação:

- **Conhecendo outras funções de agregação**: Exploração de funções como SUM, AVG, MAX, MIN.
- **Utilizando as funções para manipular strings**: Manipulação de strings com funções como CONCAT, LENGTH, UPPER, LOWER.
- **Trabalhando com as funções de datas**: Manipulação de datas com funções como NOW, DATE_FORMAT, DATE_ADD.
- **Formatando dados com as funções numéricas**: Formatação de dados numéricos com ROUND, CEIL, FLOOR.
- **Executando consultas com a função condicional CASE**: Uso da função CASE para condições dentro de consultas.

## 13. Criação e Execução de Funções

Nesta etapa, foco na criação e uso de funções:

- **Entendendo como criar funções**: Introdução à criação de funções no MySQL.
- **Realizando a declaração de variáveis**: Declaração e uso de variáveis dentro de funções.
- **Utilizando parâmetros ao chamar uma função**: Passagem de parâmetros para funções.
- **Executando um retorno composto**: Retorno de múltiplos valores de uma função.

## 14. Chamando Funções e Criando Triggers

Aqui, exploro a integração de funções e triggers:

- **Chamando uma função em outra função**: Uso de funções dentro de outras funções.
- **Criando uma trigger**: Criação de triggers para automação de tarefas.
- **Executando uma função a partir de uma trigger**: Invocação de funções através de triggers.

## 15. Tratamento de Erros e Alterações em Funções

Finalizo com a gestão de erros e alterações:

- **Conhecendo o tratamento de erros em uma função**: Manejo de erros e exceções dentro de funções.
- **Entendendo como uma função é alterada no MySQL**: Modificação de funções existentes.
- **Sabendo sobre os cuidados ao excluir uma função**: Precauções e considerações ao remover funções.

## 16. Carregamento e Exploração de Dados

Nesta etapa, foco no carregamento e na exploração inicial dos dados:

- **Carregando os dados com Script SQL**: Importação de dados utilizando scripts SQL.
- **Carregando os dados com Table Data Import Wizard**: Utilização da ferramenta Table Data Import Wizard para carregamento de dados.
- **Explorando os dados com LIMIT e COUNT**: Uso dos comandos LIMIT e COUNT para explorar e sumarizar dados.
- **Buscando o menor e maior valor com MIN e MAX**: Identificação dos valores mínimos e máximos em conjuntos de dados.
- **Calculando a diferença de datas com DATEDIFF**: Cálculo da diferença entre datas utilizando a função DATEDIFF.
- **Entregando a taxa de ocupação utilizando GROUP BY e ROUND**: Cálculo da taxa de ocupação com agrupamento e arredondamento.

## 17. Modificação e Análise de Métricas

Aqui, exploro a modificação e análise de métricas:

- **Modificando a métrica de taxa de ocupação utilizando JOIN, GROUP BY e subconsulta**: Ajuste da métrica de taxa de ocupação com JOIN e subconsultas.
- **Transformando os dados para focar em meses e anos utilizando as funções YEAR, MONTH e COUNT**: Análise de dados por mês e ano com funções YEAR e MONTH.
- **Criando uma análise com os dados separados por região e estado, utilizando as funções AVG, MAX e MIN**: Análise regional e estadual usando funções AVG, MAX e MIN.

## 18. Exploração e Procedimentos Avançados

Nesta etapa, abordo procedimentos e análise avançada:

- **Explorando os dados por região e por período de tempo, combinando JOIN, WHERE e GROUP BY**: Análise de dados com JOIN, WHERE e GROUP BY para regiões e períodos de tempo.
- **Criando PROCEDURES para explorar os dados de cada proprietário, e também por região e por período de tempo**: Desenvolvimento de PROCEDURES para análise detalhada por proprietário e região.

## 19. Criação e Consulta de Views

Foco na criação e uso de Views:

- **Criando VIEWs para os contextos de proprietários e regiões**: Criação de VIEWs para análise de dados de proprietários e regiões.
- **Realizando consultas em VIEWs para trazer informações específicas**: Execução de consultas em VIEWs para obter dados específicos.

## 20. Análise e Relatórios de Projeto

Finalizo com a análise e relatório do projeto:

- **Analisando as possibilidades de entrega de projeto**: Avaliação das possibilidades para entrega do projeto.
- **Conhecendo como nossas VIEWs podem ser utilizadas**: Entendimento das aplicações das VIEWs criadas.
- **Desenvolvendo um relatório de análise de dados**: Criação de um relatório com base na análise de dados realizada.
