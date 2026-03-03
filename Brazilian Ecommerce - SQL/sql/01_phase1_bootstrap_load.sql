/* =========================================================
   OLIST (MySQL 8) — PHASE 1.1: Bootstrap + Bulk Load
   Author: Dat Tran
   Project: Ultimate Advanced SQL (MySQL 8) — Olist Intelligence
   ========================================================= */

/* ---------------------------
   0) Create + select database
---------------------------- */
CREATE DATABASE IF NOT EXISTS olist;
USE olist;

/* ---------------------------
   1) Enable LOCAL INFILE (verify + enable)
   NOTE: Might require client setting too (Workbench).
---------------------------- */
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

/* ---------------------------
   2) Pre-load housekeeping
   - Tables are created already via Import Wizard
   - Clear tables to reload cleanly
---------------------------- */
TRUNCATE TABLE orders;
TRUNCATE TABLE order_items;
TRUNCATE TABLE customers;
TRUNCATE TABLE products;
TRUNCATE TABLE order_payments;
TRUNCATE TABLE order_reviews;
TRUNCATE TABLE sellers;
TRUNCATE TABLE geolocation;
TRUNCATE TABLE product_category_name_translation;

/* ---------------------------
   3) Sanity check: counts BEFORE load (should be 0)
---------------------------- */
SELECT 'orders' t, COUNT(*) n FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'reviews', COUNT(*) FROM order_reviews
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'geo', COUNT(*) FROM geolocation
UNION ALL SELECT 'category_translation', COUNT(*) FROM product_category_name_translation;


/* ---------------------------
   4) Speed settings (session)
---------------------------- */
SET FOREIGN_KEY_CHECKS=0;
SET UNIQUE_CHECKS=0;
SET AUTOCOMMIT=0;

/* =========================================================
   5) BULK LOADS
   Tips:
   - Windows paths: keep forward slashes OR double backslashes
   - If you see \r issues, use LINES TERMINATED BY '\r\n'
   ========================================================= */

LOAD DATA LOCAL INFILE 'D:/Data Analysis/Brazilian Ecommerce - SQL/CSV/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'D:/Data Analysis/Brazilian Ecommerce - SQL/CSV/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'D:/Data Analysis/Brazilian Ecommerce - SQL/CSV/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'D:/Data Analysis/Brazilian Ecommerce - SQL/CSV/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'D:/Data Analysis/Brazilian Ecommerce - SQL/CSV/olist_order_payments_dataset.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'D:/Data Analysis/Brazilian Ecommerce - SQL/CSV/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'D:/Data Analysis/Brazilian Ecommerce - SQL/CSV/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'D:/Data Analysis/Brazilian Ecommerce - SQL/CSV/olist_geolocation_dataset.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'D:/Data Analysis/Brazilian Ecommerce - SQL/CSV/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/* ---------------------------
   6) Commit + restore settings
---------------------------- */
COMMIT;

SET AUTOCOMMIT=1;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;

/* ---------------------------
   7) Sanity check: counts AFTER load
---------------------------- */
SELECT 'orders' t, COUNT(*) n FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM orders_items
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'reviews', COUNT(*) FROM order_reviews
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'geo', COUNT(*) FROM geolocation
UNION ALL SELECT 'category_translation', COUNT(*) FROM product_category_name_translation;
