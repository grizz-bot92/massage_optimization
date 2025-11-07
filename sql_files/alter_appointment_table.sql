use massage_data;

select treatment_name from appointments where treatment_name LIKE '%cbd%';

ALTER TABLE appointment
CHANGE COLUMN revenue revenue DECIMAL(10,2);

RENAME TABLE appointment TO appointments;

ALTER TABLE appointments ADD COLUMN expected_revenue DECIMAL(10,2);

SELECT DISTINCT(treatment_name) FROM appointments WHERE treatment_name LIKE '%CBD%';



UPDATE appointments
SET treatment_name = 'CBD Massage'
WHERE treatment_name IN('Warm Winter Glow CBD Massage', 'cbd massage');

SET SQL_SAFE_UPDATES = 0;

UPDATE appointments
SET expected_revenue = CASE
	WHEN treatment_name LIKE '%Deep Tissue%' AND duration = 60 THEN 115.00
    WHEN treatment_name LIKE '%Deep Tissue%' AND duration = 90 THEN 165.00
    WHEN treatment_name LIKE '%Swedish%' AND duration = 60 THEN 105.00
    WHEN treatment_name LIKE '%Swedish%' AND duration = 90 THEN 145.00
    WHEN treatment_name LIKE '%cbd%' THEN 110.00
    WHEN treatment_name LIKE '%Back & Shoulders' THEN 60.00
    WHEN treatment_name LIKE '%Hot Stone%' THEN 165.00
    WHEN treatment_name LIKE '%Prenatal%' THEN 110.00
    WHEN treatment_name LIKE '%Aromatherapy%' THEN 160.00
    WHEN treatment_name LIKE '%Foot%' THEN 75.00
    ELSE NULL
END;

SET SQL_SAFE_UPDATES = 1;
