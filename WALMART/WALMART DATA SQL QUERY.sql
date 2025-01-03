create database walmart;
use walmart;
-----------------------TIME OF THE DAY-------------------------------------------------------
 SELECT 
	TIME,
    (CASE
		when 'time' between "00:00:00" and "12:00:00" then "Morning"
        when 'time' between "12:00:00" and "16:00:00" then "Afternoon"
        else "Evening"
	end
	) 
    as time_of_day from walmartsales;
    
ALTER TABLE  walmartsales
ADD COLUMN time_of_day VARCHAR(20);
UPDATE walmartsales
SET time_of_day = (
CASE
		when 'time' between "00:00:00" and "12:00:00" then "Morning"
        when 'time' between "12:00:00" and "16:00:00" then "Afternoon"
        else "Evening"
END
);
    
    
    ---------DAY_NAME---------------------------------------------------------------------
    SELECT 
		date,
        dayname(date)
	from walmartsales;
    
    alter table walmartsales
    add column day_name varchar(10);
    
    update walmartsales
    set day_name = dayname(date);
    ---------------------------------------------------------------------------------------
    
    -----------------MONTHNAME------------------------------------------------------------
    
    SELECT
		DATE,
        MONTHNAME(DATE)
	FROM walmartsales;
    
    ALTER TABLE walmartsales
    ADD COLUMN month_name varchar(15)
    
    update walmartsales
    set month_name = monthname(date);
    
    --------------------------------------------------------------------------------------
    ---------------------------------GENERAL QUESTIONS-------------------------------------
    HOW MANY UNIQUE CITIES DOES THE DATA HAVE?
    select distinct city
    from walmartsales;
    
    NAME THE BRANCHES.
    select distinct branch
    from walmartsales;
    
    ------------------------------PRODUCT BASED QUESTIONS----------------------------------
  HOW MANY UNIQUE PRODUCT LINES DOES THE DATA HAVE?
  select distinct Productline
  from walmartsales;
  
  WHAT IS THE MOST COMMON PAYMENT METHOD?
  select payment
  from walmartsales;
  
  select payment,
  count(payment) as cnt
  from walmartsales
  group by payment
  order by cnt desc;
  
  WHAT IS THE MOST SELLING PRODUCT LINE?
  select *  from walmartsales;
  select Product_line,
  count(Product_line) as cnt
  from walmartsales
  group by Product_line
  order by cnt desc;
  
WHAT IS THE TOTAL REVENUE BY MONTH?
select month_name as month
from walmartsales;

  select month_name as month
  sum(total) as totalrevenue
	from walmartsales
    group by month_name
    order by totalrevenue;
    
WHICH MONTH HAD LARGEST COGS?
select month_name as month
  max(cogs) as cogs
	from walmartsales
    group by month_name
    order by cogs desc;
    
WHICH PRODUCT HAD THE LARGEST REVENUE?
SELECT
	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

NAME THE CITY WITH LARGEST REVENUE.
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;


LARGEST VAT CONTAINING PRODUCT
SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;


CATEGORISE PRODUCT AS GOOD OR BAD

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


NAME THE BRANCH WHICH SOLD MORE PRODUCTS
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


MOST COMMON PRODUCT BY GENDER
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

AVG RATING OF PRODUCT?
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

------------------------------------------------------------------------------------------

---------------------------CUSTOMER BASED QUESTIONS------------------------------------------ --------------------------------------------------------------------

UNIQUE CUSTOMERS?
SELECT
	DISTINCT customer_type
FROM sales;

UNIQUE PAYMENT METHOD?
SELECT
	DISTINCT payment
FROM sales;


MOST COMMON CUSTOMER TYPE?
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

TYPE OF CUSTOMER WHO BUYS MOST PRODUCTS?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;


TYPE OF GENDER WHO BUYS MOST PRODUCTS AS CUSTOMERS?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

GENDER DISTRIBUTION PER BRANCH?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

WHICH TIME OF THE DAY CUSTMERS GIVE MOST RATINGS?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


WHICH TIME OF THE DAY CUSTMERS GIVE MOST RATINGS BY BRANCH?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


HIGHEST AVG RATING BY DAY
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings

WHICH DAY OF THE WEEK HAS BEST RATINGS
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;
-------------------------------------SALES BASED QUESTIONS--------------------------------

NO OF SALES MADE IN EACH DAY 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
Evenings experience most sales, the stores are filled during the evening hours

THE TYPE OF CUSTOMER WHO BRINGS MOST OF REVENUE
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

CITY WHICH HAS LARGEST TAX
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

TYPE OF CUSTOMER WHO PAYS MOST IN VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;
