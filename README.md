# ppc_campaign_model

We have started multiple PPC campaigns with multiple Ad Network Providers.
We need a universal data model to have the picture of the performance for all the campaigns we have done.

This repo is created to document the ETL process of ppc campaign and keep the version of source code.

Model Structure : 
https://drive.google.com/file/d/1JAYgtY-iXxpjReZBmrFeDtgzsaw8E5an/view?usp=sharing

![image](https://user-images.githubusercontent.com/46950856/115830440-e0b9c580-a442-11eb-9d8a-c8e71482c4e5.png)

__Campaign Conversion Table :__  
Conversion (eg: virtual signup, real signup, deposit etc) from backend side on campaign level by time dimension

__Campaign Result Table :__  
Performance (eg: spend, impression, click etc) from advertising platform side on campaign level by time dimension

__Campaign Fact Table :__  
Fact table that combines campaign conversion metrics with campaign result metrics with union all
This table tells us the campaign performance by time dimension, however, it doesn't takes into account of cohort based conversion

__Campaign Expense Table :__  
Version 2 of campaign performance table, it includes cohort based performance by showing the spending of a campaign on a particular week, and conversion (eg: user count, cpl etc) coming from that week. This approach is by mapping campaign_name = user_utm_campaign and campaign_expense_week = user_join_week

__Lead Expense Table :__   
Similar to campaign expense table, but this table is on lead(Binary User Id) level, which shows the attributed cost of the ppc lead acquisition. One sanity check on this table is that sum(cost) from lead_expense_table = sum(spend) from campaign_expense_table
