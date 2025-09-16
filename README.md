# EvergreenStudent 🍀🧒🏻
EvergreenStudent is a PL/SQL system built to manage academic records with clarity and precision. It defines students, courses, and grades in a structured schema, enables controlled grade input, computes GPA through a dedicated function, and maintains integrity with audit triggers.

---

## Features

> Relational schema with four entities: Students, Courses, Grades, and GradeAudit.

> Controlled grade entry procedure (Input_Grade) that validates input and maps letters to grade points.

> GPA function (Get_GPA) that computes cumulative or term-specific GPAs with credit weighting.

> Audit triggers that log every grade insert, update, or delete for traceability.

> Sample dataset to simulate students, courses, and grade activity.

> Comprehensive test script validating input, GPA calculations, and audit trails.

---

### Project Structure

```
EvergreenStudent/
├── sql/
│   ├── tables.sql        # Schema definitions
│   ├── procedures.sql    # Controlled grade entry
│   ├── functions.sql     # GPA calculation
│   ├── triggers.sql      # Audit trail
│   ├── seed.sql          # Sample data
│   └── test.sql          # End-to-end validation
├── LICENSE               # MIT License
└── README.md             # Project documentation
```

## Quick Start

### 1. Create Schema

Run the schema definition script in Oracle Live SQL or an Oracle XE instance:

```
@sql/tables.sql
```

### 2. Load Procedures, Functions, and Triggers

```
@sql/procedures.sql
@sql/functions.sql
@sql/triggers.sql
```

### 3. Insert Sample Data

```
@sql/seed.sql
```

### 4. Execute Tests

Run the validation workflow:

```
@sql/test.sql
```

### Example Output

```
Inserted initial grades for student 1001.
GPA (2025S1) = 3.622
GPA (Cumulative) = 3.622
Updated grade for course 502.
```


The audit trail reflects each change with old and new grade values, maintaining a transparent history of modifications.

---

License

This project is licensed under the MIT License. See the LICENSE file for details.

---

## Author
Created by Rico Aprilla Nanda
