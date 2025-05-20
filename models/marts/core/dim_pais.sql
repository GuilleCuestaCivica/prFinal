WITH pais AS(
    SELECT 
        *
    FROM {{ ref('base_api_mas_visto__paises_genero') }}
)

SELECT * FROM pais