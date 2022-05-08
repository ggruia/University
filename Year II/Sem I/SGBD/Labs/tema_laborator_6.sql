set serveroutput on;

-- EXERCITIUL 5
create or replace procedure p5 as

    cursor c(dep_id number) is
        select * from (select to_char(hire_date, 'DAY'), count(*)
                           from employees
                           where department_id = dep_id
                           group by to_char(hire_date, 'DAY')
                           having count(*) = (select max(count(*))
                                                  from employees
                                                  where department_id = dep_id
                                                  group by to_char(hire_date, 'DAY'))) where rownum = 1;
    
    cursor jh(emp_id number) is
        select employee_id as id, floor(end_date - start_date) as time
        from job_history
        where employee_id = emp_id
        order by employee_id;

    type department_ids is table of number(4);
    department_ids_list department_ids := department_ids();

    department_name_var varchar2(30);
    jobs_count number;
    total_employees_count number;
    most_employees_count number;
    most_employees_day varchar(20);
    
    total_hire_time number;


begin
    
    select department_id
    bulk collect into department_ids_list
    from departments;
    
    for i in 1..department_ids_list.count loop
    
        select count(*)
        into total_employees_count
        from employees
        where department_id = department_ids_list(i);
    
        dbms_output.put_line('Department #' || department_ids_list(i) || ' <' || total_employees_count || ' employees>');
        
        
        
        select department_name
        into department_name_var
        from departments
        where department_id = department_ids_list(i);
        
        
        if total_employees_count = 0 then
            dbms_output.put_line('In the  <<< ' || department_name_var || ' >>>  department, there are no employees!');
            
        else
            open c(department_ids_list(i));
            
            loop
                fetch c into most_employees_day, most_employees_count;
                exit when c%notfound;
                
                dbms_output.put_line('In the  <<< ' || department_name_var || ' >>>  department, the most employees <' || most_employees_count || '> have been employeed on a ' || initcap(most_employees_day));
                
                for emp in (select employee_id as id, last_name || ' ' || first_name as name, hire_date, salary
                            from employees
                            where department_id = department_ids_list(i)
                            and to_char(hire_date, 'DAY') = most_employees_day)
                loop
                            
                    select count(*)
                    into jobs_count
                    from job_history
                    where employee_id = emp.id;

                    total_hire_time := floor(SYSDATE - emp.hire_date);
                    
                    -- daca ne intereseaza si istoricul joburilor executam acest IF block
                    -- datele din tabela employees sunt incorecte din punctul meu de vedere,
                    -- pentru ca este introdus hire date ca prima data de angajare a angajatului in firma,
                    -- in loc de ultima data de angajare, lucru care face tabela "job_history" redundanta
                    if jobs_count > 0 then
                        for j in jh(emp.id)
                        loop
                            total_hire_time := total_hire_time + j.time;
                        end loop;
                    end if;
                                
                    dbms_output.put_line('   - "' || emp.name || '" earns <' || emp.salary || '> and has been employed for <' || total_hire_time || '> days');
                    
                end loop;
            end loop;
            close c;
        end if;
        
        dbms_output.new_line;
    end loop;
end;
/

begin
p5();
end;
/



-- EXERCITIUL 6
create or replace procedure p6 as

    cursor c(dep_id number) is
        select * from (select to_char(hire_date, 'DAY'), count(*)
                           from employees
                           where department_id = dep_id
                           group by to_char(hire_date, 'DAY')
                           having count(*) = (select max(count(*))
                                                  from employees
                                                  where department_id = dep_id
                                                  group by to_char(hire_date, 'DAY'))) where rownum = 1;

    cursor e(dep_id number) is
        select employee_id as id, first_name || ' ' || last_name as name, department_id as department, hire_date, salary
        from employees
        where department_id = dep_id
        order by department_id asc, floor(SYSDATE - hire_date) desc;

        
    type department_ids is table of number(4);
    department_ids_list department_ids := department_ids();

    department_name_var varchar2(30);
    jobs_count number;
    total_employees_count number;
    most_employees_count number;
    most_employees_day varchar(20);
    current_hire_time number;
    previous_hire_time number;
    current_rank number;

begin
    
    select department_id
    bulk collect into department_ids_list
    from departments;
    
    for i in 1..department_ids_list.count loop
    
        select count(*)
        into total_employees_count
        from employees
        where department_id = department_ids_list(i);
        
        select department_name
        into department_name_var
        from departments
        where department_id = department_ids_list(i);
        
        previous_hire_time := 0;
        current_rank := 0;
        dbms_output.put_line('Department #' || department_ids_list(i) || ' <' || total_employees_count || ' employees>');
        
        if total_employees_count = 0 then
            dbms_output.put_line('In the  <<< ' || department_name_var || ' >>>  department, there are no employees!');
        else
            open c(department_ids_list(i));
            loop
                fetch c into most_employees_day, most_employees_count;
                exit when c%notfound;
                
                dbms_output.put_line('In the  <<< ' || department_name_var || ' >>>  department, the most employees <' || most_employees_count || '> have been employeed on a ' || initcap(most_employees_day));
                            
                for emp in e(department_ids_list(i))
                loop
                    current_hire_time := floor(SYSDATE - emp.hire_date);
                    
                    if current_hire_time != previous_hire_time and to_char(emp.hire_date, 'DAY') = most_employees_day then
                        current_rank := current_rank + 1;
                        previous_hire_time := current_hire_time;
                    end if;
                    
                    if to_char(emp.hire_date, 'DAY') = most_employees_day then
                        dbms_output.put_line('  ' || current_rank || '. "' || emp.name || '" earns <' || emp.salary || '> and has been employed for <' || floor(SYSDATE - emp.hire_date) || '> days');
                    end if;
                end loop;
            end loop;
            close c;
        end if;
        
        dbms_output.new_line;
    end loop;
end;
/

begin
p6();
end;
/