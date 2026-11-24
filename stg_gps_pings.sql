{{ config(materialized='view') }}

select
    trim(DEVICEID::varchar) as device_id,
    LATITUDE::float as latitude,
    LONGITUDE::float as longitude,
    try_to_timestamp_ntz(TIMESTAMP::varchar) as event_ts,
    st_makepoint(LONGITUDE::float, LATITUDE::float) as location_geog
from {{ source('raw', 'gps_pings') }}
where DEVICEID is not null
  and LATITUDE is not null
  and LONGITUDE is not null
  and TIMESTAMP is not null
  and LATITUDE between -90 and 90
  and LONGITUDE between -180 and 180
  and try_to_timestamp_ntz(TIMESTAMP::varchar) is not null
