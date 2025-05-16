WITH loads AS(
    SELECT 
        *
    FROM {{ source('peliculas_info', '_dlt_loads') }}

)

SELECT 
    load_id,
    inserted_at
FROM loads