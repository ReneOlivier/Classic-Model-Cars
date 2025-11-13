#Sales by Customer Country Exercise

WITH main_cte AS(
SELECT 
t1.ordernumber,
t2.productcode,
t2.quantityordered,
t2.priceeach,
quantityordered * priceeach AS sales_value,
t3.city AS customer_city,
t3.country AS customer_country,
t4.productline,
t6.city AS office_city,
t6.country AS office_country
FROM orders AS t1
INNER JOIN orderdetails AS t2 ON t1.ordernumber = t2.ordernumber
INNER JOIN customers AS t3 ON t1.customernumber = t3.customernumber
INNER JOIN products AS t4 ON t2.productCode = t4.productcode
INNER JOIN  employees AS t5 ON t3.salesRepEmployeeNumber = t5.employeeNumber
INNER JOIN offices AS t6 ON t5.officeCode = t6.officeCode
)

SELECT 
ordernumber,
customer_city,
customer_country,
productline,
office_city,
office_country,
SUM(sales_value) as sales_value
FROM main_cte
GROUP BY ordernumber,customer_city,customer_country,productline,office_city,office_country