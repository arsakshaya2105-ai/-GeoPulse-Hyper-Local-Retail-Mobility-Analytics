# GeoPulse dbt models

This starter dbt package contains staging models for GPS pings and coffee-shop locations, plus an hourly catchment-footfall fact model and data-quality tests.

## Expected Snowflake raw tables

The source declarations below assume:
- `RAW_GPS_PINGS` with `DEVICEID`, `LATITUDE`, `LONGITUDE`, `TIMESTAMP`
- `RAW_COFFEE_SHOP_LOCATIONS` with `COFFEESHOPID`, `COFFEESHOPNAME`, `AREA`, `LATITUDE`, `LONGITUDE`, `LOCATIONTYPE`

If your actual raw table or column names differ, update `models/staging/sources.yml`.

## Setup

1. Copy this folder into your dbt project's root (or copy its `models` and `tests` folders into your project).
2. Confirm your Snowflake profile and database/schema permissions.
3. Update source table names in `models/staging/sources.yml` if needed.
4. Run:

```bash
dbt debug
dbt compile --select stg_gps_pings stg_coffee_shop_locations fct_hourly_store_footfall
dbt run --select stg_gps_pings stg_coffee_shop_locations fct_hourly_store_footfall
dbt test --select stg_gps_pings stg_coffee_shop_locations fct_hourly_store_footfall
```

## Important interpretation notes

- The model uses a 500-metre straight-line distance from each ping to each store point as a circular catchment rule. It does not create or query stored catchment polygons.
- A ping in a catchment indicates potential presence, not a confirmed store visit or purchase.
- `unique_devices` is distinct devices per store per hour, not unique customers.
- The source timestamps are timezone-naive. The staging model preserves them as `TIMESTAMP_NTZ`; decide and document a timezone convention before comparing local-hour metrics across regions.
- This starter package has been authored but not executed against your Snowflake account.
