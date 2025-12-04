
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );
SELECT * FROM retail_sales
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

DELETE FROM retail_sales
	WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

--Data Exploration
--1 how many sales we have
SELECT COUNT(*) FROM retail_sales

--2 how many unique customers we have
SELECT count(DISTINCT customer_id) FROM retail_sales

--3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

--4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'


--5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
	customer_id,
	SUM(total_sale) as total_sales,
	DENSE_RANK() OVER(ORDER BY SUM(total_sale) desc) as rank
from retail_sales
GROUP BY customer_id

--7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM 
(SELECT 
	EXTRACT(MONTH FROM sale_date) AS month,
	EXTRACT(YEAR FROM sale_date) AS year,
	AVG(total_sale) as average_sale,
	DENSE_RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1,2
ORDER BY 1,3
) as t
where t.rank = 1

--8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT * FROM 
(select 
	customer_id,
	SUM(total_sale) as total_sales,
	DENSE_RANK() OVER(ORDER BY SUM(total_sale) desc) as rank
from retail_sales
GROUP BY customer_id ) AS t
WHERE t.rank<=5

--9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
 	category,
	COUNT(DISTINCT customer_id),
	COUNT(customer_id)
FROM retail_sales
GROUP BY category

--10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT 
	shifting,
	COUNT(*)
FROM (SELECT 
     *,
     CASE
	    WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shifting
FROM retail_sales ) AS t
GROUP BY t.shifting




