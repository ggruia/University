import heapq





class PriorityQueue:
    def __init__(self, elements = None):
      if(elements == None):
        self.elements = list()
      elif type(elements) == list:
        heapq.heapify(elements)
        self.elements = elements
  
    # for checking if the queue is empty
    def empty(self):
        return len(self.elements) == 0
  
    # for inserting an element in the queue
    def push(self, element):
        heapq.heappush(self.elements, element)

    # for popping an element based on Priority
    def pop(self):
        heapq.heappop(self.elements)

    def delete(self, node):
        x = self.elements
        x.remove(node)
        heapq.heapify(x)
        self.elements = x







class NodParcurgere:
    graf = None

    def __init__(self, id, info, parinte, cost, h):
        self.id=id # este indicele din vectorul de noduri
        self.info=info
        self.parinte=parinte #parintele din arborele de parcurgere
        self.g=cost #costul de la radacina la nodul curent
        self.h=h
        self.f=self.g+self.h

    def __lt__(self, other):
        if self.f < other.f:
            return True
        elif self.f == other.f:
            if self.g > other.g:
                return True
        return False

    def __eq__(self, other):
        return (self.id == other.id
            and self.info == other.info
            and self.parinte == other.parinte
            and self.g == other.cost
            and self.h == other.h
            and self.f == other.f)


    def obtineDrum(self):
        l=[self.info]
        nod=self
        while nod.parinte is not None:
            l.insert(0, nod.parinte.info)
            nod=nod.parinte
        return l
        
    def afisDrum(self): #returneaza si lungimea drumului
        l=self.obtineDrum()
        print(("->").join(l))
        print("Cost: ",self.g)
        return len(l)


    def contineInDrum(self, infoNodNou):
        nodDrum=self
        while nodDrum is not None:
            if(infoNodNou==nodDrum.info):
                return True
            nodDrum=nodDrum.parinte
        
        return False
        
    def __repr__(self):
        sir=""		
        sir+=self.info+"("
        sir+="id = {}, ".format(self.id)
        sir+="drum="
        drum=self.obtineDrum()
        sir+=("->").join(drum)
        sir+=" g:{}".format(self.g)
        sir+=" h:{}".format(self.h)
        
        sir+=" f:{})".format(self.f)
        return(sir)
        

class Graph: #graful problemei
    def __init__(self, noduri, matriceAdiacenta, matricePonderi, start, scopuri, lista_h):
        self.noduri=noduri
        self.matriceAdiacenta=matriceAdiacenta
        self.matricePonderi=matricePonderi
        self.nrNoduri=len(matriceAdiacenta)
        self.start=start
        self.scopuri=scopuri
        self.lista_h=lista_h

    def indiceNod(self, n):
        return self.noduri.index(n)
        
    def testeaza_scop(self, nodCurent):
        return nodCurent.info in self.scopuri

    #va genera succesorii sub forma de noduri in arborele de parcurgere
    def genereazaSuccesori(self, nodCurent):
        listaSuccesori=[]
        for i in range(self.nrNoduri):
            if self.matriceAdiacenta[nodCurent.id][i] == 1 and  not nodCurent.contineInDrum(self.noduri[i]):
                nodNou=NodParcurgere(i, self.noduri[i], nodCurent, nodCurent.g+ self.matricePonderi[nodCurent.id][i], self.calculeaza_h(self.noduri[i]))
                listaSuccesori.append(nodNou)
        return listaSuccesori

    def calculeaza_h(self, infoNod):
        return self.lista_h[self.indiceNod(infoNod)]

    def __repr__(self):
        sir=""
        for (k,v) in self.__dict__.items() :
            sir+="{} = {}\n".format(k,v)
        return(sir)
        
        

##############################################################################################	
#                                 Initializare problema                                      #
##############################################################################################		

#pozitia i din vectorul de noduri da si numarul liniei/coloanei corespunzatoare din matricea de adiacenta		
noduri=["a","b","c","d","e","f","g","i","j","k"]

m=[
	[0,1,1,1,0,0,0,0,0,0],
	[0,0,0,0,1,1,0,0,0,0],
	[0,0,0,0,1,0,1,0,0,0],
	[0,0,0,0,0,0,0,1,0,0],
	[0,0,1,0,0,1,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,1,1,0,0,1,0,0],
	[0,0,1,0,1,0,0,0,2,1],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0]
]
mp=[
	[0,3,9,7,0,0,0,0,0,0],
	[0,0,0,0,4,100,0,0,0,0],
	[0,0,0,0,10,0,5,0,0,0],
	[0,0,0,0,0,0,0,4,0,0],
	[0,0,1,0,0,10,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,1,7,0,0,1,0,0],
	[0,0,0,0,1,0,0,0,1,1],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0]
]
start = "a"
scopuri = ["f"]
#exemplu de euristica banala (1 daca nu e nod scop si 0 daca este)
vect_h = [0,10,3,7,8,0,14,3,1,2]

gr=Graph(noduri, m, mp, start, scopuri, vect_h)
NodParcurgere.graf = gr






def aStarOptimized(gr):
    l_open = PriorityQueue([NodParcurgere(gr.noduri.index(gr.start), gr.start, None, 0, gr.calculeaza_h(gr.start))])

    l_closed = []

    count_open = 0
    count_closed = 0

    while not l_open.empty():
        print("Coada actuala: ", str(l_open.elements))
        nodCurent = l_open.pop()

        if gr.testeaza_scop(nodCurent):
            print("Solutie: ", end="")
            nodCurent.afisDrum()
            print("Open ", count_open)
            print("Closed: ", count_closed)
            return

        lSuccesori = gr.genereazaSuccesori(nodCurent)
        for s in lSuccesori:
            gasitC = False

            for nodC in l_open.elements:
                if s.info == nodC.info:
                    gasitC = True
                    if s.f >= nodC.f:
                        lSuccesori.remove(s)
                    else:
                        l_open.delete(nodC)
                        print("Nod inlocuit: ", nodC.info)
                        count_open += 1
                    break
            
            if not gasitC:
                for nodC in l_closed:
                    if s.info == nodC.info:
                        if s.f >= nodC.f:
                            lSuccesori.remove(s)
                        else:
                            l_closed.remove(nodC)
                            print("Nod inlocuit: ", nodC.info)
                            count_closed += 1
                        break

        l_closed.append(nodCurent)
        for s in lSuccesori:
            l_open.push(s)



aStarOptimized(gr)