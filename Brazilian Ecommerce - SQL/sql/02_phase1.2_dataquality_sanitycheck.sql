USE olist;

-- ---------------------------------------------------------
-- 0) Rowcounts (baseline)
-- ---------------------------------------------------------
SELECT 'orders' t, COUNT(*) n FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'reviews', COUNT(*) FROM order_reviews
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'geo', COUNT(*) FROM geolocation
UNION ALL SELECT 'category_translation', COUNT(*) FROM product_category_name_translation;

-- ---------------------------------------------------------
-- 1) Duplicates (should be 0)
-- ---------------------------------------------------------
SELECT 'orders.order_id dupes' check_name, COUNT(*) - COUNT(DISTINCT order_id) dupes FROM orders;
SELECT 'customers.customer_id dupes', COUNT(*) - COUNT(DISTINCT customer_id) FROM customers;
SELECT 'products.product_id dupes', COUNT(*) - COUNT(DISTINCT product_id) FROM products;
SELECT 'sellers.seller_id dupes', COUNT(*) - COUNT(DISTINCT seller_id) FROM sellers;
SELECT 'order_items(order_id,order_item_id) dupes',
       COUNT(*) - COUNT(DISTINCT CONCAT(order_id,'#',order_item_id)) AS dupes
FROM order_items;

-- ---------------------------------------------------------
-- 2) Orphans (should be 0)
-- ---------------------------------------------------------
SELECT COUNT(*) AS orphan_order_items
FROM order_items oi LEFT JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS orphan_orders_customers
FROM orders o LEFT JOIN customers c ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS orphan_order_items_products
FROM order_items oi LEFT JOIN products p ON p.product_id = oi.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS orphan_order_items_sellers
FROM order_items oi LEFT JOIN sellers s ON s.seller_id = oi.seller_id
WHERE s.seller_id IS NULL;

SELECT COUNT(*) AS orphan_payments_orders
FROM order_payments op LEFT JOIN orders o ON o.order_id = op.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS orphan_reviews_orders
FROM order_reviews r LEFT JOIN orders o ON o.order_id = r.order_id
WHERE o.order_id IS NULL;

-- ---------------------------------------------------------
-- 3) Range sanity
-- ---------------------------------------------------------
SELECT
  SUM(price <= 0) AS non_positive_price_rows,
  SUM(freight_value < 0) AS negative_freight_rows
FROM order_items;

SELECT SUM(payment_value <= 0) AS non_positive_payment_rows
FROM order_payments;

SELECT MIN(review_score) min_score, MAX(review_score) max_score
FROM order_reviews;

-- ---------------------------------------------------------
-- 4) Normalize blanks to NULL (only needed if columns are TEXT)
-- ---------------------------------------------------------
UPDATE orders
SET
  order_purchase_timestamp        = NULLIF(TRIM(order_purchase_timestamp), ''),
  order_approved_at               = NULLIF(TRIM(order_approved_at), ''),
  order_delivered_carrier_date    = NULLIF(TRIM(order_delivered_carrier_date), ''),
  order_delivered_customer_date   = NULLIF(TRIM(order_delivered_customer_date), ''),
  order_estimated_delivery_date   = NULLIF(TRIM(order_estimated_delivery_date), '');

-- Optional: fix translation BOM column name if it exists
-- ALTER TABLE product_category_name_translation
--   RENAME COLUMN product_category_name` TO product_category_name;

-- ---------------------------------------------------------
-- 5) Convert order timestamps to DATETIME safely (add -> fill -> verify -> swap)
-- ---------------------------------------------------------
ALTER TABLE orders
  ADD COLUMN order_purchase_dt DATETIME NULL,
  ADD COLUMN order_approved_dt DATETIME NULL,
  ADD COLUMN order_delivered_carrier_dt DATETIME NULL,
  ADD COLUMN order_delivered_customer_dt DATETIME NULL,
  ADD COLUMN order_estimated_delivery_dt DATETIME NULL;

UPDATE orders
SET
  order_purchase_dt = STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'),
  order_approved_dt = STR_TO_DATE(order_approved_at, '%Y-%m-%d %H:%i:%s'),
  order_delivered_carrier_dt = STR_TO_DATE(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s'),
  order_delivered_customer_dt = STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s'),
  order_estimated_delivery_dt = STR_TO_DATE(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s');

SELECT
  SUM(order_purchase_timestamp IS NOT NULL AND order_purchase_dt IS NULL) AS bad_purchase_parse,
  SUM(order_delivered_customer_date IS NOT NULL AND order_delivered_customer_dt IS NULL) AS bad_delivered_parse,
  SUM(order_estimated_delivery_date IS NOT NULL AND order_estimated_delivery_dt IS NULL) AS bad_estimated_parse
FROM orders;

-- Only run this swap AFTER the bad_*_parse numbers look good (ideally 0)
ALTER TABLE orders
  DROP COLUMN order_purchase_timestamp,
  DROP COLUMN order_approved_at,
  DROP COLUMN order_delivered_carrier_date,
  DROP COLUMN order_delivered_customer_date,
  DROP COLUMN order_estimated_delivery_date,
  RENAME COLUMN order_purchase_dt TO order_purchase_timestamp,
  RENAME COLUMN order_approved_dt TO order_approved_at,
  RENAME COLUMN order_delivered_carrier_dt TO order_delivered_carrier_date,
  RENAME COLUMN order_delivered_customer_dt TO order_delivered_customer_date,
  RENAME COLUMN order_estimated_delivery_dt TO order_estimated_delivery_date;

-- ---------------------------------------------------------
-- 6) Timeline sanity (true "bad ordering")
-- ---------------------------------------------------------
SELECT COUNT(*) AS bad_delivery_before_purchase
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp;

-- ---------------------------------------------------------
-- 7) Business sanity: orders with no items (anti-join)
-- ---------------------------------------------------------
SELECT COUNT(*) AS orders_without_items
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.order_id
WHERE oi.order_id IS NULL;
