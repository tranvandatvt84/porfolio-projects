from pathlib import Path
import pandas as pd
import time
import os

RAW_PATH = Path("data/raw/dot_ontime")
MANIFEST_PATH = RAW_PATH / "manifest.csv"

def update_manifest():

    rows = []

    for f in RAW_PATH.glob("*.csv"):
        size = os.path.getsize(f)

        rows.append({
            "filename": f.name,
            "row_count": "",
            "filesize_bytes": size,
            "processed_at": time.strftime("%Y-%m-%d %H:%M:%S")
        })

    df = pd.DataFrame(rows)
    df.to_csv(MANIFEST_PATH, index=False)
    print("Manifest updated.")

if __name__ == "__main__":
    update_manifest()
