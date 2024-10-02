--What is the total number of clicks for each country? 

select country, sum(clicks) as total_clicks
from `FHFL.regional`
group by 1
order by 2 desc;

--What is the total number of clicks for each region? 

select region, sum(clicks) as total_clicks
from `FHFL.regional`
group by 1
order by 2 desc;

--What is the total impressions and average click-through rate for each campaign? 
select campaign, sum(campaign_impr) as total_impressions, round(avg(campaign_ctr),2) as avg_ctr
from `FHFL.campaign`
group by 1;

--What is the ratio of clicks to impressions for each device type? 
select device, round(sum(clicks)/sum(regional_impr),2) as ctr
from `FHFL.regional`
group by 1;

--what are the top 5 regions with the highest number of clicks throughout the month of August?
select region, sum(clicks) as total_clicks
from `fhfl-437402.FHFL.regional`
where extract (month from regional_date) = 8
group by 1
order by 2 desc
limit 5;

--Analyze how session duration varies by device type, providing insights into user experience across playforms

select device, avg(avg_session_duration) as avg_sess_dur,
stddev(avg_session_duration) as duration_variance
from `fhfl-437402.FHFL.duration ` d
join `fhfl-437402.FHFL.regional` r on d.duration_date = r.regional_date
group by 1;

--Determine which days of the week have the highest user activity
select FORMAT_DATE('%A', regional_date) AS day_of_week, COUNT(*) AS activity_count
FROM `fhfl-437402.FHFL.regional`
GROUP BY 
    day_of_week
ORDER BY 2 DESC;
