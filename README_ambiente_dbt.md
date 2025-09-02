# 🚀 Configuração Automática do Ambiente dbt + DuckDB

Este repositório contém um script Python para automatizar a criação de um ambiente dbt utilizando DuckDB como backend, facilitando o setup para novos projetos de dados.

## 📋 O que o script  `01_criacao_ambiente_dbt.py` faz ?

O script `01_criacao_ambiente_dbt.py` executa automaticamente:

- Criação de ambiente virtual Python (`.venv`)
- Instalação das dependências principais: `dbt-duckdb`, `pandas`, `duckdb`
- Criação do banco DuckDB (`meu_projeto_dbt/dev.duckdb`)
- Inicialização do projeto dbt (`meu_projeto_dbt`)
- Criação da estrutura de diretórios:
  - `models/raw` (dados brutos)
  - `models/staging` (dados em estágio)
  - `models/intermediate` (dados intermediários)
  - `models/mart` (dados finais)
- Teste de conexão com o banco
- Configuração dos arquivos de conexão do dbt

## 🎯 Como usar

### 2️⃣  O que faz o `02_duckdb_insercao_carga.ipynb`?

O notebook `02_duckdb_insercao_carga.ipynb` é responsável por:

- Mapear automaticamente todos os arquivos de dados em uma pasta de entrada.
- Conectar-se ao banco de dados DuckDB criado anteriormente.
- Criar (ou garantir a existência) do schema `raw` no banco.
- Inserir cada arquivo de dados como uma tabela separada no schema `raw`, detectando automaticamente o formato dos arquivos.
- Registrar logs das operações realizadas, facilitando o acompanhamento do processo.
- Preparar as zonas de dados para as próximas etapas do pipeline.

Este notebook é útil para automatizar a ingestão inicial de dados brutos no ambiente DuckDB, servindo como base para as transformações posteriores via dbt.


