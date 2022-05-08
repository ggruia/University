/*
drop table predare;
drop table nota;
drop table sala;
drop table locatie;
drop table curs;
drop table materie;
drop table student;
drop table grupa;
drop table angajat;
drop table proiect;
drop table departament;
drop table job;
*/

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';


-- crearea si popularea tabelei JOB
create table JOB(
ID number(4), primary key(ID),
denumire VARCHAR2(15),
salariu NUMBER(6));

create sequence IDs
start with 1
increment by 1
minvalue 0
maxvalue 9999
nocycle;

insert into JOB values(IDs.nextval, 'Proiectant', 5000);
insert into JOB values(IDs.nextval, 'Profesor', 4100);
insert into JOB values(IDs.nextval, 'Manager', 7300);
insert into JOB values(IDs.nextval, 'Asistent', 2200);
insert into JOB values(IDs.nextval, 'Furnizor', 3500);

drop sequence IDs;


-- crearea si popularea tabelei DEPARTAMENT
create table DEPARTAMENT(
denumire varchar2(15), primary key(denumire),
ID_director number(4),
tip varchar2(10));

insert into DEPARTAMENT values('Confectii', 5, 'Productie');
insert into DEPARTAMENT values('Machete', 4, 'Productie');
insert into DEPARTAMENT values('Planse', 7, 'Cercetare');
insert into DEPARTAMENT values('Software', 1, 'Cercetare');
insert into DEPARTAMENT values('Asezari', 2, 'Cercetare');

-- crearea si popularea tabelei PROIECT
create table PROIECT(
ID number(6), primary key(ID),
denumire varchar2(30),
data_inceput date,
data_final date,
departament varchar2(15),
pret float(2),
foreign key(departament) references DEPARTAMENT(denumire));

create sequence IDs
start with 1
increment by 1
minvalue 0
maxvalue 999999
nocycle;

insert into PROIECT values(IDs.nextval, 'Restaurare Castel', '10-03-2019', '18-03-2019', 'Planse', 450.00);
insert into PROIECT values(IDs.nextval, 'Macheta Residence', '21-05-2021', null, 'Machete', 1800.00);
insert into PROIECT values(IDs.nextval, 'Colaj Ateneul Roman', '07-07-2020', '02-03-2021', 'Asezari', 300.00);
insert into PROIECT values(IDs.nextval, 'Casa lui Mos-Martin', '01-04-2021', null, 'Machete', 2500.00);
insert into PROIECT values(IDs.nextval, 'Eficientizare AutoCad', '13-04-2021', '14-04-2021', 'Software', 135.00);

drop sequence IDs;


-- crearea si popularea tabelei ANGAJAT
create table ANGAJAT(
ID number(4), primary key(ID),
nume varchar2(15),
prenume varchar2(15),
data_angajare date,
ID_director number(4),
departament varchar2(15),
ID_job number(4),
foreign key(ID_director) references ANGAJAT(ID),
foreign key(departament) references DEPARTAMENT(denumire),
foreign key(ID_job) references JOB(ID));

create sequence IDs
start with 1
increment by 1
minvalue 0
maxvalue 9999
nocycle;

insert into ANGAJAT values(IDs.nextval, 'Neagu', 'Alexandra-Ioana', '22-12-2015', null, 'Asezari', 3);
insert into ANGAJAT values(IDs.nextval, 'Anton', 'Mihai-Cosmin', '17-11-2014', 1, 'Software', 1);
insert into ANGAJAT values(IDs.nextval, 'Dima', 'Carol-Valentin', '13-01-2016', 1, null, 2);
insert into ANGAJAT values(IDs.nextval, 'Florea', 'Irina', '26-12-2019', 1, 'Confectii', 4);
insert into ANGAJAT values(IDs.nextval, 'Benescu', 'Ioan', '02-02-2020', 1, 'Planse', 4);
insert into ANGAJAT values(IDs.nextval, 'Gruia', 'Gabriel', '27-06-2019', 1, null, 2);
insert into ANGAJAT values(IDs.nextval, 'Dragulescu', 'Raluca', '02-08-2016', 4, 'Machete', 5);

drop sequence IDs;


-- crearea si popularea tabelei GRUPA
create table GRUPA(
ID number(4), primary key(ID),
an_studiu number(1),
specializare varchar2(15));

create sequence IDs
start with 1
increment by 1
minvalue 0
maxvalue 9999
nocycle;

insert into GRUPA values(IDs.nextval, 3, 'Urbanism');
insert into GRUPA values(IDs.nextval, 1, 'Arhitectura');
insert into GRUPA values(IDs.nextval, 2, 'Arhitectura');
insert into GRUPA values(IDs.nextval, 2, 'Interior');
insert into GRUPA values(IDs.nextval, 1, 'Urbanism');
insert into GRUPA values(IDs.nextval, 3, 'Arhitectura');

drop sequence IDs;


-- crearea si popularea tabelei STUDENT
create table STUDENT(
ID number(6), primary key(ID),
nume varchar2(15),
prenume varchar2(15),
nr_telefon varchar2(10),
email varchar2(30),
ID_grupa number(4),
ID_prof_coordonator number(4),
data_inrolare date,
an_studiu number(1),
foreign key(ID_grupa) references GRUPA(ID),
foreign key(ID_prof_coordonator) references ANGAJAT(ID));

create sequence IDs
start with 1
increment by 1
minvalue 0
maxvalue 999999
nocycle;

insert into STUDENT values(IDs.nextval, 'Giurgiuleanu', 'Matei', '0727835824', 'gmatei@yahoo.ro', 5, 3, '10-04-2019', 1);
insert into STUDENT values(IDs.nextval, 'Sotau', 'Marin', '0256207670', 'smarin@yahoo.ro', 1, 3, '27-04-2019', 3);
insert into STUDENT values(IDs.nextval, 'Robert', 'Ioan', '0235423932', 'rioan@yahoo.ro', 3, 6, '31-07-2020', 2);
insert into STUDENT values(IDs.nextval, 'Barbu', 'Matei', '0727333342', 'bmatei@yahoo.ro', 2, 3, '06-12-2020', 1);
insert into STUDENT values(IDs.nextval, 'Stefanescu', 'Bob', '0269559228', 'sbob@yahoo.ro', 2, 6, '28-09-2021', 1);
insert into STUDENT values(IDs.nextval, 'Paun', 'Cristinel', '0212520355', 'pcristinel@yahoo.ro', 6, 6, '06-11-2021', 3);
insert into STUDENT values(IDs.nextval, 'Bitulescu', 'Carol', '0214082820', 'bcarol@yahoo.ro', 1, 3, '20-08-2021', 3);
insert into STUDENT values(IDs.nextval, 'Popos', 'Florentin', '0740142399', 'pflorentin@yahoo.ro', 4, 3, '13-02-2021', 1);
insert into STUDENT values(IDs.nextval, 'Dobre', 'Marcel', '0721328241', 'dmarcel@yahoo.ro', 4, 3, '24-03-2020', 2);
insert into STUDENT values(IDs.nextval, 'Rosevilici', 'Teodor', '0744555788', 'rteodor@yahoo.ro', 2, 6, '19-07-2019', 1);

drop sequence IDs;


-- crearea si popularea tabelei MATERIE
create table MATERIE(
ID number(4), primary key(ID),
denumire varchar2(30),
numar_cursuri number(2));

create sequence IDs
start with 1
increment by 1
minvalue 0
maxvalue 9999
nocycle;

insert into MATERIE values(IDs.nextval, 'Studiul Formei', 8);
insert into MATERIE values(IDs.nextval, 'Istoria Asezarilor in Europa', 8);
insert into MATERIE values(IDs.nextval, 'Geometrie Descriptiva', 16);
insert into MATERIE values(IDs.nextval, 'Introducere in Arh. Cont.', 12);
insert into MATERIE values(IDs.nextval, 'Perspectiva', 16);
insert into MATERIE values(IDs.nextval, 'Limba Engleza', 4);

drop sequence IDs;


-- crearea si popularea tabelei CURS
create table CURS(
denumire varchar2(30), primary key(denumire),
numar_ore number(1),
ID_materie number(4),
credite number(1),
foreign key(ID_materie) references MATERIE(ID));

insert into CURS values('Cunoasterea Spatiului', 2, 1, 2);
insert into CURS values('Diagrame', 2, 1, 3);
insert into CURS values('Eseu Grafic', 4, 1, 2);
insert into CURS values('Substractie si Aditie', 2, 1, 3);
insert into CURS values('Elemente Teoretice', 1, 2, 2);
insert into CURS values('Orasul Antic', 1, 2, 2);
insert into CURS values('Orasul Medieval', 1, 2, 2);
insert into CURS values('Orasul Industrial', 1, 2, 2);
insert into CURS values('Umbre 2D', 2, 3, 4);
insert into CURS values('Axonometrie', 4, 3, 6);
insert into CURS values('Poliedre', 2, 3, 4);
insert into CURS values('Scari', 6, 3, 5);
insert into CURS values('Vernacular', 2, 4, 3);
insert into CURS values('Recuperarea Orasului', 1, 4, 2);
insert into CURS values('Arhitectul', 1, 4, 2);
insert into CURS values('Orasul Traditional', 1, 4, 2);
insert into CURS values('Sisteme de Proiectie', 4, 5, 5);
insert into CURS values('Perspectiva la Fuga', 2, 5, 4);
insert into CURS values('Trasarea Umbrelor', 4, 5, 6);
insert into CURS values('Perspectiva la Calculator', 2, 5, 4);
insert into CURS values('Past Tenses', 1, 6, 2);
insert into CURS values('Architectural Vocabulary', 2, 6, 3);
insert into CURS values('Useful Phrases', 2, 6, 2);


-- crearea si popularea tabelei LOCATIE
create table LOCATIE(
ID number(2), primary key(ID),
adresa varchar2(60),
suprafata number(6));

create sequence IDs
start with 1
increment by 1
minvalue 0
maxvalue 99
nocycle;

insert into LOCATIE values(IDs.nextval, 'str. Belindo, nr. 6', 12500);
insert into LOCATIE values(IDs.nextval, 'str. Aurie, nr. 7A', 1500);
insert into LOCATIE values(IDs.nextval, 'str. Teilor, nr. 4', 20300);
insert into LOCATIE values(IDs.nextval, 'str. Suspendata, nr. 2B', 780);
insert into LOCATIE values(IDs.nextval, 'str. Nikolas Vinz, nr. 11', 321400);

drop sequence IDs;


-- crearea si popularea tabelei SALA
create table SALA(
ID number(4), primary key(ID),
capacitate number(2),
ID_locatie number(2),
foreign key(ID_locatie) references LOCATIE(ID));

create sequence IDs
start with 1
increment by 1
minvalue 0
maxvalue 9999
nocycle;

insert into SALA values(IDs.nextval, 18, 1);
insert into SALA values(IDs.nextval, 10, 2);
insert into SALA values(IDs.nextval, 28, 4);
insert into SALA values(IDs.nextval, 70, 3);
insert into SALA values(IDs.nextval, 20, 5);
insert into SALA values(IDs.nextval, 80, 1);
insert into SALA values(IDs.nextval, 60, 4);

drop sequence IDs;


-- crearea si popularea tabelei NOTA
create table NOTA(
ID_student number(6),
denumire_curs varchar2(30),
primary key(ID_student, denumire_curs),
nota float(8),
data_obtinerii date,
foreign key(ID_student) references STUDENT(ID),
foreign key(denumire_curs) references CURS(denumire));

insert into NOTA values(1, 'Scari', 7.50, '12-06-2020');
insert into NOTA values(1, 'Axonometrie', 8.50, '13-07-2020');
insert into NOTA values(2, 'Poliedre', 9.50, '11-05-2019');
insert into NOTA values(2, 'Axonometrie', 9, '13-07-2019');
insert into NOTA values(3, 'Poliedre', 7, '13-07-2020');
insert into NOTA values(4, 'Poliedre', 6, '12-06-2020');
insert into NOTA values(4, 'Umbre 2D', 8.50, '11-05-2019');
insert into NOTA values(4, 'Orasul Traditional', 4.30, '11-05-2019');
insert into NOTA values(4, 'Arhitectul', 8.10, '13-07-2020');
insert into NOTA values(5, 'Poliedre', 7.20, '11-05-2019');
insert into NOTA values(5, 'Umbre 2D', 8.90, '12-06-2020');
insert into NOTA values(5, 'Orasul Traditional', 8.50, '11-05-2019');
insert into NOTA values(5, 'Arhitectul', 10, '13-07-2020');
insert into NOTA values(6, 'Arhitectul', 9, '11-05-2019');
insert into NOTA values(6, 'Vernacular', 6.50, '13-07-2020');
insert into NOTA values(7, 'Poliedre', 8.50, '11-05-2019');
insert into NOTA values(7, 'Axonometrie', 7.10, '12-06-2020');
insert into NOTA values(8, 'Arhitectul', 3.20, '12-06-2020');
insert into NOTA values(9, 'Arhitectul', 9.10, '11-05-2019');
insert into NOTA values(10, 'Poliedre', 5, '13-07-2020');
insert into NOTA values(10, 'Umbre 2D', 5, '11-05-2019');
insert into NOTA values(10, 'Orasul Traditional', 4, '12-06-2020');
insert into NOTA values(10, 'Arhitectul', 6, '13-07-2020');


-- crearea si popularea tabelei PREDARE
create table PREDARE(
ID_profesor number(4),
nume_curs varchar2(30),
ID_grupa number(4),
ID_sala number(4),
primary key(ID_profesor, nume_curs, ID_grupa, ID_sala),
foreign key(ID_profesor) references ANGAJAT(ID),
foreign key(nume_curs) references CURS(denumire),
foreign key(ID_grupa) references GRUPA(ID),
foreign key(ID_sala) references SALA(ID));

insert into PREDARE values(3, 'Poliedre', 1, 1);
insert into PREDARE values(3, 'Axonometrie', 1, 1);
insert into PREDARE values(3, 'Poliedre', 2, 2);
insert into PREDARE values(3, 'Scari', 5, 3);
insert into PREDARE values(3, 'Umbre 2D', 2, 3);
insert into PREDARE values(3, 'Poliedre', 3, 4);
insert into PREDARE values(3, 'Axonometrie', 5, 5);
insert into PREDARE values(6, 'Arhitectul', 4, 1);
insert into PREDARE values(6, 'Arhitectul', 6, 6);
insert into PREDARE values(6, 'Vernacular', 6, 3);
insert into PREDARE values(6, 'Orasul Traditional', 2, 6);
insert into PREDARE values(6, 'Arhitectul', 2, 2);
