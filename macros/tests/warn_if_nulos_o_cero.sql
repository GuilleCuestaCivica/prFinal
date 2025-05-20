{% test warn_if_nulos_o_cero(model, column_name, column_names=[]) %}
  {% set column_checks = [] %}

  {% for col in column_names %}
    {% do column_checks.append(col ~ ' IS NULL OR ' ~ col ~ ' = 0') %}
  {% endfor %}

  {% set where_clause = column_checks | join(' OR ') %}

  {% set sql %}
    SELECT COUNT(*) AS problematic_count
    FROM {{ model }}
    WHERE {{ where_clause }}
  {% endset %}

  {% if execute %}
    {% set results = run_query(sql) %}
    {% set count = results.columns[0].values()[0] %}

    {% if count > 0 %}
      {{ log("⚠️ Test de calidad: Se encontraron " ~ count ~ " valores nulos o cero en " ~ column_names | join(', '), info=True) }}
    {% endif %}
  {% endif %}

  -- Devolver una query vacía válida para Snowflake
  SELECT 1 AS placeholder WHERE 1 = 0
{% endtest %}
