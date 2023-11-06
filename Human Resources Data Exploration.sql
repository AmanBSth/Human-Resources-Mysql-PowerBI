select * FROM human;
--What is the age distribution of the employees?
select age, count(*) as count from human group by age order by age;
-- How many employees work at headquarters versus remote locations?
select location, count(*) as count from human group by location order by location;

-- Which department has the highest turnover rate?
select department, count(*) as count from human where termdate is not null group by department order by count desc limit 1;

-- What is the average length of employment for employees who have been terminated? Subtract term date and hire date to get the length of employment. Convert it into year(termdate)s
select avg(datediff(termdate, hire_date)/365) as avg_length_of_employment from human where termdate is not null;

--  What is the age distribution of employees in the company?
select age_column, count(*) as count from human group by age_column order by age_column;

-- which age has the highest count?
select age_column, count(*) as count from human group by age_column order by count desc limit 1;

-- What is the average age of employees in the company?
select avg(age_column) as avg_age from human;

-- What is the average age of employees in the company by department?
select department, avg(age_column) as avg_age from human group by department;

-- In which year most employess left the compnay?
select year(termdate) as year, count(*) as count from human where termdate is not null and termdate > '0000-00-00' group by year order by count desc limit 1;

--What is the distribution of employees across locations by city and state?
select location_city, location_state, count(*) as count from human group by location_city, location_state order by count desc;

-- How many were termianted by each years?
select year(termdate) as year, count(*) as count from human where termdate is not null and termdate > '0000-00-00' group by year order by year;

-- Adding a column of termianted number of people by year in the dataset
UPDATE human AS h
JOIN (
    SELECT YEAR(termdate) AS year, COUNT(*) AS count
    FROM human
    WHERE termdate IS NOT NULL AND termdate > '0000-00-00'
    GROUP BY year
) c
ON YEAR(h.termdate) = c.year
SET h.count = c.count;

-- how many were termiante in year 2029?
select count(*) as count from human where termdate is not null and termdate > '0000-00-00' and year(termdate) = 2029;
-- Finding the remaining people after termination
SELECT 
    YEAR(hire_date) AS year, 
    COUNT(*) AS hired_count, 
    count(count) AS terminated_count,
    COUNT(*) - count(count) AS remaining_count
FROM 
    human
GROUP BY 
    YEAR(hire_date)
ORDER BY 
    YEAR(hire_date)