use namma;
select * from trips;
select * from payment;
select * from duration;
select * from loc;
select * from trips_details4 ;
select * from trips_details4;

-- 1 total trips
select count(distinct tripid) as totaltrips from trips_details4;
select tripid,count(distinct tripid) from trips_details4
group by tripid
having count(distinct tripid)>1;

-- 2 total drivers
select count(distinct driverid) as totaldrivers from trips;

-- 3 total earnings
select sum(fare) as totalearnings from trips;

-- 4  which is the most used payment method

select p.method from payment as p inner join 
(
select top 1 faremethod,count(distinct tripid) as total from trips
group by faremethod 
order by count(distinct tripid) desc) as t on t.faremethod=p.id;

-- 5 the highest payment made through which instrument

select p.method from payment as p inner join
(select top 1 faremethod,sum(fare) as total_fare from trips 
group by faremethod
order by sum(fare) desc) as t(faremethod,total_fare) on t.faremethod=p.id;

-- 6 which two locations had the most trips
select * from
(select*,dense_rank()over(order by cunt desc) rnk from
(select loc_from,loc_to,count(distinct tripid) as cunt from trips
group by loc_from,loc_to)
as b) as c
where rnk=1;

-- 7 top 5 earning drivers
select * from
(select *,dense_rank()over(order by total_fare desc)rnk
from
(select top 5 driverid,sum(fare) as total_fare from trips
group by driverid)
 as b)c
where rnk<6;

-- 8 which duration had more trips
select * from
(
select *,dense_rank() over( order by drt desc) rnk
from
(select duration,count(distinct tripid) as drt  from trips
group by duration)as b) as c
where rnk=1;

-- 9 total completed trips and total searches
select sum(end_ride) as completedtrips,sum(searches) as totalsearches from trips_details4;

-- 10 total driver_cancelled and total customer_cancelled
select  count(*) -sum(driver_not_cancelled),count(*) -sum(customer_not_cancelled) from trips_details4;

-- 11 average fare per trip
select avg(fare) as avg_fare from trips;

-- 12 total searches which got estimate,searches_got_quotes,searches_for_quotes
select sum(searches_got_estimate) AS totalsearches_gotestimate,sum(searches_for_quotes)as totalsearches_forquotes,
sum(searches_got_quotes) as totalsearches_gotquotes from trips_details4;

-- 13  which driver , customer pair had more orders
select * from (
select *,dense_rank()over( order by cont desc) rnk 
from
(select driverid,custid,count(distinct tripid) as cont from trips
group by driverid,custid) as b)c
where rnk=1;

-- 14 which area got highest trips in which duration
select * from(
select *,dense_rank()over(partition by duration order by cont desc) rnk 
from

-- 15 which area got the highest fares, cancellations,trips,
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

-- 16 which duration got the highest trips and fares
select * from (
select*,dense_rank()over(order by fare desc)rnk from
(select duration,count(distinct tripid) as fare from trips
group by duration) as b) as c
where rnk =1;

-- 17 which area got highest trips in which duration
select * from(
select *,dense_rank()over(partition by duration order by cont desc) rnk 
from
(select duration,loc_from,count(distinct tripid) as cont from trips
group by duration,loc_from) as b) as c 
where rnk=1;

-- 18 estimate to search for quote rates and quote acceptance rate
select  sum(searches_got_estimate)*100.0/sum(searches),sum(searches_for_quotes)*100.0/sum(searches),sum(searches_got_quotes)*100.0/sum(searches) from trips_details4;

-- 19 quote to booking rate and booking cancellation rate
select sum(customer_not_cancelled)*100.0/sum(searches),sum(otp_entered)*100.0/sum(searches) from trips_details4;

-- 20 trips which are cancelled bt customers
select * from (
select*,dense_rank()over(order by cancelled desc )rnk from
(select loc_from,count(*)-sum(customer_not_cancelled) as cancelled from trips_details4
group by loc_from)as b)as c
where rnk=1;



-



