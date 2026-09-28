select
    region,
    count(*) as num_graduates,
    round(avg(net_cost_usd), 0) as avg_net_cost_usd,
    round(min(net_cost_usd), 0) as min_net_cost_usd,
    round(max(net_cost_usd), 0) as max_net_cost_usd,
    rank() over (order by avg(net_cost_usd) desc) as cost_rank
from {{ ref('stg_college_major_roi') }}
group by region
order by cost_rank
