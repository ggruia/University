-- billion = miliard => trillion = biliard (PROOF)

-- EX 5.
-- a)
create table INFO_DEPT_GG
    (id number(4), primary key(id),
     nume_dept varchar2(30),
     plati number(12));

create table INFO_EMP_GG
    (id number(4), primary key(id),
     nume varchar2(30),
     prenume varchar2(30),
     salariu number(6),
     id_dept number(4), foreign key(id_dept) references INFO_DEPT_GG(id));
     
commit;

-- b)
insert into info_dept_gg
select d.department_id, d.department_name, nvl(sum(e.salary), 0)
from departments d
full outer join employees e on d.department_id = e.department_id
group by d.department_id, d.department_name
having d.department_id is not null
order by d.department_id;

insert into info_emp_gg
select employee_id, last_name, first_name, nvl(salary, 0), department_id
from employees
where department_id is not null
order by department_id, employee_id;

commit;

-- c)
create view V_INFO_GG as
select e.id, e.nume, e.prenume, e.salariu, e.id_dept, d.nume_dept, d.plati
from info_emp_gg e
join info_dept_gg d on e.id_dept = d.id;

commit;

-- d)
select * from user_updatable_columns where table_name = 'V_INFO_GG';

-- e)
-- trigger v1
create or replace trigger TR5E_GG
    instead of insert or delete or update on v_info_gg
    for each row
    
begin
    if inserting then
        insert into info_emp_gg values(:new.id, :new.nume, :new.prenume, :new.salariu, :new.id_dept);
        update info_dept_gg set plati = plati + :new.salariu where id = :new.id_dept;
        
    elsif deleting then
        delete from info_emp_gg where id = :old.id;
        update info_dept_gg set plati = plati - :old.salariu where id = :old.id_dept;
        
    elsif updating('salariu') then
        update info_emp_gg set salariu = :new.salariu where id = :old.id;
        update info_dept_gg set plati = plati - :old.salariu + :new.salariu where id = :old.id_dept;
        
    elsif updating('id_dept') then
        update info_emp_gg set id_dept = :new.id_dept where id = :old.id;
        update info_dept_gg set plati = plati - :old.salariu where id = :old.id_dept;
        update info_dept_gg set plati = plati + :new.salariu where id = :new.id_dept;
    end if;
end;
/

-- f)
-- adaugarea unui nou angajat;
select * from info_dept_gg where id = 10;
insert into v_info_gg values(400, 'N1', 'P1', 3000, 10, 'D1', 0);

select * from info_emp_gg where id = 400;
select * from info_dept_gg where id = 10;

-- modificarea salariului unui angajat;
update v_info_gg set salariu = salariu + 1000 where id = 400;

select * from info_emp_gg where id = 400;
select * from info_dept_gg where id = 10;

-- modificarea departamentului unui angajat;
select * from info_dept_gg where id = 90;
update v_info_gg set id_dept = 90 where id = 400;

select * from info_emp_gg where id = 400;
select * from info_dept_gg where id in (10, 90);

-- eliminarea unui angajat;
delete from v_info_gg where id = 400;

select * from info_emp_gg where id = 400;
select * from info_dept_gg where id = 90;

drop trigger TR5E_GG;
/

-- g)
-- trigger v2
create or replace trigger TR5G_GG
    instead of insert or delete or update on v_info_gg
    for each row
    
declare
    nr_rows number(4);

begin
    if inserting then
        select count(*) id
        into nr_rows
        from info_dept_gg
        where id = :new.id_dept;
    
        if :new.id is null and nr_rows = 0 then
            insert into info_dept_gg values(:new.id_dept, :new.nume_dept, 0);
        elsif nr_rows = 0 then
            insert into info_dept_gg values(:new.id_dept, :new.nume_dept, :new.salariu);
            insert into info_emp_gg values(:new.id, :new.nume, :new.prenume, :new.salariu, :new.id_dept);
        else
            insert into info_emp_gg values(:new.id, :new.nume, :new.prenume, :new.salariu, :new.id_dept);
            update info_dept_gg set plati = plati + :new.salariu where id = :new.id_dept;
        end if;
        
    elsif deleting then
        delete from info_emp_gg where id = :old.id;
        update info_dept_gg set plati = plati - :old.salariu where id = :old.id_dept;
        
    elsif updating('salariu') then
        update info_emp_gg set salariu = :new.salariu where id = :old.id;
        update info_dept_gg set plati = plati - :old.salariu + :new.salariu where id = :old.id_dept;
        
    elsif updating('id_dept') then
        update info_emp_gg set id_dept = :new.id_dept where id = :old.id;
        update info_dept_gg set plati = plati - :old.salariu where id = :old.id_dept;
        update info_dept_gg set plati = plati + :new.salariu where id = :new.id_dept;
    end if;
end;
/

-- h)
-- adaugarea unui nou angajat si a departamentului sau (de asemenea nou);
insert into v_info_gg values(465, 'N1', 'P1', 3000, 78, 'D1', 0);

-- adaugarea unui departament nou;
insert into v_info_gg values(null, null, null, null, 79, 'D2', null);


drop trigger TR5G_GG;
/

-- i)
-- daca trigger-ul este activ, nu se vor realiza modificari la nivelul vizualizarii sau tabelelor baza;
update v_info_gg set nume = 'nume' where nume = 'N';

-- j)
-- trigger v3
create or replace trigger TR5J_GG
    instead of insert or delete or update on v_info_gg
    for each row
    
declare
    nr_rows number(4);

begin
    if inserting then
        select count(*) id
        into nr_rows
        from info_dept_gg
        where id = :new.id_dept;
    
        if :new.id is null and nr_rows = 0 then
            insert into info_dept_gg values(:new.id_dept, :new.nume_dept, 0);
        elsif nr_rows = 0 then
            insert into info_dept_gg values(:new.id_dept, :new.nume_dept, :new.salariu);
            insert into info_emp_gg values(:new.id, :new.nume, :new.prenume, :new.salariu, :new.id_dept);
        else
            insert into info_emp_gg values(:new.id, :new.nume, :new.prenume, :new.salariu, :new.id_dept);
            update info_dept_gg set plati = plati + :new.salariu where id = :new.id_dept;
        end if;
        
    elsif deleting then
        delete from info_emp_gg where id = :old.id;
        update info_dept_gg set plati = plati - :old.salariu where id = :old.id_dept;
        
    elsif updating('salariu') then
        update info_emp_gg set salariu = :new.salariu where id = :old.id;
        update info_dept_gg set plati = plati - :old.salariu + :new.salariu where id = :old.id_dept;
        
    elsif updating('id_dept') then
        update info_emp_gg set id_dept = :new.id_dept where id = :old.id;
        update info_dept_gg set plati = plati - :old.salariu where id = :old.id_dept;
        update info_dept_gg set plati = plati + :new.salariu where id = :new.id_dept;
        
    elsif updating('nume') or updating('prenume') then
        update info_emp_gg set nume = :new.nume where nume = :old.nume;
        update info_emp_gg set prenume = :new.prenume where prenume = :old.prenume;
        
    elsif updating('nume_dept') then
        update info_dept_gg set nume_dept = :new.nume_dept where nume_dept = :old.nume_dept;
    end if;
end;
/

-- k)
-- modificarea numelui si/sau a prenumelui unui angajat;
update v_info_gg set nume = 'nume', prenume = 'prenume' where nume = 'nume';

-- modificarea numelui unui departament;
update v_info_gg set nume_dept = 'nume departament' where nume_dept = 'D1';

drop trigger TR5J_GG;
/



-- 4.
create or replace trigger T4_GG
    before insert on emp_gg
    for each row
    
declare
    nr_emp number(4);
    
begin
    select count(*)
    into nr_emp
    from emp_gg
    where department_id = :new.department_id;

    if nr_emp >= 45 then
        dbms_output.put_line('Nu mai pot fi adaugati angajati in acest departament!');
        raise_application_error(-20010, 'Too many employees in department!');
    end if;
end;
/

begin
for i in 206..210 loop
    insert into emp_gg values(i, 'p', 'n', 'e', '999999', '10-MAR-97', 'SA_REP', 1, null, 146, 80);
end loop;
end;
/
select * from emp_gg where department_id = 80;

drop trigger T4_GG;
/


-- 5.
-- a)
create table emp_test_gg as select employee_id, first_name, last_name, department_id from emp_gg;
alter table emp_test_gg add constraint pk1 primary key(employee_id);

create table dept_test_gg as select department_id, department_name from dept_gg;
alter table dept_test_gg add constraint pk2 primary key(department_id);

commit;

-- b)
create or replace trigger T5_UP_DEL_GG
    before delete or update of department_id on dept_test_gg
    for each row
    
begin

    if deleting then
        delete from emp_test_gg where department_id = :old.department_id;
    else
        update emp_test_gg set department_id = :new.department_id where department_id = :old.department_id;
    end if;
end;
/

create or replace trigger T5_UPDATE_GG
    before update of department_id on dept_test_gg
    for each row
    
begin

    if updating then
        update emp_test_gg set department_id = :new.department_id where department_id = :old.department_id;
    end if;
end;
/

create or replace trigger T5_DELETE_GG
    after delete on dept_test_gg

declare
    cursor c is
        select *
        from emp_test_gg
        where department_id is null;
    
begin
    for emp in c loop
        delete from emp_test_gg where employee_id = emp.employee_id;
    end loop;
end;
/


-- test
-- no FK constraint;
delete from dept_test_gg where department_id = 80;
update dept_test_gg set department_id = 300 where department_id = 50;

rollback;
drop trigger T5_UP_DEL_GG;
/

-- with FK constraint;
alter table emp_test_gg add constraint fk1 foreign key(department_id) references dept_test_gg(department_id);
alter table emp_test_gg drop constraint fk1;

delete from dept_test_gg where department_id = 80;
update dept_test_gg set department_id = 300 where department_id = 50;

rollback;
drop trigger T5_UP_DEL_GG;
/

-- with FK constraint and ON DELETE CASCADE;
alter table emp_test_gg add constraint fk2 foreign key(department_id) references dept_test_gg(department_id) on delete cascade;
alter table emp_test_gg drop constraint fk2;

delete from dept_test_gg where department_id = 80;
update dept_test_gg set department_id = 300 where department_id = 50;

rollback;
drop trigger T5_UPDATE_GG;
/

-- with FK constraint and ON DELETE SET NULL;
alter table emp_test_gg add constraint fk3 foreign key(department_id) references dept_test_gg(department_id) on delete set null;
alter table emp_test_gg drop constraint fk3;

delete from dept_test_gg where department_id = 80;
update dept_test_gg set department_id = 300 where department_id = 50;

rollback;
drop trigger T5_UPDATE_GG;
drop trigger T5_DELETE_GG;
/


-- 6.
-- a)
create table ERROR_LOG_GG
    (user_id varchar2(30),
    nume_bd varchar2(30),
    erori varchar2(2000),
    data DATE);
    
commit;

create or replace trigger T6_GG
   after servererror on schema
begin
    insert into ERROR_LOG_GG values (sys.login_user, sys.database_name, dbms_utility.format_error_stack, sysdate);
end;
/


-- Eroare de sintaxa;
/*
begin
    delete from employees
end;
/
end;
*/