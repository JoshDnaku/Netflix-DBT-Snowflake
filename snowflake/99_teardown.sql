-- ============================================================
-- Teardown / cleanup. Run in a Snowflake worksheet as ACCOUNTADMIN.
-- Pick the LEVEL you want. Higher levels are destructive and NOT reversible.
--
-- COST CONTEXT: COMPUTE_WH is X-SMALL with AUTO_SUSPEND=60s, so it already
-- stops billing shortly after idle. These steps are mostly hygiene / peace
-- of mind. Only running compute costs credits; suspended warehouses and
-- stored data cost (near) nothing on a trial.
-- ============================================================

USE ROLE ACCOUNTADMIN;

-- ---- LEVEL 1: just suspend the warehouse (keep everything) ----
-- Safe, reversible. The warehouse resumes automatically on the next query.
ALTER WAREHOUSE COMPUTE_WH SUSPEND;

-- ---- LEVEL 2: drop the warehouse (keep the data) ----
-- Removes the compute object. Models/data in MOVIELENS remain queryable,
-- but you'd recreate the warehouse (01_setup.sql) to run dbt again.
-- Uncomment to use:
-- DROP WAREHOUSE IF EXISTS COMPUTE_WH;

-- ---- LEVEL 3: full teardown (drop everything this project created) ----
-- Removes the database (all raw + DEV + SNAPSHOTS data), the warehouse,
-- the dbt user, and the TRANSFORM role. Rebuild from scratch to revisit.
-- Uncomment the block to use:
-- DROP DATABASE IF EXISTS MOVIELENS;
-- DROP WAREHOUSE IF EXISTS COMPUTE_WH;
-- DROP USER IF EXISTS dbt;
-- DROP ROLE IF EXISTS TRANSFORM;

-- ---- Letting the trial lapse ----
-- Snowflake trials expire automatically (~30 days or when credits run out)
-- and do NOT auto-convert to paid or ask for a card. To be certain nothing
-- bills: don't add a payment method, and optionally run LEVEL 3 above.
-- Account-level cancellation (if desired): Admin > Accounts in Snowsight,
-- or contact Snowflake support; a lapsed trial simply stops working.
