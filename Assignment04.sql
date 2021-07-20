
--1.	What is View? What are the benefits of using views?
 --view is like a virutal table that contains datat from one or multiple tables
 --but it does not exist physicallyrequire and does not need any storage in a database

--2.	Can data be modified through views?
--Yes, the base table will be modified.

--3.	What is stored procedure and what are the benefits of using it?
--Can use it to run routine job and is saved for the next time execution. 

--4.	What is the difference between view and stored procedure?
--view is a virtual table which associates to data stored in the database tables 
--whereas a stored procedure is a group of statements that can be executed       

--5.	What is the difference between stored procedure and functions?
--The function must return a value but in Stored Procedure it is optional

--6.	Can stored procedure return multiple result sets?
--NO

--7.	Can stored procedure be executed as part of SELECT Statement? Why?
--YES, Because stored procedure is still the combination of the statements

--8.	What is Trigger? What types of Triggers are there?
--Triggers are a special type of stored procedure that get executed (fired) when a specific event happens
--update, insert, delete

--9.	What are the scenarios to use Triggers?
--the trigger is mostly used for maintaining the integrity of the information on the database

--10.	What is the difference between Trigger and Stored Procedure?
--A trigger is a stored procedure that runs automatically when various events happen (eg update, insert, delete)
--while Stored Procedure is invoked by calling  

--1
insert into dbo.Region with (tablock) values (5, 'Middle Earth')
insert into dbo.Territories with (tablock) values (99999, 'Gondor', 5)
insert into dbo.Employees with (tablock) values (10, 'Aragorn', 'King', 
null, null, null, null, null, null, null, null, null, null, null, null, null, null, null)
insert into dbo.EmployeeTerritories with (tablock) values (10, 99999)

--2
update dbo.Territories set TerritoryDescription = 'Arnor' where TerritoryDescription = 'Gondor'

--3
delete from dbo.Region where RegionDescription = 'Middle Earth'

--4
create view view_product_order_chen
as
select p.ProductID, p.ProductName, sum(od.Quantity) as quantity
from dbo.Products p 
inner join dbo.[Order Details] od
on p.ProductID = od.ProductID
group by p.ProductID, p.ProductName


--5
create proc sp_product_order_quantity_chen
@id int,
@quan int out
as
begin
	select @quan=dt.total from
      (select p.ProductID as id, p.ProductName as name, sum(od.Quantity) as total 
	from dbo.Products p 
	inner join dbo.[Order Details] od
	on p.ProductID = od.ProductID
	group by p.ProductID, p.ProductName) dt
	where dt.id=@id
end


--6
create proc sp_product_order_city_chen
@name varchar(40)
as
begin
    select tb.name, tb.city, tb.quan, tb.rnk
    from
    (
	select dt.id as id, dt.name as name, dt.city as city, dt.quan as quan, 
	DENSE_RANK() over (partition by dt.id order by dt.quan desc) as rnk
	from
	(
        select p.ProductID as id, p.ProductName as name, 
		c.city as city, sum(od.Quantity) as quan
	    from dbo.Products p 
	    inner join dbo.[Order Details] od on p.ProductID = od.ProductID
	    inner join dbo.Orders o on o.OrderID = od.OrderID
	    inner join dbo.Customers c on o.CustomerID = c.CustomerID
	    group by p.ProductID, p.ProductName, c.city
	    )dt
	)tb
	where tb.name=@name and tb.rnk < 6
end


--7
create proc sp_move_employees_chen
as
begin
	if not exists(
	select dt.id
	from
		(select t.TerritoryDescription as name, e.EmployeeID as id
		from dbo.EmployeeTerritories as et 
		inner join dbo.Employees as e
		on e.EmployeeID = et.EmployeeID
		inner join dbo.Territories as t
		on et.TerritoryID = t.TerritoryID
		)dt 
	where dt.name = 'Troy'
	)
	begin
	insert into dbo.Territories with (tablock) values (99997, 'Stevens Point', 3)
	update dbo.EmployeeTerritories set TerritoryID = 99997 where TerritoryID = 3
	end
end

--8


--9











select * from dbo.Territories where TerritoryDescription = 'Troy'
