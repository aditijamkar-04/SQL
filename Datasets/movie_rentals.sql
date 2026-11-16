-- Movie Rentals - SQL practice dataset
-- Customers, movies, and rental history for a small video rental shop.
--
-- Free to use for any purpose, including commercially. No attribution required.
-- Browse, query, and re-download at https://sqlshed.com/practice-datasets/
--
-- 3 tables, 48 rows. Standard SQL: runs on
-- PostgreSQL, MySQL, SQLite, DuckDB, and SQL Server without edits.

DROP TABLE IF EXISTS rentals;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS movies;

-- movies: One row per movie in the catalog.
CREATE TABLE movies (
  movie_id INTEGER,
  title VARCHAR(255),
  genre VARCHAR(255),
  release_year INTEGER,
  rating DECIMAL(12,2)
);

INSERT INTO movies (movie_id, title, genre, release_year, rating) VALUES
  (1, 'The Last Orchard', 'Drama', 2019, 7.8),
  (2, 'Neon Harbor', 'Sci-Fi', 2021, 8.1),
  (3, 'Quiet Mountain', 'Drama', 2018, 7.2),
  (4, 'Cosmic Drift', 'Sci-Fi', 2022, 6.9),
  (5, 'Saltwater', 'Romance', 2020, 7.5),
  (6, 'Iron Valley', 'Action', 2017, 6.4),
  (7, 'The Long Night', 'Thriller', 2021, 8.4),
  (8, 'Paper Lanterns', 'Animation', 2019, 8.7),
  (9, 'Desert Lines', 'Action', 2023, 7.0),
  (10, 'Midnight Diner', 'Comedy', 2016, 7.9),
  (11, 'Glass Garden', 'Romance', 2022, 6.8),
  (12, 'Echoes', 'Thriller', 2020, 8.0);

-- customers: One row per customer.
CREATE TABLE customers (
  customer_id INTEGER,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  city VARCHAR(255),
  joined_date DATE
);

INSERT INTO customers (customer_id, first_name, last_name, city, joined_date) VALUES
  (1, 'Ava', 'Mitchell', 'Portland', '2022-01-15'),
  (2, 'Liam', 'Nguyen', 'Austin', '2022-03-02'),
  (3, 'Sofia', 'Ramirez', 'Denver', '2021-11-20'),
  (4, 'Noah', 'Patel', 'Seattle', '2022-06-10'),
  (5, 'Mia', 'Johnson', 'Portland', '2023-01-05'),
  (6, 'Ethan', 'Brooks', 'Austin', '2021-09-18'),
  (7, 'Olivia', 'Carter', 'Denver', '2022-08-22'),
  (8, 'Lucas', 'Reed', 'Seattle', '2023-02-14'),
  (9, 'Emma', 'Foster', 'Portland', '2022-04-30'),
  (10, 'Mason', 'Hughes', 'Austin', '2023-05-12');

-- rentals: One row per rental. Movies still out have a null returned_date.
CREATE TABLE rentals (
  rental_id INTEGER,
  customer_id INTEGER,
  movie_id INTEGER,
  rental_date DATE,
  returned_date DATE,
  amount DECIMAL(12,2)
);

INSERT INTO rentals (rental_id, customer_id, movie_id, rental_date, returned_date, amount) VALUES
  (1, 1, 2, '2023-06-01', '2023-06-04', 4.99),
  (2, 1, 8, '2023-06-10', '2023-06-12', 3.99),
  (3, 2, 7, '2023-06-03', '2023-06-09', 4.99),
  (4, 3, 1, '2023-06-05', NULL, 4.99),
  (5, 3, 5, '2023-06-15', '2023-06-18', 3.99),
  (6, 4, 4, '2023-06-02', '2023-06-05', 4.99),
  (7, 5, 10, '2023-06-07', '2023-06-08', 2.99),
  (8, 6, 7, '2023-06-11', '2023-06-14', 4.99),
  (9, 6, 12, '2023-06-20', NULL, 4.99),
  (10, 7, 3, '2023-06-04', '2023-06-07', 3.99),
  (11, 8, 2, '2023-06-06', '2023-06-09', 4.99),
  (12, 9, 8, '2023-06-13', '2023-06-15', 3.99),
  (13, 10, 9, '2023-06-18', '2023-06-21', 4.99),
  (14, 1, 11, '2023-06-22', NULL, 3.99),
  (15, 2, 6, '2023-06-08', '2023-06-12', 2.99),
  (16, 3, 7, '2023-06-25', '2023-06-28', 4.99),
  (17, 4, 10, '2023-06-09', '2023-06-10', 2.99),
  (18, 5, 2, '2023-06-19', '2023-06-22', 4.99),
  (19, 7, 12, '2023-06-21', '2023-06-24', 4.99),
  (20, 8, 5, '2023-06-23', NULL, 3.99),
  (21, 9, 1, '2023-06-14', '2023-06-17', 4.99),
  (22, 10, 4, '2023-06-26', '2023-06-29', 4.99),
  (23, 2, 8, '2023-06-27', NULL, 3.99),
  (24, 6, 3, '2023-06-16', '2023-06-19', 3.99),
  (25, 4, 7, '2023-06-28', '2023-06-30', 4.99),
  (26, 1, 10, '2023-06-29', NULL, 2.99);
