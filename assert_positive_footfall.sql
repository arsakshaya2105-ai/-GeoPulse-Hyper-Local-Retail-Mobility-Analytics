select *
from {{ ref('fct_hourly_store_footfall') }}
where total_pings <= 0
   or unique_devices <= 0
   or unique_devices > total_pings
