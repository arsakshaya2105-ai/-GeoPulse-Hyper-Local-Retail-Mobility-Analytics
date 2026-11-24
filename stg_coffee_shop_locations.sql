{{ config(materialized='view') }}

select
    trim(COFFEESHOPID::varchar) as coffee_shop_id,
    trim(COFFEESHOPNAME::varchar) as coffee_shop_name,
    trim(AREA::varchar) as area,
    LATITUDE::float as latitude,
    LONGITUDE::float as longitude,
    trim(LOCATIONTYPE::varchar) as location_type,
    st_makepoint(LONGITUDE::float, LATITUDE::float) as location_geog
from {{ source('raw', 'coffee_shop_locations') }}
where COFFEESHOPID is not null
  and LATITUDE is not null
  and LONGITUDE is not null
  and LATITUDE between -90 and 90
  and LONGITUDE between -180 and 180
