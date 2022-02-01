import * as Entities from "./interfaces";


export const MOCK_MEMBERS: Entities.Member[] = [
    {
        id: '5fe24875-e4f4-48b8-a782-2786b3a87935',
        firstName: 'John',
        lastName: 'Smith',
        address: 'Baxter RD, N0. 5, Bl. 4',
        registrationDate: '12-06-2020'
    },
    {
        id: '292c6d57-9d83-4c88-bb0f-bf2c5d7bafdd',
        firstName: 'James',
        lastName: 'Cook',
        address: 'Abbey RD, No. 7A, Bl. 3',
        registrationDate: '09-10-2019'
    },
    {
        id: 'a7f811d9-e1e0-4782-84a9-8cec065431c6',
        firstName: 'Brenda',
        lastName: 'Kunst',
        address: 'Str. Westminster, No. 7, Bl. A2',
        registrationDate: '28-01-2022'
    }
];

export const MOCK_ASSOCIATIONS: Entities.Association[] = [
    {
        id: 'ASMI',
        name: 'Asociatia Studentilor in Matematica si Informatica',
        description: 'ASMI este asociatia reprezentativa la nivelul Facultatii de Matematica si Informatica a Universitatii din Bucuresti, organizata ca un ONG non-profit. In primul rand, reprezentam interesele si aspiratiile studentilor, dar nu ne limitam la atat.Alaturi de partenerii nostri realizam proiecte si activitati de interes pentru studenti, ce au ca scop dezvoltarea lor pe plan profesional, socio- cultural si personal.'
    },
    {
        id: 'ASCOR',
        name: 'Asociatia Studentilor Crestini Ortodocsi Romani',
        description: 'A.S.C.O.R. - Iasi s-a infiintat la 17 decembrie 1990 din initiativa unui grup de studenti de la Universitatea “Al. I. Cuza” si Universitatea Agronomica din Iasi, cu sprijinul si binecuvantarea Prea Fericirii Sale Daniel, Patriarhul Bisericii Ortodoxe Romane, pe atunci Mitropolitul Moldovei si Bucovinei, care este presedintele de onoare al A.S.C.O.R. Iasi. In prezent, A.S.C.O.R. - Iasi functioneaza cu binecuvantarea IPS Teofan, Mitropolitul Moldovei si Bucovinei. Scopul asociatiei este acela de promovare a credintei si spiritualitatii crestin-ortodoxe in randul tinerilor, cu prioritate in mediul universitar.'
    },
    {
        id: 'ASE',
        name: 'Asociatia Studentilor in Economie',
        description: 'Noi, Uniunea Studentilor Academiei de Studii Economice din Bucuresti, suntem echipa studentilor ce reprezinta interesele comune ale tuturor studentilor de la nivelul diverselor formatii, programe sau cicluri de studii ale Academiei de Studii Economice din Bucuresti si care se implica direct in dezvoltarea lor personala si profesionala. Printre valorile ASE se regasesc spiritul de initiativa, implicarea activa, voluntariatul, creativitatea, comunicarea, entuziasmul, devotamentul, solidaritatea, integritatea, profesionalismul si pasiunea. Consideram ca cel mai de pret bun al Uniunii este capitalul uman si de aceea te incurajam sa contribui la dezvoltarea comunitatii din care facem cu totii parte, prin intermediul ideilor si spiritului inovativ!'
    },
    {
        id: 'ASD',
        name: 'Asociatia Studentilor in Drept',
        description: 'Suntem o organizatie ce are ca scop reprezentarea tuturor studentilor Facultatii de Drept, Universitatea din Bucuresti si a intereselor lor, si, in acelasi timp, organizarea unor proiecte destinate studentilor, promovandu-le ideile. Astfel, cele doua planuri - reprezentarea si executivul se imbina in mod armonios intr-un singur nume: Asociatia Studentilor in Drept.'
    }
];

export const MOCK_COMMITEES: Entities.Commitee[] = [
    {
        id: '1',
        name: 'Management & Fundraising',
        associationId: 'ASMI',
        description: 'Principalul nostru obiectiv este sa imbunatatim conditiile in care decurg evenimentele asociatiei. Acest lucru il realizam prin supervizarea desfasurarii proiectelor ASMI si dezvoltarea acestora pe mai departe, dar si intrand in contact direct cu diverse firme (din domeniul IT si nu numai), cu care incheiem contracte de sponsorizare. Un alt lucru important pentru noi este feedback-ul, fiind mereu acolo ca sa ascultam ideile si sugestiile voluntarilor nostri. In perioada pandemiei, asociatia a continuat sa pastreze relatia cu mediul de afaceri, si a adus sponsorizari si oportunitati pentru studentii FMI. Ce castigi daca faci parte din acest departament? Abilitati de negociere, contact cu multi oameni din diverse companii pe care le poti fructifica dupa facultate si traininguri speciale (project management, Linkedin, fundraising). Simti ca ai idei originale si interesante? Iti place sa organizezi un eveniment pana la cel mai mic detaliu? Daca raspunsul la oricare din intrebarile acestea este da, departamentul Management & Fundraising este pentru tine!',
        inaugurationDate: '2019-04-17'
    },
    {
        id: '2',
        name: 'Design & PR',
        associationId: 'ASMI',
        description: 'Daca am putea descrie acest departament in doua cuvinte acelea sigur ar fi "imaginea asociatiei". Imagineaza-ti pentru cateva secunde cum ar arata un proiect fara afise, postari pe Facebook sau pe Instagram, de exemplu Recrutarile sau ce zici de o petrecere? Exact, informatia ar ajunge la mult mai putini oameni, sau cei care ar sti nu ar veni, deoarece nu i-a atras nimic auzind o informatie doar prin viu grai. De aceea, avem nevoie de mult ajutor din partea acestui departament pentru a transmite informatia intr-un mod cat mai placut si mai atragator. Te pricepi la photoshop/editare video/grafica? Ai talent la desen sau pur si simplu iti doresti sa inveti tot ce ti-am enumerat? Inseamna ca ai nimerit unde trebuie, la Design & PR iti poti dezvolta hard skillurile si poti sa ajuti la toate proiectele asociatiei!',
        inaugurationDate: '2019-10-22'
    },
    {
        id: '3',
        name: 'Educational',
        associationId: 'ASMI',
        description: 'Departamentul Educational are ca scop imbunatatirea calitatii vietii academice a studentilor, reprezentand o punte de legatura intre acestia si Conducerea Facultatii. Cu ce se ocupa mai exact Edu? Proiecte precum Admiterea, Tutoriate, Ziua Portilor Deschise, Ratusca si, mai recent, Practica sunt organizate de voluntarii nostri, care sunt motivati sa ajute studentii sa aiba o experienta a anilor de Facultate cat mai placuta. Membrii departamentului faciliteaza comunicarea cu Decanatul, invata public speaking, organizeaza evenimentele vitale desfasurarii anului universitar si lucreaza activ la identificarea si solutionarea problemelor studentesti. Deci, daca vrei sa-ti ajuti colegii, ti-ar placea sa ii reprezinti sau sa contribui la organizarea proiectelor care ii influenteaza pe plan academic, Edu este pentru tine!',
        inaugurationDate: '2019-06-14'
    },
    {
        id: '4',
        name: 'Human Resources',
        associationId: 'ASMI',
        description: 'Noi suntem, in cateva cuvinte, "inima asociatiei"! Ne ocupam de integrarea bobocilor ce ni se alatura in fiecare toamna si primavara, astfel incat ei sa ajunga sa se simta cu adevarat parte din familia noastra, dar si de bunastarea tuturor voluntarilor, prin organizarea de joculete interactive si de activitati de socializare. In timpul pandemiei, am adaptat aceste activitati de socializare in mediul online prin intermediul unor seri de jocuri sau de trivia. In plus, asiguram dezvoltarea si motivarea constanta a voluntarilor nostri. Asa ca, daca iti place sa comunici cu oamenii, sa organizezi activitati si sa ajuti persoane, departamentul de Resurse Umane este pentru tine!',
        inaugurationDate: '2020-03-11'
    },
    {
        id: '5',
        name: 'Management & Human Resources',
        associationId: 'ASE',
        description: 'Asociatia de Management este principala entitate de profil din Romania si una dintre cele mai prestigioase din cadrul Academiei de Studii Economice, beneficiind de un loc aparte in inima si in constiinta numeroaselor generatii care s-au format profesional si uman in cei aproape 100 de ani de existenta. Ca prima entitate universitara de profil din Romania, Facultatea de Management urmareste, printre scopurile fundamentale ale activitatii sale, furnizarea de specialisti foarte bine pregatiti in domeniul managerial, capabili sa isi dovedeasca expertiza de exceptie pe piata muncii.',
        inaugurationDate: '2020-06-15'
    },
    {
        id: '6',
        name: 'Educational',
        associationId: 'ASE',
        description: 'Este una dintre cele mai prestigioase facultati cu profil Economics din Europa, fiind alaturi de London School of Economics unul dintre putinele medii universitare unde se pot deprinde competente economice integrate, complexe, in urma studiului unor discipline de structura si rezistenta in formarea oricarui economist.',
        inaugurationDate: '2021-03-31'
    },
    {
        id: '7',
        name: 'Academic',
        associationId: 'ASD',
        description: 'ASD reprezinta interesele studentilor prin reprezentanti in Senatul Universitatii din Bucuresti, in Consiliul Facultatii, dar si in cadrul fiecarei serii. Prin proiectele pe care le desfasoara, ASD reuseste sa le ofere studentilor o experienta completa atat pe latura academica, cat si pe cea sociala.',
        inaugurationDate: '2021-06-15'
    }
];

export const MOCK_EVENTS: Entities.Event[] = [
    {
        id: '35aa0de6-ceac-4b87-ad6b-8350d9c98292',
        name: 'Event Rebel',
        commiteeId: '1',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        location: 'Iasi',
        startTime: '2019-08-23 14:00',
        endTime: '2019-08-24 12:00',
        isCanceled: false
    },
    {
        id: 'd9041fb6-479d-4839-a53b-f2b44a565f1a',
        name: 'Vintageer Events',
        commiteeId: '1',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        location: 'Sibiu',
        startTime: '2020-01-09 12:00',
        endTime: '2020-05-07 23:00',
        isCanceled: true
    },
    {
        id: 'a8dd82a3-bd00-499b-8d10-771a58358d92',
        name: 'Open Boat Fest',
        commiteeId: '1',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        location: 'Bucuresti',
        startTime: '2021-06-24 10:00',
        endTime: '2021-07-01 12:30',
        isCanceled: false
    },
    {
        id: 'c65b7911-193f-4535-9103-0b33fe1e3261',
        name: 'Chill Vibez Music',
        commiteeId: '2',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        location: 'Iasi',
        startTime: '2019-05-22 08:00',
        endTime: '2020-04-29 08:00',
        isCanceled: false
    },
    {
        id: 'ef2c3350-5baf-4f16-a61d-a453a7601364',
        name: 'Organicarden',
        commiteeId: '2',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        location: 'Bucuresti',
        startTime: '2019-04-19 10:00',
        endTime: '2021-11-27 12:00',
        isCanceled: true
    },
    {
        id: 'cb14d236-48cc-46e3-889b-67432839fa0d',
        name: 'Spread the Word',
        commiteeId: '3',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        location: 'Oradea',
        startTime: '2019-08-12 08:30',
        endTime: '2020-06-10 12:00',
        isCanceled: false
    },
    {
        id: '910d5589-d67f-44cc-a696-aa506515f03f',
        name: 'Xin Chao Food Festival',
        commiteeId: '1',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        location: 'Cluj',
        startTime: '2021-11-30 14:00',
        endTime: '2021-12-04 22:00',
        isCanceled: false
    },
    {
        id: '66d8c956-5daa-4a90-8960-38da2619fa1b',
        name: 'Craft Juice',
        commiteeId: '5',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        location: 'Arad',
        startTime: '2019-06-12 10:00',
        endTime: '2020-10-11 10:00',
        isCanceled: true
    },
    {
        id: '02e4e882-cea6-427c-8a3a-9300ed22a3fd',
        name: 'FestiVista',
        commiteeId: '5',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        location: 'Arad',
        startTime: '2021-01-17 12:00',
        endTime: '2021-06-03 12:00',
        isCanceled: false
    },
    {
        id: 'fa12ccba-97ef-4448-b121-d4a279d446a0',
        name: 'Beatnik Summer Festival',
        commiteeId: '5',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        location: 'Iasi',
        startTime: '2019-12-04 10:00',
        endTime: '2021-07-23 10:00',
        isCanceled: false
    },
    {
        id: 'cb4d5b3b-9411-4e82-9cf7-dc8ecf5a46a2',
        name: 'Seastar Fest',
        commiteeId: '7',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        location: 'Bucuresti',
        startTime: '2019-04-29 12:00',
        endTime: '2020-04-09 20:00',
        isCanceled: false
    },
    {
        id: '45af47f7-22e1-4e1b-b497-cd8c72d686a3',
        name: 'Summertime Sadness',
        commiteeId: '7',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        location: 'Bucuresti',
        startTime: '2019-05-06 08:30',
        endTime: '2021-02-04 08:30',
        isCanceled: false
    },
    {
        id: 'a0d00d5f-6e5d-4ec4-a2cd-e1227c365693',
        name: 'Music Dreamland',
        commiteeId: '4',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        location: 'Iasi',
        startTime: '2019-08-17 09:00',
        endTime: '2020-10-28 09:00',
        isCanceled: false
    },
    {
        id: '42ec709c-d9fe-45a3-aa61-be194a901caf',
        name: 'Boogie Paradise',
        commiteeId: '4',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        location: 'Bucuresti',
        startTime: '2019-10-06 10:00',
        endTime: '2021-02-04 20:00',
        isCanceled: false
    },
    {
        id: '482a9735-bc8b-48c5-8ffc-a7ec43a3faad',
        name: 'Gala Temple',
        commiteeId: '4',
        description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        location: 'Cluj',
        startTime: '2019-12-14 20:00',
        endTime: '2020-09-29 00:00',
        isCanceled: true
    }
];