select
    major_category,
    had_internship,
    count(*) as num_graduates,
    round(avg(net_roi_usd), 0) as avg_net_roi_usd,
    round(avg(roi_pct), 1) as avg_roi_pct,
    round(avg(earnings_10yr_usd), 0) as avg_earnings_10yr_usd
from {{ ref('stg_college_major_roi') }}
group by major_category, had_internship
order by major_category, had_internship desc
