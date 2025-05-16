WITH populares AS(
    SELECT 
        *
    FROM {{ source('api_mas_visto', 'populares') }}

),

populares_transform AS(
    SELECT
        {{ dbt_utils.generate_surrogate_key(['pais']) }} AS pais_id,
        pais AS pais_desc,
        genero_favorito,
        genero_menos_visto,
        {{ remove_accents('tendencia') }} AS tendencia_cine,
        CAST(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_edad, '0-18:', 2), ';', 1)), '%', '') AS FLOAT) AS "0-18_pct",
        CAST(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_edad, '18-24:', 2), ';', 1)), '%', '') AS FLOAT) AS "18-24_pct",
        CAST(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_edad, '25-34:', 2), ';', 1)), '%', '') AS FLOAT) AS "25-34_pct",
        CAST(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_edad, '35-44:', 2), ';', 1)), '%', '') AS FLOAT) AS "35-44_pct",
        CAST(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_edad, '45+:', 2), ';', 1)), '%', '') AS FLOAT) AS "45+_pct",
        CAST(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_genero, 'Masculino:', 2), ';', 1)), '%', '') AS FLOAT) AS masculino_pct,
        CAST(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_genero, 'Femenino:', 2), ';', 1)), '%', '') AS FLOAT) AS femenino_pct,
        CAST(REPLACE(TRIM(SPLIT_PART(SPLIT_PART(distribucion_por_genero, 'Otro:', 2), ';', 1)), '%', '') AS FLOAT) AS otro_pct
    FROM populares
)

SELECT * FROM populares_transform 