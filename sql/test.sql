-- ============================================
-- EvergreenStudent • End-to-End Test
-- ============================================

SET SERVEROUTPUT ON;

-- 1) Insert grades via controlled procedure
BEGIN
  Input_Grade(1001, 501, '2025S1', 'A');   -- CS101, 3 cr, 4.00
  Input_Grade(1001, 502, '2025S1', 'B+');  -- Discrete, 4 cr, 3.30
  Input_Grade(1001, 503, '2025S1', 'A-');  -- Writing, 2 cr, 3.70
  DBMS_OUTPUT.PUT_LINE('Inserted initial grades for student 1001.');
END;
/

-- 2) Compute GPA (term and cumulative)
DECLARE
  v_gpa_term NUMBER;
  v_gpa_all  NUMBER;
BEGIN
  v_gpa_term := Get_GPA(1001, '2025S1');
  v_gpa_all  := Get_GPA(1001, NULL);
  DBMS_OUTPUT.PUT_LINE('GPA (2025S1) = ' || TO_CHAR(v_gpa_term, 'FM9.999'));
  DBMS_OUTPUT.PUT_LINE('GPA (Cumulative) = ' || TO_CHAR(v_gpa_all, 'FM9.999'));
END;
/

-- 3) Update one grade to test audit
BEGIN
  Input_Grade(1001, 502, '2025S1', 'A-');  -- B+ -> A-
  DBMS_OUTPUT.PUT_LINE('Updated grade for course 502.');
END;
/

-- 4) Show results
SELECT s.student_id, s.full_name,
       g.course_id, c.course_code, g.term_code,
       g.grade_letter, g.grade_points, g.graded_at
  FROM Grades g
  JOIN Students s ON s.student_id = g.student_id
  JOIN Courses c  ON c.course_id  = g.course_id
 WHERE s.student_id = 1001
 ORDER BY g.course_id;

-- 5) Show audit trail
SELECT action_type, old_letter, new_letter, old_points, new_points, changed_by,
       TO_CHAR(changed_at, 'YYYY-MM-DD HH24:MI:SS') AS changed_at,
       grade_id
  FROM GradeAudit
 ORDER BY audit_id;
