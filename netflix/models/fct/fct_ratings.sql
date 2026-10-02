-- Fact: user ratings (one row per rating event).
-- INCREMENTAL: first run builds the full table; later runs only append ratings
-- newer than the newest rating already loaded (timestamp watermark).
{{
  config(
    materialized = 'incremental',
    on_schema_change = 'fail'
  )
}}

WITH src_ratings AS (
    SELECT * FROM {{ ref('src_ratings') }}
)

SELECT
    user_id,
    movie_id,
    rating,
    rating_timestamp
FROM src_ratings
WHERE rating IS NOT NULL

{% if is_incremental() %}
  -- Only on runs after the first: grab rows newer than what we've already loaded.
  AND rating_timestamp > (SELECT MAX(rating_timestamp) FROM {{ this }})
{% endif %}
