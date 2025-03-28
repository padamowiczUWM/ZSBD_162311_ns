create table COUNTRIES as select * from HR.COUNTRIES;
create table DEPARTMENTS as select * from HR.DEPARTMENTS;
create table EMPLOYEES as select * from HR.EMPLOYEES;
create table JOB_GRADES as select * from HR.JOB_GRADES;
create table JOB_HISTORY as select * from HR.JOB_HISTORY;
create table JOBS as select * from HR.JOBS;
create table LOCATIONS as select * from HR.LOCATIONS;
create table PRODUCTS as select * from HR.PRODUCTS;
create table REGIONS as select * from HR.REGIONS;
create table SALES as select * from HR.SALES;

SELECT last_name || ' - ' || salary AS wynagrodzenie
FROM EMPLOYEES WHERE department_id IN (20, 50) AND salary BETWEEN 2000 AND 7000 ORDER BY last_name;

SELECT hire_date, last_name, :user_column
FROM EMPLOYEES WHERE manager_id IS NOT NULL AND EXTRACT(YEAR FROM hire_date) = 2005 ORDER BY :user_column;

SELECT first_name || ' ' || last_name AS full_name, salary, phone_number
FROM EMPLOYEES
WHERE last_name LIKE '__e%' AND first_name LIKE '%' || :user_value || '%' ORDER BY first_name DESC, last_name ASC;

SELECT first_name, last_name, ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) AS worked_months,
CASE 
    WHEN MONTHS_BETWEEN(SYSDATE, hire_date) <= 150 THEN salary * 0.1
    WHEN MONTHS_BETWEEN(SYSDATE, hire_date) BETWEEN 151 AND 200 THEN salary * 0.2
    ELSE salary * 0.3
END AS wysokość_dodatku
FROM EMPLOYEES
ORDER BY worked_months;

SELECT department_id, SUM(salary) AS suma, ROUND(AVG(salary)) AS srednia
FROM EMPLOYEES
WHERE department_id IN (SELECT department_id FROM EMPLOYEES WHERE salary > 5000)
GROUP BY department_id;

SELECT e.last_name, e.department_id, d.department_name, e.job_id
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON e.department_id = d.department_id
JOIN LOCATIONS l ON d.location_id = l.location_id
WHERE l.city = 'Toronto';

SELECT e.first_name, e.last_name, e2.first_name AS wsp_imie, e2.last_name AS wsp_nazwisko
FROM EMPLOYEES e
JOIN EMPLOYEES e2 ON e.department_id = e2.department_id AND e.employee_id != e2.employee_id
WHERE e.first_name = 'Jennifer';

SELECT department_name FROM DEPARTMENTS
WHERE department_id NOT IN (SELECT DISTINCT department_id FROM EMPLOYEES);

SELECT e.first_name, e.last_name, e.job_id, d.department_name, e.salary,
CASE
    WHEN e.salary < 3000 THEN 'Niski'
    WHEN e.salary BETWEEN 4000 AND 8000 THEN 'Średni'
    ELSE 'Wysoki'
END AS grade
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON e.department_id = d.department_id;

SELECT first_name, last_name, salary
FROM EMPLOYEES
WHERE salary > (SELECT AVG(salary) FROM EMPLOYEES)
ORDER BY salary DESC;

SELECT DISTINCT e.employee_id, e.first_name, e.last_name
FROM EMPLOYEES e
JOIN EMPLOYEES e2 ON e.department_id = e.department_id
WHERE e2.last_name LIKE '%u%';

SELECT first_name, last_name, hire_date
FROM EMPLOYEES
WHERE MONTHS_BETWEEN(SYSDATE, hire_date) > (SELECT AVG(MONTHS_BETWEEN(SYSDATE, hire_date)) FROM EMPLOYEES);

SELECT d.department_name, COUNT(e.employee_id) AS employee_count, ROUND(AVG(e.salary)) AS avg_salary
FROM DEPARTMENTS d
LEFT JOIN EMPLOYEES e ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY employee_count DESC;

SELECT first_name, last_name, salary
FROM EMPLOYEES
WHERE salary < ANY (SELECT salary FROM EMPLOYEES WHERE department_id = (SELECT department_id FROM DEPARTMENTS WHERE department_name = 'IT'));

SELECT DISTINCT d.department_name
FROM DEPARTMENTS d
JOIN EMPLOYEES e ON d.department_id = e.department_id
WHERE e.salary > (SELECT AVG(salary) FROM EMPLOYEES);

SELECT job_id, AVG(salary) AS avg_salary
FROM EMPLOYEES
GROUP BY job_id
ORDER BY avg_salary DESC
FETCH FIRST 5 ROWS ONLY;

SELECT r.region_name, COUNT(DISTINCT c.country_id) AS country_count, COUNT(e.employee_id) AS employee_count
FROM REGIONS r
JOIN COUNTRIES c ON r.region_id = c.region_id
LEFT JOIN LOCATIONS l ON c.country_id = l.country_id
LEFT JOIN DEPARTMENTS d ON l.location_id = d.location_id
LEFT JOIN EMPLOYEES e ON d.department_id = e.department_id
GROUP BY r.region_name;

SELECT e.first_name, e.last_name, e.salary
FROM EMPLOYEES e
JOIN EMPLOYEES m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;

SELECT TO_CHAR(hire_date, 'MM') AS month, COUNT(*) AS count
FROM EMPLOYEES
GROUP BY TO_CHAR(hire_date, 'MM')
ORDER BY month;

SELECT department_name, ROUND(AVG(salary), 2) AS avg_salary
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON e.department_id = d.department_id
GROUP BY department_name
ORDER BY avg_salary DESC
FETCH FIRST 3 ROWS ONLY;