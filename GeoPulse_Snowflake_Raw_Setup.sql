-- GeoPulse: Snowflake database, raw schema, and raw tables
-- Run this script in a Snowflake SQL Worksheet using a role with CREATE DATABASE
-- and CREATE SCHEMA/TABLE privileges.
--
-- The tables are designed for the synthetic files created for this project:
--   GeoPulse_Hyderabad_Coffee_Shop_Locations.csv
--   GeoPulse_Hyderabad_Synthetic_GPS_Pings.csv
--
-- Note: This script creates database objects only. It does not upload or load CSV files.

USE ROLE ACCOUNTADMIN;

CREATE DATABASE IF NOT EXISTS GEOPULSE_DB
    COMMENT = 'GeoPulse retail mobility analytics project database';

CREATE SCHEMA IF NOT EXISTS GEOPULSE_DB.RAW
    COMMENT = 'Raw landing schema for source datasets';

USE DATABASE GEOPULSE_DB;
USE SCHEMA RAW;

-- Raw coffee shop/store location records.
CREATE TABLE IF NOT EXISTS RAW_COFFEE_SHOP_LOCATIONS (
    COFFEE_SHOP_ID   VARCHAR(50)  NOT NULL,
    COFFEE_SHOP_NAME VARCHAR(255),
    AREA             VARCHAR(150),
    LATITUDE         NUMBER(10,6),
    LONGITUDE        NUMBER(10,6),
    LOCATION_TYPE    VARCHAR(30),
    SOURCE_FILE      VARCHAR(500),
    LOADED_AT        TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
)
COMMENT = 'Raw synthetic coffee shop locations for GeoPulse; coordinates are WGS84 decimal degrees';

-- Raw anonymized/synthetic GPS ping records.
CREATE TABLE IF NOT EXISTS RAW_GPS_PINGS (
    DEVICE_ID   VARCHAR(100),
    LATITUDE    NUMBER(10,6),
    LONGITUDE   NUMBER(10,6),
    EVENT_TS    TIMESTAMP_NTZ,
    SOURCE_FILE VARCHAR(500),
    LOADED_AT   TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
)
COMMENT = 'Raw synthetic GPS pings for GeoPulse; timestamps represent the supplied local observation time';

-- Optional file format for the project CSV files.
CREATE FILE FORMAT IF NOT EXISTS GEOPULSE_CSV_FORMAT
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('', 'NULL', 'null')
    EMPTY_FIELD_AS_NULL = TRUE
    TRIM_SPACE = TRUE
    ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE;

-- Verify the objects were created.
SHOW DATABASES LIKE 'GEOPULSE_DB';
SHOW SCHEMAS IN DATABASE GEOPULSE_DB;
SHOW TABLES IN SCHEMA GEOPULSE_DB.RAW;
DESCRIBE TABLE GEOPULSE_DB.RAW.RAW_COFFEE_SHOP_LOCATIONS;
DESCRIBE TABLE GEOPULSE_DB.RAW.RAW_GPS_PINGS;

-- After uploading the CSV files to a Snowflake stage, load them with COPY INTO.
-- Example assumes the files are in a stage named @GEOPULSE_DB.RAW.GEOPULSE_STAGE.
-- Create the stage separately or use an existing named stage.
--
-- COPY INTO GEOPULSE_DB.RAW.RAW_COFFEE_SHOP_LOCATIONS
--   (COFFEE_SHOP_ID, COFFEE_SHOP_NAME, AREA, LATITUDE, LONGITUDE, LOCATION_TYPE, SOURCE_FILE)
-- FROM (
--   SELECT $1, $2, $3, $4, $5, $6, METADATA$FILENAME
--   FROM @GEOPULSE_DB.RAW.GEOPULSE_STAGE
-- )
-- FILE_FORMAT = (FORMAT_NAME = GEOPULSE_DB.RAW.GEOPULSE_CSV_FORMAT)
-- PATTERN = '.*Coffee_Shop_Locations[.]csv'
-- ON_ERROR = 'ABORT_STATEMENT';
--
-- COPY INTO GEOPULSE_DB.RAW.RAW_GPS_PINGS
--   (DEVICE_ID, LATITUDE, LONGITUDE, EVENT_TS, SOURCE_FILE)
-- FROM (
--   SELECT $1, $2, $3, TO_TIMESTAMP_NTZ($4, 'YYYY-MM-DD HH24:MI:SS'), METADATA$FILENAME
--   FROM @GEOPULSE_DB.RAW.GEOPULSE_STAGE
-- )
-- FILE_FORMAT = (FORMAT_NAME = GEOPULSE_DB.RAW.GEOPULSE_CSV_FORMAT)
-- PATTERN = '.*Synthetic_GPS_Pings[.]csv'
-- ON_ERROR = 'ABORT_STATEMENT';

-- Basic post-load row-count checks (run after COPY INTO):
-- SELECT COUNT(*) AS STORE_ROWS
-- FROM GEOPULSE_DB.RAW.RAW_COFFEE_SHOP_LOCATIONS;
--
-- SELECT COUNT(*) AS GPS_PING_ROWS
-- FROM GEOPULSE_DB.RAW.RAW_GPS_PINGS;
