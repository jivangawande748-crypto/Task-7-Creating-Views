-- create Database 
create database ecommerce_db1;
use ecommerce_db1;

-- Customers Table
create table Customers(
customer_id int auto_increment primary key,
name varchar(100) not null,
email varchar(100) unique,
phone varchar(15),
address varchar(255)
);

insert into Customers (name, email, phone, address) values('Amit Sharma', 'amit@example.com', '9876543210', 'Mumbai');
insert into Customers (name, email, phone, address) values('Priya Verma', 'priy@example.com', '9123456780', 'Pune');
insert into Customers (name, email, phone, address) values('Rahul Patil', 'rahul@example.com', '9988776655', 'Nagpur');
insert into Customers (name, email, phone, address) values('Jivan Gawande', 'jivan@example.com', '9080706059', 'Buldana');

select * from Customers;

-- Products Table
create table Products(
products_id int auto_increment primary key,
product_name varchar(100) not null,
price decimal(10,2) not null,
stock int default 0
);

insert into Products (product_name, price, stock) values ('Laptop', 55000.00, 10);
insert into Products (product_name, price, stock) values ('Smartphone', 20000.00, 25);
insert into Products (product_name, price, stock) values ('Headphone', 1500.00, 50);
insert into Products (product_name, price, stock) values ('Keyboard', 8000.00, 30);

select * from Products;

-- Orders Table
create table Orders(
order_id int auto_increment primary key,
customer_id int,
order_data datetime default current_timestamp,
foreign key (customer_id) references Customers(customer_id)
);

insert into Orders (customer_id) values (1);
insert into Orders (customer_id) values (2);
insert into Orders (customer_id) values (1);
insert into Orders (customer_id) values (3);

select * from Orders;

-- Order_Details(Many-to-Many)
create table Order_Details(
order_details_id int auto_increment primary key,
order_id int,
products_id int,
quantity int not null,
foreign key (order_id) references Orders(order_id),
foreign key (products_id) references Products(products_id)
);

insert into Order_Details (order_id, products_id, quantity) values (1, 1, 1);
insert into Order_Details (order_id, products_id, quantity) values (1, 3, 2);
insert into Order_Details (order_id, products_id, quantity) values (2, 2, 1);
insert into Order_Details (order_id, products_id, quantity) values (3, 4, 1);
insert into Order_Details (order_id, products_id, quantity) values (3, 2, 1);

select * from Order_Details;

update Customers set name='Kajal Gawande' where name='Amit Sharma';

delete from Orders where order_id=1;

-- select all columns
select * from Customers;

select * from Products;

select * from Orders;

select * from Order_Details;

-- Select specific columns

select customer_id, name, email, phone, address from Customers;

-- Filter row using where

select * from Customers where address='Pune';

-- Use And / Or

select * from Products where product_name='Laptop' and stock >= 10;

-- Pattern matching with like

select * from Customers where name like 'J%';

-- Range filtering with between

select * from Products where stock between 20 and 40;

-- Sorting results

select * from Products order by stock desc;

-- Limit output

select * from Products order by stock desc limit 2;

-- Using alias

select product_name as Name, stock as Available from Products;

-- Removing duplicates

SELECT sum(price), product_name
FROM Products
GROUP BY product_name
HAVING Sum(price) > 1;

SELECT count(price), stock
FROM Products
GROUP BY stock
HAVING count(price) < 2;

SELECT max(price),  stock 
FROM Products
GROUP BY stock
HAVING min(price) > 8000;


SELECT Avg(stock), product_name
FROM Products
GROUP BY product_name
HAVING avg(stock) > 1;

SELECT min(price), stock
FROM Products
GROUP BY stock
HAVING min(price) < 10000;

select *
from Customers as C
inner join Orders as O
on C.customer_id=O.customer_id;


select *
from Customers as C
left join Orders as O
on C.customer_id=O.customer_id;

select *
from Customers as C
right join Orders as O
on C.customer_id=O.customer_id;


select *
from Customers as C
left join Orders as O
on C.customer_id=O.customer_id

union

select *
from Customers as C
right join Orders as O
on C.customer_id=O.customer_id;

-- 1. Scalar Subqueries

SELECT products_id,product_name, price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products);

-- 2. Correlated Subquery – Customers who placed at least one order

SELECT c.customer_id, c.name
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
);

-- 3. Subquery with IN – Customers who placed orders

SELECT name, email
FROM Customers
WHERE customer_id IN (SELECT customer_id FROM Orders);

-- 5. Scalar Subquery – Products more expensive than the average price

SELECT product_name, price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products);

-- 1. Basic View Creation

CREATE VIEW CustomerOrders AS
SELECT o.order_id, c.name AS customer_name, c.email, o.order_data
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;

SELECT * FROM CustomerOrders;

-- 2. Complex View with Subquery

CREATE VIEW CustomerOrderSummary AS
SELECT c.customer_id, c.name,
       (SELECT COUNT(*) 
        FROM Orders o 
        WHERE o.customer_id = c.customer_id) AS total_orders
FROM Customers c;

SELECT * FROM CustomerOrderSummary WHERE total_orders > 1;

-- 3. View with Join and Aggregation

CREATE VIEW TopCustomers AS
SELECT c.name, COUNT(o.order_id) AS order_count
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY order_count DESC;

SELECT * FROM TopCustomers LIMIT 3;