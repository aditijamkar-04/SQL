-- SQL Numeric Types:
select typeof(price) as price_type,
       typeof(quantity_on_hand) as quantity_type
from products
limit 1

-- Integers (INTEGER, BIGINT) hold whole numbers exactly.

-- Decimals (DECIMAL, also called NUMERIC) hold a fixed number of decimal places exactly. Money belongs here.
select typeof(7) as whole,
       typeof(7.50) as with_point,
       typeof(7.5e0) as scientific

select cast(123.456 as decimal(5,2)) as fits

select cast(123.456 as decimal(5,2)) as fits

select 0.1 + 0.2 = 0.3 as exact_decimals,
       0.1::double + 0.2::double = 0.3::double as floating_point

--Whole numbers and division
select 7 / 2 as slash,
       7 // 2 as whole_division,
       7 % 2 as remainder

-- Floating point (DOUBLE, FLOAT) holds a very wide range of values, fast, but only approximately.
select product_name, price, price * 1.08 as with_tax
from products
where product_name = 'Monstera Deliciosa'

select 2147483647::integer + 1 as overflow

-- Build a price list with 8% sales tax for every product under $10. Return product_name, price, and price_with_tax, the price times 1.08 as a DECIMAL(10,2). Sort by price, then by product name. The starter's tax column is a DOUBLE, and it shows.
select product_name, price, cast(price * 1.08 as decimal(10,2)) as price_with_tax
from products
where price < 10
order by price, product_name


-- SQL Three-Valued Logic
select order_id,
       shipped_date,
       shipped_date < date '2024-04-20' as shipped_before
from orders
where order_date >= date '2024-03-30'
  and order_date < date '2024-04-20'
order by order_date, order_id

--WHERE keeps only true
select null::boolean and false as null_and_false,
       null::boolean and true as null_and_true,
       null::boolean or true as null_or_true,
       null::boolean or false as null_or_false,
       not null::boolean as not_null

-- IS TRUE and IS NOT TRUE
select null::boolean = true as equals_true,
       null::boolean is true as is_true,
       null::boolean is not true as is_not_true,
       null::boolean is false as is_false,
       null::boolean is not false as is_not_false


-- Take a snapshot of the shipping backlog as it stood on the morning of April 20, 2024: every order placed before April 20 that had not shipped before April 20, including orders with no ship date at all. Keep cancelled orders in. Return order_id, order_date, shipped_date, and status, sorted by order date, then order id. The starter's report finds one order.
select order_id, order_date, shipped_date, status
from orders
where order_date < date '2024-04-20'
  and not (shipped_date < date '2024-04-20') is not true
order by order_date, order_id
