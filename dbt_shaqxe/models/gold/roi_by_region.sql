select
    region,
    count(*) as num_graduates,
    round(avg(net_roi_usd), 0) as avg_net_roi_usd,
    round(avg(roi_pct), 1) as avg_roi_pct,
    round(avg(net_cost_usd), 0) as avg_net_cost_usd,
    round(avg(debt_usd), 0) as avg_debt_usd
from {{ ref('stg_college_major_roi') }}
group by region
order by avg_net_roi_usd desc
