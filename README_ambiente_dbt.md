# 🚀 Configuração Automática do Ambiente dbt

Este projeto contém um script Python que automatiza completamente a configuração do ambiente dbt com DuckDB.

## 📋 Funcionalidades

O script `01_criacao_ambiente_dbt.py` realiza automaticamente:

- ✅ **Criação de ambiente virtual Python** (`.venv`)
- ✅ **Instalação de dependências** (dbt-duckdb, pandas, duckdb)
- ✅ **Criação do banco DuckDB** (`meu_projeto_dbt/dev.duckdb`)
- ✅ **Inicialização do projeto dbt** (`meu_projeto_dbt`)
- ✅ **Criação da estrutura de diretórios**:
  - `models/raw` - Dados brutos
  - `models/staging` - Dados em estágio
  - `models/intermediate` - Dados intermediários
  - `models/mart` - Dados finais para consumo
- ✅ **Teste de conexão com o banco**
- ✅ **Configuração dos arquivos de conexão dbt**

## 🎯 Como Usar

### Opção 1: Execução Automática (Recomendado)

```bash
# Execute o script diretamente
python 01_criacao_ambiente_dbt.py
```

### Opção 2: Execução Manual (Passo a Passo)

Se preferir executar cada etapa separadamente, você pode abrir o script no Jupyter Notebook ou executar cada função individualmente.

## 🔧 Pré-requisitos

- Python 3.7+ instalado
- Acesso à internet para download de pacotes
- Permissões de escrita no diretório atual

## 📁 Estrutura Criada

Após a execução, você terá:

```
introducao_dbt/
├── .venv/                          # Ambiente virtual Python
├── meu_projeto_dbt/               # Projeto dbt
│   ├── models/
│   │   ├── raw/                   # Dados brutos
│   │   ├── staging/               # Dados em estágio
│   │   ├── intermediate/          # Dados intermediários
│   │   └── mart/                  # Dados finais
│   ├── dbt_project.yml            # Configuração do projeto
│   └── dev.duckdb                 # Banco DuckDB
├── ~/.dbt/profiles.yml            # Perfil de conexão dbt
└── 01_criacao_ambiente_dbt.py     # Script de configuração
```

## 🚀 Próximos Passos

Após a configuração automática:

1. **Ativar o ambiente virtual:**
   ```bash
   # Windows
   .venv\Scripts\activate
   
   # Linux/Mac
   source .venv/bin/activate
   ```

2. **Navegar para o projeto:**
   ```bash
   cd meu_projeto_dbt
   ```

3. **Verificar configuração:**
   ```bash
   dbt debug
   ```

4. **Executar modelos:**
   ```bash
   dbt run
   ```

## 🔍 Verificação da Configuração

O script inclui verificações automáticas para:

- ✅ Criação do ambiente virtual
- ✅ Instalação de pacotes
- ✅ Criação do banco DuckDB
- ✅ Inicialização do projeto dbt
- ✅ Criação de diretórios
- ✅ Teste de conexão com banco
- ✅ Configuração de perfil dbt

## 🐛 Solução de Problemas

### Erro de permissão
- Verifique se você tem permissões de escrita no diretório
- Execute como administrador se necessário

### Erro de conexão com banco
- Verifique se o DuckDB foi instalado corretamente
- Confirme se o caminho do banco está correto

### Erro de inicialização dbt
- Verifique se o dbt-duckdb foi instalado
- Confirme se o ambiente virtual está ativo

## 📚 Recursos Adicionais

- **Documentação dbt:** https://docs.getdbt.com/
- **dbt-duckdb:** https://github.com/jwills/dbt-duckdb
- **DuckDB:** https://duckdb.org/

## 🤝 Contribuição

Para melhorar este script:

1. Faça um fork do projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

---

**🎉 Configuração concluída! Agora você pode começar a usar o dbt com DuckDB!**
