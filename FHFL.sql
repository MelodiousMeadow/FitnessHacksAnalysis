--1 What is the total number of clicks for each country? 

select country, sum(clicks) as total_clicks
from `FHFL.regional`
group by 1
order by 2 desc;

--2 What is the total number of clicks for each region? 

select region, sum(clicks) as total_clicks
from `FHFL.regional`
group by 1
order by 2 desc;

--3 What is the total impressions and average click-through rate for each campaign? 
select campaign, sum(campaign_impr) as total_impressions, round(avg(campaign_ctr),2) as avg_ctr
from `FHFL.campaign`
group by 1;

--4 What is the ratio of clicks to impressions for each device type? 
select device, round(sum(clicks)/sum(regional_impr),2) as ctr
from `FHFL.regional`
group by 1;

--5 What are the top 5 regions with the highest number of clicks throughout the month of August?
select region, sum(clicks) as total_clicks
from `fhfl-437402.FHFL.regional`
where extract (month from regional_date) = 8
group by 1
order by 2 desc
limit 5;

--6 Analyze how session duration varies by device type, providing insights into user experience across playforms

select device, avg(avg_session_duration) as avg_sess_dur,
stddev(avg_session_duration) as duration_variance
from `fhfl-437402.FHFL.duration ` d
join `fhfl-437402.FHFL.regional` r on d.duration_date = r.regional_date
group by 1;

--7 Determine which days of the week have the highest user activity
select FORMAT_DATE('%A', regional_date) AS day_of_week, COUNT(*) AS activity_count
FROM `fhfl-437402.FHFL.regional`
GROUP BY 
    day_of_week
ORDER BY 2 DESC;

--8 Calculate the total clicks for each region on a weekly basis over the past month

--changing dates to a weekly basis so can later aggregate sum by region and week 
with cte as (select region, date_trunc (regional_date, week) as weekly_date, clicks
from `FHFL.regional`
where extract(month from regional_date)=08 and date_trunc(regional_date,week) >='2024-08-01')

select region, weekly_date, sum(clicks) as total_clicks
from cte
group by 1,2
order by 3 desc;
 
--9 For each campaign, calculate the click-through rate (CTR) and rank them by performance.
with cte as (select campaign, round(avg(campaign_ctr),2) as avg_ctr
from `FHFL.campaign`
group by 1)

select campaign, avg_ctr, 
  row_number() over (order by avg_ctr desc) as performance_rank
from cte;

--10 Determine the average number of clicks and impressions for each device type, and identify the device with the highest engagement.

select device, round(avg(clicks),2) as avg_clicks, round(avg(regional_impr),2) as avg_impr
from `FHFL.regional`
group by 1 
order by 2 desc;

--11 Show the distribution of total clicks across regions, including the percentage share of each region.

WITH total_clicks AS (
    SELECT
        region,
        SUM(clicks) AS region_total_clicks
    FROM `FHFL.regional`
    GROUP BY
        region),
overall_total AS (SELECT SUM(clicks) AS total_clicks
    FROM`FHFL.regional`)
SELECT
    t.region,
    t.region_total_clicks,
    ROUND((t.region_total_clicks / o.total_clicks) * 100, 0) AS percentage_share
FROM total_clicks t
JOIN overall_total o
ON 1=1
ORDER BY percentage_share DESC;
