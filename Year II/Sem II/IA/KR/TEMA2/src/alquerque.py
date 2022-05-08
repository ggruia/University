import time
import pygame
import sys
import math
import statistics


def distance(p0, p1):
    (x0, y0) = p0
    (x1, y1) = p1
    return math.sqrt((x0 - x1) ** 2 + (y0 - y1) ** 2)


class Joc:
    """
    clasa care defineste jocul, in acest caz 
    """
    JMIN = None
    JMAX = None
    GOL = '#'

    noduri = [
        (0, 0), (0, 1), (0, 2), (0, 3), (0, 4),
        (1, 0), (1, 1), (1, 2), (1, 3), (1, 4),
        (2, 0), (2, 1), (2, 2), (2, 3), (2, 4),
        (3, 0), (3, 1), (3, 2), (3, 3), (3, 4),
        (4, 0), (4, 1), (4, 2), (4, 3), (4, 4)
    ]

    muchii = [  # horizontal lines
                (0, 1), (1, 2), (2, 3), (3, 4),  
                (5, 6), (6, 7), (7, 8), (8, 9),
                (10, 11), (11, 12), (12, 13), (13, 14),
                (15, 16), (16, 17), (17, 18), (18, 19),
                (20, 21), (21, 22), (22, 23), (23, 24),
                # verticle lines
                (0, 5), (5, 10), (10, 15), (15, 20),  
                (1, 6), (6, 11), (11, 16), (16, 21),
                (2, 7), (7, 12), (12, 17), (17, 22),
                (3, 8), (8, 13), (13, 18), (18, 23),
                (4, 9), (9, 14), (14, 19), (19, 24),
                # diagonal lines
                (0, 6), (6, 10), (10, 16), (16, 20),  
                (2, 6), (6, 12), (12, 16), (16, 22),
                (2, 8), (8, 12), (12, 18), (18, 22),
                (4, 8), (8, 14), (14, 18), (18, 24)
    ]

    scalare = 120
    translatie = 60
    raza_pct = 20
    raza_piesa = 50


    def __init__(self, piese_albe=None, piese_negre=None, capturat = False, nod_piesa_selectata = None):
        self.capturat = capturat
        self.coordonate_noduri = [[self.translatie + self.scalare * x for x in nod] for nod in self.noduri]
        self.nod_piesa_selectata = nod_piesa_selectata

        if piese_albe is None:
            self.piese_albe = [
            self.coordonate_noduri[3], self.coordonate_noduri[4],
            self.coordonate_noduri[8], self.coordonate_noduri[9],
            self.coordonate_noduri[13], self.coordonate_noduri[14],
            self.coordonate_noduri[17], self.coordonate_noduri[18], self.coordonate_noduri[19],
            self.coordonate_noduri[22], self.coordonate_noduri[23], self.coordonate_noduri[24]
        ]
        else:
            self.piese_albe = piese_albe

        if piese_negre is None:
            self.piese_negre = [
            self.coordonate_noduri[0], self.coordonate_noduri[1], self.coordonate_noduri[2],
            self.coordonate_noduri[5], self.coordonate_noduri[6], self.coordonate_noduri[7],
            self.coordonate_noduri[10], self.coordonate_noduri[11],
            self.coordonate_noduri[15], self.coordonate_noduri[16],
            self.coordonate_noduri[20], self.coordonate_noduri[21]
        ]
        else:
            self.piese_negre = piese_negre


    @classmethod
    def initializeaza(cls, display):
        """
        initializarea jocului
        """
        cls.display = display
        cls.diametru_piesa = 2 * cls.raza_piesa

        cls.piesa_alba = pygame.image.load('imagesAlquerque/piesa_alba.png')
        cls.piesa_alba = pygame.transform.scale(cls.piesa_alba, (cls.diametru_piesa, cls.diametru_piesa))

        cls.piesa_neagra = pygame.image.load('imagesAlquerque/piesa_neagra.png')
        cls.piesa_neagra = pygame.transform.scale(cls.piesa_neagra, (cls.diametru_piesa, cls.diametru_piesa))

        cls.piesa_selectata = pygame.image.load('imagesAlquerque/piesa_albastra.png')
        cls.piesa_selectata = pygame.transform.scale(cls.piesa_selectata, (cls.diametru_piesa, cls.diametru_piesa))

        cls.piesa_rosie = pygame.image.load('imagesAlquerque/piesa_rosie.png')
        cls.piesa_rosie = pygame.transform.scale(cls.piesa_rosie, (cls.diametru_piesa, cls.diametru_piesa))

        cls.piesa_verde = pygame.image.load('imagesAlquerque/piesa_verde.png')
        cls.piesa_verde = pygame.transform.scale(cls.piesa_verde, (cls.diametru_piesa, cls.diametru_piesa))

        cls.piesa_mov = pygame.image.load('imagesAlquerque/piesa_mov.png')
        cls.piesa_mov = pygame.transform.scale(cls.piesa_mov, (cls.diametru_piesa, cls.diametru_piesa))

        cls.culoare_ecran = (220, 220, 220)
        cls.culoare_linii = (70, 70, 70)

        cls.coordonate_noduri = [[cls.translatie + cls.scalare * x for x in nod] for nod in cls.noduri]


    def deseneaza_grid(self, jucator=None, marcaj=None):
        """
        desenarea gridului
        """
        self.display.fill(self.culoare_ecran)

        for nod in self.coordonate_noduri:
            pygame.draw.circle(surface=self.display, color=self.culoare_linii, center=nod, radius=self.raza_pct, width=0)  # width=0 face un cerc plin

        for muchie in self.muchii:
            p0 = self.coordonate_noduri[muchie[0]]
            p1 = self.coordonate_noduri[muchie[1]]
            pygame.draw.line(surface=self.display, color=self.culoare_linii, start_pos=p0, end_pos=p1, width=5)

        for nod in self.piese_albe:
            self.display.blit(self.piesa_alba, (nod[0] - self.raza_piesa, nod[1] - self.raza_piesa))

        for nod in self.piese_negre:
            self.display.blit(self.piesa_neagra, (nod[0] - self.raza_piesa, nod[1] - self.raza_piesa))

        if jucator is not None:
            piese_ce_pot_captura = self.noduri_captura(jucator)

            for nod in piese_ce_pot_captura:
                self.display.blit(self.piesa_mov, (nod[0] - self.raza_piesa, nod[1] - self.raza_piesa))

        if self.nod_piesa_selectata:
            self.display.blit(self.piesa_selectata, (self.nod_piesa_selectata[0] - self.raza_piesa, self.nod_piesa_selectata[1] - self.raza_piesa))

            if self.nod_piesa_selectata in self.piese_albe:
                noduri_invalide, noduri_valide = self.mutari_posibile(self.nod_piesa_selectata, 'albe')
            else:
                noduri_invalide, noduri_valide = self.mutari_posibile(self.nod_piesa_selectata, 'negre')

            for nod in noduri_valide:
                self.display.blit(self.piesa_verde, (nod[0] - self.raza_piesa, nod[1] - self.raza_piesa)) 

            if len(noduri_valide):
                for nod in noduri_invalide:
                    self.display.blit(self.piesa_rosie, (nod[0] - self.raza_piesa, nod[1] - self.raza_piesa))
            
            else:
                for nod in noduri_invalide:
                    self.display.blit(self.piesa_verde, (nod[0] - self.raza_piesa, nod[1] - self.raza_piesa))


        pygame.display.flip()
        # pygame.display.update()


    @classmethod
    def jucator_opus(cls, jucator):
        return cls.JMAX if jucator == cls.JMIN else cls.JMIN


    def pot_muta(self, piesa, jucator):
        """
        returnez daca pot muta piesa actuala
        """
        # daca pot muta pe vecini
        index = self.coordonate_noduri.index(piesa)

        piese_jucator = self.piese_albe
        piese_adversar = self.piese_negre

        if jucator == 'negre':
            piese_jucator, piese_adversar = piese_adversar, piese_jucator

        for i in [index - 6, index - 5, index - 4, index - 1, index + 1, index + 4, index + 5, index + 6]:
            # verific daca este in grid
            if 0 <= i < 25:
                loc = self.coordonate_noduri[i]

                if (index, i) in self.muchii or (i, index) in self.muchii:
                    if loc not in self.piese_albe and loc not in self.piese_negre:
                        return True

        # daca captura o piesa
        for i in [-12, -10, -8, -2, 2, 8, 10, 12]:
            mij = int(index + i / 2)
            varf = index + i

            if 0 <= mij < 25 and 0 <= varf < 25 and self.e_muchie(index, mij) and self.e_muchie(mij, varf):
                if self.coordonate_noduri[mij] in piese_adversar and self.coordonate_noduri[varf] not in piese_adversar + piese_jucator:
                    return True

        return False


    def mutari_posibile(self, piesa, jucator):
        """
        returnez mutarile posibile, o lista de miscari invalide si una de valide
        """
        # listele ce o sa fie returnate
        noduri_valide = []
        noduri_invalide = []

        # daca pot muta pe vecini
        index = self.coordonate_noduri.index(piesa)

        piese_jucator = self.piese_albe
        piese_adversar = self.piese_negre

        if jucator == 'negre':
            piese_jucator, piese_adversar = piese_adversar, piese_jucator

        for i in [index - 6, index - 5, index - 4, index - 1, index + 1, index + 4, index + 5, index + 6]:
            # verific daca este in grid
            if 0 <= i < 25:
                loc = self.coordonate_noduri[i]

                if (index, i) in self.muchii or (i, index) in self.muchii:
                    if loc not in self.piese_albe and loc not in self.piese_negre:
                        noduri_invalide.append(loc)

        # daca captura o piesa
        for i in [-12, -10, -8, -2, 2, 8, 10, 12]:
            mij = int(index + i / 2)
            varf = index + i

            if 0 <= mij < 25 and 0 <= varf < 25 and self.e_muchie(index, mij) and self.e_muchie(mij, varf):
                if self.coordonate_noduri[mij] in piese_adversar and self.coordonate_noduri[varf] not in piese_adversar + piese_jucator:
                    noduri_valide.append(self.coordonate_noduri[varf])

        return noduri_invalide, noduri_valide


    def noduri_captura(self, jucator):
        # initializam lista de piese ale jucatorului si ale adversarului
        lista_capturatori = []
        piese_jucator = self.piese_albe
        piese_adversar = self.piese_negre

        # daca jucatorul joaca cu negre schimbam piesele intre ele
        if jucator == 'negre':
            piese_jucator, piese_adversar = piese_adversar, piese_jucator

        for piesa in piese_jucator: 
            # am preluat indexul din lista
            index = self.coordonate_noduri.index(piesa) 
            
            # pentru fiecare pozitie peste acre as putea sari
            for i in [-12, -10, -8, -2, 2, 8, 10, 12]: 
                # am determinat nodul peste care trec
                mij = int(index + i/2) 

                # am determinat nodul unde sar
                varf = index + i 

                # verificam sa fie in grid si locul liber si muchie existenta
                if 0 <= mij < 25 and 0 <= varf < 25 and self.e_muchie(index, mij) and self.e_muchie(mij, varf):
                    if self.coordonate_noduri[mij] in piese_adversar and self.coordonate_noduri[varf] not in piese_adversar + piese_jucator:
                        lista_capturatori.append(piesa)

        return lista_capturatori


    def final(self):
        """
        returnez cine a castigat, sau false daca nu a castigat nimeni inca
        """
        # daca cineva nu mai are piese
        if len(self.piese_albe) == 0:
            return "negre"

        if len(self.piese_negre) == 0:
            return "albe"

        # daca jucatorul cu piese albe nu mai are unde muta
        ok = False
        for piesa in self.piese_albe:
            if self.pot_muta(piesa, "albe"):
                ok = True
                break

        if not ok:
            return "negre"

        # daca jucatorul cu piese albe nu mai are unde muta
        ok = False
        for piesa in self.piese_negre:
            if self.pot_muta(piesa, "negre"):
                ok = True
                break

        if not ok:
            return "albe"

        return False


    def e_muchie(self, index1, index2):
        return (index1, index2) in self.muchii or (index2, index1) in self.muchii


    def mutari(self, jucator_opus):
        # verificam daca s au realizat capturarile si initializam lista de piese ale jucatorului si ale adversarului
        lista_mutari = []
        piese_jucator = self.piese_albe
        piese_adversar = self.piese_negre

        # daca celalalt jucator joaca cu negre schimbam piesele intre ele
        if jucator_opus == 'negre':
            piese_jucator, piese_adversar = piese_adversar, piese_jucator

        pot_captura = False
        for piesa in piese_jucator: 
            # am preluat indexul din lista
            index = self.coordonate_noduri.index(piesa) 
            
            # pentru fiecare pozitie peste acre as putea sari
            for i in [-12, -10, -8, -2, 2, 8, 10, 12]: 
                # am determinat nodul peste care trec
                mij = int(index + i/2) 

                # am determinat nodul unde sar
                varf = index + i 

                # verificam sa fie in grid si locul liber si muchie existenta
                if 0 <= mij < 25 and 0 <= varf < 25 and self.e_muchie(index, mij) and self.e_muchie(mij, varf):
                    if self.coordonate_noduri[mij] in piese_adversar and self.coordonate_noduri[varf] not in piese_adversar + piese_jucator:

                        # noua lista de piese ale jucatorului, din care am sters piesa ce s a mutat si i am adaugat noua pozitie
                        piese_jucator_noi = list(piese_jucator)
                        piese_jucator_noi.remove(piesa)
                        piese_jucator_noi.append(self.coordonate_noduri[varf])

                        # noua lista de piese ale adversarului, din care am sters piesa peste care am sarit
                        piese_adversar_noi = list(piese_adversar)
                        piese_adversar_noi.remove(self.coordonate_noduri[mij]) 

                        # variabila ce indica faptul ca am avut cel putin o capturare
                        pot_captura = True 
                        
                        # am adaugat la lista de mutari
                        if self.JMAX == 'negre': 
                            lista_mutari.append(Joc(piese_adversar_noi, piese_jucator_noi, True))
                        else:
                            lista_mutari.append(Joc(piese_jucator_noi, piese_adversar_noi, True))

        # daca am capturat cel putin o piesa returnez lista curenta
        if pot_captura: 
            return lista_mutari

        # daca nu, verific unde pot muta in vecini
        for piesa in piese_jucator: 
            # am preluat indexul din lista
            index = self.coordonate_noduri.index(piesa) 
            
            # pentru fiecare nod pe care po sa l mut
            for i in [index - 6, index - 5, index - 4, index - 1, index + 1, index + 4, index + 5, index + 6]: 
                
                # daca inca sunt in grid
                if 0 <= i < 25: 
                    # am luat nodul unde o sa mut
                    loc = self.coordonate_noduri[i] 
                    
                    # daca am muchie intre cele 2 noduri
                    if self.e_muchie(i, index): 
                        # si daca nodul nou este gol
                        if loc not in piese_jucator + piese_adversar: 
                            #initializam noua lista de piese a jucatorului si inlocuim pozitia piesei mutate
                            piese_jucator_noi = list(piese_jucator)
                            piese_jucator_noi.remove(piesa) 
                            piese_jucator_noi.append(loc)

                            if self.JMAX == 'negre':
                                lista_mutari.append(Joc(piese_adversar, piese_jucator_noi))
                            else:
                                lista_mutari.append(Joc(piese_jucator_noi, piese_adversar))

        return lista_mutari


    def linie_deschisa(self, piesa, jucator):
        """
        functie care intoarce numarul de capturari pe care le pot face cu o piesa
        """
        scor = 0
        index = self.coordonate_noduri.index(piesa)
        piese_jucator = self.piese_negre
        piese_adversar = self.piese_albe

        if jucator == 'albe':
            piese_jucator, piese_adversar = piese_adversar, piese_jucator

        for i in [-12, -10, -8, -2, 2, 8, 10, 12]:
            mij = int(index + i/2)
            varf = index + i

            if 0 <= mij < 25 and 0 <= varf < 25 and self.e_muchie(index, mij) and self.e_muchie(mij, varf):
                if self.coordonate_noduri[mij] in piese_adversar and self.coordonate_noduri[varf] not in piese_adversar + piese_jucator:
                    scor += 1

        return scor

    def capturari(self, jucator, mod):
        """
        returnez scorul pentru un anumit jucator cu intr un anumit mod
        """
        scor = 0
        if mod == '1':
            # pentru fiecare piesa adaug maxim 1
            if jucator == 'negre':
                for piesa in self.piese_negre:
                    if self.linie_deschisa(piesa, jucator):
                        scor += 1

            else:
                for piesa in self.piese_albe:
                    if self.linie_deschisa(piesa, jucator):
                        scor += 1

        else:
            # pentru fiecare piesa calculez maximul de capturari
            if jucator == 'negre':
                for piesa in self.piese_negre:
                    nr_capt = self.linie_deschisa(piesa, jucator)
                    if nr_capt > scor:
                        scor = nr_capt

            else:
                for piesa in self.piese_albe:
                    nr_capt = self.linie_deschisa(piesa, jucator)
                    if nr_capt > scor:
                        scor = nr_capt

        return scor


    def estimeaza_scor(self, adancime, mod='1'):
        """
        functie ce returneaz scorul
        """
        # verific daca e final
        t_final = self.final() 

        # daca PC ul castiga
        if t_final == self.__class__.JMAX: 
            return (99 + adancime)

        # daca jucatorul castiga
        elif t_final == self.__class__.JMIN: 
            return (-99 - adancime)

        # altfel scor pc - scor jucator
        else: 
            return self.capturari(self.__class__.JMAX, mod) - self.capturari(self.__class__.JMIN, mod)


    def __str__(self):
        sir = ""
        endl = 0
        for lin in range(5):
            for col in range(0,21,5):
                x = self.coordonate_noduri[col+lin]
                endl += 1
                if x in self.piese_negre:
                    sir += "N"
                elif x in self.piese_albe:
                    sir += "A"
                else:
                    sir += "G"
                if endl % 5 == 0:
                    sir += "\n"
        return sir


class Stare:
    """
    Clasa folosita de algoritmii minimax si alpha-beta
    Are ca proprietate tabla de joc
    Functioneaza cu conditia ca in cadrul clasei Joc sa fie definiti JMIN si JMAX (cei doi jucatori posibili)
    De asemenea cere ca in clasa Joc sa fie definita si o metoda numita mutari() care ofera lista cu configuratiile posibile in urma mutarii unui jucator
    """

    def __init__(self, tabla_joc, j_curent, adancime, parinte=None, estimare=None):
        self.tabla_joc = tabla_joc
        self.j_curent = j_curent

        # adancimea in arborele de stari
        self.adancime = adancime

        # estimarea favorabilitatii starii (daca e finala) sau al celei mai bune stari-fiice (pentru jucatorul curent)
        self.estimare = estimare

        # lista de mutari posibile din starea curenta
        self.mutari_posibile = []

        # cea mai buna mutare din lista de mutari posibile pentru jucatorul curent
        self.stare_aleasa = None

    def mutari(self):
        l_mutari = self.tabla_joc.mutari(self.j_curent)
        juc_opus = Joc.jucator_opus(self.j_curent)
        l_stari_mutari = [Stare(mutare, juc_opus, self.adancime - 1, parinte=self) for mutare in l_mutari]

        return l_stari_mutari

    def __str__(self):
        sir = str(self.tabla_joc)
        return sir


""" Algoritmul MinMax """


def min_max(stare, mod_estimare):
    global n_min, n_max, n_l, mutari_gen

    if stare.adancime == 0 or stare.tabla_joc.final():
        stare.estimare = stare.tabla_joc.estimeaza_scor(stare.adancime, mod_estimare)
        return stare

    # calculez toate mutarile posibile din starea curenta
    stare.mutari_posibile = stare.mutari()
    mutari_gen += len(stare.mutari_posibile)


    # aplic algoritmul minimax pe toate mutarile posibile (calculand astfel subarborii lor)
    mutariCuEstimare = [min_max(mutare, mod_estimare) for mutare in stare.mutari_posibile]

    if stare.j_curent == Joc.JMAX:
        # daca jucatorul e JMAX aleg starea-fiica cu estimarea maxima
        stare.stare_aleasa = max(mutariCuEstimare, key=lambda x: x.estimare)

    else:
        # daca jucatorul e JMIN aleg starea-fiica cu estimarea minima
        stare.stare_aleasa = min(mutariCuEstimare, key=lambda x: x.estimare)

    stare.estimare = stare.stare_aleasa.estimare
    return stare


def alpha_beta(alpha, beta, stare, mod_estimare):
    global n_min, n_max, n_l, mutari_gen 

    if stare.adancime == 0 or stare.tabla_joc.final():
        stare.estimare = stare.tabla_joc.estimeaza_scor(stare.adancime, mod_estimare)
        return stare

    # este intr-un interval invalid deci nu o mai procesez
    if alpha > beta:
        return stare 

    stare.mutari_posibile = stare.mutari()
    mutari_gen += len(stare.mutari_posibile)

    if stare.j_curent == Joc.JMAX:
        estimare_curenta = float('-inf')

        # sortam dupa scorul estimat descrescator
        stare.mutari_posibile = sorted(stare.mutari_posibile, key=lambda x: x.tabla_joc.estimeaza_scor(stare.adancime), reverse=True)

        for mutare in stare.mutari_posibile:
            # calculeaza estimarea pentru starea noua, realizand subarborele
            stare_noua = alpha_beta(alpha, beta, mutare, mod_estimare)

            if (estimare_curenta < stare_noua.estimare):
                stare.stare_aleasa = stare_noua
                estimare_curenta = stare_noua.estimare

            if (alpha < stare_noua.estimare):
                alpha = stare_noua.estimare
                if alpha >= beta:
                    break

    elif stare.j_curent == Joc.JMIN:
        estimare_curenta = float('inf')

        # sortam dupa scorul estimat crescator
        stare.mutari_posibile = sorted(stare.mutari_posibile,key=lambda x : x.tabla_joc.estimeaza_scor(stare.adancime))
        
        for mutare in stare.mutari_posibile:
            stare_noua = alpha_beta(alpha, beta, mutare, mod_estimare)
            if (estimare_curenta > stare_noua.estimare):
                stare.stare_aleasa = stare_noua
                estimare_curenta = stare_noua.estimare

            if (beta > stare_noua.estimare):
                beta = stare_noua.estimare
                if alpha >= beta:
                    break

    stare.estimare = stare.stare_aleasa.estimare
    return stare


def afis():
    global t_l, n_l, timp_total, mutari_juc, mutari_pc

    if len(t_l):
        print("Timpul minim de gandire al calculatorului: " + str(min(t_l)) + " milisecunde")
        print("Timpul maxim de gandire al calculatorului: " + str(max(t_l)) + " milisecunde")
        print("Timpul mediu de gandire al calculatorului: " + str(sum(t_l) / len(t_l)) + " milisecunde")
        print("Timpul median de gandire al calculatorului: " + str(statistics.median(t_l)) + " milisecunde\n")

    if len(n_l):
        print("Numarul minim de mutari generate: " + str(min(n_l)))
        print("Numarul maxim de mutari generate: " + str(max(n_l)))
        print("Numarul mediu de mutari generate: " + str(sum(n_l) / len(n_l)))
        print("Numarul median de mutari generate: " + str(statistics.median(n_l)) + "\n")

    timp = int(round(time.time())) - timp_total
    print("Timpul total jucat: " + str(timp) + " secunde")
    print("Jucatorul a facut " + str(mutari_juc) + " mutari")
    print("Calculatorul a facut " + str(mutari_pc) + " mutari")

    return True


def afis_daca_final(stare_curenta):
    global game_over

    if stare_curenta == "force quit":
        print("\nProgramul a fost intrerupt!\n")
        if not game_over:
            return afis()

    else:
        final = stare_curenta.tabla_joc.final()
        if (final):
            game_over = True
            print("\nA castigat jucatorul cu piesele " + final + "!!\n")

            # colorare simboluri castigatoare
            if final == 'albe':
                for piesa in stare_curenta.tabla_joc.piese_albe:
                    Joc.display.blit(Joc.piesa_selectata, (piesa[0] - Joc.raza_piesa, piesa[1] - Joc.raza_piesa))
                pygame.display.update()

            elif final == 'negre':
                for piesa in stare_curenta.tabla_joc.piese_negre:
                    Joc.display.blit(Joc.piesa_selectata, (piesa[0] - Joc.raza_piesa, piesa[1] - Joc.raza_piesa))
                pygame.display.update()

            return afis()

    return False


def coliniare (n0, n1):
    """
    returneaza mijlocul a 2 puncte
    """
    x0 = n0[0]
    y0 = n0[1]
    x1 = n1[0]
    y1 = n1[1]

    if x0 == x1 and abs(y0 - y1) == 240:
        y2 = abs(y0 + y1) / 2
        return [x0, y2]

    if y0 == y1 and abs(x0 - x1) == 240:
        x2 = abs(x0 + x1) / 2
        return [x2, y0]

    if abs(x0 - x1) == 240 and abs(y0 - y1) == 240:
        x2 = abs(x0 + x1) / 2
        y2 = abs(y0 + y1) / 2 
        return [x2, y2]

    return False


def capturare(n0, n1, piese_adverse): # 
    """
    functie pentru a vedea daca jucatorul a capturat o piesa
    """
     # calcularea "mijlocului" dintre n0 si n1
    n2 = coliniare(n0, n1)

    # daca nu estes corect
    if n2 == False: 
        return False

    # daca n1 e gol si n2 e piesa adversa
    if n1 not in piese_adverse and n2 in piese_adverse: 
        return n2

    return False


def puteam_captura(stare_curenta, JMIN):
    """
    fucntie ce returneaza daca putem captura o piesa
    """
    piese_curente, piese_adverse = stare_curenta.tabla_joc.piese_albe, stare_curenta.tabla_joc.piese_negre

    if JMIN == "negre":
        piese_curente, piese_adverse = piese_adverse, piese_curente

    l = []
    for piesa in piese_curente:
        index = stare_curenta.tabla_joc.coordonate_noduri.index(piesa)
        for i in [-12, -10, -8, -2, 2, 8, 10, 12]:
            mij = int(index + i/2)
            varf = index + i

            if 0 <= mij < 25 and 0 <= varf < 25 and stare_curenta.tabla_joc.e_muchie(index, mij) and \
                    stare_curenta.tabla_joc.e_muchie(mij, varf):
                if stare_curenta.tabla_joc.coordonate_noduri[mij] in piese_adverse and \
                        stare_curenta.tabla_joc.coordonate_noduri[varf] not in piese_adverse + piese_curente:
                    l.append(piesa)
                    break

    return l


class Buton:
    def __init__(self, display=None, left=0, top=0, w=0, h=0, culoareFundal=(53, 80, 115),
                 culoareFundalSel=(89, 134, 194), text="", font="arial", fontDimensiune=25, culoareText=(255, 255, 255),
                 valoare=""):
        self.display = display
        self.culoareFundal = culoareFundal
        self.culoareFundalSel = culoareFundalSel
        self.text = text
        self.font = font
        self.w = w
        self.h = h
        self.selectat = False
        self.fontDimensiune = fontDimensiune
        self.culoareText = culoareText

        # creez obiectul font
        fontObj = pygame.font.SysFont(self.font, self.fontDimensiune)
        self.textRandat = fontObj.render(self.text, True, self.culoareText)
        self.dreptunghi = pygame.Rect(left, top, w, h)

        # aici centram textul
        self.dreptunghiText = self.textRandat.get_rect(center=self.dreptunghi.center)
        self.valoare = valoare


    def selecteaza(self, sel):
        self.selectat = sel
        self.deseneaza()


    def selecteazaDupacoord(self, coord):
        if self.dreptunghi.collidepoint(coord):
            self.selecteaza(True)
            return True

        return False


    def updateDreptunghi(self):
        self.dreptunghi.left = self.left
        self.dreptunghi.top = self.top
        self.dreptunghiText = self.textRandat.get_rect(center=self.dreptunghi.center)


    def deseneaza(self):
        culoareF = self.culoareFundalSel if self.selectat else self.culoareFundal
        pygame.draw.rect(self.display, culoareF, self.dreptunghi)
        self.display.blit(self.textRandat, self.dreptunghiText)


class GrupButoane:
    def __init__(self, listaButoane=[], indiceSelectat=0, spatiuButoane=10, left=0, top=0):
        self.listaButoane = listaButoane
        self.indiceSelectat = indiceSelectat
        self.listaButoane[self.indiceSelectat].selectat = True
        self.top = top
        self.left = left
        leftCurent = self.left
        for b in self.listaButoane:
            b.top = self.top
            b.left = leftCurent
            b.updateDreptunghi()
            leftCurent += (spatiuButoane + b.w)


    def selecteazaDupacoord(self, coord):
        for ib, b in enumerate(self.listaButoane):
            if b.selecteazaDupacoord(coord):
                self.listaButoane[self.indiceSelectat].selecteaza(False)
                self.indiceSelectat = ib
                return True

        return False


    def deseneaza(self):
        # atentie, nu face wrap
        for b in self.listaButoane:
            b.deseneaza()


    def getValoare(self):
        ok = False
        for btn in self.listaButoane:
            if btn.selectat:
                ok = True
                break

        if not ok:
            return ok

        return self.listaButoane[self.indiceSelectat].valoare


############# ecran initial ########################
def deseneaza_alegeri(display, tabla_curenta):
    # buron pentru tipul de algoritm folosit
    btn_alg = GrupButoane(
        top=20,
        left=50,
        listaButoane=[
            Buton(display=display, w=110, h=50, text="minimax", valoare="minimax"),
            Buton(display=display, w=110, h=50, text="alphabeta", valoare="alphabeta")
        ],
        spatiuButoane=30,
        indiceSelectat=1)

    # buton pentru culoare selectata de jucator
    btn_juc = GrupButoane(
        top=120,
        left=50,
        listaButoane=[
            Buton(display=display, w=110, h=50, text="albe", valoare="albe"),
            Buton(display=display, w=110, h=50, text="negre", valoare="negre")
        ],
        spatiuButoane=30,
        indiceSelectat=0)

    # buton pentru cine incepe
    btn_incep = GrupButoane(
        top=220,
        left=50,
        listaButoane=[
            Buton(display=display, w=200, h=50, text="incepe jucatorul", valoare="eu"),
            Buton(display=display, w=200, h=50, text="Incepe calculatorul", valoare="pc")
        ],
        spatiuButoane=30,
        indiceSelectat=1)

    # buton pentru dificultate
    btn_dif = GrupButoane(
        top = 320,
        left = 50,
        listaButoane=[
            Buton(display=display, w=130, h=50, text="incepator", valoare="2"),
            Buton(display=display, w=130, h=50, text="mediu", valoare="3"),
            Buton(display=display, w=130, h=50, text="greu", valoare="4")
        ],
        spatiuButoane=30,
        indiceSelectat= 2)

    # buton pentru modul de estimare
    btn_estimari = GrupButoane(
        top=420,
        left=50,
        listaButoane=[
            Buton(display=display, w=150, h=50, text="mod estimare 1", valoare="1"),
            Buton(display=display, w=150, h=50, text="mod stimare 2", valoare="2")
        ],
        spatiuButoane=30,
        indiceSelectat=1)

    ok = Buton(display=display, top=520, left=50, w=110, h=50, text="ok", culoareFundal=(155, 0, 55))

    btn_alg.deseneaza()
    btn_juc.deseneaza()
    btn_dif.deseneaza()
    btn_incep.deseneaza()
    btn_estimari.deseneaza()
    ok.deseneaza()

    while True:
        for ev in pygame.event.get():
            if ev.type == pygame.QUIT:
                afis_daca_final("force quit")
                pygame.quit()
                sys.exit()

            elif ev.type == pygame.MOUSEBUTTONDOWN:
                pos = pygame.mouse.get_pos()
                if not btn_alg.selecteazaDupacoord(pos):
                    if not btn_juc.selecteazaDupacoord(pos):
                        if not btn_incep.selecteazaDupacoord(pos):
                            if not btn_dif.selecteazaDupacoord(pos):
                                if not btn_estimari.selecteazaDupacoord(pos):
                                    if ok.selecteazaDupacoord(pos):
                                        if btn_juc.getValoare() and btn_alg.getValoare() and btn_incep.getValoare() and btn_dif.getValoare() and btn_estimari.getValoare():
                                            # stergere ecran
                                            display.fill((0, 0, 0))  
                                            tabla_curenta.deseneaza_grid()
                                            return btn_juc.getValoare(), btn_alg.getValoare(), btn_incep.getValoare(), btn_dif.getValoare(), btn_estimari.getValoare()
                                        else:
                                            print("Trebuie selectata cel putin o valoare de pe fiecare rand!")

        pygame.display.update()


def main():
    # initializari variabile globale pentru timp, mutari si noduri
    global t_juc_inainte, t_l, n_l, timp_total, mutari_pc, mutari_juc, mutari_gen, game_over

    # timpul de start pentru muatrile jucatorului
    t_juc_inainte = int(round(time.time() * 1000)) 

    # lista cu timpi
    t_l = [] 

    # lista cu numere de noduri
    n_l = [] 

    # timpul la care a pornit programul
    timp_total = int(round(time.time())) 

    # variabile pentru numarul de mutari
    mutari_pc = mutari_juc = mutari_gen = 0 

    # lista de capturari ce pot fi realizate
    l_puteam_captura = []

    # variabila pentru a nu afisa de 2 ori
    game_over = False 

    # initializare tabla
    tabla_curenta = Joc()
    print("Tabla initiala")
    print(str(tabla_curenta))

    # setari interf grafica
    pygame.init()
    pygame.display.set_caption('Cuciureanu Dragos-Adrian 231 ')

    # dimensiunea ferestrei in pixeli
    ecran = pygame.display.set_mode(size=(600, 600))
    Joc.initializeaza(ecran)

    # initializam parametrii din functie
    Joc.JMIN, tip_algoritm, incep, ADANCIME_MAX, mod_estimare = deseneaza_alegeri(ecran, tabla_curenta)
    ADANCIME_MAX = int(ADANCIME_MAX)
    Joc.JMAX = 'albe' if Joc.JMIN == 'negre' else 'negre'

    # initializare stare
    if incep == "eu":
        stare_curenta = Stare(tabla_curenta, Joc.JMIN, ADANCIME_MAX)
        print("\nEste randul jucatorului!\n")

    else:
        stare_curenta = Stare(tabla_curenta, Joc.JMAX, ADANCIME_MAX)
        print("\nEste randul calculatorului!\n")

    tabla_curenta.deseneaza_grid()

    while True:
        j_current = stare_curenta.j_curent
        if (j_current == Joc.JMIN):
            # muta jucatorul

            for event in pygame.event.get():
                # verificam daca a iesit
                if event.type == pygame.QUIT: 
                    afis_daca_final("force quit")

                    # inchide fereastra
                    pygame.quit()  
                    sys.exit()

                # daca a dat click
                elif event.type == pygame.MOUSEBUTTONDOWN: 
                    # coordonatele clickului
                    pos = pygame.mouse.get_pos()  

                    for nod in Joc.coordonate_noduri:
                        # daca a facut click pe un nod
                        if distance(pos, nod) <= Joc.raza_pct: 
                            if (j_current == 'albe'):
                                piese_jucator = stare_curenta.tabla_joc.piese_albe
                                piese_adversar = stare_curenta.tabla_joc.piese_negre
                            else:
                                piese_jucator = stare_curenta.tabla_joc.piese_negre
                                piese_adversar = stare_curenta.tabla_joc.piese_albe

                            # daca a dat click pe un nod gol
                            if nod not in piese_jucator + piese_adversar: 
                                # daca a dat click pe un nod gol
                                if stare_curenta.tabla_joc.nod_piesa_selectata:
                                    n0 = stare_curenta.tabla_joc.coordonate_noduri.index(nod)
                                    n1 = stare_curenta.tabla_joc.coordonate_noduri.index(stare_curenta.tabla_joc.nod_piesa_selectata)

                                    piesa_capturata = capturare(nod, stare_curenta.tabla_joc.nod_piesa_selectata, piese_adversar)

                                    if piesa_capturata:
                                        # stergem piesa captura di lista adversarului
                                        piese_adversar.remove(piesa_capturata)

                                        # modificam pozitia piesei mutate
                                        piese_jucator.remove(stare_curenta.tabla_joc.nod_piesa_selectata)
                                        piese_jucator.append(nod)
                                        stare_curenta.tabla_joc.nod_piesa_selectata = False
                                        t_juc_dupa = int(round(time.time() * 1000))
                                        mutari_juc += 1

                                        print("Jucatorul a \"gandit\" timp de " + str(t_juc_dupa - t_juc_inainte) + " milisecunde.")
                                        afis_daca_final(stare_curenta) 

                                    # daca nu a capturat
                                    elif ((n0, n1) in Joc.muchii or (n1, n0) in Joc.muchii): 
                                        # verificam daca ar fi putut captura
                                        l_puteam_captura = puteam_captura(stare_curenta, Joc.JMIN) 

                                        for piesa_pierduta in l_puteam_captura:
                                            # eliminam fiecare piesa care putea captura
                                            lin = int(piesa_pierduta[1]/100)+1
                                            col = int(piesa_pierduta[0]/100)+1

                                            print("Puteai captura cu piesa de pe linia " + str(lin) + " coloana " + str(col) + ".")

                                            piese_jucator.remove(piesa_pierduta)

                                        if stare_curenta.tabla_joc.nod_piesa_selectata not in l_puteam_captura:
                                            # daca piesa mutata nu a fost stearsa, o mut
                                            piese_jucator.remove(stare_curenta.tabla_joc.nod_piesa_selectata)
                                            piese_jucator.append(nod)

                                        # am resetat selectarea de piese
                                        stare_curenta.tabla_joc.nod_piesa_selectata = False 

                                        # schimbam jucatorul
                                        stare_curenta.j_curent = Joc.jucator_opus(stare_curenta.j_curent) 
                                        t_juc_dupa = int(round(time.time() * 1000))
                                        mutari_juc += 1

                                        print("Jucatorul a \"gandit\" timp de " + str(t_juc_dupa - t_juc_inainte) + " milisecunde.")
                                        print("\nEste randul calculatorului!\n")

                            else:
                                # daca a dat click pe o piesa curenta
                                if nod in piese_jucator: 
                                    if stare_curenta.tabla_joc.nod_piesa_selectata:
                                        stare_curenta.tabla_joc.nod_piesa_selectata = False
                                    else:
                                        stare_curenta.tabla_joc.nod_piesa_selectata = nod

                            stare_curenta.tabla_joc.deseneaza_grid(Joc.JMIN)

        # jucatorul e JMAX (calculatorul)
        else:  
            # Mutare calculator

            # preiau timpul in milisecunde de dinainte de mutare
            t_inainte = int(round(time.time() * 1000))
            if tip_algoritm == 'minimax':
                stare_actualizata = min_max(stare_curenta, mod_estimare)

            else:
                stare_actualizata = alpha_beta(-500, 500, stare_curenta, mod_estimare)

            stare_curenta.tabla_joc = stare_actualizata.stare_aleasa.tabla_joc

            print("Tabla dupa mutarea calculatorului")
            print(str(stare_curenta))
            print("Estimare stare curenta: " + str(stare_curenta.estimare))

            stare_curenta.tabla_joc.deseneaza_grid(Joc.JMIN)

            # preiau timpul in milisecunde de dupa mutare
            t_dupa = int(round(time.time() * 1000))
            t_calc = t_dupa - t_inainte

            print('Calculatorul a "gandit" timp de ' + str(t_calc) + " milisecunde.")
            t_l.append(t_calc)

            print("Nr mutari generate: " + str(mutari_gen))
            n_l.append(mutari_gen)

            mutari_gen = 0

            if (afis_daca_final(stare_curenta)):
                break

            # daca nu s-a realizat o capturare, schimb jucatorul cu cel opus
            if not stare_curenta.tabla_joc.capturat:
                stare_curenta.j_curent = Joc.jucator_opus(stare_curenta.j_curent)
                print("\nEste randul jucatorului!\n")

            else:
                afis_daca_final(stare_curenta)
                # muta prea repede
                time.sleep(1) 

            mutari_pc += 1
            t_juc_inainte = int(round(time.time() * 1000))


if __name__ == "__main__":
    main()
    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()