WITH loads AS(
    SELECT 
        *
    FROM {{ source('tmdb_movies', '_dlt_loads') }}

)

SELECT 
    load_id,
    inserted_at
FROM loads