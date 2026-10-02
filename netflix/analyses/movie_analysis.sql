-- Analysis: top-rated movies (with enough ratings to be meaningful).
-- Analyses are COMPILED by dbt (ref() resolves to real table names) but NOT
-- materialized -- dbt creates no object. Run the compiled SQL in Snowflake.
WITH ratings_summary AS (
    SELECT
        movie_id,
        AVG(rating) AS average_rating,
        COUNT(*) AS total_ratings
    FROM {{ ref('fct_ratings') }}
    GROUP BY movie_id
    HAVING COUNT(*) > 100   -- only movies with a meaningful number of ratings
)
SELECT
    m.movie_title,
    rs.average_rating,
    rs.total_ratings
FROM ratings_summary rs
JOIN {{ ref('dim_movies') }} m ON m.movie_id = rs.movie_id
ORDER BY rs.average_rating DESC
LIMIT 20;
