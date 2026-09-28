select
    institution_tier,
    count(*) as num_graduates,
    round(100.0 * count(*) / sum(count(*)) over (), 2) as pct_of_all_graduates
from {{ ref('stg_college_major_roi') }}
group by institution_tier
order by num_graduates desc
