set serveroutput on;


-- 6
variable dep varchar2(50);
variable ang number;

begin
    select department_name, count(*)
    into :dep, :ang
    from employees e
    join departments d on e.department_id = d.department_id
    group by department_name
    having count(*) = (select max(count(*))
                       from employees
                       group by department_id);

    dbms_output.put_line('Departamentul "' || :dep || '", cu ' || :ang || ' angajati;');
end;
/
print dep
print ang


-- 2
select rent_date, (select count(*) from octombrie_vbo where 
    extract(day from data) = extract(day from rent_date) and
    extract(month from data) = extract(month from rent_date)) as "NR_IMPRUMUTURI"
from(select trunc(to_date('01-OCT-2021', 'DD-MON-YYYY') + (level - 1)) "RENT_DATE"
    from dual connect by level <= 31);


-- 3
declare
    nume varchar2(50) := '&name';
    nrPersoane number;
    nrTitluri number;
    
begin
    select count(*)
    into nrPersoane
    from member_gg m
    where m.last_name = nume;
    
    if nrPersoane = 0 then
        dbms_output.put_line('Nu exista persoane cu numele "' || nume || '" in evidenta noastra!');
    elsif nrPersoane > 1 then
        dbms_output.put_line('Exista mai multe persoane cu numele "' || nume || '" in evidenta noastra!');
        dbms_output.put_line('Introduceti ID-ul persoanei pe care o cautati:');
        declare
            cod number := &ID;
        begin
            select count(*)
            into nrPersoane
            from member_gg m
            where m.member_id = cod;
            
            if nrPersoane = 0 then
                dbms_output.put_line('Persoana cautata nu se afla in evidenta noastra!');
            else
                select count(distinct title_id)
                into nrTitluri
                from member_gg m
                join rental r on r.member_id = cod
                where m.last_name = nume;
                dbms_output.put_line('Persoana "' || nume || '" a imprumutat ' || nrTitluri || ' titluri.');
            end if;
        end;
    else
        select count(distinct title_id)
        into nrTitluri
        from member_gg m
        join rental r on r.member_id = m.member_id
        where m.last_name = nume;
        dbms_output.put_line('Persoana "' || nume || '" a imprumutat ' || nrTitluri || ' titluri.');
    end if;
end;


-- 4
declare
    nume varchar2(50) := '&name';
    nrPersoane number;
    nrTitluriTotale number;
    nrTitluriImprumutate number;
    categorie number;
    
begin
    select count(*)
    into nrPersoane
    from member_gg m
    where m.last_name = nume;
    
    select count(*)
    into nrTitluriTotale
    from rental r
    join title t on t.title_id = r.title_id;
    
    if nrPersoane = 0 then
        dbms_output.put_line('Nu exista persoane cu numele "' || nume || '" in evidenta noastra!');
        
    elsif nrPersoane > 1 then
        dbms_output.put_line('Exista mai multe persoane cu numele "' || nume || '" in evidenta noastra!');
        dbms_output.put_line('Introduceti ID-ul persoanei pe care o cautati:');
        
        declare
            cod number := &ID;
        begin
            select count(*)
            into nrPersoane
            from member_gg m
            where m.member_id = cod;
            
            if nrPersoane = 0 then
                dbms_output.put_line('Persoana cautata nu se afla in evidenta noastra!');
                
            else
                select count(title_id)
                into nrTitluriImprumutate
                from member_gg m
                join rental r on r.member_id = m.member_id
                where m.last_name = nume and r.member_id = cod;
                dbms_output.put_line('Persoana "' || nume || '" a imprumutat ' || nrTitluriImprumutate || ' titluri din cele ' || nrTitluriTotale || ' disponibile;');
                
                categorie := (nrTitluriImprumutate / nrTitluriTotale) * 100;
    
                case
                    when categorie > 75 then
                        dbms_output.put_line('Categoria 1');
                    when categorie > 50 then
                        dbms_output.put_line('Categoria 2');
                    when categorie > 25 then
                        dbms_output.put_line('Categoria 3');
                    else
                        dbms_output.put_line('Categoria 4');
                end case;
            end if;
        end;
    else
        select count(title_id)
        into nrTitluriImprumutate
        from member_gg m
        join rental r on r.member_id = m.member_id
        where m.last_name = nume;
        dbms_output.put_line('Persoana "' || nume || '" a imprumutat ' || nrTitluriImprumutate || ' titluri din cele ' || nrTitluriTotale || ' disponibile;');
    
                categorie := (nrTitluriImprumutate / nrTitluriTotale) * 100;
    
                case
                    when categorie > 75 then
                        dbms_output.put_line('Categoria 1');
                    when categorie > 50 then
                        dbms_output.put_line('Categoria 2');
                    when categorie > 25 then
                        dbms_output.put_line('Categoria 3');
                    else
                        dbms_output.put_line('Categoria 4');
                end case;
    end if;
end;


-- 5
declare
    cod number := &ID;
    nrPersoane number;
    nrTitluriTotale number;
    nrTitluriImprumutate number;
    categorie number;
    reducere number;

begin
    select count(*)
    into nrTitluriTotale
    from title;

    select count(*)
    into nrTitluriImprumutate
    from rental r
    join member_gg m on m.member_id = r.member_id
    group by m.member_id
    having m.member_id = cod;

    categorie := (nrTitluriImprumutate / nrTitluriTotale) * 100;
    

    case
        when categorie >= 75 then
            select count(*)
            into reducere
            from member_gg
            where member_id = cod and discount != 10;
         
         if reducere = 1 then
            update member_gg
            set discount = 10
            where member_id = cod;
            commit;
            dbms_output.put_line('Modificare efectuata cu succes!');
        else
            dbms_output.put_line('Nicio modificare efectuata!');
        end if;

        when categorie >= 50 then
            select count(*)
            into reducere
            from member_gg
            where member_id = cod and discount != 5;
            
        if reducere = 1 then
            update member_gg
            set discount = 5
            where member_id = cod;
            commit;
            dbms_output.put_line('Modificare efectuata cu succes!');
        else
            dbms_output.put_line('Nicio modificare efectuata!');
        end if;

        when categorie >= 25 then
            select count(*)
            into reducere
            from member_gg
            where member_id = cod and discount != 3;
            
        if reducere = 1 then
            update member_gg
            set discount = 3
            where member_id = cod;
            commit;
            dbms_output.put_line('Modificare efectuata cu succes!');
        else
            dbms_output.put_line('Nicio modificare efectuata!');
        end if;

        else
            dbms_output.put_line('Nicio modificare efectuata!');
    end case;

exception
    when no_data_found then
        dbms_output.put_line('Nicio modificare efectuata!');
end;
/
select * from member_gg;