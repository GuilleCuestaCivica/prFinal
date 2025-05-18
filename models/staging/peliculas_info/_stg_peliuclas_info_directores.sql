WITH movies AS (
    SELECT 
        *
    FROM {{ ref('_stg_peliculas_info_movies') }}
),

director AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(["director"]) }} AS id_director,
        director
    FROM movies
)

SELECT * FROM director
