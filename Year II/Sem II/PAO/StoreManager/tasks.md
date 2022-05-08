# PAO Project

## Shop Stocks Manager

---


### Stage I

1. Definirea sistemului:

   Să se creeze liste pe baza temei alese cu:
   - [X] cel puțin 10 acțiuni / interogări care se pot face în cadrul sistemului;
   - [X] 8 tipuri de obiecte.


2. Implementare:

   Sa se implementeze în limbajul Java o aplicație ce va conține:
   - [X] clase simple cu atribute private / protected și metode de acces;
   - [X] cel puțin 2 colecții diferite capabile să gestioneze obiectele definite anterior (eg: List, Set, Map, etc.) dintre care cel puțin una sa fie sortata –
   se vor folosi array-uri uni/ bidimensionale în cazul în care nu se parcurg colectiile pana la data checkpoint-ului;
   - [X] utilizare moștenire pentru crearea de clase adiționale și utilizarea lor încadrul colecțiilor;
   - [X] cel puțin o clasă serviciu care sa expună operațiile sistemului;
   - [X] o clasa Main din care sunt făcute apeluri către servicii.



### Stage II

1. Extindeți proiectul din prima etapa prin realizarea persistentei utilizând fișiere:
   - [X] Se vor realiza fișiere de tip CSV pentru cel puțin 4 dintre clasele definite în prima etapa;
   - [X] Fiecare coloana din fișier este separata de virgula;
   Exemplu: nume, prenume, varsta
   - [X] Se vor realiza servicii singleton generice pentru scrierea și citirea din fișiere;
   - [X] La pornirea programului se vor încărca datele din fișiere utilizând serviciile create.


2. Realizarea unui serviciu de audit:
   - [X] Se va realiza un serviciu care sa scrie într-un fișier de tip CSV de fiecare data când este executată una dintre acțiunile descrise în prima etapa;
   - [X] Structura fișierului: nume actiune, timestamp.



### Stage III

- [X] Înlocuiți serviciile realizate în etapa a II-a cu servicii care sa asigure persistenta folosind JDBC.
- [X] Să se realizeze servicii care sa expună operații CRUD pentru cel puțin 4 dintre clasele definite.

---


### Gestiune Stocuri Magazin:
   - categorii
   - produse
   - distribuitori