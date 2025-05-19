WITH actores_explotados AS (
  SELECT 
    TRIM(f.value) AS nombre_actores
  FROM {{ ref('_stg_peliculas_info_movies') }},
       LATERAL FLATTEN(INPUT => SPLIT(actores_principales, ',')) f
)

SELECT
  {{ dbt_utils.generate_surrogate_key(["nombre_actores"]) }} AS id_actor,
  nombre_actores
FROM actores_explotados
GROUP BY nombre_actores
