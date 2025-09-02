{{ config(materialized='view') }}

with base as (
    select
        *,
        nu_idade_referencia as idade_estimada
    from {{ ref('stg_gestor') }}
),

enriched as (
    select
        *,
        case tp_sexo
            when 1 then 'Masculino'
            when 2 then 'Feminino'
            else 'Não informado'
        end as sexo_desc,

        case tp_cor_raca
            when 1 then 'Branca'
            when 2 then 'Preta'
            when 3 then 'Parda'
            when 4 then 'Amarela'
            when 5 then 'Indígena'
            else 'Não informada'
        end as cor_raca_desc,

        case when in_necessidade_especial = 1 then 'Sim' else 'Não' end as possui_deficiencia,
        case when in_licenciatura_1 = 1 or in_licenciatura_2 = 1 then 'Sim' else 'Não' end as possui_licenciatura,
        case when in_mestrado = 1 then 'Sim' else 'Não' end as possui_mestrado,
        case when in_doutorado = 1 then 'Sim' else 'Não' end as possui_doutorado,

        case tp_escolaridade
            when 1 then 'Fundamental Incompleto'
            when 2 then 'Fundamental Completo'
            when 3 then 'Médio Incompleto'
            when 4 then 'Médio Completo'
            when 5 then 'Superior Incompleto'
            when 6 then 'Superior Completo'
            when 7 then 'Especialização'
            when 8 then 'Mestrado'
            when 9 then 'Doutorado'
            else 'Não Informado'
        end as escolaridade_desc,

        case tp_cargo_gestor
            when 1 then 'Diretor'
            when 2 then 'Vice-diretor'
            when 3 then 'Secretário Escolar'
            when 4 then 'Coordenador Pedagógico'
            else 'Outro ou não informado'
        end as cargo_desc,

        case tp_tipo_acesso_cargo
            when 1 then 'Concurso'
            when 2 then 'Seleção pública'
            when 3 then 'Indicação'
            when 4 then 'Eleição'
            when 5 then 'Outro'
            else 'Não informado'
        end as tipo_acesso_desc,

        case tp_tipo_contratacao
            when 1 then 'Efetivo'
            when 2 then 'Contratado'
            when 3 then 'Comissionado'
            else 'Não informado'
        end as tipo_contratacao_desc
    from base
)

select * from enriched
