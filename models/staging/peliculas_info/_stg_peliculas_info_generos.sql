WITH generos_explotados AS (
  SELECT 
    TRIM(f.value) AS nombre_genero
  FROM {{ ref('_stg_peliculas_info_movies') }},
       LATERAL FLATTEN(INPUT => SPLIT(genero, ',')) f
)

SELECT
  {{ dbt_utils.generate_surrogate_key(["nombre_genero"]) }} AS id_genero,
  nombre_genero
FROM generos_explotados
GROUP BY nombre_genero
