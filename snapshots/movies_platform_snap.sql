{% snapshot movies_platform_snap %}

{{
    config(
        target_schema='snapshots',
        unique_key='id_pelicula',
        strategy='timestamp',
        updated_at='inserted_at'
    )
}}

WITH movies AS (
    SELECT 
        id_pelicula,
        titulo,
        popularidad,
        media_votos,
        conteo_votos,
        ingresos,
        _dlt_load_id
    FROM {{ ref('_base_peliculas_info__movies') }}
),

loads AS (
    SELECT 
        inserted_at,
        load_id
    FROM {{ ref('_base_peliculas_info__dlt_loads') }}
),

tabla_join AS (
    SELECT
        m.*,
        l.inserted_at
    FROM movies m
    INNER JOIN loads l ON m._dlt_load_id = l.load_id
)

SELECT * FROM tabla_join

{% endsnapshot %}