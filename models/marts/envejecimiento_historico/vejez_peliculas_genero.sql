WITH pelicula_genero AS (
  SELECT DISTINCT
    gp.id_pelicula,
    g.id_genero,
    g.nombre_genero
  FROM {{ ref('genero_pelicula_puente') }} gp
  JOIN {{ ref('dim_genero') }} g ON g.id_genero = gp.id_genero
),

pelicula_info AS (
  SELECT
    id_pelicula,
    titulo,
    fecha_estreno
  FROM {{ ref('dim_movie') }}
),

snapshots_con_genero AS (
  SELECT
    f.id_pelicula,
    f.snapshot_date,
    f.media_votos,
    f.popularidad,
    f.conteo_votos,
    pg.id_genero,
    pg.nombre_genero,
    pi.titulo,
    pi.fecha_estreno,
    dd.year,
    dd.month,
    dd.month_name,
    dd.day_of_week,
    dd.day_name
  FROM {{ ref('fct_movie_calification') }} f
  LEFT JOIN pelicula_genero pg ON pg.id_pelicula = f.id_pelicula
  LEFT JOIN pelicula_info pi ON pi.id_pelicula = f.id_pelicula
  LEFT JOIN {{ ref('dim_date') }} dd ON dd.date = f.snapshot_date
  WHERE f.snapshot_date IS NOT NULL
)

SELECT * FROM snapshots_con_genero
