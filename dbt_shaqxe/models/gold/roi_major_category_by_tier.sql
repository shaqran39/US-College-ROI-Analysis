select
    major_category,
    institution_tier,
    count(*) as num_graduates,
    round(avg(net_roi_usd), 0) as avg_net_roi_usd,
    round(avg(roi_pct), 1) as avg_roi_pct
from {{ ref('stg_college_major_roi') }}
group by major_category, institution_tier
order by major_category, avg_net_roi_usd desc
