from random import seed, choice
seed(1)

class Elev:
    currentUnnamed = 0
    currentHour = 9

    def __repr__(self):
        student = (self.nume, self.sanatate, self.inteligenta, self.oboseala, self.bunaDispozitie)
        return(str(student))

    def __init__(self, nume=None, sanatate=90, inteligenta=20, oboseala=0, bunaDispozitie=100):
        self.nume = nume
        if nume is None:
            __class__.currentUnnamed += 1
            self.nume = 'Necunoscut_{count}'.format(count = __class__.currentUnnamed)
        self.sanatate = sanatate
        self.inteligenta = inteligenta
        self.oboseala = oboseala
        self.bunaDispozitie = bunaDispozitie
        self.activitateCurenta = None
        self.timpExecutatActivitati = {}
    
    def desfasoaraActivitate(self, activitate):
        self.activitateCurenta = activitate
        self.timpExecutatActivitati = 0
    
    def treceOra(self):
        self.timpExecutatActivitati += 1
        return False if self.timpExecutatActivitati == self.activitateCurenta.durata else True
    
    def testeazaFinal(self):
        return True if self.inteligenta == 100 or self.sanatate == 0 or self.bunaDispozitie == 0 else False

    def afiseazaRaport(self):
        sir = self.nume + '\n'
        for i in self.timpExecutatActivitati:
            sir += (i + ':' + str(self.timpExecutatActivitati[i]) + '\n')
        return sir



class Activitate:
    def __repr__(self):
        activity = (self.nume, self.factor_sanatate, self.factor_inteligenta, self.factor_oboseala, self.factor_dispozitie, self.durata)
        return(str(activity))

    def __init__(self, nume, factor_sanatate, factor_inteligenta, factor_oboseala, factor_dispozitie, durata):
        self.nume = nume
        self.factor_sanatate = factor_sanatate
        self.factor_inteligenta = factor_inteligenta
        self.factor_oboseala = factor_oboseala
        self.factor_dispozitie = factor_dispozitie
        self.durata = durata



def pornesteSimulare(listaStudenti, listaActivitati):
    oraCurenta = 9

    while True:
        final = False

        print(listaStudenti)

        comanda = input()
        
        if comanda == 'gata':
            break

        if comanda == 'continua':
            while listaStudenti:
                for student in listaStudenti:
                    if student.activitateCurenta is None:
                        student.activitateCurenta = choice(listaActivitati)
                    student.treceOra()
                oraCurenta += 1

                for student in listaStudenti:
                    if student.testeazaFinal():
                        print(student)
                        if student.inteligenta == 100:
                            print('Elevul a terminat scoala')
                        if student.sanatate <= 0 or student.oboseala <= 0:
                            print('Elevul a ajuns la spital')
                        listaStudenti.remove(student)
        
        if comanda.isnumeric():
            for _ in range(int(comanda)):
                for student in listaStudenti:
                    if student.treceOra():
                        print(student.nume, student.activitateCurenta.nume, student.afiseazaRaport())
                oraCurenta += 1
        
        if final == True:
            print('Simularea s-a incheiat!')
            break

        




activitati = []
with open('activitati.txt') as fa:
    for line in fa:
        row = line.strip().split()
        activitati.append(Activitate(*row))

elevi = [Elev(), Elev(), Elev('John', 5, 10, 7, 3), Elev('Mark', 2, 1, 3, 9), Elev()]

print(elevi)
print(activitati)

pornesteSimulare()