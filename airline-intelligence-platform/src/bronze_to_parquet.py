import polars as pl
from pathlib import Path
import time
import os

RAW_PATH = Path('data/raw/dot_ontime')
BRONZE_PATH = Path('data/processed/bronze/dot_ontime')

BRONZE_PATH.mkdir(parents=True, exist_ok=True)

def convert_all():
    csv_files = list(RAW_PATH.glob('*.csv'))

    if not csv_files:
        print("No CSV files found in the raw directory.")
        return
    
    for file in csv_files:
        print(f"Processing {file.name}...")
        start = time.time()

        # Lazy scan = handles BIG DATA safely
        df = pl.scan_csv(file)

        out_file = BRONZE_PATH / (f'{file.stem}.parquet')

        df.collect().write_parquet(out_file)

        end = time.time()

        print(f"Saved -> {out_file}")
        print(f'Time: {round(end-start,2)} sec\n')

if __name__ == "__main__":
    convert_all()
