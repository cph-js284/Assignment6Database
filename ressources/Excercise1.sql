select customers.customerName, offices.city, concat(employees.firstName, ' ', employees.lastName) as SalesRep
from customers
inner join employees on employees.employeeNumber = customers.salesRepEmployeeNumber
inner join offices on offices.officeCode = employees.officeCode
where customers.city = offices.city;
