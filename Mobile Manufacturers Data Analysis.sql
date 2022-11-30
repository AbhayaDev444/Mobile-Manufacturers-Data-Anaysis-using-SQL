
--SQL Advance Case Study
--Q1--BEGIN 
	
use db_SQLCaseStudies

select DISTINCT dl.State  from DIM_LOCATION dl inner join FACT_TRANSACTIONS ft on dl.IDLocation  = ft.IDLocation 
       where year(ft.[Date]) >= '2005' 

--Q1--END

--Q2--BEGIN
       
       with us as(select IDLocation,state from DIM_LOCATION  where country = 'US'), 
       samsung as(select dmod.IDModel  from DIM_MODEL dmod inner join DIM_MANUFACTURER dman on dmod.IDManufacturer = dman.IDManufacturer
       where dman.Manufacturer_Name = 'Samsung')
       select top 1 u.state, sum(ft.quantity) [Total Quantity Bought] from  FACT_TRANSACTIONS ft inner join us u on u.idlocation = ft.IDLocation
           inner join samsung s on s.idmodel  = ft.IDModel
       Group By u.state
       Order by sum(ft.quantity) desc
     
--Q2--END 

--Q3--BEGIN      
	

select state,zipcode,dm2.Manufacturer_Name,dm.Model_Name,count(ft.IDModel)[No.of transactions] from fact_transactions ft  inner join DIM_LOCATION dl on ft.IDLocation =dl.IDLocation 
inner join DIM_MODEL dm on ft.IDModel = dm.IDModel inner join DIM_MANUFACTURER dm2 on dm2.IDManufacturer =dm.IDManufacturer 
group by state,zipcode,dm2.Manufacturer_Name,dm.Model_Name  
Order by count(ft.IDModel) DESC
 
--Q3--END

--Q4--BEGIN

select top 1 dm2.Manufacturer_Name,dm.Model_Name ,dm.Unit_price from DIM_MODEL dm inner join DIM_MANUFACTURER dm2 on dm.IDManufacturer =dm2.IDManufacturer 
order by dm.Unit_price asc

--Q4--END

--Q5--BEGIN

select Manufacturer_Name,dm.Model_Name,avg(ft.TotalPrice)[Average Price]  from(select top 5 dm2.IDManufacturer,dm2.Manufacturer_Name,sum(ft.Quantity)[Total Quantity]  from  DIM_MODEL dm  inner join FACT_TRANSACTIONS ft on dm.IDModel = ft.IDModel 
inner join DIM_MANUFACTURER dm2 on dm.IDManufacturer = dm2.IDManufacturer 
Group By dm2.IDManufacturer,dm2.Manufacturer_Name  
Order by [Total Quantity] desc)t5company

inner join DIM_MODEL dm on dm.IDManufacturer = t5company.IDManufacturer inner join FACT_TRANSACTIONS ft on ft.IDModel = dm.IDModel 
Group by Manufacturer_Name,dm.Model_Name
Order by [Average Price] desc

--Q5--END

--Q6--BEGIN

select dc.Customer_Name,avg(ft.TotalPrice)[Average amount Spent] from FACT_TRANSACTIONS ft inner join DIM_CUSTOMER dc on ft.IDCustomer = dc.IDCustomer 
Group By dc.Customer_Name ,year(ft.Date)
HAVING year(ft.[Date]) = '2009' and avg(ft.TotalPrice) > '500'
Order by [Average amount Spent] desc













--Q6--END
	
--Q7--BEGIN 

with t508 as (select top 5 dm.model_name from DIM_MODEL dm inner join FACT_TRANSACTIONS ft on ft.IDModel = dm.IDModel 
Group By dm.Model_Name , year(ft.[Date]) 
Having year(Date) = '2008'
Order By sum(ft.Quantity) desc),


	
t509 as (select top 5 dm.model_name from DIM_MODEL dm inner join FACT_TRANSACTIONS ft on ft.IDModel = dm.IDModel 
Group By dm.Model_Name , year(ft.[Date]) 
Having year(Date) = '2009' 
Order By sum(ft.Quantity) desc),




t510 as(select top 5 dm.model_name from DIM_MODEL dm inner join FACT_TRANSACTIONS ft on ft.IDModel = dm.IDModel 
Group By dm.Model_Name , year(ft.[Date]) 
Having year(Date) = '2010' 
Order By sum(ft.Quantity) desc)


select * from t508

intersect

select * from t509

intersect 

select * from t510



	
















--Q7--END	
--Q8--BEGIN

with top_man_0809 as(select dm2.Manufacturer_Name,year(ft.[Date])[Year],sum(ft.TotalPrice) [Total Sales],dense_rank()over(partition by year(ft.Date) order by sum(ft.TotalPrice)desc )as [Sales rank] from FACT_TRANSACTIONS ft 

inner join DIM_MODEL dm on ft.IDModel = dm.IDModel 

inner join DIM_MANUFACTURER dm2 on dm2.IDManufacturer = dm.IDManufacturer 

Group By dm2.Manufacturer_Name,year(ft.[Date])

Having year(ft.[Date]) in (2009,2010) )


select * from top_man_0809
where [Sales rank] = 2

























--Q8--END
--Q9--BEGIN

select distinct dm2.Manufacturer_Name [Manufacturer which sold cell phones 2010 but not in 2009] from FACT_TRANSACTIONS ft inner join DIM_MODEL dm on ft.IDModel  = dm.IDModel 

inner join DIM_MANUFACTURER dm2 on dm2.IDManufacturer = dm.IDManufacturer

where year(ft.[Date]) = 2010

EXCEPT 
	
select distinct dm2.Manufacturer_Name [Manufacturer which sold cell phones 2010 but not in 2009] from FACT_TRANSACTIONS ft inner join DIM_MODEL dm on ft.IDModel  = dm.IDModel 

inner join DIM_MANUFACTURER dm2 on dm2.IDManufacturer = dm.IDManufacturer

where year(ft.[Date]) = 2009

















--Q9--END

--Q10--BEGIN

with top100 as(select top 100 dc.Customer_Name,dc.IDCustomer  from FACT_TRANSACTIONS ft 

inner join DIM_CUSTOMER dc ON ft.IDCustomer = dc.IDCustomer 

Group By dc.Customer_Name,dc.IDCustomer

Order by sum(ft.TotalPrice) desc),



avgt100 as (select t.Customer_Name,year(ft.[Date])[Year],avg(ft.TotalPrice)[Average Spend] ,avg(ft.Quantity)[Average quantity],
sum(ft.TotalPrice)[Total Spend],LAG(sum(ft.TotalPrice)) OVER(partition by Customer_Name order by year(ft.[Date]))[Previous Spend] from top100 t

inner join FACT_TRANSACTIONS ft on ft.IDCustomer = t.IDCustomer 

Group by  t.Customer_Name,year(ft.[Date]))


select Customer_Name as[Top 100 Customers],[Year],[Average Spend],[Average quantity],
([Total Spend] - [Previous Spend])*100/[Previous Spend][Year over Year Percentage change in total spend]  from avgt100 



	


















--Q10--END
	