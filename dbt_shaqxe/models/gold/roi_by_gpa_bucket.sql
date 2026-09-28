select
    case
        when gpa < 2.5 then '1 - below 2.5'
        when gpa < 3.0 then '2 - 2.5 to 3.0'
        when gpa < 3.5 then '3 - 3.0 to 3.5'
        else '4 - 3.5 to 4.0'
    end as gpa_bucket,
    count(*) as num_graduates,
    round(avg(net_roi_usd), 0) as avg_net_roi_usd,
    round(avg(roi_pct), 1) as avg_roi_pct,
    round(100.0 * sum(case when positive_roi then 1 else 0 end) / count(*), 1) as pct_positive_roi
from {{ ref('stg_college_major_roi') }}
group by gpa_bucket
order by gpa_bucket
