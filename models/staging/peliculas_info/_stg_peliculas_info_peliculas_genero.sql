{{ config(
        materialized="incremental",
        unique_key="id_pelicula_genero",
        on_schema_change="append_new_columns"
    ) 
}}

WITH generos_explotados AS (
  SELECT
    id_pelicula,
    titulo,
    TRIM(f.value) AS nombre_genero,
    inserted_at
  FROM {{ ref('_stg_peliculas_info_movies') }},
       LATERAL FLATTEN(INPUT => SPLIT(genero, ',')) f
  WHERE genero IS NOT NULL
)

SELECT
  id_pelicula,
  titulo,
  nombre_genero,
  {{ dbt_utils.generate_surrogate_key(["nombre_genero"]) }} AS id_genero,
  {{ dbt_utils.generate_surrogate_key(["id_pelicula", "id_genero"]) }} AS id_pelicula_genero,
  inserted_at
FROM generos_explotados

{% if is_incremental() %}

    where INSERTED_AT > (select max(INSERTED_AT) from {{ this }})

{% endif %}
