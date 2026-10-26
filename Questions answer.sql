use Call_center_Data
-- How many contacts were received?
SELECT count(Distinct CallID)
FROM Data_processing ;
-- How many were handled, and how many were abandoned?
SELECT count(CallID) as Total_contacts
	,SUM(case when Resolved = 'True' Then 1 else 0 End ) HandelContacts
	,Sum(case When Abandoned = 'True' then 1 else 0 End ) AbandonedContacts 
FROM Data_processing
 -- What was the overall resolution rate? 
 SELECT
    SUM(CASE WHEN Resolved = 'True' THEN 1 ELSE 0 END) * 100.0
    / COUNT(*) AS ResolutionRate
FROM Data_processing;
--What percentage of contacts met the service-level target? 
with Service_level as (SELECT SUM( CASE WHEN waitTimeBucket = 'Under 1 Minute' then 1 else 0 end) as WT 
		, sum (case when Handle_time_bucket ='under 5 Min' then 1 else 0 End)  AS HT 
		,count(CallId) as Total_calls
FROM data_processing)

select ((wt+HT)/10000)*100
from Service_level
/*Customer experience*/
--Which departments receive the lowest satisfaction scores? 
SELECT top 1 Department , AVG(SatisfactionScore) as lowest_score 
from Data_processing
where SatisfactionScore is not null 
group by Department 
order by lowest_score ASC
--Does longer waiting time relate to lower customer satisfaction? 
Select WaitTimeBucket , AVG(satisfactionScore) as avg_score
FROM Data_processing
where SatisfactionScore is not null 
group by WaitTimeBucket
--Which contact reasons have the lowest resolution rates? 
SELECT top 1 callreason , count(Resolved) resolution
FROM data_processing
where Resolved = 'True'
group by CallReason
order by resolution Asc ;
--Which customer segments have the highest repeat-contact proxy rate? 
SELECT top 1 customertype , count(RepeatContactWithin7Days) as Repeating
FROM Data_processing
where RepeatContactWithin7Days = 1
Group by CustomerType
order by Repeating DESC 
--What percentage of issues were resolved on the first contact?
SELECT 
	SUM(CASE WHEN firstContactResolution ='True' then 1 else 0 end)*100 / count(firstcontactresolution)
FROM Data_processing ;


/*Agent performance*/
--Which agents handle the highest volume? 
SELECT top 1 AgentID , count(callID) as calls_number
FROM Data_processing
where AgentID is not null 
Group by AgentID
order by calls_number DESC 
--Which agents have the highest resolution rates? 
SELECT top 1 AgentID , count(Resolved) as resolve_cases
FROM Data_processing
where AgentID is not null AND Resolved = 'True'
Group by AgentID
order by resolve_cases DESC 
--Which agents have the best satisfaction scores?
SELECT  AgentID , AVG(SatisfactionScore) as satisfy_rate
FROM Data_processing
where AgentID is not null 
Group by AgentID
order by satisfy_rate DESC 
--Does agent tenure appear associated with performance? 
SELECT  AgentTenureMonths , count(callID) as number_customers , count(resolved) as resloved_P
FROM Data_processing
where resolved = 'True'
Group by AgentTenureMonths
order by resloved_P DESC ;


/*Operations and workforce planning*/
--Which hours and weekdays have the highest contact volume?
SELECT DayOfWeek ,CallHour,count(callID) as Contact_number
FROM Data_processing
Group by CallHour , DayOfWeek
order by Contact_number
--Which departments transfer the most contacts?
SELECT Department , count(Transferred) as transfer_contact
FROM Data_processing
where Transferred = 'True' 
Group by Department 
order by transfer_contact DESC
--Which regions have the weakest performance? 
SELECT Region , count(Resolved) as performance
FROM Data_processing
where Resolved = 'True' 
Group by Region
order by performance DESC
