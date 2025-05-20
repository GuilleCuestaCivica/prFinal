SELECT 
    *
FROM {{ ref('populares_transform') }}
WHERE 
    pais_desc != ''
    AND (
    COALESCE(masculino_pct, 0) + 
    COALESCE(femenino_pct, 0) + 
    COALESCE(otro_pct, 0) 
    )!= 100
