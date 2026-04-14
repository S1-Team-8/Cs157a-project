CREATE DATABASE IF NOT EXISTS petwellness;

USE petwellness;

CREATE TABLE pet_owner (
    owner_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL
);

CREATE TABLE visit (
    visit_id INT AUTO_INCREMENT PRIMARY KEY,
    pet_id INT NOT NULL,
    vet_id INT NOT NULL,
    visit_date DATETIME NOT NULL,
    notes TEXT,
    FOREIGN KEY (pet_id) REFERENCES pet(pet_id)
);

CREATE TABLE procedure_record (
    procedure_id INT AUTO_INCREMENT PRIMARY KEY,
    visit_id INT NOT NULL,
    procedure_name VARCHAR(100) NOT NULL,
    charge_amount DECIMAL(10,2) NOT NULL,
    notes TEXT,
    FOREIGN KEY (visit_id) REFERENCES visit(visit_id)
);

CREATE TABLE appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    pet_id INT NOT NULL,
    vet_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    FOREIGN KEY (pet_id) REFERENCES pet(pet_id)
);

CREATE TABLE staff (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE inventory_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    qty_on_hand INT NOT NULL,
    reorder_threshold INT NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL
);

CREATE TABLE visit_support_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    visit_id INT NOT NULL,
    technician_id INT NOT NULL,
    weight DECIMAL(6,2),
    temperature DECIMAL(5,2),
    notes TEXT,
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (visit_id) REFERENCES visit(visit_id)
);
