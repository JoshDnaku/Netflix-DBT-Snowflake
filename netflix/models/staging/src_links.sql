-- Staging: links (movie -> imdb/tmdb ids). Thin view over raw_links.
WITH raw_links AS (
    SELECT * FROM {{ source('netflix', 'r_links') }}
)
SELECT
    movieId AS movie_id,
    imdbId AS imdb_id,
    tmdbId AS tmdb_id
FROM raw_links
