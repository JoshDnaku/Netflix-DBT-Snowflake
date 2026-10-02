-- ============================================================
-- Stage 1: Snowflake account setup for the Netflix/MovieLens dbt project
-- Run this in a Snowflake worksheet while logged in as ACCOUNTADMIN.
--
-- SAFETY: replace <YOUR_STRONG_PASSWORD> below with a real strong password
-- BEFORE running. Do NOT commit the real password. This file is committed
-- with the placeholder only.
--
-- COST: these are metadata/DDL operations. They do not run compute and do
-- not meaningfully consume credits. The warehouse only bills when it runs
-- a query; AUTO_SUSPEND=60 + X-SMALL keeps that near $0.
-- ============================================================

-- Step 1: Use an admin role
USE ROLE ACCOUNTADMIN;

-- Step 2: Create the `transform` role (least-privilege role dbt will use)
CREATE ROLE IF NOT EXISTS TRANSFORM;
GRANT ROLE TRANSFORM TO ROLE ACCOUNTADMIN;

-- Step 3: Create the compute warehouse -- SMALLEST size + auto-suspend for cost control
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60          -- suspend after 60s idle so it never idle-bills
  AUTO_RESUME = TRUE         -- wake automatically on next query
  INITIALLY_SUSPENDED = TRUE;
GRANT OPERATE ON WAREHOUSE COMPUTE_WH TO ROLE TRANSFORM;

-- Step 4: Create the `dbt` service user and assign the transform role
CREATE USER IF NOT EXISTS dbt
  PASSWORD='<YOUR_STRONG_PASSWORD>'   -- <<< REPLACE THIS. Never commit the real value.
  LOGIN_NAME='dbt'
  MUST_CHANGE_PASSWORD=FALSE
  DEFAULT_WAREHOUSE='COMPUTE_WH'
  DEFAULT_ROLE=TRANSFORM
  DEFAULT_NAMESPACE='MOVIELENS.RAW'
  COMMENT='DBT user used for data transformation';
-- NOTE: do NOT set TYPE = LEGACY_SERVICE / SERVICE here. On current Snowflake
-- accounts those user types are blocked from password login, which breaks both
-- SnowSQL and dbt (they authenticate with a password). Leave TYPE = PERSON
-- (the default) so password auth works. If the user was previously set to a
-- service type, fix it with:  ALTER USER dbt SET TYPE = PERSON;
GRANT ROLE TRANSFORM TO USER dbt;

-- Step 5: Create the database and raw schema for the MovieLens project
CREATE DATABASE IF NOT EXISTS MOVIELENS;
CREATE SCHEMA IF NOT EXISTS MOVIELENS.RAW;

-- Step 6: Grant permissions to the transform role
GRANT ALL ON WAREHOUSE COMPUTE_WH TO ROLE TRANSFORM;
GRANT ALL ON DATABASE MOVIELENS TO ROLE TRANSFORM;
GRANT ALL ON ALL SCHEMAS IN DATABASE MOVIELENS TO ROLE TRANSFORM;
GRANT ALL ON FUTURE SCHEMAS IN DATABASE MOVIELENS TO ROLE TRANSFORM;
GRANT ALL ON ALL TABLES IN SCHEMA MOVIELENS.RAW TO ROLE TRANSFORM;
GRANT ALL ON FUTURE TABLES IN SCHEMA MOVIELENS.RAW TO ROLE TRANSFORM;

-- Set defaults for the current session
USE WAREHOUSE COMPUTE_WH;
USE DATABASE MOVIELENS;
USE SCHEMA RAW;

-- Sanity check
SELECT CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();
