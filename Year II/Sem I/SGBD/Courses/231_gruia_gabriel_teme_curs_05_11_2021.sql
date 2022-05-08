set serveroutput on;

create or replace type t_vector is table of integer;
/
declare
    v_init t_vector := t_vector();
    v_bubble_sort t_vector := t_vector();
    v_native_sort t_vector := t_vector();
    
    swapped boolean;
    tmp number;
    
    time_start_bubble timestamp;
    time_finish_bubble timestamp;
    
    time_start_native timestamp;
    time_finish_native timestamp;
    
begin
    v_init.extend(300);
    v_bubble_sort.extend(300);
    v_native_sort.extend(300);
    
    for i in 1..300 loop
        v_init(i) := dbms_random.value(1,100);
        v_bubble_sort(i) := v_init(i);
        v_native_sort(i) := v_init(i);
    end loop;
    dbms_output.put_line('Tabloul are ' ||  v_init.count || ' elemente: ');
    dbms_output.new_line();
    
    
    select localtimestamp into time_start_bubble from dual;
    loop
        swapped := false;

        for i in 2 .. v_bubble_sort.last loop
            if v_bubble_sort(i-1) > v_bubble_sort(i) then
                tmp := v_bubble_sort(i);
                v_bubble_sort(i) := v_bubble_sort(i-1);
                v_bubble_sort(i-1) := tmp;
                swapped := true;
            end if;
        end loop;
        
        exit when not swapped;
    end loop;
    select localtimestamp into time_finish_bubble from dual;
    
    
    select localtimestamp into time_start_native from dual;
    select cast (multiset
                (select *
                from table (v_native_sort)
                order by 1 asc)
                as t_vector)
    into v_native_sort
    from dual;
    select localtimestamp into time_finish_native from dual;
 
    dbms_output.put('Vector nesortat: ');
    for i in v_init.first..v_init.last loop
        dbms_output.put(v_init(i) || ' '); 
    end loop;
    dbms_output.new_line();
    dbms_output.new_line();
    
    dbms_output.put('Vector sortat prin Bubble Sort: ');
    /*for i in v_bubble_sort.first..v_bubble_sort.last loop
        dbms_output.put(v_bubble_sort(i) || ' ');
    end loop;*/
    dbms_output.new_line();
    dbms_output.put_line(time_start_bubble - time_finish_bubble);
    dbms_output.new_line();
    
    dbms_output.put('Vector sortat prin sortarea nativa PL/SQL: ');
    /*for i in v_native_sort.first..v_native_sort.last loop
        dbms_output.put(v_native_sort(i) || ' '); 
    end loop;*/
    dbms_output.new_line();
    dbms_output.put_line(time_start_native - time_finish_native);
    
end;