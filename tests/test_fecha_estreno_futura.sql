SELECT 
    *
FROM {{ ref('_stg_peliculas_info_movies') }}
WHERE fecha_estreno > CURRENT_DATE
