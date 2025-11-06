import pandas as pd
import re

df = pd.read_csv('excel_files/updated_merged_massage_clients.csv')


#Normalize Treatment names

df['Treatment Name'] = (
    df['Treatment Name']
    .str.strip()
    .str.lower()
    .str.replace(r'\.', '', regex=True)
    .str.replace(r'\s+', ' ', regex=True)
)

#clean status field
df['Status'] = (
    df['Status']
    .str.replace('/complete', '', regex=False)
    .str.replace('guest checked-in', 'paid', regex=False)
    .str.replace('confirmed', '', regex=False)
    .str.replace(r'paid(\(in service\))?', 'paid', regex=True)
    .str.strip()
)

#treatment mapping
replacements  = {
    "100 acres of relaxation cannabis cure massage": "cbd massage",
    "cannabis cure massage": "cbd massage",
    "warm winter glow cbd massage": "cbd massage",
    "himalayan hot stone massage": "hot stone massage",
    "signature aromatherapy massage": "aromatherapy massage",
    "90 minute deep tissue": "deep tissue massage",
    "90 minute swedish": "swedish massage",
    "deep tissue massage.": "deep tissue massage",
}

for k, v in replacements.items():
    df['Treatment Name'] = df['Treatment Name'].str.replace(k, v, regex=False)

#standardize duration in minute
pattern = r'(?i)(\d+)\s*[- ]?\s*min(?:ute)?s?'
df['Extracted Duration'] = df['Treatment Name'].str.extract(pattern)[0]

df['Duration'] = pd.to_numeric(df['Extracted Duration'], errors='coerce')

#mapping duration for fallback times 

duration_mapping = {
    'cbd massage': 60,
    'hot stone massage': 90,
    'aromatherapy massage': 60,
    'back & shoulder massage': 30,
    'prenatal massage': 60,
    'foot and leg therapy': 30,
    'deep tissue massage': 60,
    'swedish massage': 60,
}

df['Duration'].fillna(df['Treatment Name'].map(duration_mapping), inplace=True)

df.to_csv('excel_files/cleaned_massage_data.csv', index=False)