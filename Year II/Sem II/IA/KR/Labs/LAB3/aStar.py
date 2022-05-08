from queue import PriorityQueue



class Node:
    graph = None

    def __init__(self, id, info, parinte, cost, h):
        self.id = id
        self.info = info
        self.parinte = parinte
        self.g = cost
        self.h = h
        self.f = self.g + self.h
    
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
        l = [self.info]
        nod = self
        while nod.parinte is not None:
            l.insert(0, nod.parinte.info)
            nod = nod.parinte
        return l
    
    def afisDrum(self):
        l = self.obtineDrum()
        print(" -> ".join(l), " (cost: {})\n".format(self.g))
        return len(l)


    def contineInDrum(self, infoNodNou):
        nodDrum = self
        while nodDrum is not None:
            if(infoNodNou == nodDrum.info):
                return True
            nodDrum = nodDrum.parinte
        return False


    def __repr__(self):
        drum = self.obtineDrum()
        sir = str(self.info)
        sir += "(id = {}, ".format(self.id)
        sir += "drum = "
        sir += " -> ".join(drum)
        sir += " g: {}".format(self.g)
        sir += " h: {}".format(self.h)
        sir += " f: {})".format(self.f)
        return sir


class Graph:
    def __init__(self, nodeLabels, adjacencyMatrix, costs, initialState, finalStates, estimativeRemainingDistance):
        self.nodeLabels = nodeLabels
        self.adjacencyMatrix = adjacencyMatrix
        self.costuri = costs
        self.nrnodeLabels = len(adjacencyMatrix)
        self.initialState = initialState
        self.finalStates = finalStates
        self.estimativeRemainingDistance = estimativeRemainingDistance

    def indiceNod(self, n):
        return self.nodeLabels.index(n)
        
    def testeaza_scop(self, nodCurent):
        return nodCurent.info in self.finalStates

    def genereazaSuccesori(self, nodCurent):
        listaSuccesori = []
        for i in range(self.nrnodeLabels):
            if self.adjacencyMatrix[nodCurent.id][i] == 1 and not nodCurent.contineInDrum(self.nodeLabels[i]):
                nodNou = Node(i, self.nodeLabels[i], nodCurent, nodCurent.g + self.costuri[nodCurent.id], self.calculeaza_h(self.nodeLabels[i]))
                listaSuccesori.append(nodNou)
        return listaSuccesori

    def calculeaza_h(self, infoNod):
        return self.estimativeRemainingDistance[self.indiceNod(infoNod)]

    def __repr__(self):
        sir = ""
        for (k,v) in self.__dict__.items() :
            sir += "{} = {}\n".format(k,v)
        return(sir)
		
		

##############################################################################################	
#                                 Initializare problema                                      #
##############################################################################################		
		
nodeLabels = ["a","b","c","d","e","f","g","i","j","k"]
initialState = "a"
finalStates = ["f"]

adjacencyMatrix = [
	[0, 1, 1, 1, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 1, 1, 0, 0, 0, 0],
	[0, 0, 0, 0, 1, 0, 1, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
	[0, 0, 1, 0, 0, 1, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 1, 1, 0, 0, 1, 0, 0],
	[0, 0, 1, 0, 1, 0, 0, 0, 1, 1],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

cost = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
estimativeRemainingDistance = [0, 10, 3, 7, 8, 0, 14, 3, 1, 2]

gr = Graph(nodeLabels, adjacencyMatrix, cost, initialState, finalStates, estimativeRemainingDistance)
Node.graph = gr



def a_star(gr, nrSolutiiCautate):
    c = PriorityQueue()
    c.put(Node(gr.indiceNod(gr.initialState), gr.initialState, None, cost[gr.indiceNod(gr.initialState)], gr.calculeaza_h(gr.initialState)))

    while not c.empty():
        print("Coada actuala: ", str(c.queue))
        nodCurent = c.get()
        
        if gr.testeaza_scop(nodCurent):
            nodCurent.afisDrum()
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                return

        lSuccesori = gr.genereazaSuccesori(nodCurent)	
        for s in lSuccesori:
            c.put(s)



a_star(gr, nrSolutiiCautate = 3)