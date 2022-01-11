
----- Cerintele 11-16 -----


--- 11

--1. Afisati ce materii preda fiecare profesor angajat, in ordine alfabetica a numelor si a materiilor.
select distinct a.nume || ' ' || a.prenume as "PROFESOR", m.denumire
from job j
join angajat a on j.id = a.id_job
join predare p on p.id_profesor = a.id
join curs c on p.nume_curs = c.denumire
join materie m on m.id = c.id_materie
where j.denumire = 'Profesor'
order by profesor, m.denumire;


--2. Afisati numarul de credite obtinute de fiecare student al carui nume incepe cu literele 'B' sau 'R';
select s.nume || ' ' || s.prenume as "STUDENT", sum(c.credite) as "TOTAL_CREDITE"
from student s
join nota n on n.id_student = s.id
join curs c on n.denumire_curs = c.denumire
where n.nota >= 5
group by s.nume || ' ' || s.prenume
having s.nume || ' ' || s.prenume like 'B%' or s.nume || ' ' || s.prenume like 'R%'
order by total_credite;


--3. Afisati angajatii care nu au finalizat vreun proiect, departamentul si jobul lor.
select distinct a.nume || ' ' || a.prenume as "ANGAJAT", nvl(d.denumire, 'CATEDRA') as "DEPARTAMENT", j.denumire as "JOB"
from angajat a
left join departament d on a.departament = d.denumire
left join job j on a.id_job = j.id
left join proiect p on p.departament = d.denumire
where p.data_final is null
or d.denumire is null
or (select to_date(a.data_angajare) - to_date(p.data_inceput) as datediff from dual) > 0;


--4. Afisati cati studenti coordoneaza fiecare profesor al carui prenume se termina cu 'N'
with coordonatori as(
select a.id
from angajat a
join job j on a.id_job = j.id
where j.denumire = 'Profesor')

select a.nume || ' ' || a.prenume as "PROFESOR", count(s.id_prof_coordonator) as "NR_COORDONATI"
from angajat a
join student s on a.id = s.id_prof_coordonator
where a.id in (select * from coordonatori)
and substr(a.prenume, -1) = 'n'
group by a.nume || ' ' || a.prenume;


--5. Cresteti salariul angajatilor din 2014 cu 60%, al celor din 2015 cu 40%, iar al celor din 2016 cu 20% si plasati-i in potentiale categorii de plata.
with salariu_modificat as(
select a.id as "ID", decode(to_char(a.data_angajare, 'YYYY'), 2014, j.salariu*1.6, 2015, j.salariu*1.4, 2016, j.salariu*1.2, j.salariu) as "SM"
from angajat a
join job j on a.id_job = j.id)

select a.nume || ' ' || a.prenume as "ANGAJAT", b.sm,
(select
case
when (k.sm between 2200 and 3499) then 'Asistent'
when (k.sm between 3500 and 4099) then 'Furnizor'
when (k.sm between 4100 and 4999) then 'Profesor'
when (k.sm between 5000 and 7299) then 'Proiectant'
else 'Manager'
end
from salariu_modificat k
where k.id = a.id) as "ROL_POTENTIAL"
from angajat a
join job j on a.id_job = j.id
join salariu_modificat b on a.id = b.id;


--- 12

-- updatati studentii astfel incat e-mailul sa fie de forma 'nume.prenume@yahoo.ro'
update STUDENT s
set s.email = (select concat(concat(lower(substr(nume, 1, 3)), '.'), concat(lower(prenume), '@yahoo.ro')) from student where s.id = id);
rollback;

-- stergeti salile in care nu s-au tinut cursuri
delete from SALA
where id not in (select id_sala from PREDARE);
rollback;

-- stergeti notele mai mici decat media notelor
delete from NOTA
where nota < (select avg(nota) from NOTA);
rollback;


--- 13

-- Secventa folosita pentru generarea ID-urilor:

create sequence IDs
start with 1
increment by 1
minvalue 0
maxvalue 9999
nocycle;

drop sequence IDs;


--- 16

-- OUTER JOIN

--1. Afisati studentul si nota obtinuta la fiecare curs de la fiecare materie, in cazul in care nu exista, afisati (null)
select m.denumire as "MATERIE", c.denumire as "CURS", s.nume, n.nota
from materie m
full outer join curs c on m.id = c.id_materie
full outer join nota n on n.denumire_curs = c.denumire
full outer join student s on n.id_student = s.id;


-- DIVISION

--1. Afisati profesorii care au predat toate cursurile aferente unei materii
select distinct a.nume || ' ' || a.prenume as "PROFESOR", m.denumire as "MATERIE"
from angajat a
join job j on a.id_job = j.id
join predare p on p.id_profesor = a.id
join curs c on c.denumire = p.nume_curs
join materie m on m.id = c.id_materie
where j.denumire = 'Profesor'

and m.id not in(
select id_materie from curs cc
where cc.denumire not in(
select nume_curs from predare));

--2. Afisati locatiile in care au fost predate cursuri in toate salile din acea locatie
select l.id
from locatie l
where l.id not in(
select id_locatie from sala s
where s.id not in(
select id_sala from predare));
