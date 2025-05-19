WITH puente AS(
    SELECT DISTINCT
        id_pelicula,
        id_genero
    FROM _stg_peliculas_info_peliculas_genero
)

SELECT * FROM puente