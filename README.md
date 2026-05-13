# PetWellness

PetWellness is a full-stack veterinary clinic management system built for CS157A. It supports two distinct user types — **Pet Owners** and **Clinic Staff** — each with their own login, dashboard, and feature set.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Server | Apache Tomcat 9 |
| Language | Java (JSP) |
| Database | MySQL 8 |
| Frontend | HTML, CSS (custom design system) |
| Architecture | 3-tier: JSP → Service classes → MySQL via JDBC |

---

## Database

12 tables — exceeds the CS157A minimum of 10.

| Table | Purpose |
|---|---|
| `pet_owner` | Owner accounts |
| `pet` | Pet profiles linked to owners |
| `staff` | Clinic staff accounts with roles |
| `clinic` | Clinic directory (public-facing) |
| `clinic_service` | Per-clinic service pricing |
| `service_catalog` | Bookable service types |
| `appointment` | Appointment requests and their status |
| `visit` | Clinical visit records (auto-created on appointment approval) |
| `visit_support_log` | Technician vitals and notes per visit |
| `procedure_record` | Procedures and charges billed to a visit |
| `inventory_item` | Clinic supply and medication stock |
| `inventory_usage_log` | Per-procedure inventory consumption |

### Setup

```bash
mysql -u root -p < PetWellness/database/schema.sql
```

A default admin account is seeded by the schema:
- **Username:** `admin2` | **Password:** `test`

---

## Staff Roles

There are 4 staff roles. Access is enforced at the page level on every JSP.

| Role | Capabilities |
|---|---|
| **Admin** | Full access to everything |
| **Manager** | Approve appointments, manage inventory, view reports, manage service catalog and clinic pricing |
| **Veterinarian** | View appointments, add procedures and treatments |
| **Technician** | Record vitals and support logs for visits |

---

## Appointment Workflow

```
Owner requests appointment (Pending)
        ↓
Manager assigns vet + approves (Scheduled)
  → Visit record is automatically created at this step
        ↓
Technician records vitals for the visit
        ↓
Veterinarian reviews vitals, adds procedures / treatments
  → Vitals gate: procedure form is blocked until at least one vitals entry exists
        ↓
Manager marks appointment Complete
```

---

## Features

### Pet Owner Side

| Feature | Pages |
|---|---|
| Register / Login | `signup.jsp`, `login.jsp` |
| Owner profile + change password | `owner_profile.jsp`, `change_password_owner.jsp` |
| Add, edit, delete pets | `view_pets.jsp`, `add_pet.jsp`, `edit_pet.jsp` |
| Request an appointment | `schedule_appointment.jsp` |
| View appointments + cancel pending | `view_my_appointments.jsp` |
| View visit history | `view_visits.jsp` |
| View visit detail (procedures + vitals) | `view_visit_detail.jsp` |
| Browse clinics and services | `search_clinic.jsp` |

### Hospital / Staff Side

| Feature | Pages | Roles |
|---|---|---|
| Staff login / signup | `staff_login.jsp`, `staff_signup.jsp` | All |
| Hospital dashboard | `hospital_dashboard.jsp` | All |
| View all appointments | `view_appointments.jsp` | All |
| Approve appointment (assign vet + date) | `approve_appointment.jsp` | Admin, Manager |
| Mark appointment Complete / Cancel / No-show | `view_appointments.jsp` | Admin, Manager |
| Patient visit history | `hospital_view_visits.jsp` | All |
| Record technician vitals | `add_support_log.jsp` | Admin, Technician |
| View vitals for a visit | `view_vitals.jsp` | All |
| Add procedure / treatment | `add_procedure.jsp` | Admin, Veterinarian |
| View procedures for a visit | `view_procedures.jsp` | All |
| Manage service catalog | `manage_services.jsp` | Admin, Manager |
| Manage clinic pricing | `manage_clinic_services.jsp` | Admin, Manager |
| Manage inventory (add/update/restock) | `manage_inventory.jsp` | Admin, Manager |
| Low-stock inventory report | `inventory_report.jsp` | Admin, Manager |
| Hospital KPI reports | `reports.jsp` | Admin, Manager |
| Manage staff accounts (roles, deactivate) | `manage_staff.jsp`, `add_staff.jsp` | Admin |
| Change password | `change_password_staff.jsp` | All |

---

## Service Layer

Business logic is separated into Java service classes under `src/main/java/com/petwellness/service/`:

- `AppointmentService` — CRUD for appointments
- `ClinicServiceService` — clinic pricing management
- `InventoryReportService` — low-stock queries
- `InventoryService` — inventory CRUD
- `PetOwnerService` — owner registration and lookup
- `ReportService` — KPI aggregation (revenue, visits, most common procedure)
- `ServiceCatalogService` — service type management
- `StaffService` — staff account management
- `SupportLogService` — technician vitals logging
- `ViewPetService` — owner pet queries
- `ViewProcedureService` — procedure record queries
- `ViewVisitService` — visit history queries

---

## Running the Application

1. Clone the repo and import `PetWellness/` into Eclipse as a **Dynamic Web Project**
2. Add Apache Tomcat 9 as a server runtime
3. Update DB credentials in `src/main/java/com/petwellness/util/DBConnection.java` if needed (default: `root` / `Davis0508`, database `petwellness`)
4. Run the schema: `mysql -u root -p < PetWellness/database/schema.sql`
5. Right-click project → **Run on Server**
6. Open: `http://localhost:8080/PetWellness`

Owner entry point: `http://localhost:8080/PetWellness/index.jsp`  
Staff entry point: `http://localhost:8080/PetWellness/staff_login.jsp`

---

## Project Structure

```
PetWellness/
├── database/
│   └── schema.sql
└── src/main/
    ├── java/com/petwellness/
    │   ├── service/         # Business logic (12 service classes)
    │   └── util/
    │       └── DBConnection.java
    └── webapp/
        ├── style.css        # Shared design system
        └── *.jsp            # ~55 JSP pages
```

---

## Functional Requirements Coverage

14 functional requirements implemented — exceeds the CS157A minimum of 10.

1. Pet owner registration and login
2. Pet profile management (add, edit, delete)
3. Appointment request and cancellation by owner
4. Appointment approval workflow with vet assignment (Manager)
5. Automated visit record creation on appointment approval
6. Technician vitals recording per visit
7. Vitals gate — vet cannot add procedures until vitals are recorded
8. Procedure and treatment logging with billing charges
9. Inventory tracking with automatic stock decrement on procedure
10. Low-stock inventory reporting and restocking
11. Service catalog and per-clinic pricing management
12. Owner-facing clinic and service directory
13. Hospital KPI dashboard (revenue, visits, appointments, procedures)
14. Role-based access control across all 4 staff roles
