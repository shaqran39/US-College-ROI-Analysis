select
    grad_id,
    trim(lower(major)) as major,
    trim(lower(major_category)) as major_category,
    trim(lower(institution_tier)) as institution_tier,
    institution_selectivity_pctile,
    gpa,
    had_internship::boolean as had_internship,
    completed_on_time::boolean as completed_on_time,
    trim(lower(region)) as region,
    net_cost_usd,
    debt_usd,
    hs_baseline_10yr_usd,
    added_earnings_10yr_usd,
    earnings_10yr_usd,
    net_roi_usd,
    roi_pct,
    positive_roi::boolean as positive_roi,
    high_roi::boolean as high_roi,
    abs((added_earnings_10yr_usd - net_cost_usd) - net_roi_usd) > 100 as roi_calc_mismatch,
    (net_cost_usd < 0 or debt_usd < 0 or hs_baseline_10yr_usd < 0) as has_negative_value
from {{ source('bronze', 'college_major_roi') }}
qualify row_number() over (partition by grad_id order by grad_id) = 1