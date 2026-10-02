-- Staging: ratings. Materialized as a TABLE (largest input, read repeatedly
-- by fct_ratings, dim_users, mart). Casts Unix epoch to a real timestamp.
{{ config(materialized = 'table') }}

WITH raw_ratings AS (
    SELECT * FROM {{ source('netflix', 'r_ratings') }}
)
SELECT
    userId AS user_id,
    movieId AS movie_id,
    rating,
    TO_TIMESTAMP_LTZ(timestamp) AS rating_timestamp
FROM raw_ratings
