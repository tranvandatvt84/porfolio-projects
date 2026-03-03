import polars as pl
print(pl.read_parquet("data/processed/bronze/dot_ontime/flights_2013.parquet").head())

