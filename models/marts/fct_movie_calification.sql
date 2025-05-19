WITH hechos AS(
    SELECT 
        *
    FROM {{ ref('movies_platform_snap') }}
)

