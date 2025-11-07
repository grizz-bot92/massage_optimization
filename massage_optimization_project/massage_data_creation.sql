-- CREATE DATABASE massage_data;
use massage_data;

CREATE TABLE Appointment(
	appointment_id INT PRIMARY KEY AUTO_INCREMENT,
	client_id INT,
    status VARCHAR(32),
    appointment_on DATE,
    treatment_name VARCHAR(100),
    duration INT,
    price DECIMAL(10,2)
);

CREATE TABLE availability(
	appointment_date DATE PRIMARY KEY,
	year INT,
    weekday VARCHAR(32),
    available_minutes INT
);
