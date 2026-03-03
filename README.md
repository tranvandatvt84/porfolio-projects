# Airline Intelligence Platform

## Architecture Map

This project follows a medallion-style data pipeline:

`Raw DOT data -> Bronze normalization -> Silver cleaned model -> Gold marts -> Regression analysis`

## Repository Structure

```text
airline-intelligence-platform/
├── README.md
├── test.py
├── data/
│   ├── raw/
│   │   └── dot_ontime/
│   │       ├── flights_2013.csv
│   │       ├── manifest.csv
│   │       └── dictionary.html
│   └── processed/
│       ├── bronze/
│       │   └── dot_ontime/
│       ├── silver/
│       └── gold/
├── reports/
└── src/
    ├── bronze_to_parquet.py
    ├── manifest.py
    ├── 01_silver_clean.ipynb
    ├── 02_data_quality.ipynb
    ├── 03_gold_marts.ipynb
    └── 04_analysis_regression.ipynb
```

- `data/raw/dot_ontime/`: Source files (`flights_2013.csv`, `manifest.csv`, `dictionary.html`).
- `data/processed/bronze/dot_ontime/`: Initial standardized outputs from raw ingestion.
- `data/processed/silver/`: Cleaned flight fact table(s), including `fact_flights.parquet`.
- `data/processed/gold/`: Analytics-ready marts for airport, route, carrier, and delay-cause performance.
- `src/`: ETL scripts and notebooks for each transformation stage.
- `reports/`: Generated report artifacts and analysis deliverables.

## Pipeline Stages

1. **Bronze ingestion**
   - Script: `src/bronze_to_parquet.py`
   - Purpose: Convert raw DOT files into typed parquet datasets.

2. **Silver cleaning**
   - Notebook: `src/01_silver_clean.ipynb`
   - Purpose: Build cleaned, analysis-safe flight-level fact data.

3. **Data quality validation**
   - Notebook: `src/02_data_quality.ipynb`
   - Purpose: Validate schema, nulls, distributions, and business sanity checks.

4. **Gold marts**
   - Notebook: `src/03_gold_marts.ipynb`
   - Outputs:
     - `mart_airport_daily.parquet`
     - `mart_route_monthly.parquet`
     - `mart_carrier_monthly.parquet`
     - `mart_delay_causes.parquet`

5. **Modeling / insights**
   - Notebook: `src/04_analysis_regression.ipynb`
   - Purpose: Regression-driven insight generation from gold marts.

## Gold Data Products

- **Airport Daily Performance**
	- Grain: `flight_date x airport`
	- Metrics: flights, cancel/divert rates, delay rates, average arrival delay, average taxi-out.

- **Route Monthly Performance**
	- Grain: `month_start x origin x dest`
	- Metrics: flights, cancel rate, delay rates, average arrival delay, average distance.

- **Carrier Monthly Performance**
	- Grain: `month_start x carrier`
	- Metrics: flights, cancel rate, delay rates, average arrival delay, average taxi-out.

- **Delay Cause Analysis**
	- Grain: `month_start x carrier` (for delayed, non-cancelled flights)
	- Metrics: average contribution by delay cause (carrier, weather, NAS, security, late aircraft).

## Execution Order

Run in this order for full refresh:

1. `src/bronze_to_parquet.py`
2. `src/01_silver_clean.ipynb`
3. `src/02_data_quality.ipynb`
4. `src/03_gold_marts.ipynb`
5. `src/04_analysis_regression.ipynb`

