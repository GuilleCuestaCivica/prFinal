WITH movies AS (
    SELECT 
        *
    FROM {{ source('peliculas_info', 'movies') }}
),

movies_transform AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(["id"]) }} AS id_pelicula,
        {{ dbt_utils.generate_surrogate_key(["id_pelicula", "_dlt_load_id"]) }} AS id_snap,
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
        production_companies AS compania,
        SPLIT_PART(production_countries, ',', 1) AS pais_producion,
        _dlt_load_id,
        _dlt_id
    FROM movies
)

SELECT * FROM movies_transform
