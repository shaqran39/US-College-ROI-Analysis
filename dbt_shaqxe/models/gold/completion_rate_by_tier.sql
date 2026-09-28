select
    institution_tier,
    count(*) as num_graduates,
    sum(case when completed_on_time then 1 else 0 end) as num_completed_on_time,
    round(100.0 * sum(case when completed_on_time then 1 else 0 end) / count(*), 1) as pct_completed_on_time
from {{ ref('stg_college_major_roi') }}
group by institution_tier
order by pct_completed_on_time desc
