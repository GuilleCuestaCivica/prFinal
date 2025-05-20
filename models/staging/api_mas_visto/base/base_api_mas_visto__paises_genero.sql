WITH populares AS (
    SELECT 
        *
    FROM {{ source('api_mas_visto', 'populares') }}
),

populares_transform AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['pais']) }} AS pais_id,
        pais AS pais_desc,
        genero_favorito,
        genero_menos_visto,
        {{ remove_accents('tendencia') }} AS tendencia_cine,

        TRY_CAST(NULLIF(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_edad, '0-18:', 2), ';', 1)), '%', ''), '') AS FLOAT) AS "0-18_pct",
        TRY_CAST(NULLIF(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_edad, '18-24:', 2), ';', 1)), '%', ''), '') AS FLOAT) AS "18-24_pct",
        TRY_CAST(NULLIF(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_edad, '25-34:', 2), ';', 1)), '%', ''), '') AS FLOAT) AS "25-34_pct",
        TRY_CAST(NULLIF(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_edad, '35-44:', 2), ';', 1)), '%', ''), '') AS FLOAT) AS "35-44_pct",
        TRY_CAST(NULLIF(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_edad, '45+:', 2), ';', 1)), '%', ''), '') AS FLOAT) AS "45+_pct",

        TRY_CAST(NULLIF(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_genero, 'Masculino:', 2), ';', 1)), '%', ''), '') AS FLOAT) AS masculino_pct,
        TRY_CAST(NULLIF(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_genero, 'Femenino:', 2), ';', 1)), '%', ''), '') AS FLOAT) AS femenino_pct,
        TRY_CAST(NULLIF(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_genero, 'Otro:', 2), ';', 1)), '%', ''), '') AS FLOAT) AS otro_pct

    FROM populares
),

no_pais_row AS(
    SELECT
        {{ dbt_utils.generate_surrogate_key(["''"]) }} AS pais_id,
        '' AS pais_desc,
        '' AS genero_favorito,
        '' AS genero_menos_visto,
        '' AS tendencia_cine,
        0 AS "0-18_pct",
        0 AS "18-24_pct",
        0 AS "25-34_pct",
        0 AS "35-44_pct",
        0 AS "45+_pct",
        0 AS masculino_pct,
        0 AS femenino_pct,
        0 AS otro_pct
)

SELECT * FROM populares_transform

UNION ALL

SELECT * FROM no_pais_row
