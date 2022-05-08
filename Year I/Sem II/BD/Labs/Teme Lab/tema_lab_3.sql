----- TEMA 1 -----
--- ex16 varianta DECODE ---

SELECT last_name, hire_date, salary,
DECODE (to_char (hire_date,'yyyy'), 1989, salary * 1.20, 1990, salary * 1.15, 1991, salary * 1.10, salary) marit
FROM employees;

--- ex16 varianta CASE searched---

SELECT last_name, hire_date, salary,
CASE 
    WHEN to_char (hire_date,'yyyy') = 1989 THEN salary * 1.20
    WHEN to_char (hire_date,'yyyy') = 1990 THEN salary * 1.15
    WHEN to_char (hire_date,'yyyy') = 1991 THEN salary * 1.10
    ELSE salary
END AS marit
FROM employees;

--- ex16 varianta CASE simple ---

SELECT last_name, hire_date, salary,
CASE to_char (hire_date,'yyyy')
    WHEN '1989' THEN salary * 1.20
    WHEN '1990' THEN salary * 1.15
    WHEN '1991' THEN salary * 1.10
    ELSE salary
END AS marit
FROM employees;

--- ex3 ---

SELECT e.last_name, e.salary, j.job_title, l.city, c.country_name 
FROM employees e, employees m, jobs j , departments d, locations l, countries c 

WHERE m.last_name = 'King'
AND e.manager_id = m.employee_id
AND e.job_id = j.job_id
AND e.department_id (+)= d.department_id
AND l.location_id (+)= d.location_id
AND c.country_id (+)= l.country_id;