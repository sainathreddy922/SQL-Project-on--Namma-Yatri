use namma;
select * from trips;
select * from payment;
select * from duration;
select * from loc;
select * from trips_details4 ;
select * from trips_details4;

-- total trips
select count(distinct tripid) as totaltrips from trips_details4;
select tripid,count(distinct tripid) from trips_details4
group by tripid
having count(distinct tripid)>1;

-- total drivers
select count(distinct driverid) as totaldrivers from trips;

-- total earnings
select sum(fare) as totalearnings from trips;

-- total completed trips
select sum(end_ride) as completedtrips from trips_details4;

-- total searches
select sum(searches) as totalsearches from trips_details4;

-- total searches which got estimate
select sum(searches_got_estimate) AS totalsearches_gotestimate,sum(searches_for_quotes)as totalsearches_forquotes,
sum(searches_got_quotes) as totalsearches_gotquotes from trips_details4;

-- total driver_cancelled
select  count(*) -sum(driver_not_cancelled) from trips_details4;

--total customer_cancelled
select  count(*) -sum(customer_not_cancelled) from trips_details4;


-- which is the most used payment method

select p.method from payment as p inner join 
(
select top 1 faremethod,count(distinct tripid) as total from trips
group by faremethod 
order by count(distinct tripid) desc) as t on t.faremethod=p.id;

--the highest payment made through which instrument

select p.method from payment as p inner join
(select top 1 faremethod,sum(fare) as total_fare from trips 
group by faremethod
order by sum(fare) desc) as t(faremethod,total_fare) on t.faremethod=p.id;

--which two locations had the most trips
select * from
(select*,dense_rank()over(order by cunt desc) rnk from
(select loc_from,loc_to,count(distinct tripid) as cunt from trips
group by loc_from,loc_to)
as b) as c
where rnk=1;

--top 5 earning drivers
select * from
(select *,dense_rank()over(order by total_fare desc)rnk
from
(select top 5 driverid,sum(fare) as total_fare from trips
group by driverid)
 as b)c
where rnk<6;

-- which duration had more trips
select * from
(
select *,dense_rank() over( order by drt desc) rnk
from
(select duration,count(distinct tripid) as drt  from trips
group by duration)as b) as c
where rnk=1;

-- which driver , customer pair had more orders
select * from (
select *,dense_rank()over( order by cont desc) rnk 
from
(select driverid,custid,count(distinct tripid) as cont from trips
group by driverid,custid) as b)c
where rnk=1;

-- search to estimate rate
select sum(searches_got_estimate)*100.0/sum(searches) from trips_details4;

-- estimate to search for quote rates
select sum(searches_for_quotes)*100.0/sum(searches) from trips_details4;

-- quote acceptance rate
select sum(searches_got_quotes)*100.0/sum(searches) from trips_details4;

-- quote to booking rate
select sum(otp_entered)*100.0/sum(searches) from trips_details4;

-- booking cancellation rate
select sum(customer_not_cancelled)*100.0/sum(searches) from trips_details4;

-- which area got highest trips in which duration
select * from(
select *,dense_rank()over(partition by duration order by cont desc) rnk 
from
(select duration,loc_from,count(distinct tripid) as cont from trips
group by duration,loc_from) as b) as c 
where rnk=1;

-- which area got the highest fares, cancellations,trips,

select * from (
select*,dense_rank()over(order by fare desc)rnk from
(select loc_from,sum(fare) as fare from trips
group by loc_from) as b) as c
where rnk =1;

select * from (
select*,dense_rank()over(order by cancelled desc )rnk from
(select loc_from,count(*)-sum(customer_not_cancelled) as cancelled from trips_details4
group by loc_from)as b)as c
where rnk=1;

select * from (
select*,dense_rank()over(order by cancelled desc )rnk from
(select loc_from,count(*)-sum(driver_not_cancelled) as cancelled from trips_details4
group by loc_from)as b)as c
where rnk=1;

-- which duration got the highest trips and fares

select * from (
select*,dense_rank()over(order by fare desc)rnk from
(select duration,count(distinct tripid) as fare from trips
group by duration) as b) as c
where rnk =1;

--average fare per trip
select avg(fare) as avg_fare from trips;