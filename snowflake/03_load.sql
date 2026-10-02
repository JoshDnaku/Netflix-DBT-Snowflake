-- ============================================================
-- Stage 2b: Upload local CSVs to the internal stage, then load into tables.
-- RUN THIS FROM SnowSQL (not the browser worksheet) -- PUT reads local files.
--
-- Before running, edit the LOAD_DIR path below if your project lives elsewhere.
-- PUT auto-compresses files in transit. AUTO_COMPRESS handled by default.
--
-- COST: PUT is client-side (free). COPY INTO runs the warehouse for a few
-- seconds per file on the truncated data. Near $0.
-- ============================================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE MOVIELENS;
USE SCHEMA RAW;

-- ---- Upload local CSVs into the internal stage ----
-- NOTE: SnowSQL on Windows accepts forward slashes in file:// paths.
-- Adjust the absolute path if your checkout differs.
PUT 'file://C:/Users/joshu/Desktop/DE Projects/Netflix Project/Netflix DBT project/data/load/movies.csv'        @netflix_internal_stage OVERWRITE=TRUE;
PUT 'file://C:/Users/joshu/Desktop/DE Projects/Netflix Project/Netflix DBT project/data/load/ratings.csv'       @netflix_internal_stage OVERWRITE=TRUE;
PUT 'file://C:/Users/joshu/Desktop/DE Projects/Netflix Project/Netflix DBT project/data/load/tags.csv'          @netflix_internal_stage OVERWRITE=TRUE;
PUT 'file://C:/Users/joshu/Desktop/DE Projects/Netflix Project/Netflix DBT project/data/load/genome-scores.csv' @netflix_internal_stage OVERWRITE=TRUE;
PUT 'file://C:/Users/joshu/Desktop/DE Projects/Netflix Project/Netflix DBT project/data/load/genome-tags.csv'   @netflix_internal_stage OVERWRITE=TRUE;
PUT 'file://C:/Users/joshu/Desktop/DE Projects/Netflix Project/Netflix DBT project/data/load/links.csv'         @netflix_internal_stage OVERWRITE=TRUE;

-- Confirm files landed in the stage
LIST @netflix_internal_stage;

-- ---- Load each table from the stage ----
COPY INTO raw_movies
FROM @netflix_internal_stage/movies.csv
FILE_FORMAT = (FORMAT_NAME = ff_csv);

COPY INTO raw_ratings
FROM @netflix_internal_stage/ratings.csv
FILE_FORMAT = (FORMAT_NAME = ff_csv);

COPY INTO raw_tags
FROM @netflix_internal_stage/tags.csv
FILE_FORMAT = (FORMAT_NAME = ff_csv)
ON_ERROR = 'CONTINUE';   -- free-text tags occasionally contain parser-tripping chars

COPY INTO raw_genome_scores
FROM @netflix_internal_stage/genome-scores.csv
FILE_FORMAT = (FORMAT_NAME = ff_csv);

COPY INTO raw_genome_tags
FROM @netflix_internal_stage/genome-tags.csv
FILE_FORMAT = (FORMAT_NAME = ff_csv);

COPY INTO raw_links
FROM @netflix_internal_stage/links.csv
FILE_FORMAT = (FORMAT_NAME = ff_csv);

-- ---- Verify row counts ----
-- Note: ROW_COUNT alias (ROWS is a reserved word in Snowflake).
SELECT 'raw_movies'        AS tbl, COUNT(*) AS row_count FROM raw_movies
UNION ALL SELECT 'raw_ratings',       COUNT(*) FROM raw_ratings
UNION ALL SELECT 'raw_tags',          COUNT(*) FROM raw_tags
UNION ALL SELECT 'raw_genome_scores', COUNT(*) FROM raw_genome_scores
UNION ALL SELECT 'raw_genome_tags',   COUNT(*) FROM raw_genome_tags
UNION ALL SELECT 'raw_links',         COUNT(*) FROM raw_links
ORDER BY tbl;
