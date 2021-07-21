
1.	What is an object in SQL?
2.	What is Index? What are the advantages and disadvantages of using Indexes?
3.	What are the types of Indexes?
4.	Does SQL Server automatically create indexes when a table is created? If yes, under which constraints?
5.	Can a table have multiple clustered index? Why?
6.	Can an index be created on multiple columns? Is yes, is the order of columns matter?
7.	Can indexes be created on views?

8.	What is normalization? What are the steps (normal forms) to achieve normalization?
Ans: Normalization is a process of organizing data to minimize redundancy (data duplication), which in turn ensures data consistency. 
The steps can be 1NF -> 2NF -> 3NF
1NF: Data in each column should be atomic, no multiples values separated by comma
2NF: The table must meet all the conditions of 1NF. Move redundant data to separate table and Create relationships between these tables using foreign keys
3NF: Table must meet all the conditions of 1NF and 2nd. Does not contain columns that are not fully dependent on primary key. 

9.	What is denormalization and under which scenarios can it be preferable?
Ans: denormalization is the process of adding precomputed redundant data to an otherwise normalized relational database to improve read performance of the database

10.	How do you achieve Data Integrity in SQL Server?
Ans: Use constraints
Entity Integrity - by specifying a primary key, unique key, and not null.
Referential integrity - by using a Foreign Key constraintusing a Foreign Key constraint
Domain Integrity - using Check and Default constraints

11.	What are the different kinds of constraint do SQL Server have?
Ans: 
NOT NULL - Ensures that a column cannot have a NULL value
UNIQUE - Ensures that all values in a column are different
PRIMARY KEY - A combination of a NOT NULL and UNIQUE. Uniquely identifies each row in a table
FOREIGN KEY - Prevents actions that would destroy links between tables
CHECK - Ensures that the values in a column satisfies a specific condition
DEFAULT - Sets a default value for a column if no value is specified
CREATE INDEX - Used to create and retrieve data from the database very quickly

12.	What is the difference between Primary Key and Unique Key?
Ans : Primary Key cannot be null and one table can only have one primary key

13.	What is foreign key?
Ans: A foreign key is a set of attributes in a table that refers to the primary key of another table. The foreign key links these two tables

14.	Can a table have multiple foreign keys?
Ans : Yes

15.	Does a foreign key have to be unique? Can it be null?
Ans: It can be duplicates and null

16.	Can we create indexes on Table Variables or Temporary Tables?

17.	What is Transaction? What types of transaction levels are there in SQL Server?
Ans : Transactions by definition are a logical unit of work  Transaction is a single recoverable unit of work that executes either: Completely or Not at all
Isolation levels: READ UNCOMMITTED , READ COMMITTED , REPEATABLE READ , and SERIALIZABLE


--1
 create table customer(cust_id int primary key identity(1,1), iname varchar (50)) 
 create table [order](order_id int primary key identity(1,1), cust_id int Foreign key references customer(cust_id),　amount money,　order_date smalldatetime)

 insert into customer values('James')
 insert into customer values('Adam')
 insert into customer values('William')
 insert into [order] values(1, 100, '2002-05-08 12:35:29')
 insert into [order] values(1, 1000, '2020-09-09 07:12:19')
 insert into [order] values(2, 9527, '2021-05-20 03:13:27')
 insert into [order] values(3, 1490, '2002-05-20 09:12:35')

 with order_date
 as
 (
	select c.iname, o.order_id, o.order_date
	from customer c
	inner join
	[order] o
	on o.cust_id = c.cust_id
)
select od.iname, count(od.order_id) as [#order] from order_date od 
where YEAR(od.order_date) = 2002
group by od.iname

drop table [order]
drop table customer


 --2
 Create table person (id int primary key identity(1,1), firstname varchar(100), lastname varchar(100))
 insert into person values('James','Chen')
 insert into person values('Adam','Aaron')
 insert into person values('William','Addison')

 select * 
 from person p
 where p.lastname like 'A%'

drop table person

 --3
Create table person(person_id int primary key identity(1,1), manager_id int null, name varchar(100)not null) 

select p1.name, count(p2.person_id) 
from person p1, person p2
where p1.person_id = p2.manager_id and p1.manager_id is null
group by p1.name

drop table person

--4
Insert, Update, Delete and Truncate

--5
create table companies(cmp_id int primary key, cmp_name varchar(50) not null, div_id foreign key references divisions (div_Id))
create table divisions(div_id int primary key, div_name varchar(50) not null, addr varchar(50), cont_id int foreign key references contacts(cont_id))
create table contacts(cont_id int primary key, contact_name varchar(50) not null, suite_mail varchar(50), div_id int foreign key references divisions (div_id))