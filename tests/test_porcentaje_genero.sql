
SELECT 
    *
FROM {{ ref('populares_transform') }}
WHERE 
    COALESCE(masculino_pct, 0) + 
    COALESCE(femenino_pct, 0) + 
    COALESCE(otro_pct, 0) != 100
