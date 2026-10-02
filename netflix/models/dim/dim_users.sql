-- Dimension: users. MovieLens has no users table, so we synthesize the user
-- set as the distinct union of everyone who rated OR tagged a movie.
-- UNION (not UNION ALL) dedupes users who did both.
WITH ratings AS (
    SELECT DISTINCT user_id FROM {{ ref('src_ratings') }}
),
tags AS (
    SELECT DISTINCT user_id FROM {{ ref('src_tags') }}
)
SELECT DISTINCT user_id
FROM (
    SELECT user_id FROM ratings
    UNION
    SELECT user_id FROM tags
)
