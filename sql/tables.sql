-- ============================================
-- EvergreenStudent • Schema Definition
-- ============================================

-- Drop in dependency order for clean re-runs
BEGIN EXECUTE IMMEDIATE 'DROP TABLE GradeAudit PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Grades PURGE';     EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Courses PURGE';    EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Students PURGE';   EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/

-- Students: canonical roster
CREATE TABLE Students (
  student_id   NUMBER         PRIMARY KEY,
  full_name    VARCHAR2(120)  NOT NULL,
  email        VARCHAR2(160),
  enrolled_at  DATE           DEFAULT SYSDATE
);

-- Courses: catalog with credit weight
CREATE TABLE Courses (
  course_id    NUMBER         PRIMARY KEY,
  course_code  VARCHAR2(20)   NOT NULL UNIQUE,
  course_name  VARCHAR2(160)  NOT NULL,
  credits      NUMBER(3,1)    NOT NULL CHECK (credits > 0)
);

-- Grades: one row per student-course-term
CREATE TABLE Grades (
  grade_id      NUMBER         PRIMARY KEY,
  student_id    NUMBER         NOT NULL REFERENCES Students(student_id),
  course_id     NUMBER         NOT NULL REFERENCES Courses(course_id),
  term_code     VARCHAR2(20)   NOT NULL,  -- e.g., 2025S1
  grade_letter  VARCHAR2(2)    NOT NULL,  -- e.g., A, A-, B+
  grade_points  NUMBER(3,2)    NOT NULL,  -- normalized points (0.00–4.00)
  graded_at     DATE           DEFAULT SYSDATE,
  CONSTRAINT uq_grade UNIQUE (student_id, course_id, term_code)
);

-- Audit trail for grade changes
CREATE TABLE GradeAudit (
  audit_id      NUMBER         PRIMARY KEY,
  grade_id      NUMBER,
  action_type   VARCHAR2(10)   NOT NULL,   -- INSERT/UPDATE/DELETE
  old_letter    VARCHAR2(2),
  new_letter    VARCHAR2(2),
  old_points    NUMBER(3,2),
  new_points    NUMBER(3,2),
  changed_by    VARCHAR2(128),             -- USER or SYS_CONTEXT if available
  changed_at    DATE           DEFAULT SYSDATE
);

-- Helpful indexes
CREATE INDEX idx_grades_student ON Grades(student_id);
CREATE INDEX idx_grades_course  ON Grades(course_id);
