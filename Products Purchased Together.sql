#Products purchased together Exercise

WITH prod_sales AS
(
SELECT ordernumber, orderdetails.productCode, productline
FROM orderdetails
INNER JOIN products	ON orderdetails.productCode = products.productCode
)

SELECT distinct t1.ordernumber, t1.productline AS prod_1, t2.productline AS pro_2
FROM prod_sales t1
LEFT JOIN prod_sales t2 ON t1.ordernumber = t2.ordernumber 
AND t1.productline != t2.productline
