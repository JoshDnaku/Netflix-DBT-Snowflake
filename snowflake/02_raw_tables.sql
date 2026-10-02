-- ============================================================
-- Stage 2a: Create raw tables + an internal stage (direct-load, no S3)
-- Run in Snowflake (worksheet or SnowSQL) as a role that can write to MOVIELENS.RAW.
-- COST: DDL only, no compute.
-- ============================================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE MOVIELENS;
USE SCHEMA RAW;

-- Internal named stage: Snowflake-managed storage inside the account.
-- This is the direct-load replacement for an external S3 stage (no credentials).
CREATE STAGE IF NOT EXISTS netflix_internal_stage;

-- A reusable CSV file format: skip header, allow quoted fields.
CREATE FILE FORMAT IF NOT EXISTS ff_csv
  TYPE = 'CSV'
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"';

CREATE OR REPLACE TABLE raw_movies (
  movieId INTEGER,
  title   STRING,
  genres  STRING
);

CREATE OR REPLACE TABLE raw_ratings (
  userId    INTEGER,
  movieId   INTEGER,
  rating    FLOAT,
  timestamp BIGINT
);

CREATE OR REPLACE TABLE raw_tags (
  userId    INTEGER,
  movieId   INTEGER,
  tag       STRING,
  timestamp BIGINT
);

CREATE OR REPLACE TABLE raw_genome_scores (
  movieId   INTEGER,
  tagId     INTEGER,
  relevance FLOAT
);

CREATE OR REPLACE TABLE raw_genome_tags (
  tagId INTEGER,
  tag   STRING
);

CREATE OR REPLACE TABLE raw_links (
  movieId INTEGER,
  imdbId  INTEGER,
  tmdbId  INTEGER
);
