{% macro remove_accents(text_column) %}
    translate({{ text_column }}, 'áéíóúÁÉÍÓÚüÜñÑ', 'aeiouAEIOUuUnN')
{% endmacro %}
