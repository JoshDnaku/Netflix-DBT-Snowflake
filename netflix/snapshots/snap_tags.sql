{% snapshot snap_tags %}

{{
    config(
        target_schema='snapshots',
        unique_key=['user_id','movie_id','tag'],
        strategy='timestamp',
        updated_at='tag_timestamp',
        invalidate_hard_deletes=True
    )
}}

-- SCD Type 2 history of tags. dbt adds dbt_valid_from / dbt_valid_to columns
-- and keeps a new versioned row each time a record's tag_timestamp changes.
-- row_key hashes the business key into one stable column (via dbt_utils).
-- LIMIT 100 keeps the snapshot tiny/cheap for this learning project.
SELECT
    {{ dbt_utils.generate_surrogate_key(['user_id','movie_id','tag']) }} AS row_key,
    user_id,
    movie_id,
    tag,
    CAST(tag_timestamp AS TIMESTAMP_NTZ) AS tag_timestamp
FROM {{ ref('src_tags') }}
LIMIT 100

{% endsnapshot %}
