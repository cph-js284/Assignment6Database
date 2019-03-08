select offices.officeCode, sum(payments.amount), max(payments.amount)
from offices
inner join employees on offices.officeCode = employees.officeCode
inner join customers on employees.employeeNumber = customers.salesRepEmployeeNumber
inner join payments on customers.customerNumber = payments.customerNumber
group by offices.officeCode;


