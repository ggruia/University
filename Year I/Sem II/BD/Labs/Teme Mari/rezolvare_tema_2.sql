----- Tema 2 -----

--- I ---

--1
select count(*) as "ANGAJATI_K"
from employees
where last_name like 'K%';

--2
select employee_id, first_name, last_name
from employees
where salary = (select min(salary) from employees);

--3
select distinct e.manager_id, m.first_name, m.last_name
from employees e
join employees m on(e.manager_id = m.employee_id)
where e.department_id = 30
order by m.last_name;

--4
select employee_id, first_name, last_name, (select count(*) from employees where e.employee_id = manager_id) as "NR_SUBALTERNI"
from employees e;

--5
select employee_id, first_name, last_name
from employees e
where(select count(*) from employees where last_name = e.last_name) >= 2
order by last_name, first_name;

--6
select department_id, department_name 
from departments d 
where(select count(distinct job_id) from employees where department_id = d.department_id) >= 2;



--- II ---

--7
select distinct p.prod_desc,
(
select sum(qty)
from orders_tbl
group by prod_id
having prod_id = p.prod_id
) as "QUANTITY"
from products_tbl p
where lower(prod_desc) like '%plastic%';

--8
select cust_name, 'client' as "TIP"
from customer_tbl
union
select last_name||' '||first_name, 'angajat'
from employee_tbl
order by tip;

--9
select distinct prod_desc
from products_tbl p, orders_tbl o
where p.prod_id = o.prod_id
and exists (select * from orders_tbl o2 where sales_rep = o.sales_rep 
and (select (prod_desc) from products_tbl where prod_id = o2.prod_id) like '% P%');

--10
select cust_name
from customer_tbl c
where exists 
(select * from orders_tbl where cust_id = c.cust_id
and to_char(ord_date, 'dd') = 17);

--11
select last_name, first_name, bonus
from employee_pay_tbl p
join employee_tbl e on(e.emp_id = p.emp_id)
where salary < 32000 and bonus * 17 < 32000;

--12
select first_name, last_name, nvl(sum(o.qty),0) as "CANTITATE_TOTALA"
from employee_tbl e left join orders_tbl o on e.emp_id = o.sales_rep
group by e.emp_id, e.first_name, e.last_name
having sum(o.qty) > 50 or nvl(sum(o.qty),0)=0;

--13
select last_name, nvl(salary, 0) as "SALARY", MAX(ord_date) as "ULTIMA_COMANDA"
from employee_tbl e
join employee_pay_tbl p on (e.emp_id = p.emp_id)
join orders_tbl o on (e.emp_id = o.sales_rep)
group by (last_name, salary, o.sales_rep);

--14
select prod_desc
from products_tbl
where cost > (select avg(cost) from products_tbl);

--15
select last_name, first_name, nvl(salary, 0) as "SALARY", nvl(bonus, 0) as "BONUS",
(select sum(salary) from employee_pay_tbl) as "TOTAL_SALARY",
(select sum(bonus) from employee_pay_tbl) as "TOTAL_BONUS"
from employee_tbl e 
join employee_pay_tbl p on (e.emp_id = p.emp_id)
group by (last_name, first_name, salary, bonus);

--16
select city
from employee_tbl e
where (select count(*) from orders_tbl where sales_rep = e.emp_id)
= (select max(count(*)) from orders_tbl group by sales_rep);

--17
select e.emp_id, e.last_name, 
count(decode(to_char(ord_date, 'mm'), 9, 1)) as "COMENZI_SEPT",
count(decode(to_char(ord_date, 'mm'), 10, 1)) as "COMENZI_OCT"
from employee_tbl e
left join orders_tbl o on (e.emp_id = o.sales_rep)
group by (emp_id, last_name);

--18
select cust_name, cust_city
from customer_tbl
where cust_address >= '0' and cust_address <= '9'
and cust_id not in (select cust_id from orders_tbl);

--19
select distinct e.emp_id, e.last_name||' '||e.first_name as "EMP_NAME", e.city, c.cust_id, c.cust_name, c.cust_city 
from employee_tbl e, customer_tbl c
where exists(select * from orders_tbl where sales_rep = e.emp_id and cust_id = c.cust_id)
and city != cust_city
order by e.emp_id;

--20
select avg(nvl(salary,0)) as "SALARIU_MEDIU"
from employee_pay_tbl;

--21
-- a. Corect
-- b. Incorect - EMPLOYEE_ID nu este un tabel, deci nu putem extrage coloana SALARY din el
--               (se poate utiliza EMPLOYEE_PAY_TBL in locul EMPLOYEE_ID pentru a corecta acest query

--22
select last_name, pay_rate
from employee_tbl e
join employee_pay_tbl p on(e.emp_id = p.emp_id)
where pay_rate > (select max(pay_rate) 
from employee_tbl em
join employee_pay_tbl pm on(em.emp_id = pm.emp_id)
where upper(last_name) like '%LL%');
