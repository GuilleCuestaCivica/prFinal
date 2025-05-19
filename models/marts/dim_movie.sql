WITH movies AS(
    SELECT
        id_pelicula,
        titulo,
        original_language,
        fecha_estreno,
        duracion,
        descripcion,
        pais_producion
    FROM {{ ref('_stg_peliculas_info_movies') }}
    
)
SELECT * FROM movies

