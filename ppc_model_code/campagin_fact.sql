with conversion as
(SELECT source as platform, date, campaign_name, country, fact, value
FROM `business-intelligence-240201.ppc_model.campaign_conversion_vw` as f
),

spend as 
(select platform, date, campaign_name, country, 'spend' as fact, sum(spend) as value
from `business-intelligence-240201.ppc_model.campaign_result_vw` 
where spend != 0 and spend is not null
group by 1,2,3,4,5),

impressions as
(select platform, date, campaign_name, country, 'impressions' as fact, sum(impressions) as value
from `business-intelligence-240201.ppc_model.campaign_result_vw` 
where impressions != 0 and impressions is not null
group by 1,2,3,4,5),

clicks as 
(select platform, date, campaign_name, country, 'clicks' as fact, sum(clicks) as value
from `business-intelligence-240201.ppc_model.campaign_result_vw` 
where clicks != 0 and clicks is not null 
group by 1,2,3,4,5)

select * from conversion
union all
select * from spend
union all 
select * from impressions
union all 
select * from clicks
