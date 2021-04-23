with result as 
(SELECT date, platform, campaign_name, spend, clicks
FROM `business-intelligence-240201.ppc_model.campaign_result_vw` 
--where date >= '2020-11-01'
union all
SELECT date, platform, campaign_name, spend, clicks
FROM `business-intelligence-240201.ppc_model.campaign_result_0_expense` 
--where date >= '2020-11-01'
),

expense as 
(select DATE_TRUNC(date, Week(Monday)) as expense_week, platform, campaign_name, sum(spend) as spend, sum(clicks) as click
from result
group by 1,2,3),

user_join as
(select DATE_TRUNC(cast(date_joined as date), Week(Monday)) as join_week, source, campaign_name, count(distinct binary_user_id)  as user_count
FROM `business-intelligence-240201.ppc_model.ppc_campaign_lead_vw`
group by 1,2,3),

cpl as
(select *, 
(spend / (case when user_count = 0 then null else user_count end)) as cpl, 
(click / (case when user_count = 0 then null else user_count end)) as click_per_lead, 
round((user_count / case when click = 0 then null else click end ),4) as click_to_lead_conversion
from
(select expense.*,join_week, coalesce(user_count,0) as user_count
from expense 
--use full join because we have cases when we got lead, but we do not have expense for that campaign (test campaign etc), so those will be excluded by left join
--those leads will have expense_week = null, but join_week is not null
full join user_join
on expense.expense_week = join_week and platform = source and expense.campaign_name = user_join.campaign_name and expense.platform =user_join.source) as tmp
)

select * from cpl
order by 1,2,3
