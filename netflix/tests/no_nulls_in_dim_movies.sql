-- Singular test using our custom macro: fails if any column in dim_movies is
-- NULL. A test "passes" when it returns zero rows.
{{ no_nulls_in_columns(ref('dim_movies')) }}
