SELECT DISTINCT
    id_director,
    director
FROM {{ ref('_stg_peliuclas_info_directores')}}
