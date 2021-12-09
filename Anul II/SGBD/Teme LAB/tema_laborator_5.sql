set serveroutput on;



-- LABORATORUL 5 PT. 1

-- 1.
select department_name departament, count(employee_id) angajati
from departments d
left outer join employees e on d.department_id = e.department_id
group by department_name;


-- 2.
-- a)
declare
    type pair is record (departament varchar2(30), angajati number(4));
    type collection is table of pair;
    
    slider collection;
    
    cursor c is
        select department_name, count(employee_id)
        from departments d
        left outer join employees e on d.department_id = e.department_id
        group by department_name;

begin
    open c;
    
        fetch c bulk collect into slider limit 5;
            
        while slider.count > 0 loop
            for i in 1..slider.count loop
                if slider(i).angajati = 0 then
                    dbms_output.put_line('In departamentul <' || slider(i).departament || '> nu lucreaza angajati');
                elsif slider(i).angajati = 1 then
                    dbms_output.put_line('In departamentul <' || slider(i).departament || '> lucreaza un angajat');
                else
                    dbms_output.put_line('In departamentul <' || slider(i).departament || '> lucreaza ' || slider(i).angajati || ' angajati');
                end if;
            end loop;
            
            fetch c bulk collect into slider limit 5;
        end loop;
    close c;
end;
/

-- b)   (nu inteleg exact cum sa selectez cate 5 entries fara limit, sau daca sa mai fac un slider de cate 5 entries si sa il afisez pe el,
--      asa ca recurg la "varianta" mai simpla: parcurg colectia cu toate entries..)
declare
    type pair is record (departament varchar2(30), angajati number(4));
    type collection is table of pair;

    coll collection;

begin

    select department_name, count(employee_id)
    bulk collect into coll
    from departments d
    left outer join employees e on d.department_id = e.department_id
    group by department_name;
            
    for i in 1..coll.count loop
        if coll(i).angajati = 0 then
            dbms_output.put_line('In departamentul <' || coll(i).departament || '> nu lucreaza angajati');
        elsif coll(i).angajati = 1 then
            dbms_output.put_line('In departamentul <' || coll(i).departament || '> lucreaza un angajat');
        else
            dbms_output.put_line('In departamentul <' || coll(i).departament || '> lucreaza ' || coll(i).angajati || ' angajati');
        end if;
    end loop;
end;
/




-- LABORATORUL 5 PT. 2


-- 10.
-- a)   cursor clasic
declare
    depno number(4) := 0;
    
    cod number(4);
    departament varchar2(30);
    nume varchar2(30);
    
    cursor c is
        select d.department_id cod, d.department_name departament, e.first_name || ' ' || e.last_name nume
        from departments d
        left outer join employees e on d.department_id = e.department_id
        where d.department_id in (10, 20, 30, 40)
        group by d.department_id, d.department_name, e.first_name || ' ' || e.last_name
        order by d.department_id;
    
begin
    open c;

    loop
        fetch c into cod, departament, nume;
        exit when c%NOTFOUND;

        if depno = cod then
            dbms_output.put_line('   -> ' || nume);
        else
            depno := cod;
            dbms_output.new_line;
            dbms_output.put_line('Departamentul "' || departament || '", ID  <' || cod || '> :');
            dbms_output.put_line('   -> ' || nume);
        end if;
    end loop;

    close c;
end;
/

-- b)   ciclu cursor
declare
    depno number(4) := 0;

    cursor c is
        select d.department_id cod, d.department_name departament, e.first_name || ' ' || e.last_name nume
        from departments d
        left outer join employees e on d.department_id = e.department_id
        where d.department_id in (10, 20, 30, 40)
        group by d.department_id, d.department_name, e.first_name || ' ' || e.last_name
        order by d.department_id;

begin
    for dep in c loop
        if depno = dep.cod then
            dbms_output.put_line('   -> ' || dep.nume);
        else
            depno := dep.cod;
            dbms_output.new_line;
            dbms_output.put_line('Departamentul "' || dep.departament || '", ID  <' || dep.cod || '> :');
            dbms_output.put_line('   -> ' || dep.nume);
        end if;
    end loop;
end;
/


-- 1.
-- a)
declare
    type joblist is table of varchar2(10);
    cont number(4);
    lista_joburi joblist;
    
    denumire varchar2(35);
    nume varchar2(30);
    salariu number(6);
    
    cursor c (cod varchar2) is
        select e.first_name || ' ' || e.last_name, e.salary
        from employees e
        join jobs j on j.job_id = e.job_id
        where e.job_id = cod;
        
    
begin
    select job_id bulk collect
    into lista_joburi
    from jobs;

    for i in 1..lista_joburi.count
    loop
        cont := 0;
    
        select job_title
        into denumire
        from jobs
        where job_id = lista_joburi(i);
        dbms_output.put_line(denumire || ':');
        
        open c(lista_joburi(i));
        loop
            fetch c into nume, salariu;
            exit when c%NOTFOUND;
            
            dbms_output.put_line('   -> ' || nume || ': ' || salariu);
            
            cont := cont + 1;
        end loop;
        close c;
        
        if cont = 0 then
            dbms_output.put_line('   <> Niciun angajat nu lucreaza pe acest JOB!');
        end if;
        
        dbms_output.new_line();
    end loop;
end;
/


-- b)
declare
    type joblist is table of varchar2(10);
    cont number(4);
    lista_joburi joblist;
    
    denumire varchar2(35);
    
    cursor c (cod varchar2) is
        select e.first_name || ' ' || e.last_name nume, e.salary salariu
        from employees e
        join jobs j on j.job_id = e.job_id
        where e.job_id = cod;
        
    
begin
    select job_id bulk collect
    into lista_joburi
    from jobs;

    for i in 1..lista_joburi.count
    loop
        cont := 0;
    
        select job_title
        into denumire
        from jobs
        where job_id = lista_joburi(i);
        dbms_output.put_line(denumire || ':');
        
        for ang in c(lista_joburi(i))
        loop
            dbms_output.put_line('   -> ' || ang.nume || ': ' || ang.salariu);
            
            cont := cont + 1;
        end loop;
        
        if cont = 0 then
            dbms_output.put_line('   <> Niciun angajat nu lucreaza pe acest JOB!');
        end if;
        
        dbms_output.new_line();
    end loop;
end;
/


-- c)
declare
    type joblist is table of varchar2(10);
    cont number(4);
    lista_joburi joblist;
    
    denumire varchar2(35);
        
begin
    select job_id bulk collect
    into lista_joburi
    from jobs;

    for i in 1..lista_joburi.count
    loop
        cont := 0;
    
        select job_title
        into denumire
        from jobs
        where job_id = lista_joburi(i);
        dbms_output.put_line(denumire || ':');
        
        for ang in 
            (select e.first_name || ' ' || e.last_name nume, e.salary salariu
            from employees e
            join jobs j on j.job_id = e.job_id
            where e.job_id = lista_joburi(i))
        loop
            dbms_output.put_line('   -> ' || ang.nume || ': ' || ang.salariu);
            
            cont := cont + 1;
        end loop;
        
        if cont = 0 then
            dbms_output.put_line('   <> Niciun angajat nu lucreaza pe acest JOB!');
        end if;
        
        dbms_output.new_line();
    end loop;
end;
/


-- d)
declare
    type joblist is table of varchar2(10);
    type refcursor is ref cursor;
    
    cont number(4);
    denumire varchar2(35);
    nume varchar2(30);
    salariu number(6);
    
    lista_joburi joblist;
    cc refcursor;
    
    cursor c is 
        select s.job_title, cursor
            (select e.last_name || e.first_name nume, e.salary salariu
            from employees e
            join jobs j on j.job_id = e.job_id 
            where j.job_id = s.job_id)
        from jobs s;
        
begin
    open c;
    
    loop
        cont := 0;
        
        fetch c into denumire, cc;
        exit when c%NOTFOUND;
        dbms_output.put_line(denumire || ':');
        
        loop 
            fetch cc into nume, salariu;
            exit when cc%notfound;
            
            dbms_output.put_line('   -> ' || nume || ': ' || salariu);
            cont := cont + 1;
        end loop;
        
        if cont = 0 then 
            dbms_output.put_line('   <> Niciun angajat nu lucreaza pe acest JOB!');
        end if;
        
        dbms_output.new_line();
        
    end loop;
    close c;
end;
/



-- 2.
declare
    type joblist is table of varchar2(10);
    denumire varchar2(35);
    
    nr_angajati_job number;
    nr_angajati_total number := 0;
    salariu_total number := 0;
    salariu_mediu_total number(10, 2);
    salariu_job number;
    salariu_mediu_job number(8, 2);
    lista_joburi joblist;
    
    cursor c (cod varchar2) is
        select e.first_name || ' ' || e.last_name nume, e.salary salariu
        from employees e
        join jobs j on j.job_id = e.job_id
        where e.job_id = cod
        order by e.salary;
    
begin
    select job_id bulk collect
    into lista_joburi
    from jobs;

    for i in 1..lista_joburi.count
    loop
        nr_angajati_job := 0;
        salariu_job := 0;
        salariu_mediu_job := 0;
    
        select job_title
        into denumire
        from jobs
        where job_id = lista_joburi(i);
        dbms_output.put_line(denumire || ':');
        
        for ang in c(lista_joburi(i))
        loop
            nr_angajati_job := nr_angajati_job + 1;
            salariu_job := salariu_job + ang.salariu;
            dbms_output.put_line(nr_angajati_job || '. ' || ang.nume || ' ' || ang.salariu);
        end loop;
        
        salariu_mediu_job := salariu_job / nr_angajati_job;
        
        salariu_total := salariu_total + salariu_job;
        nr_angajati_total := nr_angajati_total + nr_angajati_job;
        
        dbms_output.new_line();
        dbms_output.put_line('Numar angajati ' || nr_angajati_job);
        dbms_output.put_line('Salariu TOTAL ' || salariu_job);
        dbms_output.put_line('Salariu MEDIU ' || salariu_mediu_job);
        dbms_output.put_line('...................');
        dbms_output.new_line();
        dbms_output.new_line();
    end loop;
    
    salariu_mediu_total := salariu_total / nr_angajati_total;
    
    dbms_output.new_line();
    dbms_output.put_line('Numar TOTAL angajati ' || nr_angajati_total);
    dbms_output.put_line('Salariu TOTAL ' || salariu_total);
    dbms_output.put_line('Salariu MEDIU ' || salariu_mediu_total);
end;
/



-- 3.
declare
    type joblist is table of varchar2(10);
    denumire varchar2(35);
    
    nr_angajati_job number;
    nr_angajati_total number := 0;
    salariu_total number := 0;
    salariu_mediu_total number(10, 2);
    salariu_job number;
    salariu_mediu_job number(8, 2);
    remuneratie_angajat number(8, 2);
    procent_remuneratie_angajat number(3, 2);
    lista_joburi joblist;
    
    cursor c (cod varchar2) is
        select e.first_name || ' ' || e.last_name nume, e.salary salariu, e.commission_pct comision
        from employees e
        join jobs j on j.job_id = e.job_id
        where e.job_id = cod
        order by (e.salary + e.salary * nvl(e.commission_pct, 0));
        
begin
    select job_id bulk collect  -- obtin lista cu ID-urile joburilor
    into lista_joburi
    from jobs;
    
    select sum(salary * (1 + nvl(commission_pct, 0)))   -- obtin salariul total
    into salariu_total
    from employees;
        
    for i in 1..lista_joburi.count
    loop
        nr_angajati_job := 0;
        salariu_job := 0;
        salariu_mediu_job := 0;
    
        select job_title
        into denumire
        from jobs
        where job_id = lista_joburi(i);
        dbms_output.put_line(denumire || ':');
        
        for ang in c(lista_joburi(i))
        loop
            nr_angajati_job := nr_angajati_job + 1;
            remuneratie_angajat := ang.salariu * (1 + nvl(ang.comision, 0));
            salariu_job := salariu_job + remuneratie_angajat;
            procent_remuneratie_angajat := remuneratie_angajat / salariu_total * 100;
            dbms_output.put_line(nr_angajati_job || '. ' || ang.nume || ' - ' || remuneratie_angajat || ' - ' || to_char(procent_remuneratie_angajat, 'FM990D99') || '%');
        end loop;
        
        salariu_mediu_job := salariu_job / nr_angajati_job;
        nr_angajati_total := nr_angajati_total + nr_angajati_job;
        
        dbms_output.new_line();
        dbms_output.put_line('Numar angajati ' || nr_angajati_job);
        dbms_output.put_line('Salariu TOTAL ' || salariu_job);
        dbms_output.put_line('Salariu MEDIU ' || salariu_mediu_job);
        dbms_output.put_line('...................');
        dbms_output.new_line();
        dbms_output.new_line();
    end loop;
    
    salariu_mediu_total := salariu_total / nr_angajati_total;
    
    dbms_output.new_line();
    dbms_output.put_line('Numar TOTAL angajati ' || nr_angajati_total);
    dbms_output.put_line('Salariu TOTAL ' || salariu_total);
    dbms_output.put_line('Salariu MEDIU ' || salariu_mediu_total);
end;
/



-- 4.
declare
    type joblist is table of varchar2(10);
    denumire varchar2(35);
    
    indice number;
    nr_angajati_job number;
    nr_angajati_total number := 0;
    salariu_total number := 0;
    salariu_mediu_total number(10, 2);
    salariu_job number;
    salariu_mediu_job number(8, 2);
    remuneratie_angajat number(8, 2);
    procent_remuneratie_angajat number(3, 2);
    lista_joburi joblist;
    
    cursor c (cod varchar2) is
        select e.first_name || ' ' || e.last_name nume, e.salary salariu, e.commission_pct comision
        from employees e
        join jobs j on j.job_id = e.job_id
        where e.job_id = cod
        order by (e.salary + e.salary * nvl(e.commission_pct, 0)) desc;
        
begin
    select job_id bulk collect  -- obtin lista cu ID-urile joburilor
    into lista_joburi
    from jobs;
    
    select sum(salary * (1 + nvl(commission_pct, 0)))   -- obtin salariul total
    into salariu_total
    from employees;
        
    for i in 1..lista_joburi.count
    loop
        indice := 0;
        nr_angajati_job := 0;
        salariu_job := 0;
        salariu_mediu_job := 0;
        
        select count(*)
        into nr_angajati_job
        from employees e
        join jobs j on j.job_id = e.job_id 
        where j.job_id = lista_joburi(i);
        
        
        select job_title
        into denumire
        from jobs
        where job_id = lista_joburi(i);
        
        
        if nr_angajati_job >= 5 then
            dbms_output.put_line(denumire || ', ' || nr_angajati_job || ' angajati:');
        else
            dbms_output.put_line(denumire || ' (< 5 angajati), ' || nr_angajati_job || ' angajati:');
        end if;
        
        for ang in c(lista_joburi(i))
        loop
            indice := indice + 1;
                
            if indice <= 5 then
                remuneratie_angajat := ang.salariu * (1 + nvl(ang.comision, 0));
                salariu_job := salariu_job + remuneratie_angajat;
                procent_remuneratie_angajat := remuneratie_angajat / salariu_total * 100;
                dbms_output.put_line(indice || '. ' || ang.nume || ' - ' || remuneratie_angajat || ' - ' || to_char(procent_remuneratie_angajat, 'FM990D99') || '%');
            end if;
        end loop;
        
        salariu_mediu_job := salariu_job / nr_angajati_job;
        nr_angajati_total := nr_angajati_total + nr_angajati_job;
        
        dbms_output.new_line();
        dbms_output.put_line('Salariu TOTAL ' || salariu_job);
        dbms_output.put_line('Salariu MEDIU ' || salariu_mediu_job);
        dbms_output.put_line('...................');
        dbms_output.new_line();
        dbms_output.new_line();
    end loop;
    
    salariu_mediu_total := salariu_total / nr_angajati_total;
    
    dbms_output.new_line();
    dbms_output.put_line('Numar TOTAL angajati ' || nr_angajati_total);
    dbms_output.put_line('Salariu TOTAL ' || salariu_total);
    dbms_output.put_line('Salariu MEDIU ' || salariu_mediu_total);
end;
/



-- 5.
declare
    type joblist is table of varchar2(10);
    denumire varchar2(35);
    
    indice number;
    nr_angajati_job number;
    nr_angajati_total number := 0;
    salariu_total number := 0;
    salariu_mediu_total number(10, 2);
    salariu_job number;
    salariu_mediu_job number(8, 2);
    remuneratie_angajat number(8, 2);
    remuneratie_angajat_precedent number(8, 2);
    procent_remuneratie_angajat number(3, 2);
    lista_joburi joblist;
    
    cursor c (cod varchar2) is
        select e.first_name || ' ' || e.last_name nume, e.salary salariu, e.commission_pct comision
        from employees e
        join jobs j on j.job_id = e.job_id
        where e.job_id = cod
        order by (e.salary + e.salary * nvl(e.commission_pct, 0)) desc;
        
begin
    select job_id bulk collect  -- obtin lista cu ID-urile joburilor
    into lista_joburi
    from jobs;
    
    select sum(salary * (1 + nvl(commission_pct, 0)))   -- obtin salariul total
    into salariu_total
    from employees;
        
    for i in 1..lista_joburi.count
    loop
        remuneratie_angajat_precedent := 0;
        indice := 0;
        nr_angajati_job := 0;
        salariu_job := 0;
        salariu_mediu_job := 0;
        
        select count(*)
        into nr_angajati_job
        from employees e
        join jobs j on j.job_id = e.job_id 
        where j.job_id = lista_joburi(i);
        
        
        select job_title
        into denumire
        from jobs
        where job_id = lista_joburi(i);
        
        
        if nr_angajati_job >= 5 then
            dbms_output.put_line(denumire || ', ' || nr_angajati_job || ' angajati:');
        else
            dbms_output.put_line(denumire || ' (< 5 angajati), ' || nr_angajati_job || ' angajati:');
        end if;
        
        for ang in c(lista_joburi(i))
        loop
            remuneratie_angajat := ang.salariu * (1 + nvl(ang.comision, 0));
            procent_remuneratie_angajat := remuneratie_angajat / salariu_total * 100;
            salariu_job := salariu_job + remuneratie_angajat;
                
            if remuneratie_angajat != remuneratie_angajat_precedent then
                indice := indice + 1;
                remuneratie_angajat_precedent := remuneratie_angajat;
            end if;
                
            if indice <= 5 then
                dbms_output.put_line('#' || indice || ' ' || ang.nume || ' - ' || remuneratie_angajat || ' - ' || to_char(procent_remuneratie_angajat, 'FM990D99') || '%');
            end if;
        end loop;
        
        salariu_mediu_job := salariu_job / nr_angajati_job;
        nr_angajati_total := nr_angajati_total + nr_angajati_job;
        
        dbms_output.new_line();
        dbms_output.put_line('Salariu TOTAL ' || salariu_job);
        dbms_output.put_line('Salariu MEDIU ' || salariu_mediu_job);
        dbms_output.put_line('...................');
        dbms_output.new_line();
        dbms_output.new_line();
    end loop;
    
    salariu_mediu_total := salariu_total / nr_angajati_total;
    
    dbms_output.new_line();
    dbms_output.put_line('Numar TOTAL angajati ' || nr_angajati_total);
    dbms_output.put_line('Salariu TOTAL ' || salariu_total);
    dbms_output.put_line('Salariu MEDIU ' || salariu_mediu_total);
end;
/