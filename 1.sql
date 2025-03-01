CREATE TABLE REGIONS (
    region_id NUMBER PRIMARY KEY,
    region_name VARCHAR2(50)
);

CREATE TABLE COUNTRIES (
    country_id NUMBER PRIMARY KEY,
    country_name VARCHAR2(50)
);

ALTER TABLE COUNTRIES ADD region_id NUMBER;
ALTER TABLE COUNTRIES ADD FOREIGN KEY (region_id) REFERENCES REGIONS(region_id);

CREATE TABLE LOCATIONS (
    location_id NUMBER PRIMARY KEY,
    street_address VARCHAR2(100),
    postal_code VARCHAR2(20),
    city VARCHAR2(50),
    state_province VARCHAR2(50)
);

ALTER TABLE LOCATIONS ADD country_id NUMBER;
ALTER TABLE LOCATIONS ADD FOREIGN KEY (country_id) REFERENCES COUNTRIES(country_id);


CREATE TABLE DEPARTMENTS (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(50),
    manager_id NUMBER
);

ALTER TABLE DEPARTMENTS ADD location_id NUMBER;
ALTER TABLE DEPARTMENTS ADD FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id);


CREATE TABLE JOBS (
    job_id NUMBER PRIMARY KEY,
    job_title VARCHAR2(50),
    min_salary NUMBER,
    max_salary NUMBER,
    CONSTRAINT chk_salary_diff CHECK (max_salary - min_salary >= 2000)
);

CREATE TABLE EMPLOYEES (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    email VARCHAR2(50),
    phone_number VARCHAR2(20),
    hire_date DATE,
    job_id NUMBER,
    salary NUMBER,
    commission_pct NUMBER,
    manager_id NUMBER,
    department_id NUMBER,
    CONSTRAINT fk_job FOREIGN KEY (job_id)
        REFERENCES JOBS(job_id),
    CONSTRAINT fk_manager FOREIGN KEY (manager_id)
        REFERENCES EMPLOYEES(employee_id),
    CONSTRAINT fk_department FOREIGN KEY (department_id)
        REFERENCES DEPARTMENTS(department_id)
);

CREATE TABLE JOB_HISTORY (
    employee_id NUMBER,
    start_date DATE,
    end_date DATE,
    job_id NUMBER,
    department_id NUMBER,
    CONSTRAINT pk_job_history PRIMARY KEY (employee_id, start_date),
    CONSTRAINT fk_employee FOREIGN KEY (employee_id)
        REFERENCES EMPLOYEES(employee_id),
    CONSTRAINT fk_job_history_job FOREIGN KEY (job_id)
        REFERENCES JOBS(job_id),
    CONSTRAINT fk_job_history_department FOREIGN KEY (department_id)
        REFERENCES DEPARTMENTS(department_id)
);

INSERT INTO JOBS (job_id, job_title, min_salary, max_salary) VALUES (1, 'Mechanik', 4000, 8000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary) VALUES (2, 'Programista', 5000, 10000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary) VALUES (3, 'Woźny', 3000, 6000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary) VALUES (4, 'Administrator sieci', 4500, 9000);
COMMIT;

INSERT INTO REGIONS (region_id, region_name)
VALUES (1, 'Europe');

INSERT INTO COUNTRIES (country_id, country_name, region_id)
VALUES (1, 'Poland', 1);

INSERT INTO LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
VALUES (1, '123 ABC', '00-001', 'Warsaw', 'Mazowieckie', 1);
INSERT INTO LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
VALUES (2, '456 DEF', '30-002', 'Krakow', 'Malopolskie', 1);
INSERT INTO LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
VALUES (3, '789 GHI', '50-003', 'Wroclaw', 'Dolnoslaskie', 1);
INSERT INTO LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
VALUES (4, '101 JKL', '80-004', 'Gdansk', 'Pomorskie', 1);

COMMIT;

INSERT INTO DEPARTMENTS (department_id, department_name, manager_id, location_id)
VALUES (1, 'IT', 1, 1);
INSERT INTO DEPARTMENTS (department_id, department_name, manager_id, location_id)
VALUES (2, 'Project Management', 2, 2);
INSERT INTO DEPARTMENTS (department_id, department_name, manager_id, location_id)
VALUES (3, 'Human Resources', 3, 3);
INSERT INTO DEPARTMENTS (department_id, department_name, manager_id, location_id)
VALUES (4, 'Database Administration', 4, 4);
COMMIT;

INSERT INTO EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
VALUES (1, 'Jan', 'Kowalski', 'jan.kowalski@gmail.com', '123-456-789', TO_DATE('2022-05-10', 'YYYY-MM-DD'), 1, 7000, NULL, NULL, 1);
INSERT INTO EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
VALUES (2, 'Jan', 'Nowak', 'jan.nowak@example.com', '987-654-321', TO_DATE('2021-08-15', 'YYYY-MM-DD'), 2, 9500, 0.10, 1, 2);
INSERT INTO EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
VALUES (3, 'Maria', 'Wiśniewska', 'maria.wisniewska@example.com', '555-123-456', TO_DATE('2023-01-05', 'YYYY-MM-DD'), 3, 5500, 0.05, 2, 3);
INSERT INTO EMPLOYEES (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
VALUES (4, 'Piotr', 'Dąbrowski', 'piotr.dabrowski@example.com', '111-222-333', TO_DATE('2020-11-20', 'YYYY-MM-DD'), 4, 8000, NULL, 2, 4);
COMMIT;

UPDATE EMPLOYEES set manager_id = 1 WHERE employee_id IN (2, 3);

UPDATE JOBS SET min_salary = min_salary + 500, max_salary = max_salary + 500 WHERE job_title LIKE '%b%' OR job_title LIKE '%s%';

DELETE FROM JOBS WHERE max_salary > 9000;

DROP TABLE EMPLOYEES;

