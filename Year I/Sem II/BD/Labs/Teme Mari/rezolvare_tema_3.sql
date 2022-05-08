
--1
select s.s_id as "COD", s.s_last || ' ' || s.s_first as "STUDENT_SAU_CURS", 'STUDENT' as "TIP"
from student s
join faculty f on s.f_id = f.f_id
where f.f_last = 'Brown'

union

select c.course_no as "COD", c.course_name as "STUDENT_SAU_CURS", 'CURS' as "TIP"
from course c
join course_section cs on c.course_no = cs.course_no
join faculty f on cs.f_id = f.f_id
where f.f_last = 'Brown';


--2
select s.s_id as "ID_STUDENT", s.s_last || ' ' || s.s_first as "NUME_STUDENT"
from student s
join enrollment e on s.s_id = e.s_id
join course_section cs on e.c_sec_id = cs.c_sec_id
join course c on cs.course_no = c.course_no

group by s.s_id, s.s_last, s.s_first, c.course_name
having (
exists (SELECT c.course_name FROM course WHERE 'Database Management' in c.course_name)
and not exists (SELECT c.course_name FROM course WHERE 'Programming in C++' in c.course_name));


--3
select distinct s.s_id as "ID_STUDENT", s.s_last || ' ' || s.s_first as "NUME_STUDENT"
from student s
join enrollment e on s.s_id = e.s_id
group by s.s_id, s.s_last, s.s_first, e.grade
having e.grade = 'C' or e.grade is null;


--4
select loc_id as "ID_LOCATIE", bldg_code as "COD_CLADIRE", capacity as "CAPACITATE"
from location
where capacity = (select max(capacity) from location);


--5
select min(tab1.id) + 1 as "MIN", max(tab2.id) - 1 as "MAX"
from t tab1 
cross join t tab2
where tab1.id + 1 not in (select * from t)
and tab2.id - 1 not in (select * from t);


--6
select f.f_id as "COD_PROF", f.f_last || ' ' || f.f_first as "NUME_PROF", 
case
when (select count(*) from student s where s.f_id = f.f_id) = 0 then 'Nu'
    else 'Da (' || (select count(*) from student s where s.f_id = f.f_id) || ')'
end as "STUDENT",
case
when (select count (*) from course_section cs where cs.f_id = f.f_id) = 0 then 'Nu'
    else 'Da (' || (select count (*) from course_section cs where cs.f_id = f.f_id) || ')'
end as "CURS"
from faculty f;


--7
select sem1.term_desc as "SEM_1", sem2.term_desc as "SEM_2"
from term sem1
cross join term sem2
where substr(sem1.term_desc, -1, 1) != substr(sem2.term_desc, -1, 1)
and substr(sem1.term_desc, 1, length(sem1.term_desc) - 1) = substr(sem2.term_desc, 1, length(sem2.term_desc) - 1);


--8
select s_id as "ID_STUDENT", s_last || ' ' || s_first as "NUME_STUDENT"
from student
where f_id in
(select cs1.f_id
from course_section cs1 
join course_section cs2 on cs1.f_id = cs2.f_id
where substr(cs1.course_no, 5, 1) != substr(cs2.course_no, 5, 1));


--9
select distinct cs1.course_no, cs2.course_no 
from course_section cs1
join course_section cs2 on cs1.course_no > cs2.course_no
where cs1.term_id = cs2.term_id
order by cs1.course_no desc, cs2.course_no;


--10
select distinct cs.course_no, c.course_name, t.term_desc as "SEMESTRU", cs.max_enrl as "MAX_LOCURI"
from course_section cs
join course c on cs.course_no = c.course_no
join term t on cs.term_id = t.term_id
where max_enrl < (select min(max_enrl) from course_section where loc_id = 1);


--11
select distinct c.course_no, c.course_name, cs.max_enrl as "NR_LOCURI"
from course_section cs
join course c on cs.course_no = c.course_no
where cs.max_enrl = (select min(max_enrl) from course_section);
    

--12
select f.f_last || ' ' || f.f_first as "NUME_PROF",
(select floor(avg(max_enrl)) 
from course_section
where f_id = f.f_id) as "MEDIE_LOCURI"
from faculty f;


--13
select f.f_last || ' ' || f.f_first as "NUME_PROF",
(select count(*)
from student
where f_id = f.f_id) as "NR_STUDENTI_COORD"
from faculty f
where (select count(*) from student where f_id = f.f_id) >= 3;


--14
select course_name, 
(select max(max_enrl) 
from course_section 
where course_no = c.course_no) as "MAX_LOCURI", 

(select distinct loc_id 
from course_section 
where max_enrl = (select max(max_enrl) from course_section where course_no = c.course_no)
and course_no = c.course_no) as "ID_LOCATIE"
from course c;


--15
select term_desc as "SEMESTRU",
(select floor(avg(max_enrl))
from course_section
where term_id = t.term_id) as "MEDIE_LOCURI"
from term t
where substr(t.term_desc, -4, 4) = '2007';