INSERT INTO pet_owner (full_name, email, password_hash) VALUES
('Alice Johnson', 'alice1@example.com', 'hash1'),
('Bob Smith', 'bob2@example.com', 'hash2'),
('Carol Lee', 'carol3@example.com', 'hash3'),
('David Kim', 'david4@example.com', 'hash4'),
('Emma Davis', 'emma5@example.com', 'hash5'),
('Frank Moore', 'frank6@example.com', 'hash6'),
('Grace Hall', 'grace7@example.com', 'hash7'),
('Henry Young', 'henry8@example.com', 'hash8'),
('Ivy Scott', 'ivy9@example.com', 'hash9'),
('Jack White', 'jack10@example.com', 'hash10');

INSERT INTO clinic (clinic_name, city, address, phone, email, distance, rating) VALUES
('Happy Pets Clinic', 'San Jose', '123 Main St', '111-1111', 'c1@mail.com', 5, 4.5),
('Healthy Paws', 'San Jose', '456 Oak St', '222-2222', 'c2@mail.com', 8, 4.2),
('PetCare Center', 'Santa Clara', '789 Pine St', '333-3333', 'c3@mail.com', 10, 4.8),
('VetPlus', 'Sunnyvale', '321 Elm St', '444-4444', 'c4@mail.com', 7, 4.1),
('Animal Wellness', 'Milpitas', '654 Cedar St', '555-5555', 'c5@mail.com', 12, 4.6),
('CareVet', 'Campbell', '147 Birch St', '666-6666', 'c6@mail.com', 9, 4.0),
('Pet Health Hub', 'Cupertino', '258 Maple St', '777-7777', 'c7@mail.com', 6, 4.7),
('Furry Friends Vet', 'Los Gatos', '369 Spruce St', '888-8888', 'c8@mail.com', 15, 4.3),
('Companion Care', 'San Jose', '159 Walnut St', '999-9999', 'c9@mail.com', 4, 4.9),
('Animal First Clinic', 'Santa Clara', '753 Willow St', '000-0000', 'c10@mail.com', 11, 4.4);

INSERT INTO pet (owner_id, pet_name, species) VALUES
(1, 'Buddy', 'Dog'),
(2, 'Mittens', 'Cat'),
(3, 'Charlie', 'Dog'),
(4, 'Max', 'Dog'),
(5, 'Bella', 'Cat'),
(6, 'Rocky', 'Dog'),
(7, 'Lucy', 'Cat'),
(8, 'Daisy', 'Dog'),
(9, 'Luna', 'Cat'),
(10, 'Simba', 'Cat');

INSERT INTO staff (full_name, role, username, password_hash, is_active) VALUES
('Dr. Adams', 'Vet', 'vet1', 'hash', TRUE),
('Dr. Brown', 'Vet', 'vet2', 'hash', TRUE),
('Tech Mike', 'Technician', 'tech1', 'hash', TRUE),
('Tech Sara', 'Technician', 'tech2', 'hash', TRUE),
('Reception Amy', 'Receptionist', 'rec1', 'hash', TRUE),
('Reception Tom', 'Receptionist', 'rec2', 'hash', TRUE),
('Dr. Clark', 'Vet', 'vet3', 'hash', TRUE),
('Dr. Lewis', 'Vet', 'vet4', 'hash', TRUE),
('Tech Nina', 'Technician', 'tech3', 'hash', TRUE),
('Admin John', 'Admin', 'admin3', 'hash', TRUE);

INSERT INTO service_catalog (service_name, category, description) VALUES
('Vaccination', 'Preventive', 'Routine vaccines'),
('Checkup', 'General', 'Basic health check'),
('Surgery', 'Medical', 'Surgical procedures'),
('Dental Cleaning', 'Dental', 'Teeth cleaning'),
('X-Ray', 'Diagnostic', 'Radiology imaging'),
('Blood Test', 'Diagnostic', 'Lab testing'),
('Grooming', 'Wellness', 'Pet grooming'),
('Microchipping', 'Preventive', 'ID chip implant'),
('Deworming', 'Preventive', 'Parasite control'),
('Emergency Care', 'Emergency', 'Urgent treatment');

INSERT INTO clinic_service (clinic_id, service_id, price_min, price_max) VALUES
(1,1,20,50),
(2,2,30,60),
(3,3,200,500),
(4,4,80,150),
(5,5,100,200),
(6,6,50,120),
(7,7,40,90),
(8,8,25,70),
(9,9,20,60),
(10,10,150,400);

INSERT INTO visit (pet_id, vet_id, visit_date, notes, service_id) VALUES
(1,1,'2026-01-01 10:00:00','Routine check',2),
(2,2,'2026-01-02 11:00:00','Vaccination done',1),
(3,1,'2026-01-03 12:00:00','Minor surgery',3),
(4,2,'2026-01-04 09:00:00','Checkup ok',2),
(5,7,'2026-01-05 14:00:00','Dental cleaning',4),
(6,8,'2026-01-06 15:00:00','X-ray needed',5),
(7,7,'2026-01-07 16:00:00','Blood test',6),
(8,8,'2026-01-08 10:30:00','Grooming',7),
(9,1,'2026-01-09 13:00:00','Microchip inserted',8),
(10,2,'2026-01-10 08:45:00','Emergency visit',10);

INSERT INTO procedure_record (visit_id, procedure_name, charge_amount, notes) VALUES
(1,'Checkup Exam',50,'Normal'),
(2,'Vaccination Shot',40,'Rabies'),
(3,'Surgery Operation',300,'Successful'),
(4,'Routine Exam',45,'Healthy'),
(5,'Teeth Cleaning',120,'Completed'),
(6,'X-Ray Scan',150,'Reviewed'),
(7,'Blood Work',80,'Normal'),
(8,'Full Grooming',70,'Done'),
(9,'Microchip Insert',60,'Inserted'),
(10,'Emergency Treatment',350,'Stable');

INSERT INTO appointment (pet_id, vet_id, appointment_date, status, service_id) VALUES
(1,1,'2026-02-01 10:00:00','Confirmed',2),
(2,2,'2026-02-02 11:00:00','Pending',1),
(3,1,'2026-02-03 12:00:00','Completed',3),
(4,2,'2026-02-04 09:00:00','Cancelled',2),
(5,7,'2026-02-05 14:00:00','Confirmed',4),
(6,8,'2026-02-06 15:00:00','Pending',5),
(7,7,'2026-02-07 16:00:00','Confirmed',6),
(8,8,'2026-02-08 10:30:00','Completed',7),
(9,1,'2026-02-09 13:00:00','Pending',8),
(10,2,'2026-02-10 08:45:00','Confirmed',10);

INSERT INTO inventory_item (item_name, category, qty_on_hand, reorder_threshold, unit_cost) VALUES
('Syringe','Medical',100,20,1.50),
('Bandage','Medical',200,50,0.50),
('Antibiotic','Medicine',50,10,10.00),
('Vaccine Dose','Medicine',80,20,15.00),
('Gloves','Supply',300,100,0.20),
('Shampoo','Grooming',40,10,8.00),
('Scalpel','Surgical',25,5,12.00),
('IV Fluid','Medical',60,15,20.00),
('Thermometer','Equipment',15,5,25.00),
('Pet Food','Supply',100,30,5.00);

INSERT INTO visit_support_log (visit_id, technician_id, weight, temperature, notes) VALUES
(1,3,10.5,38.5,'Normal'),
(2,4,5.2,38.0,'Good'),
(3,3,12.0,39.0,'Pre-surgery'),
(4,4,8.3,38.4,'Stable'),
(5,9,6.1,38.2,'Dental prep'),
(6,9,15.0,39.1,'X-ray prep'),
(7,3,7.5,38.7,'Blood draw'),
(8,4,9.0,38.3,'Grooming prep'),
(9,3,4.5,38.6,'Microchip'),
(10,4,11.2,39.5,'Emergency');

INSERT INTO inventory_usage_log (item_id, procedure_id, qty_used, staff_id) VALUES
(1,1,2,3),
(2,2,5,4),
(3,3,1,3),
(4,2,1,4),
(5,1,10,3),
(6,8,1,4),
(7,3,1,3),
(8,10,2,4),
(9,6,1,3),
(10,8,3,4);