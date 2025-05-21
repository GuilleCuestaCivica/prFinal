WITH pelicula_director AS (
  SELECT DISTINCT
    dp.id_pelicula,
    d.id_director,
    d.director
  FROM {{ ref('director_pelicula_puente') }} dp
  JOIN {{ ref('dim_director') }} d ON d.id_director = dp.id_director
),

pelicula_info AS (
  SELECT
    id_pelicula,
    titulo,
    fecha_estreno
  FROM {{ ref('dim_movie') }}
),

snapshots_con_director AS (
  SELECT
    f.id_pelicula,
    f.snapshot_date,
    f.media_votos,
    f.popularidad,
    f.conteo_votos,
    pd.id_director,
    pd.director,
    pi.titulo,
    pi.fecha_estreno,
    dd.year,
    dd.month,
    dd.month_name,
    dd.day_of_week,
    dd.day_name
  FROM {{ ref('fct_movie_calification') }} f
  LEFT JOIN pelicula_director pd ON pd.id_pelicula = f.id_pelicula
  LEFT JOIN pelicula_info pi ON pi.id_pelicula = f.id_pelicula
  LEFT JOIN {{ ref('dim_date') }} dd ON dd.date = f.snapshot_date
  WHERE f.snapshot_date IS NOT NULL
)

SELECT * FROM snapshots_con_director
