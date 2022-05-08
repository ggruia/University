set serveroutput on;


-- 6.
-- Afisati toti angajatii Atelierului care activeaza ca Profesori, impreuna cu lista Cursurilor predate de acestia (are mai multe aplicatii reale);

create or replace procedure P6 is
    type courses_v is varray(30) of varchar2(30);
    type emp_id_tbl is table of number(4);
    type professor_info is record
        (name varchar2(30),
         courses courses_v);
    type professors_tbl is table of professor_info;
    
    prof_name varchar2(30);
    courses_list courses_v := courses_v();
    prof_id_list emp_id_tbl;
    professors_table professors_tbl := professors_tbl();
    
begin
    select a.id
    bulk collect into prof_id_list
    from angajat a
    join job j on a.id_job = j.id
    where j.denumire = 'Profesor';
    
    professors_table.extend(prof_id_list.count);
    
    for i in prof_id_list.first..prof_id_list.last loop
        select nume || ' ' || prenume
        into prof_name
        from angajat
        where id = prof_id_list(i);
        
        select distinct nume_curs
        bulk collect into courses_list
        from predare
        where id_profesor = prof_id_list(i);
        
        professors_table(i).name := prof_name;
        professors_table(i).courses := courses_list;
    end loop;
    
    dbms_output.put_line('Lista profesorilor si a cursurilor pe care le sustin:');
    dbms_output.new_line;
    dbms_output.new_line;
    
    for i in professors_table.first..professors_table.last loop
        dbms_output.put_line(i || ') ' || professors_table(i).name || ' (ID ' || prof_id_list(i) || ') preda: ');
        for j in professors_table(i).courses.first..professors_table(i).courses.last loop
            dbms_output.put_line('  - ' || professors_table(i).courses(j));
        end loop;
        dbms_output.new_line;
    end loop;
end P6;
/
execute P6;
/


-- 7.
-- Afisati clasamentul studentilor (in functie de nota obtinuta) de la fiecare curs predat, impreuna cu media notelor (pentru a-i trimite la olimpiade si concursuri);

create or replace procedure P7 is
    type courses_tbl is table of varchar2(30);
    
    course_list courses_tbl := courses_tbl();
    
    cursor c(course_name varchar2) is
        select n.denumire_curs as course, s.id as id, s.nume || ' ' || s.prenume as name, n.nota as mark
        from nota n
        join student s on n.id_student = s.id
        where denumire_curs = course_name
        order by denumire_curs asc, nota desc;
        
    nr_students number(4);
    sum_marks_course float;
    previous_mark float;
    rank number(4);

begin
    select distinct denumire_curs
    bulk collect into course_list
    from nota
    order by denumire_curs;
    
    for i in course_list.first..course_list.last loop
        nr_students := 0;
        sum_marks_course := 0;
        previous_mark := 0;
        rank := 0;
        dbms_output.put_line(course_list(i) || ':');
        
        for std in c(course_list(i)) loop
            if std.mark != previous_mark then
                rank := rank + 1;
                previous_mark := std.mark;
            end if;
            dbms_output.put_line('  ' || rank || '. ' || std.name || ' - ' || std.mark);
            nr_students := nr_students + 1;
            sum_marks_course := sum_marks_course + std.mark;
        end loop;
        dbms_output.new_line;
        dbms_output.put_line('Media notelor: ' || trunc(sum_marks_course / nr_students, 2));
        dbms_output.put_line('-------------------------');
        dbms_output.new_line;
    end loop;
end P7;
/
execute P7;
/


-- 8.
-- Creati o Functie care sa intoarca lista Angajatilor unui Departament, care au lucrat la un Proiect trimis ca parametru (pentru ca proiectul a generat o suma mare de bani);
create or replace type emp_tbl as table of varchar2(30);
/

create or replace function P8 (project_name proiect.denumire%type) return varchar2 is
    employees_list emp_tbl := emp_tbl();
    employees_string varchar2(500) := '';
    nr_projects number(4) := 0;
    
    NO_PROJECT_FOUND exception;
    pragma exception_init (NO_PROJECT_FOUND, -20001);
    NO_EMPLOYEES_FOUND exception;
    pragma exception_init (NO_EMPLOYEES_FOUND, -20002);
    
begin
    select count(*)
    into nr_projects
    from proiect
    where denumire = project_name;
    
    if nr_projects = 0 then
        raise NO_PROJECT_FOUND;
    end if;
    
    select a.nume || ' ' || a.prenume as nume
    bulk collect into employees_list
    from angajat a
    join departament d on a.departament = d.denumire
    join proiect p on d.denumire = p.departament
    where p.denumire = project_name and nvl(p.data_final, SYSDATE) > a.data_angajare
    order by a.id;
    
    if employees_list.count = 0 then
        raise NO_EMPLOYEES_FOUND;
    end if;
    
    for i in employees_list.first..employees_list.last loop
        employees_string := employees_string || employees_list(i) || ', ';
    end loop;
    
    return rtrim(employees_string, ', ');
    
    exception
        when NO_PROJECT_FOUND then
            dbms_output.put_line('Nu exista niciun proiect cu acest nume!');
            raise_application_error(-20001, 'No Project found that matched the string passed as parameter to P8!');
        when NO_EMPLOYEES_FOUND then
            dbms_output.put_line('Proiectul a fost realizat de angajati care nu mai lucreaza in cadrul firmei!');
            raise_application_error(-20002, 'No Employees found that were employed before the Project started!');
end P8;
/
begin   -- OK;
  dbms_output.put_line('Lista Angajatilor care au lucrat la Proiectul "Macheta Residence":   ' || P8('Macheta Residence'));
end;
/
begin   -- NO_PROJECT_FOUND;
  dbms_output.put_line('Nu exista niciun proiect cu acest nume!' || P8('denumire'));
end;
/
begin   -- NO_EMPLOYEES_FOUND;
  dbms_output.put_line('Nu exista niciun angajat in prezent in firma care a lucrat la acest proiect!' || P8('Restaurare Castel'));
end;
/


-- 9.
-- Creati o Procedura care sa afiseze toate Locatiile la care a invatat un Student dat ca parametru (care si-a pierdut telefonul la o locatie);
create or replace procedure P9(std_name varchar2) is
    student_id number(4);
    nr_locations number(4) := 0;
    
    cursor l(std_id number) is
        select distinct l.id as loc, s.id as id
        from locatie l
        join sala h on l.id = h.id_locatie
        join predare p on h.id = p.id_sala
        join grupa g on p.id_grupa = g.id
        join student s on g.id = s.id_grupa
        where s.id = std_id
        order by l.id;
    
    NO_LOCATION_FOUND exception;
    pragma exception_init (NO_LOCATION_FOUND, -20003);
    
begin
    select id
    into student_id
    from student
    where nume || ' ' || prenume = std_name;

    dbms_output.put_line('Studentul "' || std_name || '" (ID ' || student_id || ')  a invatat in locatiile cu ID-urile:');
    
    for location in l(student_id) loop
        nr_locations := nr_locations + 1;
        dbms_output.put(' <' || location.loc || '>  ');
    end loop;
    dbms_output.new_line;
    
    if nr_locations = 0 then
        raise NO_LOCATION_FOUND;
    end if;
    
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Nu exista niciun student cu acest nume!');
            raise_application_error(-20001, 'Query returned NO ROWS when asked about the student whose name was passed as parameter!');
        when TOO_MANY_ROWS then
            dbms_output.put_line('Exista mai multi studenti cu acest nume!');
            raise_application_error(-20002, 'Query returned MORE THAN ONE ROW when asked about the student whose name was passed as parameter!');
        when NO_LOCATION_FOUND then
            dbms_output.put_line('Acest student nu a invatat in nicio locatie inca!');
            raise_application_error(-20003, 'Query returned NO ROWS when asked about the location a student studied at!');
end P9;
/

-- OK;
execute P9('Stefanescu Bob');
-- TOO_MANY_ROWS;
execute P9('Barbu Matei');
-- NO_DATA_FOUND;
execute P9('nume student');
-- NO_LOCATION_FOUND;
execute P9('Pop Cosmin');
/







-- 10. Creati un trigger LMD la nivel de instructiune care nu permite adaugarea a mai mult de 25 de CURSURI;
create or replace trigger T10
    before insert on curs

declare
    nr_courses number(2);
    
begin
    select count(*)
    into nr_courses
    from curs;
        
    if nr_courses >= 25 then
        dbms_output.put_line('Nu mai pot fi adaugate cursuri aditionale!');
        raise_application_error(-20010, 'Too many courses!');
    end if;
end;
/

savepoint tr10;

insert into curs values('test1', 2, 6, 2);
insert into curs values('test2', 1, 6, 3);
insert into curs values('test3', 2, 6, 2);
insert into curs values('test4', 1, 6, 3);

rollback to tr10;

drop trigger T10;
/


-- 11. Creati un trigger LMD la nivel de linie, care actualizeaza tabela MATERIE in functie de operatiile efectuate pe tabela CURS;
create or replace trigger T11
    after insert or delete on curs
    for each row
    
begin
    if inserting then
        update materie set numar_cursuri = numar_cursuri + 1 where id = :new.id_materie;
        
    elsif deleting then
        update materie set numar_cursuri = numar_cursuri - 1 where id = :old.id_materie;
    end if;
end T11;
/

savepoint tr11;

insert into curs values('test1', 2, 6, 2);
insert into curs values('test2', 1, 6, 3);
-- parent key not found
insert into curs values('test3', 2, 9, 2);

delete from curs where denumire = 'test1';
delete from curs where denumire = 'test2';

rollback to tr11;

drop trigger T11;
/


-- 12. Creati un trigger LDD, care pastreaza in tabela LOG evenimentele de la nivelul BAZEI DE DATE;
create table LOG(
    baza_date varchar2(20),
    utilizator varchar2(30),
    eveniment varchar2(20),
    tabela varchar2(30),
    data DATE);

create or replace trigger T12
    before create or alter or drop on database
begin
    insert into log values ('PROIECT SGBD', sys.login_user, sys.sysevent, sys.dictionary_obj_name, sysdate);
end;
/

create table test (ID number(4));
alter table locatie add rating varchar2(30);
alter table locatie drop column rating;
drop table test;

select * from log;
drop table log;

drop trigger T12;
/







-- 13. Definiti un pachet care sa contina toate obiectele definite in cadrul proiectului;
create or replace package PKG13 as

    type varchar_30_v is varray(30) of varchar2(30);
    type number_4_tbl is table of number(4);
    type varchar_30_tbl is table of varchar2(30);

    procedure P6;
    procedure P7;
    function P8(project_name proiect.denumire%type) return varchar2;
    procedure P9(std_name varchar2);
    
end PKG13;
/

create or replace package body PKG13 as
    -- 6.
    -- Afisati toti angajatii Atelierului care activeaza ca Profesori, impreuna cu lista Cursurilor predate de acestia (are mai multe aplicatii reale);
    procedure P6 as
        type professor_info is record
            (name varchar2(30),
             courses varchar_30_v);
        type professors_tbl is table of professor_info;
        
        prof_name varchar2(30);
        courses_list varchar_30_v := varchar_30_v();
        prof_id_list number_4_tbl;
        professors_table professors_tbl := professors_tbl();
        
    begin
        select a.id
        bulk collect into prof_id_list
        from angajat a
        join job j on a.id_job = j.id
        where j.denumire = 'Profesor';
        
        professors_table.extend(prof_id_list.count);
        
        for i in prof_id_list.first..prof_id_list.last loop
            select nume || ' ' || prenume
            into prof_name
            from angajat
            where id = prof_id_list(i);
            
            select distinct nume_curs
            bulk collect into courses_list
            from predare
            where id_profesor = prof_id_list(i);
            
            professors_table(i).name := prof_name;
            professors_table(i).courses := courses_list;
        end loop;
        
        dbms_output.put_line('Lista profesorilor si a cursurilor pe care le sustin:');
        dbms_output.new_line;
        dbms_output.new_line;
        
        for i in professors_table.first..professors_table.last loop
            dbms_output.put_line(i || ') ' || professors_table(i).name || ' (ID ' || prof_id_list(i) || ') preda: ');
            for j in professors_table(i).courses.first..professors_table(i).courses.last loop
                dbms_output.put_line('  - ' || professors_table(i).courses(j));
            end loop;
            dbms_output.new_line;
        end loop;
    end P6;
    
    
    -- 7.
    -- Afisati clasamentul studentilor (in functie de nota obtinuta) de la fiecare curs predat, impreuna cu media notelor (pentru a-i trimite la olimpiade si concursuri);
    procedure P7 as
        course_list varchar_30_tbl := varchar_30_tbl();
        
        cursor c(course_name varchar2) is
            select n.denumire_curs as course, s.id as id, s.nume || ' ' || s.prenume as name, n.nota as mark
            from nota n
            join student s on n.id_student = s.id
            where denumire_curs = course_name
            order by denumire_curs asc, nota desc;
            
        nr_students number(4);
        sum_marks_course float;
        previous_mark float;
        rank number(4);
    
    begin
        select distinct denumire_curs
        bulk collect into course_list
        from nota
        order by denumire_curs;
        
        for i in course_list.first..course_list.last loop
            nr_students := 0;
            sum_marks_course := 0;
            previous_mark := 0;
            rank := 0;
            dbms_output.put_line(course_list(i) || ':');
            
            for std in c(course_list(i)) loop
                if std.mark != previous_mark then
                    rank := rank + 1;
                    previous_mark := std.mark;
                end if;
                dbms_output.put_line('  ' || rank || '. ' || std.name || ' - ' || std.mark);
                nr_students := nr_students + 1;
                sum_marks_course := sum_marks_course + std.mark;
            end loop;
            dbms_output.new_line;
            dbms_output.put_line('Media notelor: ' || trunc(sum_marks_course / nr_students, 2));
            dbms_output.put_line('-------------------------');
            dbms_output.new_line;
        end loop;
    end P7;
    
    
    -- 8.
    -- Creati o Functie care sa intoarca lista Angajatilor unui Departament, care au lucrat la un Proiect trimis ca parametru (pentru ca proiectul a generat o suma mare de bani);
   function P8 (project_name proiect.denumire%type) return varchar2 as
        employees_list varchar_30_tbl := varchar_30_tbl();
        employees_string varchar2(500) := '';
        nr_projects number(4) := 0;
        
        NO_PROJECT_FOUND exception;
        pragma exception_init (NO_PROJECT_FOUND, -20001);
        NO_EMPLOYEES_FOUND exception;
        pragma exception_init (NO_EMPLOYEES_FOUND, -20002);
        
    begin
        select count(*)
        into nr_projects
        from proiect
        where denumire = project_name;
        
        if nr_projects = 0 then
            raise NO_PROJECT_FOUND;
        end if;
        
        select a.nume || ' ' || a.prenume as nume
        bulk collect into employees_list
        from angajat a
        join departament d on a.departament = d.denumire
        join proiect p on d.denumire = p.departament
        where p.denumire = project_name and nvl(p.data_final, SYSDATE) > a.data_angajare
        order by a.id;
        
        if employees_list.count = 0 then
            raise NO_EMPLOYEES_FOUND;
        end if;
        
        for i in employees_list.first..employees_list.last loop
            employees_string := employees_string || employees_list(i) || ', ';
        end loop;
        
        return rtrim(employees_string, ', ');
        
        exception
            when NO_PROJECT_FOUND then
                dbms_output.put_line('Nu exista niciun proiect cu acest nume!');
                raise_application_error(-20001, 'No Project found that matched the string passed as parameter to P8!');
            when NO_EMPLOYEES_FOUND then
                dbms_output.put_line('Proiectul a fost realizat de angajati care nu mai lucreaza in cadrul firmei!');
                raise_application_error(-20002, 'No Employees found that were employed before the Project started!');
    end P8;
    
    
    -- 9.
    -- Creati o Procedura care sa afiseze toate Locatiile la care a invatat un Student dat ca parametru (care si-a pierdut telefonul la o locatie);
    procedure P9(std_name varchar2) as
        student_id number(4);
        nr_locations number(4) := 0;
        
        cursor l(std_id number) is
            select distinct l.id as loc, s.id as id
            from locatie l
            join sala h on l.id = h.id_locatie
            join predare p on h.id = p.id_sala
            join grupa g on p.id_grupa = g.id
            join student s on g.id = s.id_grupa
            where s.id = std_id
            order by l.id;
        
        NO_LOCATION_FOUND exception;
        pragma exception_init (NO_LOCATION_FOUND, -20003);
        
    begin
        select id
        into student_id
        from student
        where nume || ' ' || prenume = std_name;
    
        dbms_output.put_line('Studentul "' || std_name || '" (ID ' || student_id || ')  a invatat in locatiile cu ID-urile:');
        
        for location in l(student_id) loop
            nr_locations := nr_locations + 1;
            dbms_output.put(' <' || location.loc || '>  ');
        end loop;
        dbms_output.new_line;
        
        if nr_locations = 0 then
            raise NO_LOCATION_FOUND;
        end if;
        
        exception
            when NO_DATA_FOUND then
                dbms_output.put_line('Nu exista niciun student cu acest nume!');
                raise_application_error(-20001, 'Query returned NO ROWS when asked about the student whose name was passed as parameter!');
            when TOO_MANY_ROWS then
                dbms_output.put_line('Exista mai multi studenti cu acest nume!');
                raise_application_error(-20002, 'Query returned MORE THAN ONE ROW when asked about the student whose name was passed as parameter!');
            when NO_LOCATION_FOUND then
                dbms_output.put_line('Acest student nu a invatat in nicio locatie inca!');
                raise_application_error(-20003, 'Query returned NO ROWS when asked about the location a student studied at!');
    end P9;
    
end PKG13;
/

-- TESTAM PACHETUL PKG13;
-- 6
execute PKG13.P6;

-- 7
execute PKG13.P7;

-- 8
begin   -- OK;
  dbms_output.put_line('Lista Angajatilor care au lucrat la Proiectul "Macheta Residence":   ' || PKG13.P8('Macheta Residence'));
end;
/
begin   -- NO_PROJECT_FOUND;
  dbms_output.put_line('Nu exista niciun proiect cu acest nume!' || PKG13.P8('denumire'));
end;
/
begin   -- NO_EMPLOYEES_FOUND;
  dbms_output.put_line('Nu exista niciun angajat in prezent in firma care a lucrat la acest proiect!' || PKG13.P8('Restaurare Castel'));
end;
/

-- 9
-- OK;
execute PKG13.P9('Stefanescu Bob');
-- TOO_MANY_ROWS;
execute PKG13.P9('Barbu Matei');
-- NO_DATA_FOUND;
execute PKG13.P9('nume student');
-- NO_LOCATION_FOUND;
execute PKG13.P9('Pop Cosmin');