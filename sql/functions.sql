-- ============================================
-- EvergreenStudent • Functions
-- ============================================

-- Drop if present
BEGIN EXECUTE IMMEDIATE 'DROP FUNCTION Get_GPA'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -4043 THEN RAISE; END IF; END;
/

-- Get_GPA: weighted GPA across all terms (or a specific term if provided)
-- If p_term_code is NULL, computes cumulative GPA. Returns 0 when no grades.
CREATE OR REPLACE FUNCTION Get_GPA (
  p_student_id IN NUMBER,
  p_term_code  IN VARCHAR2 DEFAULT NULL
) RETURN NUMBER IS
  v_total_points  NUMBER(10,4);
  v_total_credits NUMBER(10,4);
  v_gpa           NUMBER(5,3);
BEGIN
  SELECT NVL(SUM(g.grade_points * c.credits), 0),
         NVL(SUM(c.credits), 0)
    INTO v_total_points, v_total_credits
    FROM Grades g
    JOIN Courses c ON c.course_id = g.course_id
   WHERE g.student_id = p_student_id
     AND (p_term_code IS NULL OR g.term_code = p_term_code);

  IF v_total_credits = 0 THEN
    RETURN 0;
  END IF;

  v_gpa := ROUND(v_total_points / v_total_credits, 3);
  RETURN v_gpa;
END Get_GPA;
/
SHOW ERRORS;
