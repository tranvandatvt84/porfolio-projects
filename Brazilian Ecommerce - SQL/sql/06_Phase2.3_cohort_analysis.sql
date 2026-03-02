USE olist;

-- =========================================================
-- COHORT + RETENTION ANALYSIS
-- ---------------------------------------------------------
-- Goal:
--   1) Group customers by their FIRST purchase month (cohort)
--   2) Track how many customers return in later months
--
-- Output:
--   cohort_ym        = cohort month (YYYY-MM)
--   month_index      = months since first purchase
--   active_customers = customers active in that month
--   cohort_customers = original cohort size
--   retention_pct    = retention rate
-- =========================================================


-- ---------------------------------------------------------
-- Step 1: Find each customer's FIRST purchase date
-- ---------------------------------------------------------
WITH first_purchase AS (
    SELECT
        c.customer_unique_id,
        MIN(DATE(o.order_purchase_timestamp)) AS first_order_date
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),


-- ---------------------------------------------------------
-- Step 2: Create customer activity by MONTH
-- (One row per customer per active month)
-- ---------------------------------------------------------
orders_by_month AS (
    SELECT
        c.customer_unique_id,
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_ym
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    WHERE o.order_purchase_timestamp IS NOT NULL

    -- GROUP BY removes duplicate orders within same month
    GROUP BY c.customer_unique_id, order_ym
),


-- ---------------------------------------------------------
-- Step 3: Assign each customer to a COHORT month
-- (based on their first purchase)
-- ---------------------------------------------------------
cohorts AS (
    SELECT
        fp.customer_unique_id,
        DATE_FORMAT(fp.first_order_date, '%Y-%m') AS cohort_ym
    FROM first_purchase fp
),


-- ---------------------------------------------------------
-- Step 4: Calculate cohort SIZE
-- (# of customers who joined each cohort)
-- ---------------------------------------------------------
cohort_size AS (
    SELECT
        cohort_ym,
        COUNT(DISTINCT customer_unique_id) AS cohort_customers
    FROM cohorts
    GROUP BY cohort_ym
),


-- ---------------------------------------------------------
-- Step 5: Calculate cohort ACTIVITY
--
-- month_index:
--   difference between activity month and cohort month
--   0 = first purchase month
--   1 = next month
--   etc.
--
-- PERIOD_DIFF requires YYYYMM format,
-- so we remove "-" from YYYY-MM strings.
-- ---------------------------------------------------------
cohort_activity AS (
    SELECT
        ch.cohort_ym,
        obm.order_ym,

        PERIOD_DIFF(
            REPLACE(obm.order_ym,'-',''),
            REPLACE(ch.cohort_ym,'-','')
        ) AS month_index,

        COUNT(DISTINCT obm.customer_unique_id) AS active_customers

    FROM cohorts ch
    JOIN orders_by_month obm
        ON obm.customer_unique_id = ch.customer_unique_id

    GROUP BY ch.cohort_ym, obm.order_ym, month_index
)


-- ---------------------------------------------------------
-- Step 6: Final Retention Calculation
-- ---------------------------------------------------------
SELECT
    ca.cohort_ym,
    ca.month_index,
    ca.active_customers,
    cs.cohort_customers,

    -- Retention % = active / original cohort size
    ROUND(100 * ca.active_customers / cs.cohort_customers, 2) AS retention_pct

FROM cohort_activity ca
JOIN cohort_size cs USING (cohort_ym)

-- Remove negative month_index (data issues or edge cases)
WHERE ca.month_index >= 0

ORDER BY ca.cohort_ym, ca.month_index;
