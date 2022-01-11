
--1
select s.s_last || ' ' || s.s_first as "NUME"
from student s
where not exists
(select e.grade 
from enrollment e 
where s.s_id = e.s_id 
and e.grade is not null);

--2
select distinct l.bldg_code
from location l
where l.bldg_code not in 
(select bldg_code from location 
where loc_id not in 
(select loc_id from course_section));

--3
select distinct f.f_id as "ID", f.f_last || ' ' || f.f_first as "NUME_PROF"
from faculty f
join student s on f.f_id = s.f_id
join enrollment e on s.s_id = e.s_id
join course_section cs on f.f_id = cs.f_id
join course c on cs.course_no = c.course_no
where (e.grade = 'A') and (c.course_name = 'Database Management');

--4
select f.f_last || ' ' || f.f_first as "NUME_PROF"
from faculty f
join course_section cs on f.f_id = cs.f_id
where (cs.max_enrl = (select max(max_enrl) from course_section where rownum = 1))
or (cs.loc_id = (select loc_id from location where capacity = (select max(capacity) from location where rownum = 1)));

--5
select f.f_last || ' ' || f.f_first as "NUME_PROF"
from faculty f
where f.loc_id in (select loc_id
                from location 
                where capacity in (select min(capacity) from location))
and f.f_id in (select cs.f_id
                from course_section cs
                where cs.max_enrl in (select min(max_enrl) from course_section 
                                    where loc_id in (select loc_id from location 
                                                    where capacity in (select max(capacity) from location))));

--6
with sali as (select loc_id
            from course_section
            where f_id in (select f_id
                            from faculty 
                            where f_last = 'Marx')),
locuri as (select cs.c_sec_id
            from course_section cs, enrollment e, student s
            where cs.c_sec_id = e.c_sec_id
            and e.s_id = s.s_id
            and s.s_last = 'Jones')
            
select (sum(l.capacity) + sum(max_enrl))/(count(l.loc_id) + count(cs.c_sec_id)) as "CAP_MEDIE"
from location l, course_section cs
where l.loc_id in (select * from sali)
and cs.c_sec_id in (select * from locuri);

--7
select bldg_code, floor(avg(capacity)) as "CAP_MEDIE"
from location l

where exists
(select * from course_section cs where loc_id = l.loc_id and
(select course_name from course where course_no = cs.course_no) like '%Systems%')

group by bldg_code;

--8
select avg(l.capacity) as "CAP_MEDIE"
from location l
where l.loc_id in 
(select distinct l.loc_id
from location l
join course_section cs on l.loc_id = cs.loc_id
join course c on c.course_no = cs.course_no
where c.course_name like '%Systems%');

--9
select c.course_name
from course c
where c.course_name like '%Java%'
or not exists (select course_name from course where course_name like '%Java%');

--10       
select distinct cs.course_no, c.course_name
from course_section cs
join course c on c.course_no = cs.course_no
where(
decode((select count(*)
        from course_section cs1
        join location l on cs1.loc_id = l.loc_id
        where cs.c_sec_id = cs1.c_sec_id
        and l.capacity = 42), 0, 0, 1) +
decode((select count(*)
        from course_section cs2
        join faculty f on cs2.f_id = f.f_id
        where cs.c_sec_id = cs2.c_sec_id
        and f_last like 'Brown'), 0, 0, 1) +
decode((select count(*)
        from course_section cs3
        join enrollment e on cs3.c_sec_id = e.c_sec_id
        join student s on e.s_id = s.s_id
        where cs.c_sec_id = cs3.c_sec_id
        and s_last || ' ' || s_first like 'Jones Tammy'), 0, 0, 1) +
decode((select count(*)
        from course_section cs4
        join course c on cs4.course_no = c.course_no
        where cs.c_sec_id = cs4.c_sec_id
        and c.course_name like '%Database%'), 0, 0, 1) +
decode((select count(*)
        from course_section cs5
        join term t on cs5.term_id = t.term_id
        where cs.c_sec_id = cs5.c_sec_id
        and t.term_desc like '%2007%'), 0, 0, 1)) >= 3;

--11
select distinct t.term_desc 
from term t
join course_section cs on t.term_id = cs.term_id
join course c on cs.course_no = c.course_no

where cs.sec_num in 
(select max(cs.sec_num) 
from course_section cs
join course c on cs.course_no = c.course_no
where c.course_name like ('%Database%'));

--12
select e.grade, count(distinct s.s_id) as nr_aparitii
from student s
join enrollment e on s.s_id = e.s_id

group by e.grade
having count(distinct s.s_id) = 
(select max(count(distinct s.s_id))
from student s, enrollment e
where s.s_id = e.s_id

group by e.grade
having e.grade is not null);

--13
select term_desc, count(c.course_no) as "NR_MAT"
from term t
join course_section cs on t.term_id = cs.term_id
join course c on c.course_no = cs.course_no
where c.credits = 3

group by t.term_desc
having count (c.course_no) = 
(select max(count(c.course_no))
from term t
join course_section cs on t.term_id = cs.term_id
join course c on c.course_no = cs.course_no
where c.credits = 3
group by t.term_desc);

--14
select loc_id
from location l

where exists (select *
from course_section cs 
join course c on c.course_no = cs.course_no 
where loc_id = l.loc_id and course_name like '%C++%')

and exists (select *
from course_section cs 
join course c on c.course_no = cs.course_no 
where loc_id = l.loc_id and course_name like '%Database%');

--15
select bldg_code
from location
group by bldg_code
having count(loc_id) = 1;