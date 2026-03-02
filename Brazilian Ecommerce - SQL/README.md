# 🧠 Olist Intelligence --- Advanced SQL Analytics (MySQL 8)

**Author:** Dat Tran\
**Tech Stack:** MySQL 8 • SQL • Data Modeling • Analytical SQL\
**Dataset:** Brazilian Olist E-Commerce Public Dataset

------------------------------------------------------------------------

## 📌 Project Overview

This project demonstrates an **end-to-end SQL analytics workflow**,
starting from raw CSV ingestion and progressing through data
engineering, relationship modeling, business analytics, and advanced
cohort retention analysis.

The goal was to simulate a real production-style analytics pipeline
using MySQL:

✔ Bulk load large datasets\
✔ Perform data quality validation\
✔ Build relational schema with PK/FK relationships\
✔ Create enriched analytical views\
✔ Develop business KPI queries\
✔ Implement advanced cohort retention analytics

------------------------------------------------------------------------

## 🏗️ Architecture Overview

    CSV Files
       ↓
    (MySQL Workbench Import Wizard — table structure creation)
       ↓
    Phase 1 — Data Engineering
       • Bootstrap & Bulk Load
       • Data Quality Checks
       • Relationship Modeling
       ↓
    Phase 2 — Analytical Layer
       • Enriched Views + Indexes
       • Core Business Metrics
       • Cohort Retention Analysis

------------------------------------------------------------------------

## 📂 Project Structure
    /csv
      olist_customers_dataset.csv
      olist_geolocation_dataset.csv
      olist_order_items_dataset.csv
      olist_order_payments_dataset.csv
      olist_order_reviews_dataset.csv
      olist_orders_dataset.csv
      olist_products_dataset.csv
      olist_sellers_dataset.csv
      product_category_name_translation.csv
    /sql
      01_phase1_bootstrap_load.sql
      02_phase1.2_dataquality_sanitycheck.sql
      03_phase1.3_create_relationships.sql
      05_Phase2.1_CreateViews.sql
      06_Phase2.2_core_business_metrics.sql
      07_Phase2.3.sql

    /docs
      DATA_DICTIONARY.md
      Olist_Data_Dictionary_PRO_No_EER.pdf

    README.md

------------------------------------------------------------------------

# ⚙️ Phase 1 --- Data Engineering

## 🧱 Table Creation (Workbench Import Wizard)

Before running the SQL pipeline, table schemas were created using the
**MySQL Workbench Table Data Import Wizard**.\
This step generated the initial table structures based on CSV headers.

After the schema was created:

-   Tables were **emptied using TRUNCATE**
-   Data was then reloaded using `LOAD DATA LOCAL INFILE`

This approach separates:

✔ Structure creation (GUI Import Wizard)\
✔ High-performance data ingestion (SQL bulk load)

------------------------------------------------------------------------

## 1.1 Bootstrap + Bulk Load

**Script:** `01_phase1_bootstrap_load.sql`

-   Create database `olist`
-   Enable LOCAL INFILE
-   **Truncate tables created via Import Wizard**
-   Bulk load CSV datasets
-   Apply performance settings
-   Validate row counts after ingestion

Datasets loaded: - customers - orders - order_items - products -
order_payments - order_reviews - sellers - geolocation -
product_category_name_translation

------------------------------------------------------------------------

## 1.2 Data Quality & Sanity Checks

**Script:** `02_phase1.2_dataquality_sanitycheck.sql`

Key validations: - Duplicate detection - Orphan checks - Range
validation - Timestamp normalization - TEXT → DATETIME conversion -
Timeline sanity checks - Orders without items check

------------------------------------------------------------------------

## 1.3 Relationship Modeling (PK/FK Design)

**Script:** `03_phase1.3_create_relationships.sql`

Primary Keys: - customers(customer_id) - sellers(seller_id) -
products(product_id) - orders(order_id) - order_items(order_id,
order_item_id) - order_payments(order_id, payment_sequential) -
order_reviews(order_id, review_id)

Foreign Keys: - orders → customers - order_items →
orders/products/sellers - order_payments → orders - order_reviews →
orders

------------------------------------------------------------------------

# 📊 Phase 2 --- Analytical SQL Layer

## 2.1 Enriched Views + Indexing

**Script:** `04_Phase2.1_CreateViews.sql`

Views: - vw_orders_enriched - vw_order_items_enriched

Indexes: - orders(customer_id) - orders(order_purchase_timestamp) -
order_items(order_id) - order_items(product_id) -
order_payments(order_id) - order_reviews(order_id)

------------------------------------------------------------------------

## 2.2 Core Business Metrics

**Script:** `05_Phase2.2_core_business_metrics.sql`

Includes: - Revenue & GMV calculations - Orders & customer behavior -
Monthly trends & AOV - Product/category performance - Seller
performance - Payment analysis - Delivery logistics KPIs - Customer
geography insights

------------------------------------------------------------------------

## 🚀 2.3 Advanced Analytics --- Cohort Retention

**Script:** `06_Phase2.3.sql`

Measures customer retention by first purchase month cohorts.

Output fields: - cohort_ym - month_index - active_customers -
cohort_customers - retention_pct

------------------------------------------------------------------------

# 🧩 Key Skills Demonstrated

-   Bulk data ingestion (LOAD DATA LOCAL INFILE)
-   Data quality validation & normalization
-   Relational schema design (PK/FK modeling)
-   Analytical SQL & aggregation
-   Index optimization
-   Cohort retention analysis
-   Production-style SQL workflow

------------------------------------------------------------------------

# ▶️ How to Run

Execute scripts in this order:

    01_phase1_bootstrap_load.sql
    02_phase1.2_dataquality_sanitycheck.sql
    03_phase1.3_create_relationships.sql
    01_Phase2.1_CreateViews.sql
    02_Phase2.2_core_business_metrics.sql
    03_Phase2.3.sql

------------------------------------------------------------------------

# 📎 Dataset Source

Olist Brazilian E-Commerce Public Dataset (Kaggle)

------------------------------------------------------------------------

# ⭐ Author Notes

Tables were initially generated via MySQL Workbench Import Wizard, then
reloaded through optimized SQL bulk ingestion to simulate a
production-ready ETL workflow.
