CREATE TABLE archiwum_departamentow (
  id NUMBER,
  nazwa VARCHAR2(100),
  data_zamkniecia DATE,
  ostatni_manager VARCHAR2(100)
);

CREATE OR REPLACE TRIGGER trg_departament_delete
AFTER DELETE ON departments
FOR EACH ROW
BEGIN
  INSERT INTO archiwum_departamentow
  VALUES (
    :OLD.department_id,
    :OLD.department_name,
    SYSDATE,
    (SELECT first_name || ' ' || last_name FROM employees WHERE employee_id = :OLD.manager_id)
  );
END;
/
DELETE departments WHERE department_id = 300;

CREATE TABLE zlodziej (
  id NUMBER GENERATED ALWAYS AS IDENTITY,
  "USER" VARCHAR2(100),
  czas_zmiany DATE
);

CREATE OR REPLACE TRIGGER trg_check_salary
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
  IF :NEW.salary < 2000 OR :NEW.salary > 26000 THEN
    INSERT INTO zlodziej("USER", czas_zmiany)
    VALUES (USER, SYSDATE);
    RAISE_APPLICATION_ERROR(-20005, 'Zarobki poza widełkami 2000 - 26000');
  END IF;
END;
/
CREATE SEQUENCE seq_emp_id START WITH 1000 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_emp_autoinc
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  :NEW.employee_id := seq_emp_id.NEXTVAL;
END;
/
CREATE OR REPLACE TRIGGER trg_block_job_grades
BEFORE INSERT OR UPDATE OR DELETE ON job_grades
BEGIN
  RAISE_APPLICATION_ERROR(-20006, 'Operacje na tabeli JOB_GRADES są zabronione');
END;
/
CREATE OR REPLACE TRIGGER trg_protect_salary_range
BEFORE UPDATE OF min_salary, max_salary ON jobs
FOR EACH ROW
BEGIN
  :NEW.min_salary := :OLD.min_salary;
  :NEW.max_salary := :OLD.max_salary;
END;