select
    coffee_shop_id,
    hour_start,
    count(*) as row_count
from {{ ref('fct_hourly_store_footfall') }}
group by coffee_shop_id, hour_start
having count(*) > 1
