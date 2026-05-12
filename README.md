# PetWellness

PetWellness is a full-stack web application designed to help pet owners and veterinary clinics manage pet care efficiently. The system supports both pet owner functionality and hospital-side administrative tools.

## Overview

The application is built using:
- Java (JSP + Servlets-style structure)
- MySQL (database)
- Apache Tomcat (server)
- HTML/CSS (frontend)

It follows a simple 3-tier architecture:
- Presentation Layer (JSP pages)
- Application Layer (Java service classes)
- Data Layer (MySQL database)

---

## Features

### Pet Owner Features
- Create account and log in
- Add pet profiles
- View pet information
- View pet visit history
- Schedule appointments
- View appointment status

### Hospital / Staff Features
- Manage staff accounts
- Create visit records
- View patient (pet) history
- Add procedures / treatments to visits
- View procedures for a visit
- Manage appointments (create, update status)
- Record technician notes and vitals
- Manage inventory (add/update items)
- View inventory reports (low stock items)
- View hospital KPI dashboard (revenue, visits, appointments)

---

## Database

The system uses a relational MySQL database with tables such as:
- pet_owner
- pet
- visit
- procedure_record
- appointment
- staff
- inventory_item
- visit_support_log

To set up the database:
mysql -u root -p < PetWellness/database/schema.sql


---

## Running the Application

1. Import the project into Eclipse as a **Dynamic Web Project**
2. Configure Apache Tomcat
3. Update database credentials in:

DBConnection.java

4. Start the server:

Run → Run on Server

5. Open in browser:

http://localhost:8080/PetWellness


---

## Default Access

You may manually insert a default hospital admin into the database:

Example:
- Username: admin
- Role: Admin

(This allows access to the hospital dashboard.)

---

## Project Structure

PetWellness/
├── src/main/java/com/petwellness/service
├── src/main/java/com/petwellness/model
├── src/main/webapp
├── database/schema.sql
└── README.md
