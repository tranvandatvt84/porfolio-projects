use olist;

-- ---------------------------------------------------------
-- Create Relationships
-- ---------------------------------------------------------

-- Convert key columns from TEXT to VARCHAR 
ALTER TABLE customers    MODIFY customer_id VARCHAR(32) NOT NULL;
ALTER TABLE sellers      MODIFY seller_id   VARCHAR(32) NOT NULL;
ALTER TABLE products     MODIFY product_id  VARCHAR(32) NOT NULL;
ALTER TABLE orders       MODIFY order_id    VARCHAR(32) NOT NULL;
ALTER TABLE order_items  MODIFY order_id    VARCHAR(32) NOT NULL,
                         MODIFY product_id  VARCHAR(32) NOT NULL,
                         MODIFY seller_id   VARCHAR(32) NOT NULL;
ALTER TABLE order_payments MODIFY order_id  VARCHAR(32) NOT NULL;
ALTER TABLE order_reviews  MODIFY review_id  VARCHAR(32) NOT NULL;

ALTER TABLE product_category_name_translation
  MODIFY product_category_name VARCHAR(100) NOT NULL;

ALTER TABLE products
  MODIFY product_category_name VARCHAR(100) NULL;
  
ALTER TABLE customers
  MODIFY customer_id VARCHAR(32) NOT NULL;

ALTER TABLE orders
  MODIFY customer_id VARCHAR(32) NOT NULL;



-- Primary keys
-- --------------------------------------------------------
ALTER TABLE customers ADD PRIMARY KEY (customer_id);
ALTER TABLE sellers   ADD PRIMARY KEY (seller_id);
ALTER TABLE products  ADD PRIMARY KEY (product_id);
ALTER TABLE orders    ADD PRIMARY KEY (order_id);

-- order_items: one order has multiple items -> composite PK
ALTER TABLE order_items ADD PRIMARY KEY (order_id, order_item_id);

-- payments: multiple payments per order -> composite PK
ALTER TABLE order_payments ADD PRIMARY KEY (order_id, payment_sequential);

-- reviews: often 1 per order; use review_id PK + unique order_id if you want
ALTER TABLE order_reviews
ADD PRIMARY KEY (order_id, review_id);
-- Optional (recommended if truly 1 review per order):
-- ALTER TABLE order_reviews ADD UNIQUE KEY uk_reviews_order (order_id);

ALTER TABLE product_category_name_translation
  ADD PRIMARY KEY (product_category_name);

  
  -- Foreign keys
  -- -----------------------------------------------------
-- =========================
-- ORDERS → CUSTOMERS
-- =========================
ALTER TABLE orders ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

-- =========================
-- ORDER_ITEMS → ORDERS
-- =========================
ALTER TABLE order_items ADD CONSTRAINT fk_items_order
FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- =========================
-- ORDER_ITEMS → PRODUCTS
-- =========================
ALTER TABLE order_items ADD CONSTRAINT fk_items_product
FOREIGN KEY (product_id) REFERENCES products(product_id);

-- =========================
-- ORDER_ITEMS → SELLERS
-- =========================
ALTER TABLE order_items ADD CONSTRAINT fk_items_seller
FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);

-- =========================
-- ORDER_PAYMENTS → ORDERS
-- =========================
ALTER TABLE order_payments ADD CONSTRAINT fk_payments_order
FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- =========================
-- ORDER_REVIEWS → ORDERS
-- (works with composite PK you created)
-- =========================
ALTER TABLE order_reviews ADD CONSTRAINT fk_reviews_order
FOREIGN KEY (order_id) REFERENCES orders(order_id);


SELECT CONCAT(
    'ALTER TABLE `', TABLE_NAME, '` DROP PRIMARY KEY;'
)
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY'
AND TABLE_SCHEMA = 'olist';
ALTER TABLE `customers` DROP PRIMARY KEY;
ALTER TABLE `order_items` DROP PRIMARY KEY;
ALTER TABLE `order_payments` DROP PRIMARY KEY;
ALTER TABLE `orders` DROP PRIMARY KEY;
ALTER TABLE `products` DROP PRIMARY KEY;
ALTER TABLE `sellers` DROP PRIMARY KEY;




