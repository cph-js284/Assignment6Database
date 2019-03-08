ALTER TABLE `classicmodels`.`offices` 
ADD INDEX `cityInx` (`city` ASC) VISIBLE;
;

ALTER TABLE `classicmodels`.`customers` 
ADD INDEX `CustCityInx` (`city` ASC) VISIBLE;
;

