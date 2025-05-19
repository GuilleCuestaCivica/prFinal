{% snapshot movies_platform_snap %}

{{
    config(
        target_schema='snapshots',
        unique_key='id_pelicula',
        strategy='check',
        check_cols=['titulo', 'popularidad', 'media_votos', 'conteo_votos', 'ingresos']
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
        _dlt_load_id,
        id_snap
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
        ROW_NUMBER() OVER (PARTITION BY id_pelicula ORDER BY inserted_at DESC, id_snap DESC) AS row_num,
        l.inserted_at
    FROM movies m
    INNER JOIN loads l ON m._dlt_load_id = l.load_id
)

SELECT * FROM tabla_join WHERE row_num = 1

{% endsnapshot %}