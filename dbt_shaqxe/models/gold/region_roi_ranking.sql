select
    region,
    count(*) as num_graduates,
    round(avg(net_roi_usd), 0) as avg_net_roi_usd,
    round(avg(roi_pct), 1) as avg_roi_pct,
    rank() over (order by avg(net_roi_usd) desc) as roi_rank
from {{ ref('stg_college_major_roi') }}
group by region
order by roi_rank
