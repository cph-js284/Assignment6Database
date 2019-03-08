ALTER TABLE `stackoverflow`.`posts` 
ADD FULLTEXT INDEX `title_idx` (`Title`) VISIBLE;
;

