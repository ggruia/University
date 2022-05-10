import pygame
import copy


EMPTY = '.'
BLACK = "B"
WHITE = "W"


class Game:
    SIZE = None
    JMIN = None
    JMAX = None

    scor_maxim = 0


    def __init__(self, size=None, config=None):
        self.lastMove = None

        match config:
            case None:
                self.config = [[0] * size for _ in range(size)]
            
                if size is not None:
                    self.__class__.SIZE= size
                
                sc_randuri = (size - 3) * size
                sc_coloane = (size - 3) * size
                sc_diagonale = (size - 3) * (size - 3) * 2
                self.__class__.scor_maxim = sc_randuri + sc_coloane + sc_diagonale
            case _:
                self.config = config

    def __repr__(self):
        rep = "  | "
        rep += " ".join([str(i) for i in range(self.__class__.SIZE)]) + "\n"
        rep += "-" * ((self.__class__.SIZE + 1) * 2 + 1) + "\n"
        rep += "\n".join([str(i) + " | " + " ".join([str(x) for x in self.config[i]]) for i in range(len(self.config))])
        return rep


    def drawGrid(self, coloana_marcaj=None):

        for ind in range(self.__class__.SIZE * self.__class__.SIZE):
            linie = ind // self.__class__.SIZE
            coloana = ind % self.__class__.SIZE

            if coloana == coloana_marcaj:
                #daca am o patratica selectata, o desenez cu rosu
                culoare = (255, 255, 0)
            else:
                #altfel o desenez cu alb
                culoare = (255, 255, 255)
            pygame.draw.rect(self.__class__.display, culoare, self.__class__.celuleGrid[ind])
            if self.config[linie][coloana] == 'x':
                self.__class__.display.blit(self.__class__.x_img, (coloana * (self.__class__.dim_celula + 1), linie * (self.__class__.dim_celula + 1)))
            elif self.config[linie][coloana] == '0':
                self.__class__.display.blit(self.__class__.zero_img, (coloana * (self.__class__.dim_celula + 1), linie * (self.__class__.dim_celula + 1)))			
        pygame.display.update()

    @classmethod
    def enemy(cls, player):
        return cls.JMAX if player == cls.JMIN else cls.JMIN


    @classmethod
    def prepare(cls, display, size=7, dim_celula=100):
        cls.display=display
        cls.dim_celula=dim_celula
        cls.x_img = pygame.image.load('x.png')
        cls.x_img = pygame.transform.scale(cls.x_img, (dim_celula,dim_celula))
        cls.zero_img = pygame.image.load('0.png')
        cls.zero_img = pygame.transform.scale(cls.zero_img, (dim_celula,dim_celula))
        cls.celuleGrid=[] #este lista cu patratelele din grid
        for linie in range(size):
            for coloana in range(size):
                patr = pygame.Rect(coloana*(dim_celula+1), linie*(dim_celula+1), dim_celula, dim_celula)
                cls.celuleGrid.append(patr)

    def parcurgere(self, directie):
        um = self.lastMove # (l,c)
        culoare = self.config[um[0]][um[1]]
        nr_mutari = 0
        while True:
            um = (um[0] + directie[0], um[1] + directie[1])
            if not 0 <= um[0] < self.__class__.SIZE or not 0 <= um[1] < self.__class__.SIZE:
                break
            if not self.config[um[0]][um[1]] == culoare:
                break
            nr_mutari += 1
        return nr_mutari
        
    def final(self):
        if not self.lastMove: #daca e inainte de prima mutare
            return False
        directii = [[(0, 1), (0, -1)], [(1, 1), (-1, -1)], [(1, -1), (-1, 1)], [(1, 0), (-1, 0)]]
        um = self.lastMove
        rez = False
        for per_dir in directii:
            len_culoare = self.parcurgere(per_dir[0]) + self.parcurgere(per_dir[1]) + 1 # +1 pt chiar ultima mutare
            if len_culoare >= 4:
                rez = self.config[um[0]][um[1]]
        
        if(rez):
            return rez
        elif all(self.__class__.GOL not in x for x in self.config):
            return 'remiza'
        else:
            return False

    def moves(self, jucator):
        l_mutari=[]
        for j in range(self.__class__.SIZE):
            last_poz = None
            if self.config[0][j] != self.__class__.GOL:
                continue
            for i in range(self.__class__.SIZE):
                if self.config[i][j]!=self.__class__.GOL:
                        last_poz = (i-1,j)
                        break			 
            if last_poz is None:
                last_poz = (self.__class__.SIZE-1, j)
            config_tabla_noua = copy.deepcopy(self.config)
            config_tabla_noua[last_poz[0]][last_poz[1]] = jucator
            jn=Game(config_tabla_noua)
            jn.lastMove=(last_poz[0],last_poz[1])
            l_mutari.append(jn)
        return l_mutari


    #linie deschisa inseamna linie pe care jucatorul mai poate forma o configuratie castigatoare
    #practic e o linie fara simboluri ale jucatorului opus
    def linie_deschisa(self,lista, jucator):
        jo=self.enemy(jucator)
        #verific daca pe linia data nu am simbolul jucatorului opus
        if not jo in lista:
                #return 1
                return lista.count(jucator)
        return 0
            
    def linii_deschise(self, jucator):
        
        linii = 0
        for i in range(self.__class__.SIZE):
            for j in range(self.__class__.SIZE - 3):
                linii += self.linie_deschisa(self.config[i][j:j + 4], jucator)
                
        for j in range(self.__class__.SIZE):
            for i in range(self.__class__.SIZE - 3):
                linii += self.linie_deschisa([self.config[k][j] for k in range(i, i + 4)],jucator)

        # \
        for i in range(self.__class__.SIZE - 3):
            for j in range(self.__class__.SIZE - 3):
                linii += self.linie_deschisa([self.config[i+k][j+k] for k in range(0, 4)],jucator)
        
        # /
        for i in range(self.__class__.SIZE-3):
            for j in range(3, self.__class__.SIZE):
                linii += self.linie_deschisa([self.config[i+k][j-k] for k in range(0, 4)],jucator)
        
        return linii

        
    def estimateScore(self, adancime):
        t_final = self.final()

        if t_final == self.__class__.JMAX :
            return (self.__class__.scor_maxim + adancime)
        elif t_final == self.__class__.JMIN:
            return (-self.__class__.scor_maxim - adancime)
        elif t_final == 'remiza':
            return 0
        else:
            return (self.linii_deschise(self.__class__.JMAX) - self.linii_deschise(self.__class__.JMIN))