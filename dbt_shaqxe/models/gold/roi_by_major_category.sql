select
    major_category,
    count(*) as num_graduates,
    round(avg(net_roi_usd), 0) as avg_net_roi_usd,
    round(avg(roi_pct), 1) as avg_roi_pct,
    round(avg(net_cost_usd), 0) as avg_net_cost_usd,
    round(100.0 * sum(case when positive_roi then 1 else 0 end) / count(*), 1) as pct_positive_roi,
    round(100.0 * sum(case when high_roi then 1 else 0 end) / count(*), 1) as pct_high_roi
from {{ ref('stg_college_major_roi') }}
group by major_category
order by avg_net_roi_usd desc
