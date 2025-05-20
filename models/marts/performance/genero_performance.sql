WITH genero_relacionado AS (
  SELECT DISTINCT
    gp.id_pelicula,
    gp.id_genero
  FROM {{ ref('genero_pelicula_puente') }} gp
),

peliculas_con_metricas AS (
  SELECT
    gr.id_genero,
    f.id_pelicula,
    f.media_votos AS media_votos_total,
    f.popularidad AS popularidad_total,
    f.conteo_votos AS conteo_votos_total
  FROM genero_relacionado gr
  JOIN {{ ref('fct_movie_calification') }} f 
    ON f.id_pelicula = gr.id_pelicula
   AND f.is_current = true
),

agregado_por_genero AS (
  SELECT
    g.id_genero,  
    -- Identificador único del género cinematográfico (clave técnica)

    g.nombre_genero,  
    -- Nombre del género (por ejemplo, Comedia, Drama, Ciencia Ficción)

    COUNT(DISTINCT pcm.id_pelicula) AS total_peliculas,  
    -- Número total de películas asociadas a este género
    -- Indica cuán representado está el género en el catálogo

    ROUND(AVG(pcm.media_votos_total), 2) AS media_votos_total,  
    -- Promedio de las calificaciones medias de las películas de este género
    -- Refleja la calidad general percibida por el público

    ROUND(MIN(pcm.media_votos_total), 2) AS min_media_votos,  
    -- La calificación media más baja entre todas las películas de este género
    -- Muestra el peor caso de recepción crítica dentro del género

    ROUND(MAX(pcm.media_votos_total), 2) AS max_media_votos,  
    -- La calificación media más alta en el género
    -- Muestra el mejor caso dentro de ese tipo de cine

    ROUND(STDDEV(pcm.media_votos_total), 2) AS stddev_media_votos,  
    -- Desviación estándar de la media de votos dentro del género
    -- Mide la variabilidad: si es alta, el género tiene películas muy dispares en calidad

    CASE 
        WHEN STDDEV(pcm.media_votos_total) < 0.8 THEN 'baja'
        WHEN STDDEV(pcm.media_votos_total) BETWEEN 0.8 AND 1.5 THEN 'media'
        ELSE 'alta'
    END AS consistencia_calidad,  
    -- Clasificación de la consistencia del género en calidad:
    -- baja = homogéneo; alta = muy irregular

    ROUND(AVG(pcm.popularidad_total), 2) AS popularidad_total,  
    -- Popularidad promedio de las películas del género
    -- Ayuda a medir qué tan atractivo es el género en general

    SUM(pcm.conteo_votos_total) AS conteo_votos_total  
    -- Total de votos que han recibido todas las películas del género
    -- Indica el nivel de participación o visibilidad del público

  FROM peliculas_con_metricas pcm
  JOIN {{ ref('dim_genero') }} g ON g.id_genero = pcm.id_genero
  GROUP BY g.id_genero, g.nombre_genero
)

SELECT * FROM agregado_por_genero
