-- PetWellness Migration Script
-- Run this against your existing petwellness database to bring it up to date.
-- Safe to run multiple times (uses IF NOT EXISTS / IGNORE where possible).

USE petwellness;

-- 1. service_catalog (if it was never created)
CREATE TABLE IF NOT EXISTS service_catalog (
    service_id   INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    category     VARCHAR(50),
    description  TEXT
);

-- 2. clinic_service (links clinics to services with pricing)
CREATE TABLE IF NOT EXISTS clinic_service (
    clinic_service_id INT AUTO_INCREMENT PRIMARY KEY,
    clinic_id         INT NOT NULL,
    service_id        INT NOT NULL,
    price_min         DECIMAL(10,2),
    price_max         DECIMAL(10,2),
    UNIQUE KEY uq_clinic_service (clinic_id, service_id),
    FOREIGN KEY (clinic_id)  REFERENCES clinic(clinic_id),
    FOREIGN KEY (service_id) REFERENCES service_catalog(service_id)
);

-- 3. Add missing columns to clinic (skip if already present)
ALTER TABLE clinic ADD COLUMN IF NOT EXISTS email  VARCHAR(100);
ALTER TABLE clinic ADD COLUMN IF NOT EXISTS rating DECIMAL(3,2) DEFAULT 0.00;

-- 4. Add service_id to visit (skip if already present)
ALTER TABLE visit ADD COLUMN IF NOT EXISTS service_id INT NULL;

-- 5. Add service_id to appointment (skip if already present)
ALTER TABLE appointment ADD COLUMN IF NOT EXISTS service_id INT NULL;

-- 6. Make appointment.vet_id nullable (owners submit requests before a vet is assigned)
ALTER TABLE appointment MODIFY COLUMN vet_id INT NULL;

-- 7. inventory_usage_log (tracks which inventory items were consumed per procedure)
CREATE TABLE IF NOT EXISTS inventory_usage_log (
    usage_id     INT AUTO_INCREMENT PRIMARY KEY,
    item_id      INT NOT NULL,
    procedure_id INT NULL,
    qty_used     INT NOT NULL,
    used_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    staff_id     INT NOT NULL,
    FOREIGN KEY (item_id)      REFERENCES inventory_item(item_id),
    FOREIGN KEY (procedure_id) REFERENCES procedure_record(procedure_id),
    FOREIGN KEY (staff_id)     REFERENCES staff(employee_id)
);

-- Add FK constraints (will error harmlessly if already exist — just ignore)
ALTER TABLE visit       ADD CONSTRAINT fk_visit_service FOREIGN KEY (service_id) REFERENCES service_catalog(service_id);
ALTER TABLE appointment ADD CONSTRAINT fk_appt_service  FOREIGN KEY (service_id) REFERENCES service_catalog(service_id);
