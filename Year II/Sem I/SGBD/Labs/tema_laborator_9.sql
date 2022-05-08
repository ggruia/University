set serveroutput on;

create table ERROR_GG
    (cod number,
    tip varchar2(100));

-- 1.
-- a)
accept code prompt 'Input code: ';
declare
    x number := &code;
    NEGATIVE_INTEGER exception;
    
begin
    if x < 0 then
        raise NEGATIVE_INTEGER;
    else
        dbms_output.put_line(sqrt(x));
    end if;
    
    
    exception
        when NEGATIVE_INTEGER then
            insert into error_gg values(-20001, 'codul introdus este negativ;');
end;
/

-- b)
accept code prompt 'Input code: ';
declare
    x number := &code;
    err_number number;
    err_message varchar2(100);
    
begin
    x := sqrt(x);
    dbms_output.put_line(x);
    
    exception
        when VALUE_ERROR then
            err_number := sqlcode;
            err_message := substr(sqlerrm, 1, 100);
            insert into error_gg values(err_number, err_message);
end;
/


-- 2.
accept salary prompt 'Input salary: ';
declare
    x number := &salary;
    name varchar2(30);

begin
    select first_name || ' ' || last_name
    into name
    from emp_gg
    where salary = x;
    
    dbms_output.put_line(name);
    
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('No employees with the specified salary!');
        when TOO_MANY_ROWS then
            dbms_output.put_line('More than one employee with the specified salary!');
end;
/


-- 3.
create or replace trigger T3
    before update of department_id on dept_gg
    for each row

declare
    nr_emp number;
    EMPLOYEES_FOUND exception;

begin
    select count(*)
    into nr_emp
    from emp_gg
    where department_id = :old.department_id;
    
    if nr_emp != 0 then
        raise EMPLOYEES_FOUND;
    end if;

    exception
        when EMPLOYEES_FOUND then
            dbms_output.put_line('This department has employees working in it; Cannot change ID!');
            raise_application_error(-20010, 'Employees found in Department!');
end T3;
/

begin
    update dept_gg set department_id = 6 where department_id = 60;
    update dept_gg set department_id = 290 where department_id = 270;
end;
/

drop trigger T3;
/


-- 4.
accept nr_emp_low prompt 'Inferior Limit of Employees: ';
accept nr_emp_high prompt 'Superior Limit of Employees: ';
declare
    l number := &nr_emp_low;
    h number := &nr_emp_high;
    
    nr_emp number;
    dept_name varchar2(30);

begin
    select count(*)
    into nr_emp
    from emp_gg
    where department_id = 10;
    
    select department_name
    into dept_name
    from dept_gg
    where department_id = 10;
    
    if nr_emp between l and h then
        dbms_output.put_line(dept_name);
    else
        dbms_output.put_line('Departamentul 10 nu are angajati in intervalul specificat!');
    end if;
end;
/


-- 5.
accept id prompt 'Department ID: ';
accept name prompt 'New Department Name: ';
declare
    dep_id number := &id;
    dep_name varchar2(30) := '&name';

begin
    update dept_gg set department_name = dep_name where department_id = dep_id;

    if SQL%NOTFOUND then
        raise_application_error(-20006, 'No department found with the specified ID!');
    end if;
end;
/


-- 6.
-- O a doua metoda, pe langa ce am abordat, ar fi sa rezolv fara procedura, dar e foarte asemanator cu ce am scris deja;
create or replace procedure P6 (dep_id number, dep_loc number) is
    dep_name_loc varchar2(30);
    dep_name_id varchar2(30);
    
    check_id number := 0;

begin
    select department_name
    into dep_name_id
    from dept_gg
    where department_id = dep_id;
    
    check_id := 1;
    
    select department_name
    into dep_name_loc
    from dept_gg
    where location_id = dep_loc;
    
    dbms_output.put_line('Department name by ID: ' || dep_name_id);
    dbms_output.put_line('Department name by Location: ' || dep_name_loc);
    
    exception
        when NO_DATA_FOUND then
            if check_id = 1 then
                dbms_output.put_line('Error originated from asking for department name by Location!');
            else
                dbms_output.put_line('Error originated from asking for department name by ID!');
            end if;
end P6;
/

execute P6(10, 1400);
execute P6(10, 856);
execute P6(19, 856);

drop procedure P6;
/