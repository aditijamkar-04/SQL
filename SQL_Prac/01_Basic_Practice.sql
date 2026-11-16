-- SQL SYNTAX:
select column_names
from table_name

--Run the starter query, then change it to show each customer's first name, last name, city, and state.
SELECT FIRST_NAME,LAST_NAME,CITY,STATE FROM customers
limit 5


--SQL SELECT Statement
select column_one, column_two
from table_name
limit 5

-- Show each product's product name and price. Keep the result to the first 5 rows.
SELECT PRODUCT_NAME,PRICE
FROM PRODUCTS
LIMIT 5


--Tables, Rows, and Columns in SQL
select count(*) as row_count
from table_name

--Count how many rows are in the customers table. Name the output column customer_count.
select COUNT(*) as customer_count
from customers
limit 5

-- Meet the SQL Workbench
-- The workbench is where you try SQL, read results, and fix mistakes.
select column_one, column_two
from table_name
limit 5

-- Run the starter query to see what happens, then fix it so it shows each product's product name, price, and quantity on hand for the first 5 rows.
select product_name, prise, quantity_on_hand
from products
limit 5         --- error
-- Binder Error: Referenced column "prise" not found in FROM clause!
--fixed
select product_name, price, quantity_on_hand
from products
limit 5


--SQL WHERE: Filtering Rows
select column_one, column_two
from table_name
where number_column < 10

--Show the product name and price of every product that costs less than $10.
select product_name, price
from products
where price<10;


--SQL ORDER BY and LIMIT
select column_one, column_two
from table_name
order by sort_column desc
limit 5

--Show the product name and quantity on hand for the five products with the least stock, lowest first.
select product_name, quantity_on_hand
from products
order by quantity_on_hand
limit 5










