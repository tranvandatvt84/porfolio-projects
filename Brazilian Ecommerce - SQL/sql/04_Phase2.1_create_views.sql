USE olist;

-- =========================================================
-- 2.1A) Orders + Customers (1 row per order)
-- =========================================================
CREATE OR REPLACE VIEW vw_orders_enriched AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state
FROM orders o
LEFT JOIN customers c
  ON c.customer_id = o.customer_id;
  
  -- =========================================================
-- 2.1B) Order Items + Products + Sellers (1 row per order item)
-- =========================================================
CREATE OR REPLACE VIEW vw_order_items_enriched AS
SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    oi.shipping_limit_date,
    oi.price,
    oi.freight_value,

    p.product_category_name,
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,

    s.seller_zip_code_prefix,
    s.seller_city,
    s.seller_state
FROM order_items oi
LEFT JOIN products p
  ON p.product_id = oi.product_id
LEFT JOIN sellers s
  ON s.seller_id = oi.seller_id;
  
  -- =========================================================
-- 2.1C) Create Indexes
-- =========================================================
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_purchase_ts ON orders(order_purchase_timestamp);
CREATE INDEX idx_items_order ON order_items(order_id);
CREATE INDEX idx_items_product ON order_items(product_id);
CREATE INDEX idx_payments_order ON order_payments(order_id);
CREATE INDEX idx_reviews_order ON order_reviews(order_id);
