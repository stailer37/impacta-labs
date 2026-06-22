{# Por padrão o dbt concatena target.schema + custom schema (ex.: sales_db_marts).
   Aqui cada model já define o catalog (database) certo via +database em
   dbt_project.yml, então o schema customizado deve ser usado como está,
   sem concatenar com o schema default do profile. #}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
