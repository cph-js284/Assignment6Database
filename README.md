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
```
ALTER TABLE `classicmodels`.`offices` 
ADD INDEX `cityInx` (`city` ASC) VISIBLE;
;

ALTER TABLE `classicmodels`.`customers` 
ADD INDEX `CustCityInx` (`city` ASC) VISIBLE;
;
```
These scripts adds an index on the city-columns in the offices and customers tables<br>
The executionplan below documents the increase in performance; *the cost to perform the query is lower(fewer bananas)*

![Eplan2_optimized](https://github.com/cph-js284/Assignment6Database/blob/master/ressources/ExecutionPlanOptimized.png)

---------------------------------------------------------------------------------------------------------------------
# Excercise 3
*We want to find out how much each office has sold and the max single payment for each office. Write two queries which give this information*

Query A
````
select offices.officeCode, sum(payments.amount), max(payments.amount)
from offices
inner join employees on offices.officeCode = employees.officeCode
inner join customers on employees.employeeNumber = customers.salesRepEmployeeNumber
inner join payments on customers.customerNumber = payments.customerNumber
group by offices.officeCode;
````
The executionplan for query A:
![Eplan3A](https://github.com/cph-js284/Assignment6Database/blob/master/ressources/ExecutionPlan_groupby.png)


Query B
````
select offices.officeCode, 
sum(payments.amount) over (partition by offices.officeCode), 
max(payments.amount) over (partition by offices.officeCode)
from offices
inner join employees on offices.officeCode = employees.officeCode
inner join customers on employees.employeeNumber = customers.salesRepEmployeeNumber
inner join payments on customers.customerNumber = payments.customerNumber
````
The executionplan for query B:
![Eplan3B](https://github.com/cph-js284/Assignment6Database/blob/master/ressources/ExecutionPlan_window.png)

*Not sure what's going on here I was under the impression that windowing would be cheaper - I Even tried slimming the windowed query down futher, but as the image shows that only brings it to 273, which is still more expensive*
Query B (alternativ - using the DISTINCT in the SELECT-statement)<br>
![Eplan3B_alternativ](https://github.com/cph-js284/Assignment6Database/blob/master/ressources/Excercise3_window_v2_273.png)

----------------------------------------------------------------------------------------------------------------------
# Excercise 4
*In the stackexchange forum for coffee (coffee.stackexchange.com), write a query which return the displayName and title of all posts which with the word groundsin the title.*
````
select posts.Title, users.DisplayName 
from posts
inner join users on posts.OwnerUserId = users.Id
where posts.Title like '%grounds%'
````
The executionplan:
![Eplan4](https://github.com/cph-js284/Assignment6Database/blob/master/ressources/ExecutionPlan_withjoin.png)

*To document the cost on the join, we remove the join and use the OwnerUserId instead to identify the users*
```
select posts.Title, posts.OwnerUserId
from posts
where posts.Title like '%grounds%'
```
The executionplan without the join:
![Eplan4](https://github.com/cph-js284/Assignment6Database/blob/master/ressources/ExecutionPlan_nojoin.png)

The difference in cost between the two plans are negligible

---------------------------------------------------------------------------------------------------------------------
# Excercise 5
*Add a full text index to the posts table and change the query from exercise 4 so it no longer scans the entire posts table.*
To add the fullTextIndex the following statement is excuted:
```
ALTER TABLE `stackoverflow`.`posts` 
ADD FULLTEXT INDEX `title_idx` (`Title`) VISIBLE;
;
```
To make use of the fullTextIndex the following statement is excuted:
*(this is the query from Ex4 without the join)*
```
select posts.Title, posts.OwnerUserId
from posts
where match (posts.Title)
against ('grounds' in boolean mode)
```
*If you were to run this using a natual language search, you would simply replace the boolean keyword. Running the query in boolean mode enables the usage of special characters in the query*

The executionplan clearly shows the difference 
![Eplan4](https://github.com/cph-js284/Assignment6Database/blob/master/ressources/ExecutionPlan_withFullTextIdx.png)


----------------------------------------------------------------------------------------------------------------------
# Clean-up
If you did indeed use my script to setup the docker container with mysql, you can remove it by typing
```
sudo docker rm -f mysql01
```



