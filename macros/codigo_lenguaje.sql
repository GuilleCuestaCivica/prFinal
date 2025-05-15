{% macro language_from_code(code) %}
    case {{ code }}
        when 'en' then 'Ingles'
        when 'es' then 'Espanol'
        when 'fr' then 'Frances'
        when 'pt' then 'Portugués'
        when 'ja' then 'Japonés'
        when 'tr' then 'Turco'
        when 'nl' then 'Neerlandés'
        when 'ht' then 'Criollo Haitiano'
        when 'ca' then 'Catalan'
        else 'Desconocido'
    end
{% endmacro %}
