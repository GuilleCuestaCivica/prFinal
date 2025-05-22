--comprueba que un los registros de la snapshot vienen bien

SELECT 
    *
FROM {{ ref('fct_movie_calification') }}
WHERE is_current = true
  AND snapshot_end IS NOT NULL
