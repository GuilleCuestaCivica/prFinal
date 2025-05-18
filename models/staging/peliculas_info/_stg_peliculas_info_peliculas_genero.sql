WITH generos_explotados AS (
  SELECT
    id_pelicula,
    titulo,
    TRIM(f.value) AS nombre_genero
  FROM {{ ref('_stg_peliculas_info_movies') }},
       LATERAL FLATTEN(INPUT => SPLIT(genero, ',')) f
  WHERE genero IS NOT NULL
)

SELECT
  id_pelicula,
  titulo,
  nombre_genero,
  {{ dbt_utils.generate_surrogate_key(["nombre_genero"]) }} AS id_genero
FROM generos_explotados
