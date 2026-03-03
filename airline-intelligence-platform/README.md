# U.S. Airline Intelligence Platform

A medallion-style data pipeline and analytics platform built on the BTS On-Time Performance dataset (~6M flights, 2013).

`Raw DOT data → Bronze → Silver → Gold marts → Regression analysis`

---

## Repository Structure

```text
airline-intelligence-platform/
├── test.py
├── reports/
│   ├── data_quality_phase2.md
│   └── manifest.parquet
└── src/
    ├── bronze_to_parquet.py
    ├── manifest.py
    ├── 01_silver_clean.ipynb
    ├── 02_data_quality.ipynb
    ├── 03_gold_marts.ipynb
    ├── 04_analysis_regression.ipynb
    └── reports/
        └── data_quality_phase2.md
```

> **Note:** `data/` is excluded from version control (raw + processed files are too large).  
> **Download raw data:** [BTS On-Time Performance — Download Page](https://www.transtats.bts.gov/DL_SelectFields.aspx?gnoyr_VQ=FGJ&QO_fu146_anzr=b0-gvzr)  
> Select year **2013**, download all months, combine into `flights_2013.csv`, and place it in `data/raw/dot_ontime/`. Then run the pipeline in order.

---

## Pipeline Stages

| Step | File | Purpose |
|------|------|---------|
| 1 | `src/bronze_to_parquet.py` | Convert raw DOT CSV to typed Parquet (Bronze) |
| 2 | `src/01_silver_clean.ipynb` | Build cleaned flight-level fact table (Silver) |
| 3 | `src/02_data_quality.ipynb` | Validate schema, nulls, distributions, business rules |
| 4 | `src/03_gold_marts.ipynb` | Build four analytics-ready Gold marts |
| 5 | `src/04_analysis_regression.ipynb` | Regression-driven delay insights |

---

## Gold Data Products

- **Airport Daily Performance** — grain: `flight_date × airport`  
  Metrics: flights, cancel/divert rates, delay rates, avg arrival delay, avg taxi-out

- **Route Monthly Performance** — grain: `month_start × origin × dest`  
  Metrics: flights, cancel rate, delay rates, avg arrival delay, avg distance

- **Carrier Monthly Performance** — grain: `month_start × carrier`  
  Metrics: flights, cancel rate, delay rates, avg arrival delay, avg taxi-out

- **Delay Cause Analysis** — grain: `month_start × carrier` (delayed, non-cancelled flights)  
  Metrics: avg contribution by delay cause (carrier, weather, NAS, security, late aircraft)

---

## Tools Used

Python, Pandas, NumPy, scikit-learn, Jupyter Notebooks, Parquet / PyArrow
