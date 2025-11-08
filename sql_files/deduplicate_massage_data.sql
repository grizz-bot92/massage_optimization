select COUNT(*) from appointments WHERE status = 'Cancelled';

ALTER TABLE appointments
MODIFY COLUMN revenue DECIMAL(10,2);

UPDATE appointments
SET treatment_name = 'CBD Massage'
WHERE treatment_name IN('Cannabis Cure Massage','winter warmup massage');

SELECT
	treatment_name,
	SUM(revenue) AS total_revenue,
    SUM(expected_revenue) AS expected_revenue,
	SUM(expected_revenue - revenue) AS lost_income
FROM appointments
GROUP BY treatment_name;

select * from appointments WHERE treatment_name = 'Back & Shoulder Massage';

SELECT *
FROM appointments
WHERE appointment_on = '2023-12-11'
  AND LOWER(TRIM(status)) LIKE 'cancel%';

-- check for duplicates

SELECT appointment_on, client_id, treatment_name, COUNT(*) AS rows_per_combo
FROM appointments
WHERE appointment_on = '2023-12-11'
  AND LOWER(TRIM(status)) LIKE 'cancel%'
GROUP BY appointment_on, client_id, treatment_name
HAVING COUNT(*) > 1;

CREATE TABLE appointments_backup AS SELECT * FROM appointments;

WITH ranked AS (
	SELECT
		appointment_id,
        ROW_NUMBER() OVER(
			PARTITION BY appointment_on, client_id, treatment_name, duration
            ORDER BY(TRIM(LOWER(status)) = 'paid') DESC,
            revenue DESC,
            appointment_id DESC
		) AS rn
        FROM appointments
)
SELECT a.*
FROM appointments a
JOIN ranked r ON r.appointment_id = a.appointment_id
WHERE r.rn = 1
ORDER BY appointment_on, client_id, treatment_name, duration;

WITH ranked AS (
	SELECT
		appointment_id,
        ROW_NUMBER() OVER(
			PARTITION BY appointment_on, client_id, treatment_name, duration
            ORDER BY(TRIM(LOWER(status)) = 'paid') DESC,
            revenue DESC,
            appointment_id DESC
		) AS rn
        FROM appointments
)
DELETE a
FROM appointments a
JOIN ranked r ON r.appointment_id = a.appointment_id
WHERE r.rn > 1;

SELECT COUNT(*)
FROM appointments
WHERE appointment_on = '2023-12-11'
ORDER BY client_id, treatment_name;

SELECT COUNT(*) 
FROM appointments
WHERE appointment_on = '2023-12-11' AND LOWER(TRIM(status)) = 'cancelled';

ALTER TABLE appointments
ADD UNIQUE KEY unique_appt(appointment_on, client_id, treatment_name, duration);

SELECT 
	YEAR(appointment_on) AS year,
    MONTH(appointment_on) AS month,
    SUM(expected_revenue) AS total_expected,
    SUM(revenue) AS revenue,
    SUM(expected_revenue - revenue) AS lost_income
FROM appointments
GROUP BY 
	YEAR(appointment_on),
    MONTH(appointment_on)
ORDER BY
	YEAR(appointment_on),
    MONTH(appointment_on);
    
SELECT 
	YEAR(appointment_on) AS year, 
    SUM(revenue) AS revenue
FROM appointments
GROUP BY YEAR(appointment_on)
ORDER BY YEAR(appointment_on);

SELECT COUNT(*), COUNT(DISTINCT appointment_id)
FROM appointments;





