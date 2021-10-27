spool C:\Users\gruia\Desktop\output.sql;

set pagesize 0
set feedback off

select 'insert into departments values(' || department_id || ', ''' || department_name || ''', ' || manager_id || ', ' || location_id || ');' 
from departments;

spool off;