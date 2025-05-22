{% macro traducir_dia(date_column) %}
  CASE TRIM(TO_CHAR({{ date_column }}, 'DY'))
    WHEN 'Mon' THEN 'Lunes'
    WHEN 'Tue' THEN 'Martes'
    WHEN 'Wed' THEN 'Miercoles'
    WHEN 'Thu' THEN 'Jueves'
    WHEN 'Fri' THEN 'Viernes'
    WHEN 'Sat' THEN 'Sabado'
    WHEN 'Sun' THEN 'Domingo'
    ELSE 'Desconocido'
  END
{% endmacro %}
