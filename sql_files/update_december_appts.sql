use massage_data;

DESCRIBE appointments;
DESCRIBE appointments_backup;

SELECT (SELECT COUNT(*) FROM appointments) AS now_appts,
		(SELECT COUNT(*) FROM appointments_backup) AS backup_appts;

SELECT b.appointment_id
FROM appointments_backup b
LEFT JOIN appointments a USING (appointment_id)
WHERE a.appointment_id IS NULL;

SELECT DISTINCT(COUNT(*)) FROM appointments;
SELECT COUNT(DISTINCT appointment_id) AS distinct_ids FROM appointments;

SELECT * FROM appointments;

UPDATE appointments 
SET treatment_name = CONCAT(
	UPPER(LEFT(TRIM(LOWER(treatment_name)), 1)),
    SUBSTRING(TRIM(LOWER(treatment_name)), 2)
);

SELECT DISTINCT treatment_name
FROM appointments
ORDER BY treatment_name;

SELECT * FROM appointments;

SELECT
	appointment_on,
	SUM(revenue) AS revenue,
	SUM(expected_revenue) AS expected_revenue,
	SUM(expected_revenue - revenue) AS lost_revenue
FROM appointments
GROUP BY appointment_on;

UPDATE appointments
SET status = 'Cancelled'
WHERE status IN('No Show', 'Booked');

UPDATE appointments
SET status = 'Paid'
WHERE status IN('');

SELECT status FROM appointments;


-- Identified duplicate appointments Signature aromatherapy and aromatherpay and deleted dupes
SELECT * 
FROM appointments
WHERE appointment_on IN (
	SELECT appointment_on
	FROM appointments
    WHERE treatment_name IN('Signature aromatherapy massage')
)
AND client_id IN(
	SELECT client_id
    FROM appointments
    WHERE treatment_name IN('Signature aromatherapy massage')
)
AND treatment_name IN('Signature aromatherapy massage', 'Aromatherapy massage')
ORDER BY appointment_on, client_id;

DELETE FROM appointments
WHERE TRIM(LOWER(treatment_name)) = 'signature aromatherapy massage';

SELECT 
	treatment_name,
	SUM(revenue) AS total_revenue
FROM appointments
GROUP BY treatment_name
ORDER BY total_revenue DESC;

-- Add missing December data

SELECT
	YEAR(appointment_on) AS year,
    SUM(revenue) AS total_revenue
FROM appointments
GROUP BY YEAR(appointment_on);

SELECT
	YEAR(appointment_on) AS year,
	MONTH(appointment_on) AS Month,
    SUM(revenue) AS total_revenue
FROM appointments
GROUP BY YEAR(appointment_on), MONTH(appointment_on);

select SUM(revenue) from appointments;

-- correct wrongly inserted data
CREATE TABLE december_2023_staging LIKE appointments;

START TRANSACTION;
-- DELETE FROM appointments
-- WHERE appointment_on BETWEEN '2023-12-01' AND '2023-12-31';

SET SQL_SAFE_UPDATES = 0;

UPDATE december_2023_staging
SET expected_revenue = CASE
	WHEN treatment_name LIKE '%Deep Tissue%' AND duration = 60 THEN 115.00
    WHEN treatment_name LIKE '%Deep Tissue%' AND duration = 90 THEN 165.00
    WHEN treatment_name LIKE '%Swedish%' AND duration = 60 THEN 105.00
    WHEN treatment_name LIKE '%Swedish%' AND duration = 90 THEN 145.00
    WHEN treatment_name LIKE '%cbd%' THEN 110.00
    WHEN treatment_name LIKE '%Back & Shoulder%' THEN 60.00
    WHEN treatment_name LIKE '%Hot Stone%' THEN 165.00
    WHEN treatment_name LIKE '%Prenatal%' THEN 110.00
    WHEN treatment_name LIKE '%Aromatherapy%' THEN 160.00
    WHEN treatment_name LIKE '%Foot%' THEN 75.00
    ELSE NULL
END;
SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;

UPDATE december_2023_staging
SET treatment_name = CONCAT
	(UPPER(LEFT(TRIM(LOWER(treatment_name)), 1)),
	SUBSTRING(TRIM(LOWER(treatment_name)), 2)
);

INSERT INTO appointments
(client_id, appointment_on, status, treatment_name, duration, revenue, expected_revenue) 
SELECT 
	TRIM(client_id), 
    STR_TO_DATE(TRIM(appointment_on),'%Y-%m-%d') AS appointment_on, 
    TRIM(status), 
    treatment_name, 
    duration, 
    CAST(revenue AS DECIMAL(10,2)), 
    CAST(expected_revenue AS DECIMAL(10,2))
FROM december_2023_staging
ON DUPLICATE KEY UPDATE
	status = VALUES(status),
    revenue = VALUES(revenue),
    expected_revenue = VALUES(expected_revenue);
SET SQL_SAFE_UPDATES = 1;
    
select * FROM appointments WHERE appointment_on LIKE '%2023-12%';

ALTER TABLE `massage_data`.`december_staging` 
RENAME TO  `massage_data`.`december_2024_staging` ;

UPDATE december_2024_staging
SET appointment_on = DATE_ADD(STR_TO_DATE(appointment_on, '%Y-%m-%d'), INTERVAL 1 YEAR)
WHERE appointment_on BETWEEN '2023-12-01' AND '2023-12-31';

SET SQL_SAFE_UPDATES = 0;

UPDATE december_2024_staging
SET expected_revenue = CASE
	WHEN treatment_name LIKE '%Deep Tissue%' AND duration = 60 THEN 115.00
    WHEN treatment_name LIKE '%Deep Tissue%' AND duration = 90 THEN 165.00
    WHEN treatment_name LIKE '%Swedish%' AND duration = 60 THEN 105.00
    WHEN treatment_name LIKE '%Swedish%' AND duration = 90 THEN 145.00
    WHEN treatment_name LIKE '%cbd%' THEN 110.00
    WHEN treatment_name LIKE '%Back & Shoulder%' THEN 60.00
    WHEN treatment_name LIKE '%Hot Stone%' THEN 165.00
    WHEN treatment_name LIKE '%Prenatal%' THEN 110.00
    WHEN treatment_name LIKE '%Aromatherapy%' THEN 160.00
    WHEN treatment_name LIKE '%Foot%' THEN 75.00
    ELSE NULL
END;
SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;

UPDATE december_2024_staging

SET treatment_name = CONCAT
	(UPPER(LEFT(TRIM(LOWER(treatment_name)), 1)),
	SUBSTRING(TRIM(LOWER(treatment_name)), 2)
);

INSERT INTO appointments
(client_id, appointment_on, status, treatment_name, duration, revenue, expected_revenue) 
SELECT 
	TRIM(client_id), 
    STR_TO_DATE(TRIM(appointment_on),'%Y-%m-%d') AS appointment_on, 
    TRIM(status), 
    treatment_name, 
    duration, 
    CAST(revenue AS DECIMAL(10,2)), 
    CAST(expected_revenue AS DECIMAL(10,2))
FROM december_2024_staging
ON DUPLICATE KEY UPDATE
	status = VALUES(status),
    revenue = VALUES(revenue),
    expected_revenue = VALUES(expected_revenue);

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM appointments;