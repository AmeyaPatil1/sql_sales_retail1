Create Table retail_sales
       (
       transactions_id	int primary key,
	   sale_date date,	
	   sale_time time,	
	   customer_id int,
	   gender varchar(20),	
	   age int,	
	   category	varchar(20),
	   quantiy int,
	   price_per_unit float,
	   cogs float,
	   total_sale float
	   )

select * from retail_sales;

select count(*) from retail_sales;

--
select * from retail_sales
where transactions_id is null;

select * from retail_sales
where sale_date is null;

select * from retail_sales
where sale_time is null;

select * from retail_sales
where 
      transactions_id is null
      or
	  sale_date is null
	  or
	  sale_time  is null
	  or
	  gender is null
	  or 
	  category is null
	  or
	  quantiy is null
	  or
	  cogs is null
	  or 
	  total_sale is null;

--
delete from retail_sales
where 
      transactions_id is null
      or
	  sale_date is null
	  or
	  sale_time  is null
	  or
	  gender is null
	  or 
	  category is null
	  or
	  quantiy is null
	  or
	  cogs is null
	  or 
	  total_sale is null;

select count(*) from retail_sales;

--Data Exploration

-- How many sales we have?
select count(*) as total_sale from retail_sales

-- How many unique customers we have?
select count(distinct customer_id) as total_sale from retail_sales

-- How many catgories we ahve?
select distinct category from retail_sales

-- Data analysis and Business key problems and answers

--q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail_sales
where sale_date='2022-11-05';

--q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 
--in the month of Nov-2022:
select * from retail_sales
where category='Clothing' 
      and
	  to_char(sale_date, 'yyyy-mm')='2022-11'
	  and
	  quantiy >=4;

--Q3. Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT CATEGORY, SUM(TOTAL_SALE) AS TOTAL_SALES, COUNT(CATEGORY) AS TOTAL_ORDER
FROM RETAIL_SALES
GROUP BY 1

--Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT ROUND(AVG(AGE),2) AS avg_age
FROM RETAIL_SALES
WHERE CATEGORY='Beauty';

--q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * FROM RETAIL_SALES
WHERE TOTAL_SALE>1000;

--Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT CATEGORY, gender, count(*)
FROM RETAIL_SALES
GROUP BY CATEGORY, gender 
order by category

--q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT YEAR, MONTH, AVG_SALE FROM
(
SELECT 
     EXTRACT(YEAR FROM SALE_DATE) AS YEAR, 
	 EXTRACT(MONTH FROM SALE_DATE)AS MONTH, 
	 AVG(TOTAL_SALE) AS AVG_SALE,
	 RANK() OVER(PARTITION BY EXTRACT(YEAR FROM SALE_DATE) ORDER BY AVG(TOTAL_SALE) DESC) AS RANK
FROM RETAIL_SALES
GROUP BY 1, 2 
) AS T1
WHERE RANK=1;
--ORDER BY 1, 3 DESC

--Q8. Write a SQL query to find the top 5 customers based on the highest total sales:
select Customer_id, SUM(TOTAL_SALE) as net_sales
FROM RETAIL_SALES
group by 1
order by 2 DESC
limit 5

--q9. Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT CATEGORY, count(distinct(Customer_id))
FROM RETAIL_SALES
GROUP BY 1 

--q10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH HOURLY_SALES AS
(
SELECT *,
     CASE
	     WHEN EXTRACT(HOUR FROM SALE_TIME)<12 THEN 'MORNING'
		 WHEN EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		 ELSE 'EVENING'
		 END AS SHIFTS
FROM RETAIL_SALES		 
) 
SELECT COUNT(*) AS TOTAL_ORDERS, SHIFTS FROM HOURLY_SALES
GROUP BY SHIFTS