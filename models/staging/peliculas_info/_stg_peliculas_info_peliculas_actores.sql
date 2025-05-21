{{ config(
        materialized="incremental",
        unique_key="id_pelicula_actor",
        on_schema_change="append_new_columns"
    ) 
}}

WITH actores_explotados AS (
  SELECT
    id_pelicula,
    titulo,
    TRIM(f.value) AS nombre_actor,
    inserted_at
  FROM {{ ref('_stg_peliculas_info_movies') }},
       LATERAL FLATTEN(INPUT => SPLIT(actores_principales, ',')) f
  WHERE actores_principales IS NOT NULL
)

SELECT
  id_pelicula,
  titulo,
  nombre_actor,
  {{ dbt_utils.generate_surrogate_key(["nombre_actor"]) }} AS id_actor,
  {{ dbt_utils.generate_surrogate_key(["id_pelicula", "id_actor"]) }} AS id_pelicula_actor,
  inserted_at
FROM actores_explotados

{% if is_incremental() %}

    where INSERTED_AT > (select max(INSERTED_AT) from {{ this }})

{% endif %}

