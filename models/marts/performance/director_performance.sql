WITH director_relacionado AS (
  SELECT DISTINCT
    dp.id_pelicula,
    dp.id_director
  FROM {{ ref('director_pelicula_puente') }} dp
),

pelicula_genero AS (
  SELECT DISTINCT
    gp.id_pelicula,
    g.nombre_genero
  FROM {{ ref('genero_pelicula_puente') }} gp
  JOIN {{ ref('dim_genero') }} g ON g.id_genero = gp.id_genero
),

peliculas_con_metricas AS (
  SELECT
    dr.id_director,
    f.id_pelicula,
    f.media_votos AS media_votos_total
  FROM director_relacionado dr
  JOIN {{ ref('fct_movie_calification') }} f 
    ON f.id_pelicula = dr.id_pelicula
   AND f.is_current = true
),

peliculas_con_genero AS (
  SELECT
    pcm.id_director,
    pcm.id_pelicula,
    pg.nombre_genero,
    pcm.media_votos_total
  FROM peliculas_con_metricas pcm
  LEFT JOIN pelicula_genero pg ON pg.id_pelicula = pcm.id_pelicula
),

agregado_director_genero AS (
  SELECT
    d.id_director,
    d.director,
    pg.nombre_genero,
    ROUND(AVG(pg.media_votos_total), 2) AS media_votos_total,
    COUNT(DISTINCT pg.id_pelicula) AS total_peliculas
  FROM peliculas_con_genero pg
  JOIN {{ ref('dim_director') }} d ON d.id_director = pg.id_director
  GROUP BY d.id_director, d.director, pg.nombre_genero
)

SELECT * FROM agregado_director_genero
