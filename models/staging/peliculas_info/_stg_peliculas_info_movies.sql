{{ config(
        materialized="incremental",
        unique_key="id_pelicula",
        on_schema_change="append_new_columns"
    ) 
}}

WITH loads AS(
    SELECT 
        *
    FROM {{ ref('_base_peliculas_info__dlt_loads') }}
),

movies AS(
    SELECT 
        *
    FROM {{ ref('_base_peliculas_info__movies') }}
),

tabla_join AS(
    SELECT
        m.*,
        l.inserted_at
    FROM movies m INNER JOIN loads l ON m._dlt_load_id = l.load_id
)
SELECT * from tabla_join

{% if is_incremental() %}

    where INSERTED_AT > (select max(INSERTED_AT) from {{ this }})

{% endif %}

