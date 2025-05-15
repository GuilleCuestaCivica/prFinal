{{ config(
        materialized="incremental",
        unique_key="id",
        on_schema_change="append_new_columns"
    ) 
}}

WITH movies AS(
    SELECT 
        *
    FROM {{ ref("_base_tmdb_movies__movies") }}
),

loads AS(
    SELECT
        *
    FROM {{ ref("_base_tmdb_movies__dlt_loads") }}
),

tablas_juntas AS(
    SELECT
        m.*,
        l.inserted_at
    FROM movies m INNER JOIN loads l ON m._dlt_load_id = l.load_id
)

SELECT * FROM tablas_juntas

{% if is_incremental() %}

  where INSERTED_AT > (select max(INSERTED_AT) from {{ this }})

{% endif %}