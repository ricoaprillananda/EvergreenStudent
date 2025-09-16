-- ============================================
-- EvergreenStudent • Triggers (Grade Audit)
-- ============================================

-- Drop if present
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_grades_ai'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -4080 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_grades_au'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -4080 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_grades_ad'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -4080 THEN RAISE; END IF; END;
/

-- Insert audit
CREATE OR REPLACE TRIGGER trg_grades_ai
AFTER INSERT ON Grades
FOR EACH ROW
BEGIN
  INSERT INTO GradeAudit (audit_id, grade_id, action_type, old_letter, new_letter, old_points, new_points, changed_by, changed_at)
  VALUES (
    NVL((SELECT MAX(audit_id) FROM GradeAudit),0)+1,
    :NEW.grade_id,
    'INSERT',
    NULL, :NEW.grade_letter,
    NULL, :NEW.grade_points,
    USER, SYSDATE
  );
END;
/
SHOW ERRORS;

-- Update audit
CREATE OR REPLACE TRIGGER trg_grades_au
AFTER UPDATE ON Grades
FOR EACH ROW
BEGIN
  INSERT INTO GradeAudit (audit_id, grade_id, action_type, old_letter, new_letter, old_points, new_points, changed_by, changed_at)
  VALUES (
    NVL((SELECT MAX(audit_id) FROM GradeAudit),0)+1,
    :NEW.grade_id,
    'UPDATE',
    :OLD.grade_letter, :NEW.grade_letter,
    :OLD.grade_points, :NEW.grade_points,
    USER, SYSDATE
  );
END;
/
SHOW ERRORS;

-- Delete audit
CREATE OR REPLACE TRIGGER trg_grades_ad
AFTER DELETE ON Grades
FOR EACH ROW
BEGIN
  INSERT INTO GradeAudit (audit_id, grade_id, action_type, old_letter, new_letter, old_points, new_points, changed_by, changed_at)
  VALUES (
    NVL((SELECT MAX(audit_id) FROM GradeAudit),0)+1,
    :OLD.grade_id,
    'DELETE',
    :OLD.grade_letter, NULL,
    :OLD.grade_points, NULL,
    USER, SYSDATE
  );
END;
/
SHOW ERRORS;
