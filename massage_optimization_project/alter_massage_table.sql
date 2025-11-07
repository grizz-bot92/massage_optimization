use massage_data;

ALTER TABLE appointment
CHANGE COLUMN price revenue DECIMAL(10,2);

RENAME TABLE appointment TO appointments;

ALTER TABLE appointments ADD COLUMN expected_revenue DECIMAL(10,2);

UPDATE appointments
SET expected_revenue = CASE
	WHEN treatment_name LIKE '%deep tissue%' AND duration = 60 THEN 115
    WHEN treatment_name LIKE '%deep Tissue%' AND duration = 90 THEN 165
    WHEN treatment_name LIKE '%swedish%' AND duration = 60 THEN 105
    WHEN treatment_name LIKE '%swedish%' AND duration = 90 THEN 145
    WHEN treatment_name LIKE '%cbd%' THEN 110
    WHEN treatment_name LIKE '%back & shoulders' THEN 60
    WHEN treatment_name LIKE '%hot stone%' THEN 165
    WHEN treatment_name LIKE '%prenatal%' THEN 110
    WHEN treatment_name LIKE '%aromatherapy%' THEN 160
    WHEN treatment_name LIKE '%foot%' THEN 75
    ELSE 'logic error'
END

