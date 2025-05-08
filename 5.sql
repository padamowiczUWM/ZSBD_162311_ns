BEGIN
    DECLARE
      numer_max departments.department_id%TYPE;
      nowy_numer departments.department_id%TYPE;
      nowa_nazwa departments.department_name%TYPE := 'EDUCATION';
    BEGIN
      SELECT MAX(department_id) INTO numer_max FROM departments;
      nowy_numer := numer_max + 10;
    
      INSERT INTO departments(department_id, department_name)
      VALUES (nowy_numer, nowa_nazwa);
      
      DBMS_OUTPUT.PUT_LINE('Dodano departament: ' || nowy_numer || ' - ' || nowa_nazwa);
    END;
END;
/
CREATE TABLE nowa (
    liczba VARCHAR2(10)
);
/
BEGIN
    FOR i IN 1..10 LOOP
        IF i NOT IN (4, 6) THEN
            INSERT INTO nowa (liczba) VALUES (TO_CHAR(i));
        END IF;
    END LOOP;
END;
/
DECLARE
    kraj countries%ROWTYPE;
BEGIN
    SELECT * INTO kraj FROM countries WHERE country_id = 'CA';
    DBMS_OUTPUT.PUT_LINE('Nazwa kraju: ' || kraj.country_name || ', Region ID: ' || kraj.region_id);
END;
/
DECLARE
    CURSOR c IS
        SELECT last_name, salary FROM employees WHERE department_id = 50;
    v_last_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_last_name, v_salary;
        EXIT WHEN c%NOTFOUND;

        IF v_salary > 3100 THEN
            DBMS_OUTPUT.PUT_LINE(v_last_name || ' - nie dawać podwyżki');
        ELSE
            DBMS_OUTPUT.PUT_LINE(v_last_name || ' - dać podwyżkę');
        END IF;
    END LOOP;
    CLOSE c;
END;
/
DECLARE
    CURSOR c_zarobki(p_min NUMBER, p_max NUMBER, p_imie_fragment VARCHAR2) IS
        SELECT first_name, last_name, salary
        FROM employees
        WHERE salary BETWEEN p_min AND p_max
          AND UPPER(first_name) LIKE '%' || UPPER(p_imie_fragment) || '%';
    v_first_name employees.first_name%TYPE;
    v_last_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
BEGIN
    -- a.
    DBMS_OUTPUT.PUT_LINE('Pracownicy z "a":');
    FOR rec IN c_zarobki(1000, 5000, 'a') LOOP
        DBMS_OUTPUT.PUT_LINE(rec.first_name || ' ' || rec.last_name || ' - ' || rec.salary);
    END LOOP;

    -- b.
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Pracownicy z "u":');
    FOR rec IN c_zarobki(5000, 20000, 'u') LOOP
        DBMS_OUTPUT.PUT_LINE(rec.first_name || ' ' || rec.last_name || ' - ' || rec.salary);
    END LOOP;
END;