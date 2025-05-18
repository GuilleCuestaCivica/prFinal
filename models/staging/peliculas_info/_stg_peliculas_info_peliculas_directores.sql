WITH directores AS (
    SELECT  
        *
    FROM {{ ref('_stg_peliculas_info_movies') }}

)

SELECT
  id_pelicula,
  titulo,
  director,
  {{ dbt_utils.generate_surrogate_key(['director']) }} AS id_director
FROM directores
