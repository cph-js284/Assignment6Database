select offices.officeCode, 
sum(payments.amount) over (partition by offices.officeCode), 
max(payments.amount) over (partition by offices.officeCode)
from offices
inner join employees on offices.officeCode = employees.officeCode
inner join customers on employees.employeeNumber = customers.salesRepEmployeeNumber
inner join payments on customers.customerNumber = payments.customerNumber
