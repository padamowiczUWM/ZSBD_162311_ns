CREATE VIEW v_wysokie_pensje AS
SELECT * FROM employees WHERE salary > 6000;

CREATE OR REPLACE VIEW v_wysokie_pensje AS
SELECT * FROM employees WHERE salary > 12000;

DROP VIEW v_wysokie_pensje;

CREATE VIEW v_finance_employees AS
SELECT employee_id, last_name, first_name 
FROM employees 
WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Finance');

CREATE VIEW v_srednie_pensje AS
SELECT employee_id, last_name, first_name, salary, job_id, email, hire_date
FROM employees
WHERE salary BETWEEN 5000 AND 12000;

CREATE VIEW v_departments_stats AS
SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS liczba_pracownikow,
       AVG(e.salary) AS srednia_pensja, MAX(e.salary) AS najwyzsza_pensja
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.employee_id) >= 4;

CREATE VIEW v_srednie_pensje_check AS
SELECT employee_id, last_name, first_name, salary, job_id, email, hire_date
FROM employees
WHERE salary BETWEEN 5000 AND 12000
WITH CHECK OPTION;

CREATE MATERIALIZED VIEW v_managerowie AS
SELECT e.*, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.job_id LIKE '%MANAGER%';

CREATE VIEW v_najlepiej_oplacani AS
SELECT * FROM employees ORDER BY salary DESC FETCH FIRST 10 ROWS ONLY;
