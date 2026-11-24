{{ config(materialized='table') }}

with gps as (
    select
        device_id,
        event_ts,
        location_geog
    from {{ ref('stg_gps_pings') }}
    where device_id is not null
      and event_ts is not null
      and location_geog is not null
),

stores as (
    select
        coffee_shop_id,
        coffee_shop_name,
        area,
        location_type,
        location_geog
    from {{ ref('stg_coffee_shop_locations') }}
    where coffee_shop_id is not null
      and location_geog is not null
),

catchment_pings as (
    select
        s.coffee_shop_id,
        s.coffee_shop_name,
        s.area,
        s.location_type,
        date_trunc('hour', g.event_ts) as hour_start,
        g.device_id,
        st_distance(g.location_geog, s.location_geog) as distance_meters
    from gps g
    inner join stores s
        on st_distance(g.location_geog, s.location_geog) <= 500
)

select
    coffee_shop_id,
    coffee_shop_name,
    area,
    location_type,
    hour_start,
    count(*) as total_pings,
    count(distinct device_id) as unique_devices,
    avg(distance_meters) as avg_distance_meters
from catchment_pings
group by
    coffee_shop_id,
    coffee_shop_name,
    area,
    location_type,
    hour_start
