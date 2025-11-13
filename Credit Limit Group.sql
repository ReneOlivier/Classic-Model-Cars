#Credit Limit group Exercise

WITH sales AS
(
SELECT 
t1.ordernumber,
t1.customernumber,
productcode,
quantityordered,
priceeach,
priceeach * quantityordered AS Sales_Value,
creditlimit 
FROM orders T1
INNER JOIN orderdetails T2 ON t1.ordernumber = t2.ordernumber
INNER JOIN customers t3 ON t1.customernumber = t3.customernumber
)

SELECT 
ordernumber,
customernumber,
CASE 
WHEN creditlimit < 75000 THEN "a: Less than 75k"
WHEN creditlimit BETWEEN 75000 AND 100000 THEN "b: 75k - 100k"
WHEN creditlimit BETWEEN 100000 AND 150000 THEN "c: 100k - 150k"
WHEN creditlimit > 150000 THEN "d: Over 150k"
ELSE "other"
END AS creditlimit_grp,
SUM(Sales_Value) AS Sales_Value
FROM sales
GROUP BY ordernumber, customernumber, creditlimit_grp
