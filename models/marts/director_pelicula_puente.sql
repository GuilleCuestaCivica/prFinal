SELECT DISTINCT
    id_pelicula,
    id_director
FROM {{ ref('_stg_peliculas_info_peliculas_directores') }}
