{% macro country_from_codes_sql(column_name) %}
(
    SELECT ARRAY_TO_STRING(ARRAY_AGG(
        CASE TRIM(value)
            WHEN 'US' THEN 'Estados Unidos'
            WHEN 'GB' THEN 'Reino Unido'
            WHEN 'FR' THEN 'Francia'
            WHEN 'ES' THEN 'España'
            WHEN 'BR' THEN 'Brasil'
            WHEN 'PA' THEN 'Panamá'
            WHEN 'HT' THEN 'Haití'
            WHEN 'NL' THEN 'Países Bajos'
            WHEN 'BE' THEN 'Bélgica'
            WHEN 'CZ' THEN 'República Checa'
            WHEN 'DO' THEN 'República Dominicana'
            ELSE TRIM(value)
        END
    ), ', ')
    FROM TABLE(FLATTEN(input => SPLIT({{ column_name }}, ',')))
)
{% endmacro %}
