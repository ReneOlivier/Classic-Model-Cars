#Sales Value change from previous order Exercise

WITH main_cte AS (

SELECT ordernumber,orderdate,customernumber, SUM(sales_value) AS Sales_Value
FROM 
(SELECT t1.ordernumber, orderdate, customernumber, productCode, quantityordered * priceeach AS sales_value
FROM orders AS t1
INNER JOIN orderdetails AS t2 ON t1.ordernumber = t2.ordernumber) main
GROUP BY ordernumber,orderdate,customernumber
),

sales_query AS(

SELECT t1.*, t2.customerName, ROW_NUMBER() OVER(PARTITION BY customername ORDER BY orderdate) AS Purchase_Number,
LAG(sales_value) OVER(PARTITION BY customername ORDER BY orderdate) AS Previous_Sales_Value
FROM main_cte AS t1
INNER JOIN customers AS t2 ON t1.customernumber = t2.customernumber
)

SELECT *, sales_value - previous_sales_value AS purchase_value_change
FROM sales_query
WHERE previous_sales_value IS NOT NULL