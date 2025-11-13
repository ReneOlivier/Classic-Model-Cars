# Customers Over Credit limit


WITH cte_sales AS(
SELECT 
orderdate,
t1.ordernumber,
t1.customernumber,
customername,
productcode,
creditlimit,
quantityordered * priceeach AS sales_value
FROM orders AS t1
INNER JOIN orderdetails AS t2 ON t1.ordernumber = t2.ordernumber
INNER JOIN customers AS t3 ON t1.customerNumber = t3.customernumber
),

running_total_sales_cte AS(
SELECT *, LEAD(orderdate) OVER(PARTITION BY customernumber ORDER BY orderdate) AS next_order_date
FROM( 
SELECT 
orderdate,
ordernumber,
customernumber,
customername,
creditlimit,
SUM(sales_value) AS sales_value
FROM cte_sales
GROUP BY orderdate, ordernumber, customernumber, customername, creditlimit
) subquery
),

payments_cte AS (
SELECT *
FROM payments
),

main_cte AS(
SELECT t1.*,
SUM(sales_value) OVER(PARTITION BY t1.customernumber ORDER BY paymentdate) AS running_total_sales,
SUM(amount) OVER(PARTITION BY t1.customernumber ORDER BY orderdate) AS running_total_payments
FROM running_total_sales_cte AS t1
LEFT JOIN payments_cte AS t2 ON t1.customernumber = t2.customernumber 
AND t2.paymentdate BETWEEN t1.orderdate AND CASE 
WHEN t1.next_order_date IS NULL THEN current_date() 
ELSE next_order_date 
END
)

SELECT *, running_total_sales - running_total_payments AS money_owed,
creditlimit - (running_total_sales - running_total_payments) AS difference
FROM main_cte








