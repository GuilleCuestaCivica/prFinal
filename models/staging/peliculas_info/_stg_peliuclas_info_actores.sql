WITH actores_explotados AS (
  SELECT 
    TRIM(f.value) AS nombre_actor
  FROM {{ ref('_stg_peliculas_info_movies') }},
       LATERAL FLATTEN(INPUT => SPLIT(actores_principales, ',')) f
)

SELECT 
  {{ dbt_utils.generate_surrogate_key(["nombre_actor"]) }} AS id_actor,
  nombre_actor
FROM actores_explotados
GROUP BY nombre_actor
