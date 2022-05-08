----- lab 5 -----

-- 19
drop table angajati_gg;
commit;

create table angajati_gg
(
cod_ang number(4), 
nume varchar2(20) not null, 
prenume varchar2(20), 
email char(15), 
data_ang date default sysdate, 
job varchar2(15), 
cod_sef number(4), 
salariu number(8, 2) not null,
cod_dep number(2),
comision number(2,2),

constraint fkey_cod_angajat primary key(cod_ang), 
constraint unique_email unique(email),
constraint check_dept_gg check(cod_dep > 0),
constraint fkey_cod_sef_gg foreign key(cod_sef) references angajati_gg(cod_ang),
constraint unique_cod_prenume unique(nume, prenume),
constraint check_salariu_comision_gg check(salariu > comision * 100),
constraint fkey_cod_dept_gg foreign key(cod_dep) references departamente_gg(cod_dep)
);

describe angajati_gg;

-- 24
alter table angajati_gg
modify email not null;



----- lab 6 -----

--- 9 ---
select e.first_name||' '||e.last_name as "Name", e.job_id, d.department_id
from employees e
join departments d on(e.department_id = d.department_id)
join locations l on(d.location_id = l.location_id)
where l.city = 'Toronto';

--- 16 ---
select d.department_name as "DEPARTAMENT", l.city as "LOCATIE",

nvl((select count(department_id)
from employees e group by department_id
having e.department_id = d.department_id), 0) as "NUMAR_ANGAJATI",

nvl((select avg(e.salary)
from employees e group by department_id
having e.department_id = d.department_id), 0) as "SALARIU_MEDIU"

from departments d
join locations l on(d.location_id = l.location_id);