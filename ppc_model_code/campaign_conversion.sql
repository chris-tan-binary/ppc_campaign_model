with leads as 
(SELECT channel,subchannel, source,placement, campaign_name, country, cast(date_joined as date) as user_date_joined,binary_user_id, cast(date_joined as date) as date, 'user_lead_count' as fact, 1 as value
from `business-intelligence-240201.ppc_model.ppc_campaign_lead_vw`
where channel = 'ppc'
),

bo_vr as
(select leads.* except(date,fact,value), cast(creation_stamp as date) as date, 'bo_virtual' as fact, 1 as value
FROM `business-intelligence-240201.bi.user_loginid`	as uli
join  leads
on uli.binary_user_id = leads.binary_user_id
where uli.loginid like 'VR%'),

bo_real as
(select leads.* except(date,fact,value), cast(creation_stamp as date) as date, 'bo_real' as fact, 1 as value
FROM `business-intelligence-240201.bi.user_loginid`	as uli
join leads
on uli.binary_user_id = leads.binary_user_id
where uli.loginid not like 'VR%' and uli.loginid not like 'MT%'),

mt5_virtual as
(select leads.* except(date,fact,value), cast(creation_stamp as date) as date, 'mt5_demo' as fact, 1 as value
FROM `business-intelligence-240201.bi.user_loginid`	as uli
join leads
on uli.binary_user_id = leads.binary_user_id
where uli.loginid like 'MTD%'),

mt5_real as
(select leads.* except(date,fact,value), cast(creation_stamp as date) as date, 'mt5_real' as fact, 1 as value
FROM `business-intelligence-240201.bi.user_loginid`	as uli
join  leads
on uli.binary_user_id = leads.binary_user_id
where uli.loginid like 'MTR%'),

activated as 
(select leads.* except(date,fact,value), cast(first_deposit_time as date) as date, 'deposit_activated_bo_account' as fact, 1 as value
FROM `business-intelligence-240201.bi.user_loginid`	as uli
join  leads
on uli.binary_user_id = leads.binary_user_id
left join `business-intelligence-240201.bi.bo_client` as c
on uli.loginid = c.loginid
where first_deposit_time is not null),

deposit as 
(select  leads.* except(date,fact,value), cast(transaction_time as date) as date, 'client_deposit_usd' as fact, round(sum(coalesce(amount_usd,0)),2) as value
FROM `business-intelligence-240201.bi.user_loginid`	as uli
join  leads
on uli.binary_user_id = leads.binary_user_id
join (select * from `business-intelligence-240201.bi.bo_payment_model` where category = 'Client Deposit') as pm
on uli.loginid = pm.client_loginid
group by 1,2,3,4,5,6,7,8,9)

select * from leads
union all
select * from bo_vr
union all
select * from bo_real
union all
select * from mt5_virtual
union all
select * from mt5_real
union all
select * from activated
union all
select * from deposit
