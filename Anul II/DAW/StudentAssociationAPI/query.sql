insert into StudentAssociationDb.dbo.Associations values
	('ASMI', '<< Oameni obisnuiti >>  ~ Hadirca Dionisie'),
	('Asociatia Evanghelistilor', '<< Oameni evlaviosi >>  ~ Hadirca Dionisie'),
	('AS Stiinte Aplicate', '<< Nu cunosc acesti oameni >>  ~ Hadirca Dionisie'),
	('Asociatia Fizicienilor Romani', '<< Daca ai avea FaceBook ai sti >>  ~ Hadirca Dionisie');

insert into StudentAssociationDb.dbo.Commitees values
	('1', 'Management & Fundraising', 'ASMI', '2019-10-07', 'Principalul nostru obiectiv este sa imbunatatim conditiile in care decurg evenimentele asociatiei. Acest lucru il realizam prin supervizarea desfasurarii proiectelor ASMI si dezvoltarea acestora pe mai departe, dar si intrand in contact direct cu diverse firme (din domeniul IT si nu numai), cu care incheiem contracte de sponsorizare.'),
	('2', 'Design & PR', 'ASMI', '2016-06-23', 'Daca am putea descrie acest departament in doua cuvinte acelea sigur ar fi "imaginea asociatiei". Imagineaza-ti pentru cateva secunde cum ar arata un proiect fara afise, postari pe Facebook sau pe Instagram, de exemplu Recrutarile sau ce zici de o petrecere? Exact, informatia ar ajunge la mult mai putini oameni, sau cei care ar sti nu ar veni, deoarece nu i-a atras nimic auzind o informatie doar prin viu grai.'),
	('3', 'Educational', 'ASMI', '2017-01-25', 'Departamentul Educational are ca scop imbunatatirea calitatii vietii academice a studentilor, reprezentand o punte de legatura intre acestia si Conducerea Facultatii. Cu ce se ocupa mai exact Edu? Proiecte precum Admiterea, Tutoriate, Ziua Portilor Deschise, Ratusca si, mai recent, Practica sunt organizate de voluntarii nostri, care sunt motivati sa ajute studentii sa aiba o experienta a anilor de Facultate cat mai placuta.'),
	('4', 'Human Resources', 'ASMI', '2016-07-21', 'Noi suntem, in cateva cuvinte, "inima asociatiei"! Ne ocupam de integrarea bobocilor ce ni se alatura in fiecare toamna si primavara, astfel incat ei sa ajunga sa se simta cu adevarat parte din familia noastra, dar si de bunastarea tuturor voluntarilor, prin organizarea de joculete interactive si de activitati de socializare.'),
	('5', 'Planner', 'AS Stiinte Aplicate', '2020-09-10', 'In cadrul acestui comitet are loc un mix de energie, originalitate si motivatie, conferit de prezenta si implicarea tinerilor. Datorita acestora, ideea de comunitate capata noi valente.'),
	('6', 'RIUF', 'AS Stiinte Aplicate', '2021-05-05', 'RIUF - The Romanian International University Fair, cel mai mare eveniment educational, international de universitati din Europa de Sud Est este locul in care peste 220.000 de elevi, studenti, profesori si parinti au discutat cu reprezentantii din peste 150 de universitati din intreaga lume.');

insert into StudentAssociationDb.dbo.AssociationMemberships values
	('bd4cc4f9-d5df-4210-b8e3-90bae3d56f7d', '75aba1be-399a-44d4-987f-79b1cb18c342', 'ASMI', '2016-03-12'),
	('ab3a6dde-b044-4cca-9d6f-d1b08f8dbaf6', 'd24ffd0d-f292-4a30-b60d-706e293ce5a8', 'ASMI', '2017-12-03'),
	('d59aa6f0-ef22-49ee-9d8d-4803d73f8223', 'f85f832c-d791-4979-ac35-a70d88c1bd5d', 'ASMI', '2018-03-26'),
	('40c921f8-6b2b-44fe-be1c-f507a007cae4', 'f3458426-cebd-4bb0-b30c-a7ba838236bf', 'ASMI', '2016-08-30'),
	('6f2e3887-cf4a-4c2a-ac23-e8cd963d1665', 'f85f832c-d791-4979-ac35-a70d88c1bd5d', 'AS Stiinte Aplicate', '2020-11-30'),
	('70b82bc6-74a3-49b3-9407-b4650610643f', 'd24ffd0d-f292-4a30-b60d-706e293ce5a8', 'AS Stiinte Aplicate', '2020-07-19');

insert into StudentAssociationDb.dbo.BoardMemberships values
	('1', 'f85f832c-d791-4979-ac35-a70d88c1bd5d', 'ASMI', '2021-12-10'),
	('2', 'f3458426-cebd-4bb0-b30c-a7ba838236bf', 'ASMI', '2021-10-19'),
	('3', 'd24ffd0d-f292-4a30-b60d-706e293ce5a8', 'AS Stiinte Aplicate', '2022-01-13');


insert into StudentAssociationDb.dbo.AspNetRoles values
	('1', 'Admin', 'ADMIN', null),
	('2', 'User', 'USER', null);

insert into StudentAssociationDb.dbo.AssociationMemberships values
	('3dc48fb8-656b-46df-afab-b7a232ddbe48', '8de44728-5f72-4a30-9119-b0006bdac12a', 'ASMI', '2022-01-21 15:00:58.7443404');

select * from StudentAssociationDb.dbo.AspNetUserRoles;