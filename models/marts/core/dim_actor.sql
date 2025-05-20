WITH actores AS(
    SELECT DISTINCT
        *
    FROM {{ ref('_stg_peliculas_info_actores') }}
    
)
SELECT * FROM actores

