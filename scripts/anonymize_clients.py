import pandas as pd
from pathlib import Path

RAW  = Path("excel_files/updated_merged_massage_clients.csv")
OUT = Path("data/anonymized_clients.csv")

df  = pd.read_csv(RAW)

name_col = "Customer Name"

unique_names = pd.Series(df[name_col].dropna().unique(), name="client_name")
mapping = unique_names.reset_index().rename(columns={"index":"client_id"})
mapping["client_id"] = mapping["client_id"] + 1

df = df.merge(mapping, left_on=name_col, right_on="client_name", how="left")
df = df.drop(columns=[name_col, "client_name"])

OUT.parent.mkdir(parents=True, exist_ok=True)
df.to_csv(OUT, index=False)

print(f"Anonymized File: {OUT} ")