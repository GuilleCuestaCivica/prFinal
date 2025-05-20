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
    f.media_votos AS media_votos_total,
    f.popularidad AS popularidad_total,
    f.conteo_votos AS conteo_votos_total
  FROM director_relacionado dr
  JOIN {{ ref('fct_movie_calification') }} f 
    ON f.id_pelicula = dr.id_pelicula
   AND f.is_current = true
),

peliculas_con_genero AS (
  SELECT
    pcm.*,
    pg.nombre_genero
  FROM peliculas_con_metricas pcm
  LEFT JOIN pelicula_genero pg ON pg.id_pelicula = pcm.id_pelicula
),

pelicula_top_bottom AS (
  SELECT
    id_director,
    FIRST_VALUE(nombre_genero) OVER (PARTITION BY id_director ORDER BY media_votos_total DESC) AS genero_mejor_valorado,
    FIRST_VALUE(nombre_genero) OVER (PARTITION BY id_director ORDER BY media_votos_total ASC) AS genero_peor_valorado
  FROM peliculas_con_genero
),

agregado_por_director AS (
  SELECT

    d.id_director,  -- Identificador único del director

    d.director,     -- Nombre completo del director

    COUNT(DISTINCT pcm.id_pelicula) AS total_peliculas,  
    -- Número total de películas distintas dirigidas por esta persona
    -- Útil para saber cuán prolífico es el director

    ROUND(AVG(pcm.media_votos_total), 2) AS media_votos_total,  
    -- Promedio de la media de votos de todas sus películas
    -- Indica su rendimiento general en términos de calidad percibida

    ROUND(AVG(pcm.popularidad_total), 2) AS popularidad_total,  
    -- Promedio de popularidad de sus películas
    -- Ayuda a medir qué tan conocidas o vistas han sido sus obras

    SUM(pcm.conteo_votos_total) AS conteo_votos_total,  
    -- Suma total de votos recibidos por todas sus películas
    -- Mide el alcance o visibilidad general del director en la audiencia

    pb.genero_mejor_valorado,  
    -- Género al que pertenece su película mejor calificada (mayor media de votos)
    -- Permite entender en qué tipo de cine tiene mejor desempeño

    pb.genero_peor_valorado  
    -- Género al que pertenece su película peor calificada (menor media de votos)
    -- Identifica su punto débil o el género que menos le favorece

  FROM peliculas_con_metricas pcm
  JOIN {{ ref('dim_director') }} d ON d.id_director = pcm.id_director
  LEFT JOIN pelicula_top_bottom pb ON pb.id_director = pcm.id_director
  GROUP BY d.id_director, d.director, pb.genero_mejor_valorado, pb.genero_peor_valorado
)

SELECT * FROM agregado_por_director
