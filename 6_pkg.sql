CREATE OR REPLACE PACKAGE emp_util_pkg AS
  FUNCTION get_job_title(p_job_id VARCHAR2) RETURN VARCHAR2;
  FUNCTION annual_salary(p_employee_id NUMBER) RETURN NUMBER;
  FUNCTION format_phone(p_number VARCHAR2) RETURN VARCHAR2;
  FUNCTION capitalize_first_last(p_input VARCHAR2) RETURN VARCHAR2;
  FUNCTION pesel_to_date(p_pesel VARCHAR2) RETURN DATE;
  FUNCTION country_stats(p_country_name VARCHAR2) RETURN VARCHAR2;
END emp_util_pkg;
/
CREATE OR REPLACE PACKAGE BODY emp_util_pkg AS

  FUNCTION get_job_title(p_job_id VARCHAR2)
  RETURN VARCHAR2 IS
    v_job_title jobs.job_title%TYPE;
  BEGIN
    SELECT job_title INTO v_job_title
    FROM jobs
    WHERE job_id = p_job_id;

    RETURN v_job_title;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Brak pracy o podanym ID.');
  END get_job_title;

  FUNCTION annual_salary(p_employee_id NUMBER)
  RETURN NUMBER IS
    v_salary employees.salary%TYPE;
    v_comm_pct employees.commission_pct%TYPE;
  BEGIN
    SELECT salary, NVL(commission_pct, 0)
    INTO v_salary, v_comm_pct
    FROM employees
    WHERE employee_id = p_employee_id;

    RETURN (v_salary * 12) + (v_salary * v_comm_pct);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20002, 'Pracownik o podanym ID nie istnieje');
  END annual_salary;

  FUNCTION format_phone(p_number VARCHAR2)
  RETURN VARCHAR2 IS
    v_result VARCHAR2(50);
  BEGIN
    IF LENGTH(p_number) >= 3 THEN
      v_result := '(' || SUBSTR(p_number, 1, 3) || ')' || SUBSTR(p_number, 4);
    ELSE
      v_result := p_number;
    END IF;

    RETURN v_result;
  END format_phone;

  FUNCTION capitalize_first_last(p_input VARCHAR2)
  RETURN VARCHAR2 IS
    v_len PLS_INTEGER := LENGTH(p_input);
  BEGIN
    IF v_len < 1 THEN
      RETURN '';
    ELSIF v_len = 1 THEN
      RETURN UPPER(p_input);
    ELSE
      RETURN UPPER(SUBSTR(p_input, 1, 1)) ||
             LOWER(SUBSTR(p_input, 2, v_len - 2)) ||
             UPPER(SUBSTR(p_input, -1));
    END IF;
  END capitalize_first_last;

  FUNCTION pesel_to_date(p_pesel VARCHAR2)
  RETURN DATE IS
    v_year VARCHAR2(2);
    v_month VARCHAR2(2);
    v_day VARCHAR2(2);
    v_full_year VARCHAR2(4);
  BEGIN
    v_year := SUBSTR(p_pesel, 1, 2);
    v_month := SUBSTR(p_pesel, 3, 2);
    v_day := SUBSTR(p_pesel, 5, 2);

    CASE
      WHEN v_month BETWEEN '01' AND '12' THEN
        v_full_year := '19' || v_year;
      WHEN v_month BETWEEN '21' AND '32' THEN
        v_full_year := '20' || v_year;
        v_month := TO_CHAR(TO_NUMBER(v_month) - 20);
      ELSE
        RAISE_APPLICATION_ERROR(-20003, 'Nieprawidłowy miesiąc w PESELu');
    END CASE;

    RETURN TO_DATE(v_full_year || LPAD(v_month, 2, '0') || v_day, 'YYYYMMDD');
  END pesel_to_date;

  FUNCTION country_stats(p_country_name VARCHAR2)
  RETURN VARCHAR2 IS
    v_dept_count NUMBER;
    v_emp_count NUMBER;
  BEGIN
    SELECT COUNT(DISTINCT d.department_id), COUNT(e.employee_id)
    INTO v_dept_count, v_emp_count
    FROM countries c
    JOIN locations l ON c.country_id = l.country_id
    JOIN departments d ON d.location_id = l.location_id
    LEFT JOIN employees e ON e.department_id = d.department_id
    WHERE c.country_name = p_country_name;

    RETURN 'Pracownicy: ' || v_emp_count || ', Departamenty: ' || v_dept_count;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20004, 'Nie znaleziono kraju');
  END country_stats;

END emp_util_pkg;
/
CREATE OR REPLACE PACKAGE regions_pkg AS
  PROCEDURE create_region(p_id NUMBER, p_name VARCHAR2);
  PROCEDURE update_region(p_id NUMBER, p_name VARCHAR2);
  PROCEDURE delete_region(p_id NUMBER);
  PROCEDURE get_region(p_id NUMBER);
  PROCEDURE get_regions_by_name(p_pattern VARCHAR2);
END regions_pkg;
/
CREATE OR REPLACE PACKAGE BODY regions_pkg AS
  PROCEDURE create_region(p_id NUMBER, p_name VARCHAR2) IS
  BEGIN
    INSERT INTO regions(region_id, region_name) VALUES (p_id, p_name);
  END;

  PROCEDURE update_region(p_id NUMBER, p_name VARCHAR2) IS
  BEGIN
    UPDATE regions SET region_name = p_name WHERE region_id = p_id;
  END;

  PROCEDURE delete_region(p_id NUMBER) IS
  BEGIN
    DELETE FROM regions WHERE region_id = p_id;
  END;

  PROCEDURE get_region(p_id NUMBER) IS
    v_name regions.region_name%TYPE;
  BEGIN
    SELECT region_name INTO v_name FROM regions WHERE region_id = p_id;
    DBMS_OUTPUT.PUT_LINE('Region: ' || v_name);
  END;

  PROCEDURE get_regions_by_name(p_pattern VARCHAR2) IS
  BEGIN
    FOR r IN (SELECT * FROM regions WHERE region_name LIKE p_pattern) LOOP
      DBMS_OUTPUT.PUT_LINE('ID: ' || r.region_id || ' Name: ' || r.region_name);
    END LOOP;
  END;
END regions_pkg;