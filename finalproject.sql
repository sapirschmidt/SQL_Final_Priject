--DA course--25/12/24--sapir schmidt--final project

--1
select YEAR(o.OrderDate) as order_year,
datepart(quarter, o.OrderDate) as order_quarter,
sum(quantity*unitprice) as gross_revenue,
sum((quantity*unitprice)*discount) as total_discount,
sum((quantity*unitprice)-(quantity*unitprice)*discount) as net_revenue,
count(distinct od.OrderID) as orders,
sum(quantity) as quantity_of_products, 
count(distinct productid) as uniqueproducts
from Orders o
join [Order Details] od on od.OrderID=o.orderid
group by YEAR(o.OrderDate),
datepart(quarter, o.OrderDate)
order by order_year
--2
select p.ProductName,
count(distinct o.OrderID) as orders,
sum(datediff(dd, orderdate, ShippedDate)) as days_to_ship
from Orders o
join [Order Details] od on o.OrderID=od.OrderID
join Products p on p.ProductID=od.ProductID
where year(OrderDate) = 1997
group by  p.ProductName
having sum(datediff(dd, orderdate, ShippedDate))>200
order by days_to_ship desc
--3
select shipcountry,
sum(unitprice*quantity) as gross_revenue, 
sum((unitprice*quantity)*discount) as total_discount,
sum((quantity*unitprice)-(quantity*unitprice)*discount) as net_revenue,
count(distinct o.OrderID) as orders,
sum(quantity) as quantity_of_products, 
count(distinct productid) as uniqueproducts
from Orders o
join [Order Details] od on o.OrderID=od.OrderID
where ShipCountry in ('germany', 'usa', 'brazil', 'austria')
group by shipcountry
--4
select MONTH(OrderDate) as monthnum ,
DATENAME(MONTH, OrderDate) as month_name, 
count(distinct o.OrderID) as num_of_orders, 
sum(unitprice*quantity) as gross_revenue
from Orders o
join [Order Details] od on o.OrderID=od.OrderID
where YEAR(OrderDate)=1997
group by MONTH(OrderDate), DATENAME(MONTH, OrderDate)
order by monthnum asc
--5
select s.CompanyName,
sum(datediff(dd, orderdate, ShippedDate)) as days_to_ship,
count(OrderID) as orders
from shippers s
join orders o on s.ShipperID=o.ShipVia
join Customers c on o.CustomerID=c.CustomerID
where year(OrderDate)='1997'
group by s.CompanyName
order by days_to_ship asc
--6
select *
from (
select top 5 count(p.ProductID) as order_per_product, productname
from [Order Details] od
join Products p on od.ProductID=p.ProductID 
join orders o on od.orderid=o.OrderID
where year(orderdate)='1997'
group by productname
order by count(p.ProductID) desc) a
union
select *
from (
select top 5 count(p.ProductID) as order_per_product, productname
from [Order Details] od
join Products p on od.ProductID=p.ProductID 
join orders o on od.orderid=o.OrderID
where year(orderdate)='1997'
group by productname
order by count(p.ProductID) asc) b
order by order_per_product desc
--7
select top 10 percent CategoryName, productname,
count(distinct o.OrderID) as orders,
sum(quantity) as quantity_of_products,
sum(od.UnitPrice*quantity) as gross_revenue, 
sum((od.unitprice*quantity)*discount) as total_discount,
sum((quantity*od.UnitPrice)-(quantity*od.UnitPrice)*discount) as net_revenue
from [Order Details] od
join Orders o on od.OrderID=o.orderid
join Products p on od.ProductID=p.ProductID
join Categories c on p.CategoryID=c.CategoryID
where year(OrderDate)='1997'
group by CategoryName, productname
order by orders desc
--8
select CategoryName, ProductName, sum(unitsinstock) as total_uis, sum(UnitsOnOrder) as total_uoo
from Categories c
join Products p on c.CategoryID=p.CategoryID
where UnitsInStock<10
group by CategoryName, ProductName
order by ProductName asc
--9
select employee_name, 'top 5' as performence, orders 
from(
select top 5 firstname+' '+lastname as employee_name, count(o.employeeid) as orders
from employees e
join orders o on e.EmployeeID=o.EmployeeID 
where year(orderdate)='1997'
group by firstname+' '+lastname
order by orders desc) a
union
select employee_name,'bottom 5' as performence, orders
from(
select top 5 firstname+' '+lastname as employee_name, count(o.employeeid) as orders
from employees e
join orders o on e.EmployeeID=o.EmployeeID 
where year(orderdate)='1997'
group by firstname+' '+lastname
order by orders asc) b
order by orders desc
--10
select Title, firstname, gross_revenue, total_discount, net_revenue,
total_quantity, orders,
sum(orders) over(partition by Title) as orders_pt,
sum(total_quantity) over(partition by Title) as total_quantity_pt,
sum(gross_revenue) over(partition by Title) as gross_revenue_pt,
sum(total_discount) over(partition by Title) as total_discount_pt,
sum(net_revenue) over(partition by Title) as net_revenue_pt
from ( 
select
Title, 
firstname,
count(distinct OrderID) as orders,
sum(Quantity) as total_quantity,
sum(UnitPrice*Quantity) as gross_revenue,
sum(UnitPrice*Quantity*Discount) as total_discount,
sum((UnitPrice*Quantity)-(UnitPrice*Quantity)*Discount) as net_revenue
from
(select o.OrderID, UnitPrice, Quantity, Discount, EmployeeID
from [Order Details] od
join Orders o on od.OrderID=o.OrderID
where year(OrderDate)='1997'
) a
join Employees e on a.EmployeeID=e.EmployeeID
group by Title, 
firstname ) a
group by  Title, 
firstname, gross_revenue, total_discount, net_revenue, total_quantity, orders
--11
select RegionDescription, 
count(distinct od.OrderID) orders,
sum((unitprice*quantity)-(unitprice*quantity)*Discount) as revenue,
sum(((unitprice*quantity)-(unitprice*quantity)*Discount)/UnitPrice) as revenue_per_order
from region r
join Territories t on r.RegionID=t.RegionID
join EmployeeTerritories et on t.TerritoryID=et.TerritoryID
join Employees e on et.EmployeeID=e.EmployeeID
join Orders o on e.EmployeeID=o.EmployeeID
join [Order Details] od on o.OrderID=od.OrderID
group by RegionDescription
order by revenue_per_order desc
--12
select OrderDate,
datename(MONTH,o.orderdate) as order_month,
datename(quarter,o.orderdate) as order_quarter,
c.CustomerID, c.Country, c.City, s.ShipperID, s.CompanyName,
e.EmployeeID, Title, FirstName, p.ProductName, ca.CategoryName,
sum(od.UnitPrice*Quantity) as gross_revenue,
sum(Discount) as TD, sum(Quantity) as TQ,
DATEDIFF(DAY,OrderDate,ShippedDate) as days_to_ship,
count(distinct p.ProductID) as products,
count(distinct o.OrderID) as orders
from Customers c
join Orders o on c.CustomerID=o.CustomerID
join Shippers s on s.ShipperID=o.ShipVia
join Employees e on o.EmployeeID=e.EmployeeID
join [Order Details] od on o.OrderID=od.OrderID
join Products p on od.ProductID=p.ProductID
join Categories ca on p.CategoryID=ca.CategoryID
group by OrderDate,
datename(MONTH,o.orderdate),
datename(quarter,o.orderdate),
c.CustomerID, c.Country, c.City, s.ShipperID,
s.CompanyName, e.EmployeeID, Title, FirstName, p.ProductName,
ca.CategoryName, DATEDIFF(DAY,OrderDate,ShippedDate)
