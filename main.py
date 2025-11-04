import pandas as pd

df = pd.read_csv("excel/anonymized_massage_data")

duration_mapping = {
    'Warm Winter Glow CBD Massage': 60,
    '100 Acres of Relaxation Cannabis Cure Massage': 60,
    'Hot Stone Massage': 90,
    'Signature Aromatherapy Massage': 60,
    'Back & Shoulder Massage': 30,
    'Prenatal Massage': 60,
    'Foot and Leg Therapy': 30,
    'Himalayan Hot Stone Massage': 90,
}


def calculate_price(row):
    treatment = row['Treatment Name']
    duration = row['Duration']
    status = row['Status']

    if status in ['Cancelled', 'No Show']:
        return 0

    if 'Warm Winter Glow CBD Massage' in treatment:
        return 110
    elif 'Deep Tissue Massage' in treatment:
        return 115 if duration == 60 else 165
    elif 'Swedish Massage' in treatment:
        return 105 if duration == 60 else 145
    elif 'Hot Stone Massage' in treatment:
        return 165
    elif 'Back & Shoulder Massage' in treatment:
        return 60
    elif 'Cannabis Cure Massage' in treatment:
        return 100
    elif 'Prenatal Massage' in treatment:
        return 110
    elif 'Himalayan Hot Stone Massage' in treatment:
        return 175
    elif 'Foot and Leg Therapy' in treatment:
        return 75
    elif 'Signature Aromatherapy Massage' in treatment:
        return 160
    return 0


df['Appointment On'] = pd.to_datetime(df['Appointment On']).dt.date
df['Customer Name'] = df['Customer Name'].str.replace('*', '', regex=False)
df['Status'] = df['Status'].str.replace('/Complete', '', regex=False).str.strip()

extracted_duration = df['Treatment Name'].str.extract(r'\((\d+)\s*min\)')[0]
df['Duration'] = extracted_duration.astype(float)
df['Duration'].fillna(df['Treatment Name'].map(duration_mapping), inplace=True)

df['Treatment Name'] = df['Treatment Name'].str.replace(r'\s*\(\d+\s*min\)', '', regex=True)
df['Treatment Name'] = df['Treatment Name'].str.replace('Eyebrow Waxing', '', regex=True)
df['Treatment Name'] = df['Treatment Name'].str.replace('Deep Tissue Massage.', 'Deep Tissue Massage', regex=True)
df['Treatment Name'] = df['Treatment Name'].str.replace('100 Acres of Relaxation Cannabis Cure Massage',
                                                        'Cannabis Cure Massage', regex=True)

df['Status'] = (df['Status'].str.replace('Guest Checked-in', 'Paid')).str.replace('Confirmed', '')
df['Status'] = df['Status'].str.replace(r'Paid( \(In Service\))?', 'Paid', regex=True)


df['Price'] = df.apply(calculate_price, axis=1)


#Cleaned up data removing timestamp
df['Appointment On'] = pd.to_datetime(df['Appointment On']).dt.date
df['Customer Name'] = df['Customer Name'].str.replace('*', '', regex=False)
df['Status'] = df['Status'].str.replace('/Complete', '', regex=False).str.strip()
df.to_csv('updated_merged_massage_clients.csv', index=False)