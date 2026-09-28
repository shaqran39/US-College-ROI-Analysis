select
    major,
    major_category,
    count(*) as num_graduates,
    round(100.0 * count(*) / sum(count(*)) over (), 2) as pct_of_all_graduates
from {{ ref('stg_college_major_roi') }}
group by major, major_category
order by num_graduates desc
