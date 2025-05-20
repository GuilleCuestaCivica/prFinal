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
),

no_director_row AS(
    SELECT
        {{ dbt_utils.generate_surrogate_key(["''"]) }} AS id_director,
        '' AS director
)

SELECT * FROM director

UNION ALL

SELECT * FROM no_director_row
