WITH generos AS(
    SELECT DISTINCT
        *
    FROM {{ ref('_stg_peliculas_info_generos') }}
    
)
SELECT * FROM generos

