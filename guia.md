# Introdução ao DBT

# 🧱 1. Conceitos de uma Stack Moderna para Pipeline de Dados

---

## 🔁 Pipeline de Dados

Um pipeline de dados é uma sequência de processos automatizados que captura, transforma e carrega dados de diversas fontes para um destino, normalmente com o objetivo de análise, visualização ou tomada de decisão.

### Etapas comuns:
- **Ingestão:** captura de dados (de APIs, bancos, arquivos etc.)
- **Transformação:** limpeza, enriquecimento e reestruturação dos dados
- **Armazenamento e consulta:** envio para bancos de dados, data warehouses ou data lakes
- **Consumo:** dashboards, modelos de ML, relatórios

---

## 🔄 ELT vs ETL

### ETL (Extract, Transform, Load):
- **Extração:** obtém dados da fonte
- **Transformação:** limpa e organiza antes de armazenar
- **Carga:** envia os dados prontos ao destino

🧠 **Usado quando:** há necessidade de transformar os dados antes de armazenar.

---

### ELT (Extract, Load, Transform):
- **Extração:** obtém dados da fonte
- **Carga:** carrega os dados brutos no destino
- **Transformação:** transforma os dados **dentro do banco** (ex: via SQL)

🧠 **Usado quando:** o banco de destino é potente e permite transformação rápida (ex: Snowflake, BigQuery, DuckDB)

---

## ⚙️ Ferramentas de Inserção

Essas ferramentas automatizam a **ingestão** de dados, conectando-se a APIs, arquivos ou bancos de dados.

### Exemplos:
- **Airbyte** – código aberto, permite conectar diversas fontes e destinos
- **Fivetran** – solução paga com foco em ELT
- **Singer** – especificação para ingestão de dados via arquivos "tap" e "target"
- **Python personalizado** – scripts para ingestão sob medida

---

## 🔧 Ferramentas de Pipelines de Dados

São usadas para **orquestrar** as etapas do pipeline (agendamento, monitoramento, dependências).

### Exemplos:
- **Prefect** – pipelines com foco em simplicidade e observabilidade
- **Dagster** – design modular, com foco em desenvolvimento e validação
- **Airflow** – robusto e altamente configurável, ideal para ambientes complexos
- **Luigi** – bom para pipelines locais e dependências simples
- **Make / bash / crontab** – soluções caseiras e simples para fluxos pequenos

---

## 🧱 Banco de Dados Colunares

Diferente dos bancos tradicionais (linha a linha), os bancos colunares armazenam os dados **por coluna**, o que permite otimizações para consultas analíticas.

### 🆚 Banco de Dados Colunares vs Relacionais

| Característica      | Relacional (row-based) | Colunar (columnar)       |
|---------------------|------------------------|--------------------------|
| Armazenamento       | Linha por linha        | Coluna por coluna        |
| Otimizado para      | Escrita, OLTP          | Leitura, OLAP            |
| Exemplos            | PostgreSQL, MySQL      | DuckDB, ClickHouse, BigQuery |

---

## 🦆 DuckDB

DuckDB é um banco de dados analítico **colunar**, projetado para rodar **localmente**, dentro do seu processo Python (sem servidor).

### Vantagens:
- Extremamente leve (sem necessidade de servidor)
- Suporte nativo a formatos como Parquet e CSV
- Integração direta com pandas, Arrow e NumPy
- Alta performance em queries analíticas
- Ideal para prototipação e ambientes de desenvolvimento

---

## 🧪 Formas de Uso do DuckDB

- Como banco **embutido** em scripts e notebooks
- Com arquivos locais `.csv`, `.parquet`, `.json`
- Para consultar **DataFrames diretamente** (sem gravar no disco)
- Como camada intermediária de análise antes de enviar para um warehouse

### Exemplos:
```python
import duckdb
import pandas as pd

df = pd.read_csv("dados.csv")
duckdb.query("SELECT * FROM df WHERE valor > 100").to_df()
```




# 🧩 2. Utilizando o DBT (Data Build Tool)

---

## 📌 O que é o DBT?

DBT (Data Build Tool) é uma ferramenta que permite aplicar princípios de engenharia de software à transformação de dados no ambiente de dados analíticos.

🎯 **Propósito:** Transformar dados já carregados em um banco de dados (ex: DuckDB, BigQuery, Redshift) usando **SQL modular, versionado e testado**.

---

## ⚙️ Como funciona o DBT?

1. Você cria **models** em arquivos SQL, organizados por camadas (ex.: `staging/`, `intermediate/`, `marts/`).
2. DBT converte esses arquivos em SQL executável no warehouse, respeitando dependências (via `ref()`).
3. Gera documentação visual, realiza testes de qualidade, cria lineage (linhagem) e suporta versionamento com Git.
4. Não é ferramenta de ingestão ou visualização — foca na transformação (`T` de ELT).

🎯 Você **não move dados com o DBT**, mas transforma **dados já existentes no banco**.

---

## ☁️ Dbt Cloud vs 🖥️ Dbt Core

| Item             | DBT Cloud                        | DBT Core (open source)         |
|------------------|----------------------------------|-------------------------------|
| Interface        | Web, com UI e agendador          | Linha de comando (CLI)        |
| Infraestrutura   | DBT executa na nuvem             | Você executa localmente       |
| Preço            | Gratuito (limitado) / Pago       | Gratuito                      |
| Recursos extras  | Scheduler, logs, alertas, UI     | Totalmente manual             |
| Ideal para       | Equipes e ambientes gerenciados  | Aprendizado e pequenos projetos |

---

## 🧱 Organização das camadas: raw → staging → intermediate → serving

O DBT incentiva uma estrutura em **camadas**, baseada em boas práticas de modelagem de dados analíticos:

### 1. **Raw**
- Dados crus, diretamente da fonte
- Sem transformações

1. **Staging** (`models/staging/`)  
   - Prepara os dados "atomizados" vindos das fontes (raw), usando **sources**.  
   - Renomeia colunas, padroniza tipos e formatos.  
   - Serve de única referência às tabelas de origem, reduzindo acoplamento.  


2. **Intermediate** (`models/intermediate/`)  
   - Agrega lógica de negócio intermediária.  
   - Organiza os dados por grupo de negócio (ex.: `finance/`, `marketing/`).  
   - Geralmente possui verbos na nomenclatura (ex.: `int_payments_pivoted_to_orders.sql`)  


3. **Marts** (ou **Marts**) (`models/marts/`)  
   - Dados finais preparados para análise e relatórios.  
   - Combina dados processados para formar as entidades úteis para o negócio. 

📌 Essa organização modulariza o projeto e facilita a manutenção e entendimento do fluxo de dados.

Além dessas, também podem existir:
- **raw**— Dados integralmente copiados de outras fontes de dados, onde não é aplicada nenhuma alteração.
- **utilities** — modelos utilitários reutilizáveis (ex.: tabela de datas), não contêm dados de negócios propriamente ditos.  

---

## 🔧 O que o DBT faz?

✅ Transforma dados com SQL  
✅ Controla dependências entre modelos  
✅ Roda transformações com versionamento (Git)  
✅ Valida com **testes automatizados**  
✅ Documenta todo o projeto com **interface navegável**  
✅ Gera **lineage (linhagem)** de dados para rastrear o fluxo

---

## 🚫 O que o DBT **não faz**

⛔ Não extrai dados de fontes (não faz ingestão)  
⛔ Não carrega dados para o banco (não é ETL completo)  
⛔ Não cria dashboards ou relatórios  
⛔ Não armazena dados em si  
⛔ Não é ferramenta de Machine Learning

---

## 📚 Documentação com DBT

Com um único comando (`dbt docs generate`), o DBT cria uma documentação HTML com:

- Definição de cada modelo
- Descrição das colunas
- Relações entre tabelas (lineage)
- Testes aplicados
- Seeds, snapshots, macros

📎 É possível acessar via navegador (`dbt docs serve`) ou publicar no DBT Cloud.

---

## ✅ Testes no DBT

DBT possui testes **integrados e customizados**, aplicados diretamente no SQL.

### Testes integrados (genéricos):
```yml
models:
  - name: vendas
    columns:
      - name: id_venda
        tests:
          - unique
          - not_null
```

# 🚀 2.1. DBT Avançado

Neste tópico, exploramos funcionalidades mais avançadas do DBT que tornam os projetos mais dinâmicos, reutilizáveis e auditáveis: **macros**, **snapshots** e **seeds**.

---

## 🧠 2.1.1. Macros

### O que são?
Macros são **funções reutilizáveis** escritas em Jinja (um template engine para Python), usadas para gerar SQL dinamicamente dentro do DBT.

🔁 **Servem para:**
- Reduzir repetição de código SQL
- Criar lógica condicional ou parametrizada
- Padronizar transformações

---

### Exemplo básico de macro

📁 Arquivo: `macros/formatar_datas.sql`

```sql
{% macro formatar_data(coluna) %}
    date_trunc('day', {{ coluna }})
{% endmacro %}
```


```sql
SELECT
    {{ formatar_data("data_pedido") }} AS data_formatada
FROM {{ ref('stg_pedidos') }}
```

## 🧬 2.1.2 Snapshots

### O que são?

Snapshots são usados para capturar mudanças históricas em dados dimensionais, como SCDs (Slowly Changing Dimensions). Eles permitem rastrear como um registro mudou ao longo do tempo.

🔁 **Servem para:**
Você tem uma tabela de clientes e deseja registrar cada vez que o endereço de um cliente mudar, mantendo o histórico.

### Exemplo básico de snapshot
📁 Arquivo: snapshots/clientes_snapshot.sql

```sql
{% snapshot clientes_snapshot %}

{{
  config(
    target_schema='snapshots',
    unique_key='id_cliente',
    strategy='check',
    check_cols=['nome', 'email', 'endereco']
  )
}}

SELECT * FROM {{ source('vendas', 'clientes') }}

{% endsnapshot %}

```

📁 dbt_project.yml (configuração):

```yaml
snapshots:
  my_dbt_project:
    +target_schema: snapshots
    +strategy: check
```

## 🌱 2.1.3  Seeds

### O que são?

Seeds são arquivos CSV usados como tabelas estáticas no projeto DBT. Ideal para dados pequenos e constantes como tabelas de referência, códigos de UF, calendários etc.

🔁 **Como funciona:**
1. Salve um CSV na pasta /seeds/

2. Execute dbt seed

3. O DBT converte o CSV em uma tabela no banco de dados


### Resumo 
```plaintext
macros/
├── utilitarios.sql   # funções Jinja para SQL dinâmico

snapshots/
├── clientes_snapshot.sql   # monitora mudanças históricas

seeds/
├── calendario.csv          # dados estáticos
├── tipo_produto.csv

```


# 🗂️ 3. Estrutura de um Projeto DBT

Um projeto DBT segue uma organização padronizada de arquivos e pastas, permitindo modularidade, versionamento e manutenção clara do pipeline de transformações de dados.

---

## 📁 Estrutura Geral do Projeto

```plaintext
my_dbt_project/
├── dbt_project.yml
├── packages.yml
├── models/
│   ├── staging/
│   │   └── ...
│   ├── intermediate/
│   │   └── ...
│   ├── marts/
│   │   └── ...
│   └── ...
├── macros/
│   └── ...
├── snapshots/
│   └── ...
├── seeds/
│   └── ...
├── analyses/
│   └── ...
├── tests/
│   └── ...
└── target/  
```

🧾 dbt_project.yml

Arquivo principal de configuração do projeto. Define:

Nome do projeto

Caminho para modelos

Configurações de materialização (ex: view, table)

Versionamento

Pacotes externos

name: my_dbt_project
version: '1.0'
profile: default

models:
  my_dbt_project:
    staging:
      materialized: view
    marts:
      materialized: table


🔌 Arquivos de Fonte de Banco de Dados (Entrada e Saída)
📥 Fonte (entrada): sources

Declarados em arquivos .yml dentro da pasta models/, geralmente sob staging/.

version: 2

sources:
  - name: vendas
    database: raw_db
    schema: ecommerce
    tables:
      - name: pedidos
        description: Tabela de pedidos da loja virtual
        columns:
          - name: id_pedido
            description: Identificador único
            tests:
              - not_null
              - unique


Chamado nos modelos SQL via:

SELECT * FROM {{ source('vendas', 'pedidos') }}


📤 Modelos (saída): ref()
São os modelos transformados, referenciados por ref() para manter dependências claras:
SELECT * FROM {{ ref('stg_pedidos') }}


🧱 Arquivos de Modelo SQL

Localizados dentro de models/, organizados por camada (staging/, intermediate/, marts/, etc.)

Exemplo: models/staging/stg_pedidos.sql

WITH raw AS (
  SELECT * FROM {{ source('vendas', 'pedidos') }}
)

SELECT
  id_pedido,
  cliente_id,
  total::float AS valor_total
FROM raw



🐍 Arquivos de Modelo Python (dbt v1.3+)

Suporte para transformação com Python está disponível em bancos compatíveis (ex: Databricks, Snowpark, etc.). Para DuckDB, esse suporte é ainda limitado ou experimental.

Exemplo: models/intermediate/agg_pedidos.py


def model(dbt, session):
    df = dbt.ref("stg_pedidos")
    df_agg = df.groupby("cliente_id").agg({"valor_total": "sum"})
    return df_agg


Observação: ⚠️ Modelos Python exigem engines específicos.

🗒️ Arquivos de Documentação .yml

Localizados junto aos modelos ou fontes, esses arquivos descrevem cada modelo, coluna, teste e relacionamento.

Exemplo: models/staging/stg_pedidos.yml

version: 2

models:
  - name: stg_pedidos
    description: Modelo staging da tabela de pedidos
    columns:
      - name: id_pedido
        description: Chave primária do pedido
        tests:
          - unique
          - not_null
      - name: valor_total
        description: Total da compra


dbt docs generate
dbt docs serve


✅ Checklist por zona de dados
Zona	Conteúdo	Formato	Arquivos
staging/	Modelos que limpam e padronizam fontes	.sql, .yml	SQL + YAML
intermediate/	Modelos intermediários (joins, lógica)	.sql, .py	SQL/Python
marts/	Modelos finais para análise (KPIs, etc.)	.sql	SQL
seeds/	Dados estáticos em CSV	.csv	CSV + .yml
snapshots/	Controle de mudanças em dimensões lentas	.sql, .yml	SQL + YAML
macros/	Funções reutilizáveis (em Jinja/SQL)	.sql	SQL (Jinja)


Estrutura completa:

models/
├── staging/
│   └── stg_tabela.sql / stg_tabela.yml
├── intermediate/
│   └── join_clientes_pedidos.sql
├── marts/
│   └── kpi_vendas_mensal.sql
seeds/
├── calendario.csv
├── calendario.yml
snapshots/
├── clientes_snapshot.sql
tests/
├── test_valor_total_positivo.sql
