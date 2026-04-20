create database Bharatkart;
Use Bharatkart;
select * from sales;



-- 1. What is the total revenue, total number of orders, and average order value?
SELECT  SUM(order_value) AS total_revenue,
COUNT(order_id) AS total_orders,
ROUND(AVG(order_value),2) AS average_order_value 
FROM sales;

-- 2. Which cities generate the highest revenue (excluding 'Unknown')?
SELECT city, SUM(order_value) AS total_revenue 
FROM sales
WHERE city <> 'Unknown'
GROUP BY city
ORDER BY  total_revenue DESC;

-- 3. Which product categories contribute the most to overall revenue?
SELECT product_category, SUM(order_value) AS total_revenue
FROM sales
WHERE product_category <> 'Unknown'
GROUP BY product_category	 
ORDER BY total_revenue DESC; 
-- 4. How does revenue vary month-wise over time?
SELECT month, year, SUM(order_value) AS total_revenue
FROM sales
GROUP BY month, year 
ORDER BY year, month;

-- 5. Who are the top 5 customers based on total spending?
SELECT DISTINCT(customer_id) AS customer_id, customer_name, SUM(order_value) AS total_revenue
FROM sales 
WHERE customer_name <>'Unknown' 
GROUP BY customer_id, customer_name 
ORDER BY total_revenue desc
limit 5;
--  6. Which customers have placed more than one order?
SELECT customer_id, customer_name, COUNT(order_id) AS total_order
FROM sales
GROUP BY customer_id, customer_name
HAVING COUNT(order_id) > 1
ORDER BY total_order DESC;
-- 7. Find customers whose total spending is above the average order value .
SELECT customer_id, customer_name, SUM(order_value) AS total_value
FROM sales
GROUP BY customer_id,customer_name
HAVING SUM(order_value) > (SELECT AVG(order_value) FROM sales)
ORDER BY total_value DESC; 
-- 8. Create delivery time buckets (Fast, Medium, Slow) and find the average rating for each
WITH delivery_bucket AS (
SELECT *,
CASE WHEN delivery_days <= 3 THEN 'Fast'
WHEN delivery_days <= 7 THEN 'Medium'
ELSE 'Slow'
END AS delivery_type FROM sales)
SELECT delivery_type, AVG(rating) AS avg_rating FROM delivery_bucket
GROUP BY delivery_type;

-- 9. Compare average order value of each product category with overall average 
SELECT product_category, ROUND(AVG(order_value),2) AS  category_avg, (SELECT ROUND(AVG(order_value),2) FROM sales) AS overall_avg
FROM sales 
GROUP BY product_category 
ORDER BY category_avg DESC;

-- 10. Segment customers into repeat and one-time buyers and compare their total revenue contribution and average order value.
WITH customer_order AS ( 
SELECT customer_id, customer_name,
COUNT(order_id) AS total_order,
SUM(order_value) AS total_revenue,
AVG(order_value) AS avg_order_value
FROM sales
GROUP BY customer_id, customer_name)
SELECT 
CASE WHEN total_order > 1 THEN 'Repeat Customer'
ELSE 'One-Time Customer'
END AS customer_type,
COUNT(customer_id) AS total_customer,
SUM(total_revenue) AS revenue_contribution,
AVG(avg_order_value) AS average_order_value
FROM customer_order
GROUP BY customer_type
ORDER BY revenue_contribution DESC;