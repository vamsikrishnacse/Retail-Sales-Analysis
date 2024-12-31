CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
SELECT * FROM retail_sales;

SELECT * FROM retail_sales LIMIT 10;

--Count the totel number of rows 
SELECT COUNT(*) FROM retail_sales;
--output - 2000 rows 
select * from retail_sales order by transactions_id;

-- Data Exploration and Cleaning

SELECT * from retail_sales where transactions_id is null;
SELECT * from retail_sales where category is null;
SELECT * from retail_sales where customer_id is null;

SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
-- 155
SELECT DISTINCT category FROM retail_sales;
SELECT COUNT(DISTINCT category) FROM retail_sales;


SELECT COUNT(*) FROM retail_sales
WHERE 
    sale_date IS NULL OR
	sale_time IS NULL OR
	customer_id IS NULL OR 
    gender IS NULL OR
	age IS NULL OR
	category IS NULL OR 
    quantity IS NULL OR
	price_per_unit IS NULL OR
	cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
-- output is DELETE 13


-- Data Analysis & Findings

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:

Select * 
from retail_sales
where  sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
	AND 
	Extract(month from sale_date) = 11;

--Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category:
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

--Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP BY category,gender
ORDER BY 1;


--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
Select year,month, avg_sale 
from ( select EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1;

--Write a SQL query to find the top 5 customers based on the highest total sales :
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

--Write a SQL query to create each shift and number of orders, avg and sum of total_sales  (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
Select shift,
    COUNT(*) as total_orders ,
	avg(total_sale) as AVG_total_sales,
	sum(total_sale) as SUM_total_sales
	from (
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
	) as time_sale
group by shift
order by AVG_total_sales;

	