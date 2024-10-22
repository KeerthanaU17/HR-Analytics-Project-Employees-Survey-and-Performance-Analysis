create database project;
use project;

select * from train;

#total no. of records in the data
select count(*) from train;

-- #total no. of distinct records in the data(no. of duplicates)
select distinct count(*) from train;

-- #renaming column name
alter table train
rename column `Employee ID` to `Employee_ID`;

select * from train;
select Employee_ID from train;

-- #what is the number of male and female present in the data
select gender, count(Employee_ID) as Gender_wise_count from train
group by gender;


-- #Find the employee id who has received high number of promotions
select employee_id, sum(`Number of promotions`) as Total_Promotions from train
group by employee_id
order by Total_Promotions desc;


-- #How many employees got the highest numbers of promotions?
select count(employee_id) as No_of_employees from (select employee_id, sum(`Number of promotions`) as Total_Promotions from train
                         group by employee_id
                         having Total_Promotions = 4
                         order by Total_Promotions desc) IQ;
 
 alter table train
 add column Salary_Package float;
 
 update train
 set Salary_Package = `Monthly Income`*12;
 
 alter table train
 rename column `job role` to Dept;
 
 alter table train
 rename column `years at company` to Work_Experience;

--  #Find and display the information of top3 employees from each dept based on their Company Tenure
 
with ABC
as (select dept, employee_id, `company tenure`, 
row_number() over (partition by dept order by `company tenure` desc) as Ranks from train)
select * from ABC
where ranks <=3;

 
 #If the company tenure is same for more than 1 person, then find the ranks of employees according to the promotions
 
with ABC
as (select dept, employee_id, `company tenure`, `number of promotions`,age, salary_package,
rank() over (partition by dept order by `company tenure` desc, `number of promotions` desc,age desc, salary_package desc) as Ranks from train)
select * from ABC
where ranks <=3;

 
 -- #Find number of employees working in each department
 SELECT dept, COUNT(employee_id) AS no_of_employees
FROM train
GROUP BY dept;

 -- #Display employee_id,gender,dept,salary_package of employees whose salary package lies betweeen 50000 and 65000
 select employee_id,gender,dept,salary_package from train
 where salary_package between 50000 and 65000
 order by salary_package;
 

 -- #Find the number of employees whose performance is average and above
 select count(*) as No_of_Employees
from train
where `performance rating` in ('average', 'high');


-- #Find employee id in each department which has highest salary
with salary as(
select employee_id,dept, max(salary_package) as max_salary,
row_number() over(partition by dept order by max(salary_package) desc) as Ranks
from train
group by employee_id,dept
order by dept,max_salary desc)
select employee_id,dept, max_salary from salary
where Ranks=1;


#Find employee id in each department which has second highest salary
with salary as(
select employee_id,dept, max(salary_package) as max_salary,
row_number() over(partition by dept order by max(salary_package) desc) as Ranks
from train
group by employee_id,dept
order by dept,max_salary desc)
select employee_id,dept, max_salary from salary
where Ranks=2;

 #Find second highest salary in each department using sub queries
select dept,max(salary_package) from train
where salary_package < (select max(salary_package) from train)
group by  dept;

select * from train;

#Add a permanent column Work_Ex_Status based on work experience 
# work experience <= 12         fresher
# work experience <= 36         medium
# work experience > 36          high

alter table train
add column Work_Ex_Status varchar(20) not null;

select * from train;

update train
set Work_Ex_Status = (
case when Work_Experience <= 12 then "Fresher"
     when Work_Experience <= 36 then "Medium" 
     else "High" 
     end
	 );
     
     select * from train;



 # I have to compare two classes employees;
 # one class : work experience>=10
 # second class : work experience<10
 
 #How many employees are there whose experience is greater than or equal to 10 years but they are getting lesser salaries
 # than the employees having experience of less than 10 years in each job role
 with ABC
 as (select A.Employee_ID as AE, A.Dept as AD, A.Work_Experience as AWE, A.Salary_Package as ASP, 
 B.Employee_ID as BE, B.Dept as BD, B.Work_Experience as BWE, B.Salary_Package as BSP from train A
 inner join train B 
 on  A.Work_Experience >=10 and B.Work_Experience <10 
 where A.Salary_Package<B.Salary_Package)
 select count(*) from ABC;
