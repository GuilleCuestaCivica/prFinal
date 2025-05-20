WITH puente AS(
    SELECT DISTINCT
        id_pelicula,
        id_actor
    FROM {{ ref('_stg_peliculas_info_peliculas_actores') }}
)

SELECT * FROM puente