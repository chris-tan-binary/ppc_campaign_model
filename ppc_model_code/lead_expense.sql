with lead_cost as
(SELECT lead.binary_user_id, expense.platform,expense.campaign_name, expense_week, country, date_joined, (case when cpl is not null then cpl else spend end) as cost,
--add click per user, similar to spend
(case when click_per_lead is not null then click_per_lead else click end) as click,
FROM `business-intelligence-240201.ppc_model.ppc_campaign_lead_vw`  as lead
full join `business-intelligence-240201.ppc_model.campaign_expense_model` as expense
--to include user join without campaign expense (old and test campaign that we dont recognise in campaign expense)
on lead.source = expense.platform and lead.campaign_name = expense.campaign_name and DATE_TRUNC(cast(date_joined as date), Week(Monday)) = join_week
),

lifetime as
(select platform, campaign_name, 
sum(spend) / sum(case when user_count= 0 then null else user_count end) as overall_cpl, 
sum(click) / sum(case when user_count= 0 then null else user_count end) as overall_click_per_lead, 
sum(user_count) as user_count
from  `business-intelligence-240201.ppc_model.campaign_expense_model` as expense
group by 1,2)

select lead_cost.*,
--to make spending as distributed cost when the campaign dont have any lead
--also remove distributed cost when a campaign has spending on certain week, but no lead on that week, but overall has lead
(case when user_count != 0 and binary_user_id is null then 0 else coalesce(overall_cpl,cost) end) as distributed_cost,
(case when user_count != 0 and binary_user_id is null then 0 else coalesce(overall_click_per_lead,click) end) as distributed_click
--,user_count
from lead_cost
left join lifetime
on lead_cost.platform = lifetime.platform and lead_cost.campaign_name = lifetime.campaign_name
--to filter out campaign week with no spend and no lead
where (binary_user_id is not null or cost != 0)
order by platform, campaign_name, expense_week

--3 cases 
--bui non null but expense week null (ppc lead that we dont save the campaign expense)
--bui null but expense week null (we spend but dont get any lead)
--bui non null and expense week non null (normal case, we spend that week, we get lead that week)
