-- SQL Data Types:
select column_one, number_column
from table_name
order by number_column desc

-- Show each product's product name and price, sorted from the highest price to the lowest. Keep only the first 5 rows.
select product_name, price
from products
order by price desc
limit 5


--Numbers and Calculations in SQL 
select column_one, number_a - number_b as new_number
from table_name
where number_a - number_b >= 10
order by new_number desc

--ow each product's product name, price, cost, and calculated margin. Keep products where the margin is at least 10, with the largest margin first and ties broken by product name.s
select product_name, price, cost, price - cost as margin
from products
where price - cost >= 10
order by margin desc, product_name


--SQL Strings Need Quotes
select text_column, another_column
from table_name
where text_column = 'exact text value'
order by text_column

--Fix the query so it returns the supplier name and state for suppliers in PA, sorted by supplier name.
select supplier_name, state
from suppliers
where state = 'PA'
order by supplier_name

-- Dates and Times
select id_column, date_column
from table_name
where date_column >= date '2024-05-01'
order by date_column


--Show the order id, order date, and status for orders placed on or after May 1, 2024. Sort from oldest to newest.
select order_id, order_date, status
from orders
where order_date >= date '2024-05-01'
order by order_date

--Booleans and Flag
select item_name, flag_column
from table_name
where condition
  and not flag_column

-- Show the product name, quantity on hand, reorder level, and discontinued flag for products that are below their reorder level, excluding discontinued products.
select product_name, quantity_on_hand, reorder_level, discontinued
from products
where quantity_on_hand < reorder_level
  and not discontinued
order by quantity_on_hand, product_name


--Missing Values with SQL NULL
select id_column, nullable_column
from table_name
where nullable_column is null
  and status_column <> 'cancelled'

--Fix the query so it returns unshipped orders: rows where shipped date is missing. Exclude cancelled orders and sort from oldest to newest.
select order_id, order_date, shipped_date, status
from orders
where shipped_date = null
  and status  <> 'cancelled'
order by order_date,order_id




