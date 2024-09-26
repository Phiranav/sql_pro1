--data exploration:
select * from retail_sales;


--data cleaning :
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL OR 
	sale_date IS NULL OR 
	sale_time IS NULL OR 
	customer_id IS NULL OR 
	gender IS NULL OR  
	category IS NULL OR 
	quantiy IS NULL OR 
	price_per_unit IS NULL OR 
	cogs IS NULL OR 
	total_sale IS NULL ;

DELETE FROM retail_sales
	WHERE 
	transactions_id IS NULL OR 
	sale_date IS NULL OR 
	sale_time IS NULL OR 
	customer_id IS NULL OR 
	gender IS NULL OR  
	category IS NULL OR 
	quantiy IS NULL OR 
	price_per_unit IS NULL OR 
	cogs IS NULL OR 
	total_sale IS NULL ;


--how many sales we have ?
SELECT COUNT(*) AS TOTAL_SALES FROM retail_sales;

--how many unique customer we have ?
SELECT COUNT(DISTINCT CUSTOMER_ID) FROM retail_sales;

--how many category we have?
SELECT distinct category FROM retail_sales
group by category;

--Data analysis and Business key problems with solutions:

--1. write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

--2.write a SQL query to retrieve all transactions where the category is  "clothing" and quantity sold greater than 2 the month of nov-2022
select * from retail_sales
where category = 'Clothing' and 
TO_CHAR(sale_date,'yyyy-mm') = '2022-11' AND quantiy >=2;


--3.write a sql query to calculate the total sales(total_sales) for eact category:
select distinct category,sum(total_sale), count(*) as total_orders from retail_sales
group by category;

--4.write a sql query to find the average age of customers who purchased the items from "beauty" category
select round(avg(age),0) from retail_sales where category = 'Beauty';

--5.write a sql query to find all transactions where the total_sales is greater than 1000?

select * from retail_sales
where total_sale > 1000;

--6.write a sql query to find the total number of transactions (transactions_id) made by each gender
select gender,category,count(*) from retail_sales
group by gender, category;

--7.write a sql query to calculate the average sale for month& find the best selling month

select * from 
(
	select extract(year from sale_date) as Year,
	extract(month from sale_date) as month, avg(total_sale) as AVG,
	rank() over(partition by extract(year from sale_date)  order by avg(total_sale) desc ) as Rank
	from retail_sales
	group by 1,2
) as t1 
where Rank = 1;

--8.write a sql query to find the top 5 customer based on highest sale:

select customer_id, sum(total_sale) as total_sales from retail_sales
group by customer_id
order by total_sales desc
limit(5);

--9.write a sql query to find the number of unique customer from each category:

select category,count(distinct customer_id) as unique_customer from retail_sales
group by category;

--10.write a sql query to create each shift and number of orders:

with shift_sales
as
(
	select *, case
	when extract(hour from sale_time) < 12 then 'morning'
	when extract(hour from sale_time) between 12 and 17 then 'aftenoon'
	else 'evening'
	end as shift
	from retail_sales
) 
select shift,count(*) as total_orders from shift_sales 
group by shift;

--end of project