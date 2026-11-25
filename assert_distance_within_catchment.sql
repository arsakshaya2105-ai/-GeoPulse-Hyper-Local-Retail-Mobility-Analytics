select *
from {{ ref('fct_hourly_store_footfall') }}
where avg_distance_meters < 0
   or avg_distance_meters > 500
