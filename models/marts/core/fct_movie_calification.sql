WITH base AS (
  SELECT
    id_pelicula,
    id_snap,
    CAST(dbt_valid_from AS DATE) AS snapshot_start,
    CAST(dbt_valid_to AS DATE) AS snapshot_end,
    popularidad,
    media_votos,
    conteo_votos,
    ingresos,
    CAST(snapshot_start AS DATE) AS snapshot_date --FK
  FROM {{ ref('movies_platform_snap') }}
)

SELECT
  *,
  snapshot_end IS NULL AS is_current
FROM base
