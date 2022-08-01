SELECT * FROM employee.emp_record_table;

#to fetch details from employee record table
SELECT EMP_ID, FIRST_NAME,LAST_NAME,GENDER,DEPT FROM emp_record_table; 

#To fetch employee details based on employee rating
SELECT EMP_ID, FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING FROM emp_record_table
where EMP_RATING < 2;

SELECT EMP_ID, FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING FROM emp_record_table
where EMP_RATING >4 ;

SELECT EMP_ID, FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING FROM emp_record_table
where EMP_RATING between 2 and 4;

#to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table
# and then give the resultant column alias as NAME.

ALTER TABLE emp_record_table
ADD NAME VARCHAR(50)
GENERATED ALWAYS AS (CONCAT(FIRST_NAME,' ',LAST_NAME));

SELECT * FROM employee.emp_record_table;

#a query to list only those employees who have someone reporting to them.
# Also, show the number of reporters (including the President).

SELECT * FROM employee.emp_record_table;

SELECT m.NAME,m.ROLE,count(e.EMP_ID) AS "NO. OF REPORTERS",m.EMP_ID
from emp_record_table m
inner join emp_record_table e
on m.EMP_ID=e.MANAGER_ID
and e.EMP_ID != e.MANAGER_ID
where m.ROLE in ('MANAGER','PRESIDENT')
GROUP BY m.EMP_ID with rollup;

#query to list down all the employees from the healthcare and finance departments using union.
# Take data from the employee record table.

select NAME,DEPT from emp_record_table
where DEPT in ("FINANCE")
UNION
select NAME,DEPT from emp_record_table
where DEPT in ("HEALTHCARE");

#Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, 
#DEPARTMENT, and EMP_RATING grouped by dept.
#Also include the respective employee rating along with the max emp rating for the department.

SELECT*,max(EMP_RATING)
FROM emp_record_table
group by DEPT;

SELECT*FROM emp_record_table;

#Write a query to calculate the minimum and the maximum salary of the employees in each role.
#Take data from the employee record table.

SELECT*,max(SALARY),min(SALARY)
FROM emp_record_table
group by ROLE;

#Write a query to assign ranks to each employee based on their experience.
#Take data from the employee record table.

select * ,
RANK() OVER(ORDER BY EXP desc) AS RANK_BY_EXP,
dense_rank() OVER(ORDER BY EXP desc) AS DENSE_RANK_BY_EXP
FROM emp_record_table;

#Write a query to create a view that displays employees in various countries
#whose salary is more than six thousand. Take data from the employee record table.

CREATE VIEW V1 AS
SELECT*FROM emp_record_table
WHERE SALARY>6000;

#Write a nested query to find employees with experience of more than ten years.
#Take data from the employee record table.

select *FROM emp_record_table;

SELECT NAME FROM emp_record_table
WHERE EMP_ID IN(
SELECT EMP_ID 
FROM emp_record_table
WHERE EXP>10
);

#Write a query to create a stored procedure to retrieve the details of the employees 
#whose experience is more than three years. Take data from the employee record table.

DELIMITER &&
CREATE PROCEDURE GET_EXP()
BEGIN
select*FROM emp_record_table
WHERE EXP>3;
END &&
CALL GET_EXP();

#Write a query using stored functions in the project table to check whether the job profile assigned 
#to each employee in the data science team matches the organization’s set standard.
#The standard being:
#For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
#For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
#For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
#For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
#For an employee with the experience of 12 to 16 years assign 'MANAGER'.

DELIMITER $$
CREATE FUNCTION COMPANY_STANDARDS(EXP int)
returns varchar(40)
deterministic
BEGIN
DECLARE COMPANY_STANDARDS varchar(40);
IF EXP<=2 THEN
SET COMPANY_STANDARDS = 'JUNIOR DATA SCIENTIST';
ELSEIF (EXP>2 AND EXP<=5) THEN
SET COMPANY_STANDARDS = 'ASSOCIATE DATA SCIENTIST';
ELSEIF (EXP>5 AND EXP<=10) THEN
SET COMPANY_STANDARDS = 'SENIOR DATA SCIENTIST';
ELSEIF (EXP>10 AND EXP<=12) THEN
SET COMPANY_STANDARDS = 'LEAD DATA SCIENTIST';
ELSEIF (EXP>12 AND EXP<=16) THEN
SET COMPANY_STANDARDS = 'MANAGER';
END IF;
RETURN (COMPANY_STANDARDS);
END$$

select NAME,EXP,ROLE, COMPANY_STANDARDS(EXP)
FROM emp_record_table
ORDER BY EXP DESC;

#Create an index to improve the cost and performance of the query to find the employee
#whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.

#TO VIEW DATA TYPE OF A COLUMN
SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS 
  WHERE table_name = 'emp_record_table' AND COLUMN_NAME = 'FIRST_NAME';
  
  

CREATE INDEX IX_FIRST_NAME 
ON emp_record_table(FIRST_NAME);