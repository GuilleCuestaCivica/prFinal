WITH actores_explotados AS (
  SELECT 
    TRIM(f.value) AS nombre_actores
  FROM {{ ref('_stg_peliculas_info_movies') }},
       LATERAL FLATTEN(INPUT => SPLIT(actores_principales, ',')) f
),

no_actor_row AS (
  SELECT
    {{ dbt_utils.generate_surrogate_key(["''"]) }} AS id_actor,
    '' AS nombre_actores
)

SELECT
  {{ dbt_utils.generate_surrogate_key(["nombre_actores"]) }} AS id_actor,
  nombre_actores
FROM actores_explotados
GROUP BY nombre_actores

UNION ALL

SELECT * FROM no_actor_row
