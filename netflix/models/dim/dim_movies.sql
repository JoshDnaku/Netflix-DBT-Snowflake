-- Dimension: movies. Cleans the title and turns the pipe-delimited genre
-- string into a real array, while keeping the raw genres string for reference.
WITH src_movies AS (
    SELECT * FROM {{ ref('src_movies') }}
)
SELECT
    movie_id,
    INITCAP(TRIM(title)) AS movie_title,
    SPLIT(genres, '|') AS genre_array,
    genres
FROM src_movies
