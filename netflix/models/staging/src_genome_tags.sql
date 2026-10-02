-- Staging: genome tags. Thin view over raw_genome_tags.
WITH raw_genome_tags AS (
    SELECT * FROM {{ source('netflix', 'r_genome_tags') }}
)
SELECT
    tagId AS tag_id,
    tag
FROM raw_genome_tags
