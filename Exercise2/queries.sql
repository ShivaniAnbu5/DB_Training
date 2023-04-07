-- 1 Write a SQL query to remove the details of an employee whose first name ends in ‘even’
select * from employees where first_name like '%even';
delete from employees where first_name like '%even';
select * from employees where first_name like '%even';

-- 2 Write a query in SQL to show the three minimum values of the salary from the table.
select first_name,last_name,salary from employee order by salary limit 3;

-- 3 Write a SQL query to copy the details of this table into a new table with table name as Employee table and to delete the records in employees table
create table employee like employees;
insert into employee select * from employees;
select * from employee;
truncate table employees;
select * from employees;

-- 4 Write a SQL query to remove the column Age from the table
alter table employee drop column age;

-- 5 Obtain the list of employees (their full name, email, hire_year) where they have joined the firm before 2000
select concat_ws(' ',first_name,last_name)as full_name ,email,extract(day from hire_date) as hire_year,dayname(hire_date) as Day from employee where hire_year < 2000;

-- 6 Fetch the employee_id and job_id of those employees whose start year lies in the range of 1990 and 1999
select employee_id,job_id,year(start_date) from job_history where year(start_date) between 1990 and 1999;

-- 7 Find the first occurrence of the letter 'A' in each employees Email ID Return the employee_id, email id and the letter position
select employee_id,email,regexp_instr(email,'A') as charposition from employee where contains(email,'A');
select employee_id,email,position('A',email) as charposition from employee where contains(email,'A');
select employee_id,email,charindex('A',email) as charposition from employee where contains(email,'A');

-- 8 Fetch the list of employees(Employee_id, full name, email) whose full name holds characters less than 12
select employee_id,concat(first_name,' ',last_name)as full_name ,email from employee where length(full_name) < 12;

-- 9 Create a unique string by hyphenating the first name, last name , and email of the employees to obtain a new field named UNQ_ID Return the employee_id, and their corresponding UNQ_ID;
select concat_ws('-',first_name,last_name,email) as UNQ_ID,employee_id from employee;

-- 10 Write a SQL query to update the size of email column to 30
alter table employee modify column email VARCHAR(30);
describe table employee;

-- 11 Write a SQL query to change the location of Diana to London
select * from locations;
update locations set city = 'London' where location_id = ( select location_id from departments where department_id = (select departments.department_id from departments join employee on departments.department_id = employee.department_id where first_name='Diana'));
select * from locations;

-- 12 Fetch all employees with their first name , email , phone (without extension part) and extension (just the extension)  Info : this mean you need to separate phone into 2 parts eg: 123.123.1234.12345 => 123.123.1234 and 12345 . first half in phone column and second half in extension column
select first_name,email,substr(phone_number,0,length(phone_number) - (position('.', reverse(phone_number)))) as phone ,right(phone_number, position('.', reverse(phone_number)) -1) as extension from employee;

-- 13 Write a SQL query to find the employee with second and third maximum salary
select employee.*,jobs.max_salary from employee,jobs where employee.job_id = jobs.job_id order by max_salary desc limit 2 offset 1;

-- 14 Fetch all details of top 3 highly paid employees who are in department Shipping and IT
select * from departments;
select top 3 * from employee where department_id in (select department_id from departments where department_name = 'Shipping') 
union
select top 3 * from employee where department_id in (select department_id from departments where department_name = 'IT')
order by department_id,salary desc;

-- 15 Display employee id and the positions(jobs) held by that employee (including the current position)
select employee.employee_id,jobs.job_title from employee,jobs where employee.job_id  = jobs.job_id
union 
select job_history.employee_id,jobs.job_title from job_history,jobs where job_history.job_id  = jobs.job_id order by employee_id;

-- 16 Display Employee first name and date joined as WeekDay, Month Day, Year
-- Decode takes an expression and <search expr><result> and if the result of the expression matches the search ecpr,then returns the corresponding result
select first_name,concat(decode(extract ('DAYOFWEEK_ISO',hire_date), 1, 'Monday', 2, 'Tuesday', 3, 'Wednesday', 4, 'Thursday', 5, 'Friday', 6,                    'Saturday', 7, 'Sunday'),to_varchar(hire_date,',mmmm '),day(hire_date),(CASE
        WHEN right(day(hire_date),2) between 11 and 20 THEN 'th,'
        WHEN right(day(hire_date),1)=1 THEN 'st,'
        WHEN right(day(hire_date),1)=2 THEN 'nd,'
        WHEN right(day(hire_date),1)=3 THEN 'rd,'
        ELSE 'th,'
    END ),year(hire_date)) as Date_Joined from employee;

-- 17 The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 .  The job position might be removed based on market trends (so, save the changes) .  - Later, update the maximum salary to 40,000 . - Save the entries as well.Now, revert back the changes to the initial state, where the salary was 30,000
insert into jobs values ('DT_ENGG','Data Engineer',12000,30000);
select * from jobs;
begin transaction;
set autocommit=0;
select current_transaction();
update jobs set max_salary=40000 where job_id = 'DT_ENGG';
select * from jobs;
rollback;
select * from jobs;
-- delete from jobs where job_id = 'DT_ENGG';

-- 18 Find the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals
select round(avg(salary),3) as avg_salary from employee where hire_date between '1996-01-08' and '2000-01-01';

-- 19 Display  Australia, Asia, Antarctica, Europe along with the regions in the region table (Note: Do not insert data into the table)
-- A. Display all the regions
select ('Australia') as region_name union
select ('Asia') as region_name union
select ('Antarctica') as region_name union
select ('Europe') as region_name union 
select region_name from regions;
-- B. Display all the unique regions
select ('Australia') as region_name union
select ('Asia') as region_name union
select ('Antarctica') as region_name union
select ('Europe') as region_name union all
select region_name from regions;

-- 20 Write a SQL query to remove the employees table from the database
drop table employees;
