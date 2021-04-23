select * from
(SELECT 'bing' AS platform, date, campaign_name, cast(campaign_id as string) as campaign_id, country, spend, impressions,null as reach,null as frequency, clicks, null as cpm, null as cpc
FROM `business-intelligence-240201.ppc_microsoft.campaign_result` 
union all 
SELECT 'fb' as platform, cast(date_start as date) as date, campaign_name, campaign_id, null as country, spend, impressions, reach, frequency, clicks, cpm, cpc 
FROM `business-intelligence-240201.ppc_fb.campaign_result`
union all
--something is wrong with data integrated with stitchdata, so i just manual extract the report from Adroll and use it
SELECT 'adroll' as platform, Day as date, Campaign as campaign_name, Campaign_ID as campaign_id,null as country,	spend, impressions, null as reach, null as frequency,	clicks, null as cpm, null as cpc	
FROM `business-intelligence-240201.ppc_adroll.campaign_results`
union all
--SELECT 'adroll' as platform, date, campaign_name, campaign_id,null as country,	spend, impressions, null as reach, null as frequency,	clicks, cpm, cpc	
--FROM `business-intelligence-240201.ppc_adroll.campaign_result`
--union all
--adding adroll campaigns which cant load with stitchdata
--SELECT 'adroll' as platform, date, campaign_name, null as campaign_id,null as country,	spend,impression as impressions, null as reach, null as frequency,	clicks, null as cpm,null as cpc	
--FROM `business-intelligence-240201.ppc_adroll.manual_extract_campaign`
--union all
select platform,cast(date as date) as date,campaign_name, campaign_name as campaign_id, cast(country as string) as country, spend, impressions, reach, frequency, clicks, cpm, cpc
from `business-intelligence-240201.ppc_manual_campaign.manual_campaign_result`
union all
SELECT 'verizonmedia' as platform, date, campaign_name, campaign_id,null as country,	spend, impressions, null as reach, null as frequency,	clicks, cpm, cpc	
FROM `business-intelligence-240201.ppc_yahoo.campaign_result`
union all
select 'adskeeper' as platform, date, campaign_name, campaign_id,null as country,	spend, impressions, null as reach, null as frequency,	clicks, null as cpm, null as cpc
from `business-intelligence-240201.ppc_adskeeper.campaign_result`
union all
select 'smartyads' as platform, date, campaign_name, campaign_id,null as country,	spend, impressions, null as reach, null as frequency,	clicks, null as cpm, null as cpc
from `business-intelligence-240201.ppc_smartyads.campaign_result` 
union all
select 'adcash' as platform, date, campaign_name, campaign_id,null as country,	spend, impressions, null as reach, null as frequency,	clicks, null as cpm, null as cpc
from `business-intelligence-240201.ppc_adcash.campaign_result` 
union all
select 'match2one' as platform, date, campaign_name, campaign_id,null as country,	spend, impressions, null as reach, null as frequency,	clicks, null as cpm, null as cpc
from `business-intelligence-240201.ppc_match2one.campaign_result` 
union all
select 'investingdotcom' as platform, date, campaign_name, null as campaign_id,null as country,	spend, impressions, null as reach, null as frequency,	clicks, null as cpm, null as cpc
from `business-intelligence-240201.ppc_investingdotcom.campaign_result` 
union all
select 'google' as platform, date, campaign_name, null as campaign_id,null as country,	spend, impressions, null as reach, null as frequency,	clicks, null as cpm, null as cpc
from `business-intelligence-240201.ppc_google.campaign_result`
union all
select 'tradingviewdotcom' as platform, date, campaign_name, null as campaign_id,null as country,	spend, impressions, null as reach, null as frequency,	clicks, null as cpm, null as cpc
from `business-intelligence-240201.ppc_tradingview.campaign_result` 
) 
where date >= '2020-06-01'
--we now only recognise expense after june 2020 to avoid edge cases
