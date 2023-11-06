
select * from human;

alter table human drop column ï»¿id;
alter table human drop column abcd;

alter table human add column employee_id int auto_increment primary key first;

desc human;

-- changing the date format of birthdate to YYYY-MM-DD
UPDATE human
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

-- changing the datatype of birthdate to date
alter table human modify birthdate date;


-- changing the date format of hire_date to YYYY-MM-DD
UPDATE human
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

-- changing the datatype of hire_date to date type
alter table human modify hire_date date;

-- changing the datatype of termdate to date type and removing the UTC time
UPDATE human
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != ' ';

select * from human;

ALTER TABLE human
MODIFY COLUMN termdate DATE;

-- creating a new age column using birthdate
alter table human add column age int;

ALTER TABLE human ADD COLUMN age INT(11) AS (DATEDIFF(CURDATE(), birthdate) / 365);

alter table human drop age_column;

ALTER TABLE human ADD COLUMN age_column INT;
UPDATE human
SET age_column = timestampdiff(YEAR, birthdate, CURDATE());

--multiply the age column with -1 to convert the negative values to positive
UPDATE human SET age_column = age_column * -1 WHERE age < 0;






