-- ============================================
-- EvergreenStudent • Sample Data
-- ============================================

-- Students
INSERT INTO Students (student_id, full_name, email) VALUES (1001, 'Alice Johnson', 'alice@example.com');
INSERT INTO Students (student_id, full_name, email) VALUES (1002, 'Brian Lee',     'brian@example.com');

-- Courses
INSERT INTO Courses (course_id, course_code, course_name, credits) VALUES (501, 'CS101', 'Intro to CS',        3);
INSERT INTO Courses (course_id, course_code, course_name, credits) VALUES (502, 'MATH201', 'Discrete Math',    4);
INSERT INTO Courses (course_id, course_code, course_name, credits) VALUES (503, 'ENG150', 'Academic Writing',  2);

COMMIT;
