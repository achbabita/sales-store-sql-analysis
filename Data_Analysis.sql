
select * from sales ;


-- Data Analysis

-- 1. What are the top 5 most selling products by quantity?

	--Business Problem: We don't know which products are most in demand.

	--Business Impact: Helps prioritize stock and boost sales through targeted promotions.

select Top 5 product_name, SUM(quantity) as total_quantity_sold
from sales
where status = 'delivered'
Group By product_name
order by total_quantity_sold

-- 2. Which products are most frequently cancelled?

	--Business Problem: Frequent cancellations affect revenue and customer trust.

	--Business Impact: Identify poor-performing products to improve quality or remove from catalog.

select Top 5 product_name, count(*) as total_cancelled
from sales
where status = 'cancelled'
group by product_name
ORDER BY total_cancelled DESC;


-- 3. What time of the day has the highest number of purchases?

	--Business Problem Solved: Find peak sales times.

	--Business Impact: Optimize staffing, promotions, and server loads.
select 
 CASE
  WHEN DATEPART(HOUR, time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT'
  WHEN DATEPART(HOUR, time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
  WHEN DATEPART(HOUR, time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
  WHEN DATEPART(HOUR, time_of_purchase) BETWEEN 18 AND 23 THEN 'EVENING'
 END AS time_of_the_day,
 COUNT(*) As total_orders

from sales

GROUP BY 
CASE
  WHEN DATEPART(HOUR, time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT'
  WHEN DATEPART(HOUR, time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
  WHEN DATEPART(HOUR, time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
  WHEN DATEPART(HOUR, time_of_purchase) BETWEEN 18 AND 23 THEN 'EVENING'
 END

 ORDER BY total_orders DESC ;


 -- 4. Who are the top 5 highest spending customers?

	--Business Problem Solved: Identify VIP customers.

	--Business Impact: Personalized offers, loyalty rewards, and retention.


 select TOP 5 customer_name, 
  FORMAT(SUM(price*quantity),'C0', 'en-IN') As total_spending
 from sales
 group by customer_name
 Order By SUM(price*quantity) DESC ;


 -- 5. Which product categories generate the highest revenue?

	--Business Problem Solved: Identify top-performing product categories.

	--Business Impact: Refine product strategy, supply chain, and promotions.
	--allowing the business to invest more in high-margin or high-demand categories.


 select product_category, 
  FORMAT(SUM(price*quantity),'C0', 'en-IN') As Revenue
 FROM sales
 group by product_category 
 order by SUM(price*quantity) DESC

 -- 6. What is the return/cancellation rate per product category?

	 --Business Problem Solved: Monitor dissatisfaction trends per category.


	---Business Impact: Reduce returns, improve product descriptions/expectations.
	--Helps identify and fix product or logistics issues.

 -- Cancellation

 select product_category,
	
	FORMAT( COUNT(
	CASE WHEN status='cancelled' THEN 1 END) *100.0 / COUNT(*), 'N3') + '  %'
	AS cancelled_percent
	FROM sales
	GROUP BY product_category
	ORDER BY cancelled_percent DESC ;


	-- Return

	select product_category,
	
	FORMAT( COUNT(
	CASE WHEN status='returned' THEN 1 END) *100.0 / COUNT(*), 'N3') + '  %'
	AS returned_percent
	FROM sales
	GROUP BY product_category
	ORDER BY returned_percent DESC ;


 -- 7. Which is the most preferred payment mode ?

	--Business Problem Solved: Know which payment options customers prefer.

	--Business Impact: Streamline payment processing, prioritize popular modes.


 Select payment_mode, count(payment_mode) as payment_mode_used
 from sales 
 Group BY payment_mode
 ORDER BY payment_mode_used DESC ;


 -- 8. How does age group affect purchasing behavior?

	--Business Problem Solved: Understand customer demographics.

	--Business Impact: Targeted marketing and product recommendations by age group.

	SELECT MIN(Customer_age), MAX(customer_age)
	from sales


	SELECT 
		CASE
			WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
			WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
			WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
			ELSE '51+'
		END As customer_age,
		FORMAT(SUM(price*quantity), 'C0', 'en-IN') AS total_purchase

from sales
Group by CASE
			WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
			WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
			WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
			ELSE '51+'
		END 
order by SUM(price*quantity) DESC ;


-- 9. What’s the monthly sales trend?

	--Business Problem: Sales fluctuations go unnoticed.

	--Business Impact: Plan inventory and marketing according to seasonal trends.


-- Method 1

SELECT 
	FORMAT(purchase_date, 'yyyy-MM') AS Month_Year,
	FORMAT(SUM(price*quantity), 'C0', 'en-IN' )AS total_sales,
	SUM(quantity) AS total_quantity

From sales
Group By format(purchase_date, 'yyyy-MM')


-- Method 2

Select 
	YEAR(purchase_date) As Year,
	MONTH(purchase_date) AS Month,
	FORMAT(SUM(price*quantity), 'C0', 'en-IN' )AS total_sales,
	SUM(quantity) AS total_quantity

From sales
GROUP BY YEAR(purchase_date), MONTH(purchase_date)
ORDER BY Month ;


-- 10. Are certain genders buying more specific product categories?

	--Business Problem Solved: Gender-based product preferences.

	--Business Impact: Personalized ads, gender-focused campaigns.

	-- Method 1

	SELECT gender, product_category, count(product_category) AS total_purchase
	FROM sales
	GROUP BY  gender, product_category
	ORDER BY gender ;


	-- Method 2

	SELECT *
	FROM (
			SELECT gender, product_category
			from sales
			) as source_table
	
	PIVOT (
	COUNT(gender)
	FOR gender IN ([M],[F])
	) AS pivot_table
ORDER BY product_category ;

