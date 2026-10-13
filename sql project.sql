-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
use OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- This is for execute the all query...

-- 1) Retrieve all books in the "Fiction" genre:

select* from books
where genre = 'Fiction';


-- 2) Find books published after the year 1950:

select published_Year , title , Author from books
where published_Year >= 1950;

-- 3) List all customers from the Canada:
select * from customers
where country ='Canada'

-- 4) Show orders placed in November 2023:
select * from orders
where Order_Date between '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
select sum(stock)  as total_stock
from books ;

-- 6) Find the details of the most expensive book:
select * from books
order by Price desc limit 1;

-- 7) Show all customers who ordered more than 7 quantity of a book:
select * from orders
where quantity>7;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders
where total_amount>20;

-- 9) List all genres available in the Books table:
select distinct genre from books;

-- 10) Find the book with the lowest stock:
select * from books
order by stock
limit 1;

-- 11) Calculate the total revenue generated from all orders:
select sum(total_amount) as revenue
from orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

select b.Genre , sum(o.quantity) as Total_book_sold
from orders o
join books b on o.book_id = b.book_id
group by b.genre;

-- 2) Find the average price of books in the "Fantasy" genre:
select avg(price) as average_price
from books
where genre = 'fantasy';


-- 3) List customers who have placed at least 2 orders:
select customer_id ,  count(order_id) AS Total_Count
from orders
group by customer_id
having count(order_id) >=2;

-- 4) Find the most frequently ordered book: also we find book name.
select o.book_id ,b.title, count(o.order_id) as order_book
from orders o
join books b on o.book_id = b.book_id
group by book_id,title
order by order_book desc limit  1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

select title , price , genre from books
where genre ='fantasy'
order by price desc limit 3;

-- 6) Retrieve the total quantity of books sold by each author:
select b.author, sum(o.quantity) as total_unit
from orders o
join books b on o.book_id = b.book_id
group by b.author 
order by total_unit desc;



-- 7) List the cities where customers who spent over $30 are located:
select distinct c.city, total_amount
from orders o
join customers c on o.customer_id = c.customer_id
where o.total_amount >30;

-- 8) Find the customer who spent the most on orders:
select c.customer_id , c.name  ,sum(o.order_id) as total_spend
from orders o
join customers c on o.customer_id = c.customer_id
group by c.customer_id, c.name
order by total_spend desc;

-- 9) Calculate the stock remaining after fulfilling all orders:

select b.book_id, b.title , b.stock , coalesce(sum(o.quantity),0 ) as order_quantity,
b.stock - coalesce(sum(o.quantity),0) as Remaining_quantity
from books b
left join orders o on  b.book_id = o.book_id
group by b.book_id

-- This is the basic project... 
