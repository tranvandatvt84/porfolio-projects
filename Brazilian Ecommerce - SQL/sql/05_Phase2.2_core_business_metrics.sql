USE olist;

-- =========================================================
-- 2.2A) Revenue / GMV basics
-- =========================================================

-- Total item revenue
SELECT
	SUM(price) AS total_item_revenue
FROM order_items;

-- Total freight charge
SELECT
	SUM(freight_value) AS total_freight
FROM order_items;

-- GMV = items + freight (order_items-based)
SELECT
	SUM(price + freight_value) AS total_gmv
FROM order_items;

-- Payments total (my different from GMV)
SELECT 
	SUM(payment_value) AS total_payments
FROM order_payments;

-- =========================================================
-- 2.3B) Orders & customers overview
-- =========================================================

-- Total orders, deliered orders, delivery rate
SELECT
	COUNT(*) AS total_orders,
    SUM(order_status = 'delivered') AS delivered_orders,
    ROUND(100 * SUM(order_status = 'delivered') / COUNT(*), 2) AS delivery_rate
FROM orders;

-- Unique customers (by customer_unique_id)
SELECT
	COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;

-- Orders per custoer distribution
SELECT
	c.customer_unique_id,
    COUNT(*) AS orders_cnt
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY orders_cnt DESC;

-- =========================================================
-- 2.3C) Time series trends (monthly)
-- =========================================================

-- Monthly orders
SELECT
	DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS ym,
    COUNT(*) AS orders_cnt
FROM orders
GROUP BY ym
ORDER BY ym;

-- Monthly GMV (items + freight) using purchase date
SELECT 
	DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS ym,
    SUM(oi.price + oi.freight_value) AS gmv
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY ym
ORDER BY ym;

-- Monthly average order value (AOV) based on items + freight per order
SELECT
	DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS ym,
    AVG(t.order_gmv) AS avg_order_value
FROM orders o
JOIN (
	SELECT order_id, SUM(price + freight_value) AS order_gmv
    FROM order_items
    GROUP BY order_id) t
	ON t.order_id = o.order_id
GROUP BY ym
ORDER BY ym;

-- =========================================================
-- 2.3D) Product & category performance
-- =========================================================

-- GMV by product category (English, Portuguese)
SELECT
  COALESCE(t.product_category_name_english, p.product_category_name) AS category_english,
  COALESCE(t.product_category_name) AS category_portuguese,
  SUM(oi.price + oi.freight_value) AS gmv
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation t
  ON t.product_category_name = p.product_category_name
GROUP BY category_portuguese, category_english
ORDER BY gmv DESC;

-- Top products by item revenue
SELECT
	oi.product_id,
    SUM(oi.price) AS item_revenue,
    COUNT(*) AS items_sold
FROM order_items oi
GROUP BY oi.product_id
ORDER BY item_revenue DESC;

-- =========================================================
-- 2.3E) Seller performance
-- =========================================================

-- Top sellers by GMV
SELECT
  oi.seller_id,
  SUM(oi.price + oi.freight_value) AS gmv,
  COUNT(DISTINCT oi.order_id) AS orders_cnt,
  COUNT(*) AS items_cnt
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY gmv DESC
LIMIT 20;

-- Seller performance by state
SELECT
  s.seller_state,
  SUM(oi.price + oi.freight_value) AS gmv,
  COUNT(DISTINCT oi.order_id) AS orders_cnt
FROM order_items oi
JOIN sellers s ON s.seller_id = oi.seller_id
GROUP BY s.seller_state
ORDER BY gmv DESC;

-- =========================================================
-- 2.3F) Payment behavior
-- =========================================================

-- Payment type mix (share)
SELECT
  payment_type,
  COUNT(*) AS payment_rows,
  ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM order_payments), 2) AS share_pct
FROM order_payments
GROUP BY payment_type
ORDER BY payment_rows DESC;

-- Average payment value by payment type
SELECT
  payment_type,
  AVG(payment_value) AS avg_payment_value,
  AVG(payment_installments) AS avg_installments
FROM order_payments
GROUP BY payment_type
ORDER BY avg_payment_value DESC;

-- =========================================================
-- 2.3H) Delivery performance (logistics KPIs)
-- =========================================================

-- Delivery time (days) for delivered orders
SELECT
	AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS avg_delivery_days,
    MIN(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS min_delivery_days,
    MAX(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS max_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
 AND  order_purchase_timestamp IS NOT NULL;
 
-- Late delivery rate (delivered after estimated)
SELECT
	COUNT(*) AS delivered_orders_with_estimate,
    SUM(order_delivered_customer_date > order_estimated_delivery_date) AS late_deliveries,
    ROUND(100 * SUM(order_delivered_customer_date > order_estimated_delivery_date) / COUNT(*), 2) AS late_rate_pct
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

-- Late rate by customer state
SELECT 
	c.customer_state,
    COUNT(*) AS delivered_orders_with_estimate,
    SUM(o.order_delivered_customer_date > o.order_estimated_delivery_date) AS late_deliveries,
    ROUND(100 * SUM(o.order_delivered_customer_date > o.order_estimated_delivery_date) / COUNT(*), 2) AS late_rate_pct
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY c.customer_state
HAVING COUNT(*) >= 200
ORDER BY late_rate_pct DESC;

-- =========================================================
-- 2.3I) Customer location insights
-- =========================================================

-- GMV by customer state
SELECT
  c.customer_state,
  SUM(oi.price + oi.freight_value) AS gmv,
  COUNT(DISTINCT o.order_id) AS orders_cnt
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_state
ORDER BY gmv DESC;

-- Top cities by order count
SELECT
  c.customer_state,
  c.customer_city,
  COUNT(*) AS orders_cnt
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_state, c.customer_city
ORDER BY orders_cnt DESC
LIMIT 30;
    