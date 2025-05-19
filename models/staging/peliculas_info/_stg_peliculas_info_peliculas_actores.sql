WITH actores_explotados AS (
  SELECT
    id_pelicula,
    titulo,
    TRIM(f.value) AS nombre_actor
  FROM {{ ref('_stg_peliculas_info_movies') }},
       LATERAL FLATTEN(INPUT => SPLIT(actores_principales, ',')) f
  WHERE actores_principales IS NOT NULL
)

SELECT
  id_pelicula,
  titulo,
  nombre_actor,
  {{ dbt_utils.generate_surrogate_key(["nombre_actor"]) }} AS id_actor
FROM actores_explotados
