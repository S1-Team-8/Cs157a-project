CREATE DATABASE IF NOT EXISTS petwellness;

USE petwellness;

CREATE TABLE IF NOT EXISTS pet_owner (
    owner_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS clinic (
    clinic_id INT AUTO_INCREMENT PRIMARY KEY,
    clinic_name VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    address VARCHAR(255),
    phone VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS pet (
    pet_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    pet_name VARCHAR(100) NOT NULL,
    species VARCHAR(50),
    FOREIGN KEY (owner_id) REFERENCES pet_owner(owner_id)
);

CREATE TABLE IF NOT EXISTS staff (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS visit (
    visit_id INT AUTO_INCREMENT PRIMARY KEY,
    pet_id INT NOT NULL,
    vet_id INT NOT NULL,
    visit_date DATETIME NOT NULL,
    notes TEXT,
    FOREIGN KEY (pet_id) REFERENCES pet(pet_id)
);

CREATE TABLE IF NOT EXISTS procedure_record (
    procedure_id INT AUTO_INCREMENT PRIMARY KEY,
    visit_id INT NOT NULL,
    procedure_name VARCHAR(100) NOT NULL,
    charge_amount DECIMAL(10,2) NOT NULL,
    notes TEXT,
    FOREIGN KEY (visit_id) REFERENCES visit(visit_id)
);

CREATE TABLE IF NOT EXISTS appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    pet_id INT NOT NULL,
    vet_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    FOREIGN KEY (pet_id) REFERENCES pet(pet_id)
);

CREATE TABLE IF NOT EXISTS inventory_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    qty_on_hand INT NOT NULL,
    reorder_threshold INT NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS visit_support_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    visit_id INT NOT NULL,
    technician_id INT NOT NULL,
    weight DECIMAL(6,2),
    temperature DECIMAL(5,2),
    notes TEXT,
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (visit_id) REFERENCES visit(visit_id)
);

CREATE TABLE IF NOT EXISTS clinic (
    clinic_id INT AUTO_INCREMENT PRIMARY KEY,
    clinic_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(30),
    email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS service_catalog (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    description TEXT
);

-- Default admin staff account
-- username: admin2 | password: test (SHA-256 hashed)
INSERT IGNORE INTO staff (full_name, role, username, password_hash, is_active)
VALUES ('Admin User', 'Admin', 'admin2',
        '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', TRUE);
