{{ config(
        materialized="incremental",
        unique_key="id_pelicula_director",
        on_schema_change="append_new_columns"
    ) 
}}

WITH directores AS (
    SELECT  
        *
    FROM {{ ref('_stg_peliculas_info_movies') }}

)

SELECT
  id_pelicula,
  titulo,
  director,
  {{ dbt_utils.generate_surrogate_key(['director']) }} AS id_director,
  {{ dbt_utils.generate_surrogate_key(["id_pelicula", "id_director"]) }} AS id_pelicula_director,
  inserted_at
FROM directores

{% if is_incremental() %}

    where INSERTED_AT > (select max(INSERTED_AT) from {{ this }})

{% endif %}
