-- Staging: tags. Materialized as a TABLE (feeds dim_users and the snapshot).
-- Casts Unix epoch to a real timestamp (used as the snapshot's updated_at).
{{ config(materialized = 'table') }}

WITH raw_tags AS (
    SELECT * FROM {{ source('netflix', 'r_tags') }}
)
SELECT
    userId AS user_id,
    movieId AS movie_id,
    tag,
    TO_TIMESTAMP_LTZ(timestamp) AS tag_timestamp
FROM raw_tags
