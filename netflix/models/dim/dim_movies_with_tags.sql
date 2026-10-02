-- EPHEMERAL model: creates NO table/view in the warehouse. When another model
-- ref()s it, dbt inlines this SQL as a CTE. Useful as a reusable, named join
-- of movies + genome tags + relevance scores, without materializing it.
{{ config(materialized = 'ephemeral') }}

WITH movies AS (
    SELECT * FROM {{ ref('dim_movies') }}
),
tags AS (
    SELECT * FROM {{ ref('dim_genome_tags') }}
),
scores AS (
    SELECT * FROM {{ ref('fct_genome_scores') }}
)

SELECT
    m.movie_id,
    m.movie_title,
    m.genres,
    t.tag_name,
    s.relevance_score
FROM movies m
LEFT JOIN scores s ON m.movie_id = s.movie_id
LEFT JOIN tags t ON t.tag_id = s.tag_id
