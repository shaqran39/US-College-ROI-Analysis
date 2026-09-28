select
    major,
    major_category,
    round(avg(debt_usd), 0) as avg_debt_usd,
    round(avg(added_earnings_10yr_usd), 0) as avg_added_earnings_10yr_usd,
    round(avg(case when added_earnings_10yr_usd > 0 
        then debt_usd::float / added_earnings_10yr_usd else null end), 3) as avg_debt_to_earnings_ratio
from {{ ref('stg_college_major_roi') }}
group by major, major_category
order by avg_debt_to_earnings_ratio asc
