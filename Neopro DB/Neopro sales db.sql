-- Task1
-- 1. create a new database “Neopro” and activate it to store database object such as tables.
-- 2. create 3 different tables - sales, marketing and accounts and each table should have employee_id, first name, last name, gender and age.
-- 3. add proficiencylevel column to all the tables using alter command and set proficiencylevel column default =1
-- 4. In each table we have to alter employee_id with primarykey constraint
-- 5. We have to alter the proficiencylevel column in each table with check constraint and the proficiencylevel of employees should be between 1 and 5
-- 6. We have to modify the age column in each table with check constraint and the age of employees should be between 21 and 55
-- 7. Add a new table called as project in that table add the columns, project id primary key, project name, project duration, project client name.
-- 8. add a column project id in each of the first three tables on sales, marketing and accounts.
-- 9. each of the project id from these three tables will refer to project id of project table
-- 10. add a new column work location with default location being unknown in the project table

CREATE DATABASE NEOPRO;
USE NEOPRO;
CREATE TABLE SALES(
EMPLOYEE_ID varchar(255),
FIRST_NAME VARCHAR(255),
LAST_NAME VARCHAR(255),
GENDER varchar(255),
AGE INT
);
ALTER TABLE SALES ADD COLUMN PROFICIENCY_LEVEL INT DEFAULT 1;
ALTER TABLE SALES ADD PRIMARY KEY (EMPLOYEE_ID);
ALTER TABLE SALES ADD CONSTRAINT chk_p_level CHECK (PROFICIENCY_LEVEL BETWEEN 1 AND 5);
ALTER TABLE SALES ADD CHECK (AGE BETWEEN 21 AND 55 );
ALTER TABLE SALES ADD COLUMN PROJECT_ID varchar(255) NOT NULL ;
ALTER TABLE SALES ADD FOREIGN KEY (PROJECT_ID) REFERENCES PROJECT(PROJECT_ID);



CREATE TABLE MARKETING(
EMPLOYEE_ID varchar(255),
FIRST_NAME VARCHAR(255),
LAST_NAME VARCHAR(255),
GENDER varchar(255),
AGE INT
);
ALTER TABLE MARKETING ADD PROFICIENCY_LEVEL INT DEFAULT 1;
ALTER TABLE MARKETING ADD PRIMARY KEY (EMPLOYEE_ID);
ALTER TABLE MARKETING ADD CONSTRAINT chk_proficiency_level CHECK (PROFICIENCY_LEVEL BETWEEN 1 AND 5);
ALTER TABLE MARKETING ADD CHECK (AGE BETWEEN 21 AND 55 );
ALTER TABLE MARKETING ADD COLUMN PROJECT_ID varchar(255) NOT NULL ;
ALTER TABLE MARKETING ADD FOREIGN KEY (PROJECT_ID) REFERENCES PROJECT(PROJECT_ID);


CREATE TABLE ACCOUNTS(
EMPLOYEE_ID varchar(255),
FIRST_NAME VARCHAR(255),
LAST_NAME VARCHAR(255),
GENDER varchar(255),
AGE INT
);
ALTER TABLE ACCOUNTS ADD PROFICIENCY_LEVEL INT DEFAULT 1;
ALTER TABLE ACCOUNTS ADD PRIMARY KEY (EMPLOYEE_ID);
ALTER TABLE ACCOUNTS ADD CONSTRAINT chk_p_L CHECK (PROFICIENCY_LEVEL BETWEEN 1 AND 5);
ALTER TABLE ACCOUNTS ADD CHECK (AGE BETWEEN 21 AND 55 );
ALTER TABLE ACCOUNTS ADD COLUMN PROJECT_ID varchar(255) NOT NULL ;
ALTER TABLE ACCOUNTS ADD FOREIGN KEY (PROJECT_ID) REFERENCES PROJECT(PROJECT_ID);


CREATE TABLE PROJECT(
PROJECT_ID VARCHAR(255) NOT NULL PRIMARY KEY,
PROJECT_NAME VARCHAR(255) NOT NULL,
PROJECT_DURATION VARCHAR(255),
CLIENT_NAME VARCHAR(255)
);
ALTER TABLE PROJECT ADD WORK_LOCATION VARCHAR(255) DEFAULT 'UNKNOWN';
INSERT INTO PROJECT(PROJECT_ID,PROJECT_NAME,PROJECT_DURATION,CLIENT_NAME,WORK_LOCATION) values
('PR12345','Medicene Analysis','30 Days','Pharmeasy','India'),
('PR12346','Agricultural safety analysis','90 Days','Beta Agro','USA'),
('PR12347','Tesla Power Plant','180 Days','Tesla ltd','Australia'),
('PR12348','Genysis Model','365 Days ','AItech','California'),
('PR12349','Sales analysis','30 Days','Samsung','Mexico');


-- DML insert Update delete
-- Task1 cont...
-- 11. Insert 10 values into Sales Tables the sales employee id begins this NEOS101
-- 12. Insert 10 values into marketing Tables the sales employee id begins this NEOM101
-- 13. Insert 10 values into account Tables the sales employee id begins this NEOA101

INSERT INTO SALES VALUES
('NEOS101', 'Shahzeb', 'Ali', 'Male', 22, 5,'PR12348'),
('NEOS102', 'Jack', 'Ramson', 'Male', 38, 4,'PR12345'),
('NEOS103', 'Thomas', 'Grant', 'Male', 31, 3,'PR12346'),
('NEOS104', 'Jennifer', 'Ralph', 'Female', 26, 3,'PR12348'),
('NEOS105', 'Nicola', 'James', 'Male', 40, 5,'PR12347'),
('NEOS106', 'Daniel', 'Brian', 'Male', 26, 2,'PR12345'),
('NEOS107', 'Mariya', 'Shelby', 'Female', 29, 5,'PR12348'),
('NEOS108', 'Donald', 'Trump', 'Male', 48, 4,'PR12346'),
('NEOS109', 'Jannet', 'Wilsons', 'Female', 24, 5,'PR12347'),
('NEOS110', 'Ronny', 'sullivan', 'Male', 27, 5,'PR12348');

INSERT INTO MARKETING VALUES
('NEOM101', 'Ethan', 'Anderson', 'Male', 22, 5,'PR12348'),
('NEOM102', 'Olivia', 'Johnson', 'Female', 38, 4,'PR12345'),
('NEOM103', 'Liam', 'Martinez', 'Male', 31, 3,'PR12346'),
('NEOM104', 'Emma', 'Brown', 'Female', 26, 3,'PR12348'),
('NEOM105', 'Mason', 'Williams', 'Male', 40, 5,'PR12347'),
('NEOM106', 'Daniel', 'Brian', 'Male', 26, 2,'PR12345'),
('NEOM107', 'Noah', 'Davis', 'Male', 29, 5,'PR12348'),
('NEOM108', 'Sophia', 'Garcia', 'Female', 48, 4,'PR12346'),
('NEOM109', 'Jannet', 'Wilsons', 'Female', 24, 5,'PR12347'),
('NEOM110', 'Benjamin', 'Clark', 'Male', 27, 1,'PR12348');

INSERT INTO ACCOUNTS VALUES
('NEOA101', 'Henry', 'Robinson', 'Male', 22, 5,'PR12348'),
('NEOA102', 'Tia', 'Johnson', 'Female', 38, 4,'PR12345'),
('NEOA103', 'Wayne', 'Martinez', 'Male', 31, 3,'PR12346'),
('NEOA104', 'Polly', 'White', 'Female', 26, 3,'PR12348'),
('NEOA105', 'Mason', 'Peterson', 'Male', 40, 5,'PR12347'),
('NEOA106', 'Daniel', 'Brian', 'Male', 26, 2,'PR12345'),
('NEOA107', 'Lucas', 'Davis', 'Male', 29, 5,'PR12348'),
('NEOA108', 'Sophia', 'Garcia', 'Female', 48, 4,'PR12346'),
('NEOA109', 'Ava', 'Miller', 'Female', 24, 5,'PR12347'),
('NEOA110', 'Benjamin', 'Miller', 'Male', 27, 1,'PR12348');

-- Task 1 cont..
-- 14. update the proficiency level to 3 for the employees with the following employee codes: NEOS104, NEOS105, NEOM107, NEOM110,NEOA102, NEOA101
-- 15. delete the record NEOS108, NEOS104, NEOM103, NEOM105, NEOA101,
select * from sales;
UPDATE SALES
SET PROFICIENCY_LEVEL = 3
WHERE EMPLOYEE_ID in ('NEOS104', 'NEOS105');
UPDATE MARKETING
SET PROFICIENCY_LEVEL = 3
WHERE EMPLOYEE_ID in ('NEOM107', 'NEOM110');
UPDATE ACCOUNTS
SET PROFICIENCY_LEVEL = 3
WHERE EMPLOYEE_ID in ('NEOA102', 'NEOA101');

-- DQL
-- 16. In NeoPro Database identify the sales employees whose proficiency level is greater than 4
SELECT FIRST_NAME,LAST_NAME,PROFICIENCY_LEVEL FROM SALES
WHERE PROFICIENCY_LEVEL > 4;
-- 17. Identify all females from marketing department whose name starts with J
SELECT FIRST_NAME FROM MARKETING
WHERE GENDER = 'FEMALE' AND FIRST_NAME LIKE 'J%';
-- 18. Identify all females from accounts department whose name ends with a and proficiency
-- level between 2 and 4
SELECT FIRST_NAME,LAST_NAME,PROFICIENCY_LEVEL FROM ACCOUNTS
WHERE GENDER = 'FEMALE' AND PROFICIENCY_LEVEL BETWEEN 2 AND 4
AND LAST_NAME LIKE '%A';
-- 19. Find the count of females in Accounts department
SELECT COUNT(*)  FROM ACCOUNTS
WHERE GENDER = 'FEMALE';
SELECT COUNT(GENDER) FROM ACCOUNTS
GROUP BY GENDER;
-- 20. Organization is not able to achieve the desired targets hence the management has
-- decided to hire more sales employee in the team but at the cost of old employees with a
-- proficiency score less than 3. Update the records in sales table remove the old values and
-- add the same no of values in the sales table and assign proficiency score more than or equal to 4.
SELECT * FROM SALES;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM SALES
WHERE PROFICIENCY_LEVEL < 3;
INSERT INTO SALES VALUES('NEOS106', 'ROBERT', 'TUCKER', 'Male', 26, 5,'PR12345');

-- CREATING BACKUPS AND MERGING 
-- 21. Company NEO Pro has decided to create a backup of all the data help the organization achieve this task
CREATE TABLE SALES_BACKUP SELECT * FROM SALES;
CREATE TABLE ACCOUNTS_BACKUP SELECT * FROM ACCOUNTS;
CREATE TABLE MARKETING_BACKUP SELECT * FROM MARKETING;

-- 22. Delete the records from NEOA101 to NEOA105
DELETE FROM ACCOUNTS
WHERE EMPLOYEE_ID BETWEEN 'NEOA101' AND 'NEOA105';
SELECT * FROM ACCOUNTS;

-- 23. As most of people from accounts department has left the organization so
-- company has decided to store the accounts data along with marketing data
INSERT INTO MARKETING SELECT * FROM ACCOUNTS;
SELECT * FROM MARKETING;

-- 24. Delete the accounts data after creating a new table with the same structure as accounts
TRUNCATE TABLE ACCOUNTS;



-- TASK-2 - JOINS
-- 1. Fetch the names and ids of the employees who are working in the IT department.
USE HR;
SELECT FIRST_NAME,LAST_NAME,EMPLOYEE_ID,EMPLOYEES.DEPARTMENT_ID,DEPARTMENTS.DEPARTMENT_NAME
FROM EMPLOYEES JOIN 
DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
WHERE DEPARTMENT_NAME = 'IT';

-- 2. Fetch the first name, last name, job id, job title, minimum salary and maximum salary of all employees
SELECT FIRST_NAME,LAST_NAME,EMPLOYEES.JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY
FROM EMPLOYEES JOIN 
JOBS ON EMPLOYEES.JOB_ID = JOBS.JOB_ID;

-- 3. Identify the top 10 cities which have the largest number of employees
SELECT CITY, COUNT(EMPLOYEE_ID) FROM EMPLOYEES
JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
JOIN LOCATIONS ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID
GROUP BY CITY
ORDER BY COUNT(EMPLOYEE_ID) DESC ;

-- 4. Fetch the employee ids and names of all employees whose last working day in the organization was 1999-12-31
SELECT FIRST_NAME,LAST_NAME,EMPLOYEES.EMPLOYEE_ID,END_DATE FROM EMPLOYEES
JOIN JOB_HISTORY ON EMPLOYEES.EMPLOYEE_ID = JOB_HISTORY.EMPLOYEE_ID
WHERE END_DATE = '1999-12-31' ;

-- 5. Fetch the employee id , first name, department name and total experience of all 
-- employees who have completed at least 25 years in the organization
SELECT FIRST_NAME,SALARY,YEAR(NOW())-YEAR(HIRE_DATE) AS TOTAL_EXP FROM EMPLOYEES
WHERE (YEAR(NOW())-YEAR(HIRE_DATE))>24 ;

-- 6. Fetch the details of top 3 countries where most of the employees are working
SELECT COUNTRY_NAME,COUNT(*) FROM EMPLOYEES
JOIN DEPARTMENTS USING(DEPARTMENT_ID)
JOIN LOCATIONS USING(LOCATION_ID)
JOIN COUNTRIES USING(COUNTRY_ID)
GROUP BY COUNTRY_NAME
ORDER BY COUNT(*)
LIMIT 3;

-- 7. Fetch the details of those employees who have completed 10 years in the organization
SELECT FIRST_NAME,SALARY,YEAR(NOW())-YEAR(HIRE_DATE) AS TOTAL_EXP FROM EMPLOYEES
WHERE (YEAR(NOW())-YEAR(HIRE_DATE))>9;

-- 8. Fetch the department wise cost to the company
SELECT DEPARTMENT_NAME,SUM(SALARY) AS TOTAL_COST FROM EMPLOYEES
JOIN DEPARTMENTS USING(DEPARTMENT_ID) 
GROUP BY DEPARTMENT_NAME
ORDER BY SUM(SALARY) DESC;

-- 9. Fetch the details of employees whose salary is greater than average salary
SELECT EMPLOYEE_ID,FIRST_NAME,SALARY FROM EMPLOYEES
WHERE SALARY >(SELECT avg(SALARY) FROM EMPLOYEES);

-- 10. Find the names of all employees whose salary is greater than 60% of their
-- departments total salary bill.
select first_name, last_name , salary from employees where salary in (select
sum(salary) from employees group by department_id having
sum(salary)>0.6*sum(salary) ) order by department_id ; 
