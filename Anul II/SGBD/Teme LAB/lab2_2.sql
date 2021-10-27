-- 10
select m.first_name || ' ' || m.last_name as "NUME", r.copy_id "ID COPIE", t.title "TITLU", count(t.title_id) "NR. IMPRUMUTURI"
from member m
join rental r on r.member_id = m.member_id
join title_copy c on c.copy_id = r.copy_id and c.title_id = r.title_id
join title t on t.title_id = c.title_id
group by m.last_name, m.first_name || ' ' || m.last_name, m.first_name, r.copy_id, t.title, t.title_id
order by m.last_name, m.first_name, t.title;

-- 12
-- a
-- nu stiu sa aleg si sa afisez coloane fara date valide

-- b
select book_date, count(*) as "Imprumuturi"
from rental 
where extract(month from book_date) = extract(month from SYSDATE) - 1   -- observ ca toate entry-urile sunt din septembrie, asa ca pentru siguranta ca functioneaza query-ul, am comparat cu septembrie
group by book_date 
order by book_date asc;

-- c
-- nu stiu sa aleg si sa afisez coloane fara date valide; the SQL-query strikes back