select
    case
        when institution_selectivity_pctile >= 90 then '1 - top 10%'
        when institution_selectivity_pctile >= 75 then '2 - top 25%'
        when institution_selectivity_pctile >= 50 then '3 - top 50%'
        else '4 - bottom 50%'
    end as selectivity_bucket,
    count(*) as num_graduates,
    round(avg(net_cost_usd), 0) as avg_net_cost_usd,
    round(avg(net_roi_usd), 0) as avg_net_roi_usd,
    round(avg(roi_pct), 1) as avg_roi_pct
from {{ ref('stg_college_major_roi') }}
group by selectivity_bucket
order by selectivity_bucket
