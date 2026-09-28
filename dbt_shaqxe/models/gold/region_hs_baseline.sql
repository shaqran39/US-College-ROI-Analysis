select
    region,
    count(*) as num_graduates,
    round(avg(hs_baseline_10yr_usd), 0) as avg_hs_baseline_10yr_usd,
    rank() over (order by avg(hs_baseline_10yr_usd) desc) as hs_baseline_rank
from {{ ref('stg_college_major_roi') }}
group by region
order by hs_baseline_rank
