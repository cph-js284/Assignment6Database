# Assignment6Database
This is the 6th assignment for PBA database soft2019spring

# what it is
This is a collection of sql-scripts that is meant to be run against the classicmodels- and coffee.stackexchange databases.<br>
*For my setup I ran Mysql in a docker container using the latest image*

--------------------------------------------------------------------------------------------------------------------
# Setup
For setup feel free to copy this small script [setupMySql](https://github.com/cph-js284/MySqlSetup) - or by any other means
get an MySql database up and running and then copy the scripts directly into the mysql-shell

-----------------------------------------------------------------------------------------------------------------------

# Excercise 1
*In the classicmodels database, write a query that picks out those customers who are in the same city as office of their sales representative.*<br>
```
select customers.customerName, offices.city, concat(employees.firstName, ' ', employees.lastName) as SalesRep
from customers
inner join employees on employees.employeeNumber = customers.salesRepEmployeeNumber
inner join offices on offices.officeCode = employees.officeCode
where customers.city = offices.city;
```
As documented in the image below, the main problem with this query is the *full table scan* performed on the offices table<br>

![Eplan1](https://github.com/cph-js284/Assignment6Database/blob/master/ressources/ExecutionPlan.png)

----------------------------------------------------------------------------------------------------------------------
# Excercise 2
*Change the database schema so that the query from exercise get better performance.*


----------------------------------------------------------------------------------------------------------------------
# Clean-up
If you did indeed use my script to setup the docker container with mysql, you can remove it by typing
```
sudo docker rm -f mysql01
```



