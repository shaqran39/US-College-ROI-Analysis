select
    case
        when debt_usd = 0 then '0 - no debt'
        when debt_usd <= 25000 then '1 - up to 25k'
        when debt_usd <= 50000 then '2 - 25k to 50k'
        when debt_usd <= 100000 then '3 - 50k to 100k'
        else '4 - over 100k'
    end as debt_bucket,
    count(*) as num_graduates,
    round(avg(net_roi_usd), 0) as avg_net_roi_usd,
    round(avg(roi_pct), 1) as avg_roi_pct,
    round(100.0 * sum(case when positive_roi then 1 else 0 end) / count(*), 1) as pct_positive_roi
from {{ ref('stg_college_major_roi') }}
group by debt_bucket
order by debt_bucket
