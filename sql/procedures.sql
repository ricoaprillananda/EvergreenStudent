-- ============================================
-- EvergreenStudent • Procedures
-- ============================================

-- Drop if present
BEGIN EXECUTE IMMEDIATE 'DROP PROCEDURE Input_Grade'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -4043 THEN RAISE; END IF; END;
/

-- Input_Grade: validates letter grade, maps to points, upserts Grades
CREATE OR REPLACE PROCEDURE Input_Grade (
  p_student_id  IN NUMBER,
  p_course_id   IN NUMBER,
  p_term_code   IN VARCHAR2,
  p_grade_letter IN VARCHAR2
) AS
  v_points   NUMBER(3,2);
  v_exists   NUMBER;
  v_grade_id NUMBER;
BEGIN
  -- Normalize letter (trim/upper)
  -- Supported set: A, A-, B+, B, B-, C+, C, C-, D, F
  CASE UPPER(TRIM(p_grade_letter))
    WHEN 'A'  THEN v_points := 4.00
    WHEN 'A-' THEN v_points := 3.70
    WHEN 'B+' THEN v_points := 3.30
    WHEN 'B'  THEN v_points := 3.00
    WHEN 'B-' THEN v_points := 2.70
    WHEN 'C+' THEN v_points := 2.30
    WHEN 'C'  THEN v_points := 2.00
    WHEN 'C-' THEN v_points := 1.70
    WHEN 'D'  THEN v_points := 1.00
    WHEN 'F'  THEN v_points := 0.00
    ELSE
      RAISE_APPLICATION_ERROR(-20020, 'Unsupported grade letter');
  END CASE;

  -- Ensure student exists
  SELECT COUNT(*) INTO v_exists FROM Students WHERE student_id = p_student_id;
  IF v_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20021, 'Student not found');
  END IF;

  -- Ensure course exists
  SELECT COUNT(*) INTO v_exists FROM Courses WHERE course_id = p_course_id;
  IF v_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20022, 'Course not found');
  END IF;

  -- Upsert semantics: update if (student,course,term) exists; else insert
  SELECT COUNT(*) INTO v_exists
    FROM Grades
   WHERE student_id = p_student_id
     AND course_id  = p_course_id
     AND term_code  = p_term_code;

  IF v_exists > 0 THEN
    UPDATE Grades
       SET grade_letter = UPPER(TRIM(p_grade_letter)),
           grade_points = v_points,
           graded_at    = SYSDATE
     WHERE student_id = p_student_id
       AND course_id  = p_course_id
       AND term_code  = p_term_code
     RETURNING grade_id INTO v_grade_id;
  ELSE
    v_grade_id := NVL((SELECT MAX(grade_id) FROM Grades), 0) + 1;
    INSERT INTO Grades (grade_id, student_id, course_id, term_code, grade_letter, grade_points, graded_at)
    VALUES (v_grade_id, p_student_id, p_course_id, p_term_code, UPPER(TRIM(p_grade_letter)), v_points, SYSDATE);
  END IF;

  COMMIT;
END Input_Grade;
/
SHOW ERRORS;
