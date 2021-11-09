set serveroutput on;


-- no_data_found from 'select into' handled with exception
declare
    memberID number := &ID;
    memberName varchar2(50);
begin
    select last_name || ' ' || first_name
    into memberName
    from member
    where member_id = memberID;
    dbms_output.put_line(memberName);

exception
    when no_data_found then
        dbms_output.put_line('ATENTIE! Persoana cu acest ID nu exista in evidenta noastra!');
end;

-- no_data_found from 'table' handled with exception
declare
    type IDs is table of varchar2(20) index by pls_integer;
    listID IDs;
    nameList varchar2(200) := '';
begin
    listID(99) := 'Biri';
    listID(100) := 'Velasquez';
    listID(101) := 'Ngao';
    listID(102) := 'Mark';
    
    for i in 99..103
    loop
        nameList := nameList || '   (' || i || ') ' || listID(i);
    end loop;
    dbms_output.put_line(nameList);
    
exception
    when no_data_found then
        dbms_output.put_line('Lista discontinua de valori!!!');
end;