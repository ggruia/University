----- TEMA 1 -----


--- I ---

-- grila 1: A
-- grila 2: C
-- grila 3: C
-- grila 4: C
-- grila 5: 09-MAR-09
-- grila 6: 3
-- grila 7: D



--- II ---

-- ex 1:
SELECT CUST_ID, CUST_NAME FROM customer_tbl
WHERE CUST_STATE IN ('IN', 'OH', 'MI', 'IL')
AND CUST_NAME LIKE ('A%') OR CUST_NAME LIKE('B%')
ORDER BY 2;

-- ex 2.a:
SELECT * FROM products_tbl
WHERE COST BETWEEN 1 AND 12.5;

-- ex 2.b:
SELECT * FROM products_tbl
WHERE COST < 1 OR COST > 12.5;

-- ex 3:
SELECT LOWER(FIRST_NAME)||'.'||LOWER(LAST_NAME)||'@ittitech.com' AS "E-MAIL"
FROM EMPLOYEE_TBL;

-- ex 4:
SELECT LAST_NAME||', '||FIRST_NAME AS "NAME",
SUBSTR(EMP_ID, 1, 3)||'-'||SUBSTR(EMP_ID, 4, 2)||'-'||SUBSTR(EMP_ID, 6, 4) AS "EMP_ID",
'('||SUBSTR(PHONE, 1, 3)||')'||SUBSTR(PHONE, 4, 3)||'-'||SUBSTR(PHONE, 6, 4) AS "PHONE"
FROM employee_tbl;

-- ex 5:
SELECT EMP_ID, to_char(DATE_HIRE, 'yyyy') AS "AN_ANGAJARE" FROM employee_pay_tbl;

-- ex 6:
SELECT e.EMP_ID, e.LAST_NAME, e.FIRST_NAME, p.SALARY, p.BONUS
FROM employee_tbl e
JOIN employee_pay_tbl p ON(e.EMP_ID = p.EMP_ID);

-- ex 7:
SELECT c.CUST_NAME, o.ORD_NUM, o.ORD_DATE
FROM customer_tbl c
JOIN orders_tbl o ON(c.CUST_ID = o.CUST_ID)
WHERE c.CUST_STATE LIKE('I%');

-- ex 8:
SELECT o.ORD_NUM, o.QTY, e.LAST_NAME, e.FIRST_NAME, e.CITY
FROM employee_tbl e
JOIN ORDERS_TBL o ON(e.EMP_ID = o.SALES_REP);

-- ex 9:
SELECT o.ORD_NUM, o.QTY, e.LAST_NAME, e.FIRST_NAME, e.CITY
FROM employee_tbl e
JOIN ORDERS_TBL o ON(e.EMP_ID = o.SALES_REP(+));

-- ex 10:
SELECT EMP_ID FROM employee_tbl
WHERE MIDDLE_NAME IS NULL;

-- ex 11:
SELECT EMP_ID, NVL(SALARY, 0) + NVL(BONUS, 0) SALARIU_ANUAL FROM employee_pay_tbl;

-- ex 12.DECODE:
SELECT e.FIRST_NAME||' '||e.LAST_NAME AS "NAME", p.SALARY, p.POSITION, DECODE (p.POSITION, 'MARKETING', SALARY * 1.1, 'SALESMAN', SALARY * 1.15, SALARY) SALARIU_MODIFICAT
FROM employee_tbl e
JOIN employee_pay_tbl p ON(e.EMP_ID = p.EMP_ID);

-- ex 12.CASE:
SELECT e.FIRST_NAME||' '||e.LAST_NAME AS "NAME", p.SALARY, p.POSITION,
CASE p.POSITION
    WHEN 'MARKETING' THEN SALARY * 1.1
    WHEN 'SALESMAN' THEN SALARY * 1.15
    ELSE SALARY
END AS SALARIU_MODIFICAT
FROM employee_tbl e
JOIN employee_pay_tbl p ON(e.EMP_ID = p.EMP_ID);

----- END -----