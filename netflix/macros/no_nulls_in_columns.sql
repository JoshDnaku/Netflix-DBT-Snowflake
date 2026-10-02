-- Custom macro: given a model, generate SQL that returns any row where ANY
-- column is NULL. Loops over the relation's columns at compile time to build
-- the "col IS NULL OR ..." chain. A DRY way to null-check every column at once.
{% macro no_nulls_in_columns(model) %}
    SELECT * FROM {{ model }} WHERE
    {% for col in adapter.get_columns_in_relation(model) %}
        {{ col.column }} IS NULL OR
    {% endfor %}
    FALSE
{% endmacro %}
