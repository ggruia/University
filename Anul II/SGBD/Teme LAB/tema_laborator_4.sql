set serveroutput on;



-- 2.
drop table excursie_gg;
commit;

create or replace type tip_orase_gg is varray(50) of varchar2(20);
/
create table excursie_gg
    (cod_excursie number(20),
    denumire varchar2(20),
    orase tip_orase_gg,
    status varchar2(20));


-- a)
insert into excursie_gg (cod_excursie, denumire, orase, status) values (1, '"Scoala altfel"', tip_orase_gg('Sibiu', 'Sighisoara'), 'disponibila');
insert into excursie_gg (cod_excursie, denumire, orase, status) values (2, 'Excursie "Paste"', tip_orase_gg('Targoviste', 'Magurele', 'Bucuresti'), 'anulata');
insert into excursie_gg (cod_excursie, denumire, orase, status) values (3, 'City break Germania', tip_orase_gg('Munchen', 'Frankfurt', 'Berlin'), 'anulata');
insert into excursie_gg (cod_excursie, denumire, orase, status) values (4, 'Drumetie Bucegi', tip_orase_gg('Rasnov', 'Azuga', 'Predeal'), 'disponibila');
insert into excursie_gg (cod_excursie, denumire, orase, status) values (5, 'Sejur Grecia', tip_orase_gg('Atena'), 'anulata');
insert into excursie_gg (cod_excursie, denumire, orase, status) values (6, 'Tara exotica', tip_orase_gg('Bali'), 'disponibila');

    
-- b)
-- b1
declare
    cod  number(4);
    oras_nou  varchar2(20);
    orase_curente  tip_orase_gg;
    
begin
    cod := &ID_excursie;
    oras_nou := '&Oras_nou';
    
    select orase
    into orase_curente
    from excursie_gg
    where cod_excursie = cod;

    orase_curente.extend();
    orase_curente(orase_curente.count) := oras_nou;
    
    update excursie_gg 
    set orase = orase_curente
    where cod_excursie = cod;
end;

-- b2
declare
    cod  number(4);
    oras_nou  varchar2(20);
    orase_curente  tip_orase_gg;
    
begin
    cod := &ID_excursie;
    oras_nou := '&Oras_nou';
    
    select orase
    into orase_curente
    from excursie_gg
    where cod_excursie = cod;
    
    orase_curente.extend();
    for i in reverse 2..orase_curente.count loop
        orase_curente(i) := orase_curente(i-1);
    end loop;
    orase_curente(2) := oras_nou;
    
    update excursie_gg
    set orase = orase_curente
    where cod_excursie = cod;
end;

-- b3
declare
    cod number(4);
    orase_curente tip_orase_gg;
    oras1 varchar2(20);
    oras2 varchar2(20);
    tmp varchar2(20);
    id_oras1 number(20);
    id_oras2 number(20);
    
begin
    cod := &ID_excursie;
    oras1 := '&Oras_1';
    oras2 := '&Oras_2';
    
    select orase
    into orase_curente 
    from excursie_gg
    where cod_excursie = cod;
    
    for i in 1..orase_curente.count loop
    
        if orase_curente(i) = oras1 then
            id_oras1 := i;
        end if;
        
        if orase_curente(i) = oras2 then
            id_oras2 :=i;
        end if;

    end loop;
    
    tmp := orase_curente(id_oras1);
    orase_curente(id_oras1) := orase_curente(id_oras2);
    orase_curente(id_oras2) := tmp;
    
    update excursie_gg
    set orase = orase_curente
    where cod_excursie = cod;
end;
    
-- b4
declare
    cod  number(4);
    oras  varchar2(20);
    ID_oras  number(5);
    orase_curente  tip_orase_gg;
    
begin
    cod := &ID_excursie;
    oras := '&Oras';
    
    select orase
    into orase_curente
    from excursie_gg
    where cod_excursie = cod;
    
    for i in 1..orase_curente.count loop
        if orase_curente(i) = oras then 
            ID_oras := i;
        end if;
    end loop;
    
    for i in reverse ID_oras..(orase_curente.count - 1) loop
        orase_curente(i) := orase_curente(i + 1);
    end loop;
    
    orase_curente.trim;
    
    update excursie_gg
    set orase = orase_curente
    where cod_excursie = cod;
end;


-- c)
declare
    cod number(4);
    orase_curente tip_orase_gg;

begin
    cod := &ID_excursie;

    select orase
    into orase_curente
    from excursie_gg
    where cod_excursie = cod;

    dbms_output.put_line('Excursia ' || cod || ' e formata din ' || orase_curente.count || ' orase:   ');

    for i in 1..orase_curente.count loop
        if i < orase_curente.count then
            dbms_output.put(orase_curente(i) || ' -> ');
        else
             dbms_output.put(orase_curente(i));
        end if;
    end loop;
    dbms_output.new_line;
end;

    
-- d)
create or replace type vector_IDs is table of number(4);
/
declare
    orase_curente tip_orase_gg;
    ID_excursii vector_IDs;
    
begin
    select cod_excursie
    bulk collect into ID_excursii
    from excursie_gg;
    
    for i in 1..ID_excursii.count loop
    
        select orase
        into orase_curente
        from excursie_gg
        where cod_excursie = ID_excursii(i);
        
        dbms_output.put_line('Excursia ' || ID_excursii(i) || ' este formata din orasele:');
        
        for i in 1..orase_curente.count loop
            if i < orase_curente.count then
                dbms_output.put(orase_curente(i) || ' -> ');
            else
                dbms_output.put(orase_curente(i));
            end if;
        end loop;
        
        dbms_output.new_line;
        dbms_output.new_line;
    end loop;
end;


--e anulati excursiile cu cele mai putine orase vizitate
create or replace type vector_IDs is table of number(4);
/
declare
    
    orase_curente tip_orase_gg;
    ID_excursii vector_IDs;
    min_orase number(20) := 50;
    
begin
    select cod_excursie
    bulk collect into ID_excursii
    from excursie_gg;
    
    for i in 1..ID_excursii.count loop
    
        select orase
        into orase_curente
        from excursie_gg
        where cod_excursie = ID_excursii(i);
        
        if min_orase > orase_curente.count then
            min_orase := orase_curente.count;
        end if;
        
    end loop;
    
    for i in 1..ID_excursii.count loop
    
        select orase into orase_curente
        from excursie_gg
        where cod_excursie = ID_excursii(i);
        
        if min_orase = orase_curente.count then
            update excursie_gg 
            set status = 'anulata' 
            where cod_excursie = ID_excursii(i);
        end if;
        
    end loop;
end;



-- 3.
drop table excursie_gg;
commit;

create or replace type tip_orase_gg is table of varchar2(20);
/
create table excursie_gg
    (cod_excursie number(4),
    denumire varchar2(20),
    orase tip_orase_gg,
    status varchar2(20))
    
nested table orase store as tabel_orase_gg;


-- a)
insert into excursie_gg (cod_excursie, denumire, orase, status) values (1, '"Scoala altfel"', tip_orase_gg('Sibiu', 'Sighisoara'), 'disponibila');
insert into excursie_gg (cod_excursie, denumire, orase, status) values (2, 'Excursie "Paste"', tip_orase_gg('Targoviste', 'Magurele', 'Bucuresti'), 'anulata');
insert into excursie_gg (cod_excursie, denumire, orase, status) values (3, 'City break Germania', tip_orase_gg('Munchen', 'Frankfurt', 'Berlin'), 'anulata');
insert into excursie_gg (cod_excursie, denumire, orase, status) values (4, 'Drumetie Bucegi', tip_orase_gg('Rasnov', 'Azuga', 'Predeal'), 'disponibila');
insert into excursie_gg (cod_excursie, denumire, orase, status) values (5, 'Sejur Grecia', tip_orase_gg('Atena'), 'anulata');
insert into excursie_gg (cod_excursie, denumire, orase, status) values (6, 'Tara exotica', tip_orase_gg('Bali'), 'disponibila');

    
-- b)
-- b1
declare
    cod  number(4);
    oras_nou  varchar2(20);
    orase_curente  tip_orase_gg;
    
begin
    cod := &ID_excursie;
    oras_nou := '&Oras_nou';
    
    select orase
    into orase_curente
    from excursie_gg
    where cod_excursie = cod;

    orase_curente.extend();
    orase_curente(orase_curente.count) := oras_nou;
    
    update excursie_gg 
    set orase = orase_curente
    where cod_excursie = cod;
end;

-- b2
declare
    cod  number(4);
    oras_nou  varchar2(20);
    orase_curente  tip_orase_gg;
    
begin
    cod := &ID_excursie;
    oras_nou := '&Oras_nou';
    
    select orase
    into orase_curente
    from excursie_gg
    where cod_excursie = cod;
    
    orase_curente.extend();
    for i in reverse 2..orase_curente.count loop
        orase_curente(i) := orase_curente(i-1);
    end loop;
    orase_curente(2) := oras_nou;
    
    update excursie_gg
    set orase = orase_curente
    where cod_excursie = cod;
end;

-- b3
declare
    cod number(4);
    orase_curente tip_orase_gg;
    oras1 varchar2(20);
    oras2 varchar2(20);
    tmp varchar2(20);
    id_oras1 number(20);
    id_oras2 number(20);
    
begin
    cod := &ID_excursie;
    oras1 := '&Oras_1';
    oras2 := '&Oras_2';
    
    select orase
    into orase_curente 
    from excursie_gg
    where cod_excursie = cod;
    
    for i in 1..orase_curente.count loop
    
        if orase_curente(i) = oras1 then
            id_oras1 := i;
        end if;
        
        if orase_curente(i) = oras2 then
            id_oras2 :=i;
        end if;

    end loop;
    
    tmp := orase_curente(id_oras1);
    orase_curente(id_oras1) := orase_curente(id_oras2);
    orase_curente(id_oras2) := tmp;
    
    update excursie_gg
    set orase = orase_curente
    where cod_excursie = cod;
end;
    
-- b4
declare
    cod  number(4);
    oras  varchar2(20);
    ID_oras  number(5);
    orase_curente  tip_orase_gg;
    
begin
    cod := &ID_excursie;
    oras := '&Oras';
    
    select orase
    into orase_curente
    from excursie_gg
    where cod_excursie = cod;
    
    for i in 1..orase_curente.count loop
        if orase_curente(i) = oras then 
            ID_oras := i;
        end if;
    end loop;
    
    for i in reverse ID_oras..(orase_curente.count - 1) loop
        orase_curente(i) := orase_curente(i + 1);
    end loop;
    
    orase_curente.trim;
    
    update excursie_gg
    set orase = orase_curente
    where cod_excursie = cod;
end;


-- c)
declare
    cod number(4);
    orase_curente tip_orase_gg;

begin
    cod := &ID_excursie;

    select orase
    into orase_curente
    from excursie_gg
    where cod_excursie = cod;

    dbms_output.put_line('Excursia ' || cod || ' e formata din ' || orase_curente.count || ' orase:   ');

    for i in 1..orase_curente.count loop
        if i < orase_curente.count then
            dbms_output.put(orase_curente(i) || ' -> ');
        else
             dbms_output.put(orase_curente(i));
        end if;
    end loop;
    dbms_output.new_line;
end;

    
-- d)
create or replace type vector_IDs is table of number(4);
/
declare
    orase_curente tip_orase_gg;
    ID_excursii vector_IDs;
    
begin
    select cod_excursie
    bulk collect into ID_excursii
    from excursie_gg;
    
    for i in 1..ID_excursii.count loop
    
        select orase
        into orase_curente
        from excursie_gg
        where cod_excursie = ID_excursii(i);
        
        dbms_output.put_line('Excursia ' || ID_excursii(i) || ' este formata din orasele:');
        
        for i in 1..orase_curente.count loop
            if i < orase_curente.count then
                dbms_output.put(orase_curente(i) || ' -> ');
            else
                dbms_output.put(orase_curente(i));
            end if;
        end loop;
        
        dbms_output.new_line;
        dbms_output.new_line;
    end loop;
end;


--e anulati excursiile cu cele mai putine orase vizitate
create or replace type vector_IDs is table of number(4);
/
declare
    
    orase_curente tip_orase_gg;
    ID_excursii vector_IDs;
    min_orase number(20) := 50;
    
begin
    select cod_excursie
    bulk collect into ID_excursii
    from excursie_gg;
    
    for i in 1..ID_excursii.count loop
    
        select orase
        into orase_curente
        from excursie_gg
        where cod_excursie = ID_excursii(i);
        
        if min_orase > orase_curente.count then
            min_orase := orase_curente.count;
        end if;
        
    end loop;
    
    for i in 1..ID_excursii.count loop
    
        select orase into orase_curente
        from excursie_gg
        where cod_excursie = ID_excursii(i);
        
        if min_orase = orase_curente.count then
            update excursie_gg 
            set status = 'anulata' 
            where cod_excursie = ID_excursii(i);
        end if;
        
    end loop;
end;