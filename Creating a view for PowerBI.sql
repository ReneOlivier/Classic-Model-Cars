# Creating a view for PowerBI

CREATE OR REPLACE VIEW sales_data_for_power_bi AS

SELECT
	orderdate,
    ord.orderNumber,
    p.productName,
    p.productline,
    cu.customername,
    cu.country AS customer_country,
    o.country AS office_country,
    buyprice,
    priceeach,
    quantityOrdered,
    quantityOrdered * priceeach AS sales_value,
    quantityOrdered * buyPrice AS cost_op_sales
FROM
	orders AS ord
INNER JOIN
	orderdetails AS orddet ON ord.orderNumber = orddet.orderNumber
INNER JOIN
	customers AS cu ON ord.customerNumber = cu.customerNumber
INNER JOIN
	products AS p ON orddet.productCode = p.productcode
INNER JOIN 
	employees AS emp ON cu.salesRepEmployeeNumber = emp.employeeNumber
INNER JOIN
	offices AS o ON emp.officeCode = o.officeCode
    