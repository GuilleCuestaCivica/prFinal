WITH movies AS (
    SELECT 
        *
    FROM {{ source('tmdb_movies', 'movies') }}
),

movies_transform AS (
    SELECT
        id,
        title AS titulo,
        original_language,
        TO_DATE(release_date, 'YYYY-MM-DD') AS fecha_estreno,
        popularity AS popularidad,
        vote_average AS media_votos,
        vote_count AS conteo_votos,
        genre_names AS genero,
        director,
        main_actors AS actores_principales,
        budget AS presupuesto,
        revenue AS ingresos,
        runtime AS duracion,
        overview AS descripcion,
        status AS estado,
        production_companies AS compania,
        production_countries AS pais_producion,
        _dlt_load_id,
        _dlt_id
    FROM movies
)

SELECT * FROM movies_transform
