
SELECT 
    *
FROM {{ ref('base_api_mas_visto__paises_genero') }}
WHERE 
    COALESCE("0-18_pct", 0) + 
    COALESCE("18-24_pct", 0) + 
    COALESCE("25-34_pct", 0) + 
    COALESCE("35-44_pct", 0) + 
    COALESCE("45+_pct", 0) != 100

