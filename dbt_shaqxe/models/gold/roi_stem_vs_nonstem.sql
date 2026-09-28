select
    case when major_category = 'stem' then 'stem' else 'non_stem' end as stem_flag,
    count(*) as num_graduates,
    round(avg(net_roi_usd), 0) as avg_net_roi_usd,
    round(avg(roi_pct), 1) as avg_roi_pct,
    round(avg(net_cost_usd), 0) as avg_net_cost_usd,
    round(avg(debt_usd), 0) as avg_debt_usd,
    round(100.0 * sum(case when had_internship then 1 else 0 end) / count(*), 1) as pct_had_internship
from {{ ref('stg_college_major_roi') }}
group by stem_flag
