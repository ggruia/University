import cProfile
from queue import Queue



# TEMA:
# 1. Optimizare BF astfel incat sa afiseze un drum chiar in momentul in care se adauga nodul scop in coada. 

# 2. Implementati BF folosind un obiect de tip Queue din Python si afisati toate solutiile.
# Scoateti apelurile de tip input din programul dat la laborator.
# Comparati cu cProfile programul vostru  si cel dat la laborator.
# Ce structura e mai eficienta?
# Observatie: daca diferentele de timp sunt prea mici, mariti numarul de noduri si de muchii in matricea de adiacenta.

# 3. Sa se afiseze la DF la fiecare expandare nodul expandat si stiva actuala si textul "se intoarce ->" pentru fiecare eliminare de nod din stiva 

# 4. Generati un graf aleator cu un numar mai mare de noduri (dar nu foarte mare), de exemplu N=20 noduri si un numar mare (dar nu foarte mare) de muchii/arce, de exemplu M=200.
# Nodul 0 va fi nodul start.
# Alegeti aleator S noduri scop (de exemplu S=5).
# Implementati algorimul DF in mod nerecursiv folosind o stiva. Folositi in implementare:
# a) o lista pe post de stiva
# b) deque din modulul collections
# c) LifoQueue din modulul queue
# -eventual inca un mod propriu de rezolvare

# Folositi cProfiler pentru a analiza performanta pentru cele 3 moduri de implementare, impreuna cu cel de la laborator.
# Care este cel mai eficient?

# 5. La afisarea solutiei pt DFI, afisati pentru fiecare nod din graf de cate ori a fost extins in total (practic din cate iteratii a facut parte).
# Puteti folosi un dictionar sau Counter.



class Node:
    def __repr__(self):
        node = self.alias
        node += "("
        node += "id = {} | ".format(self.id)
        node += "path = "
        node += " -> ".join(self.getPath())
        node += ")"
        return(node)

    def __init__(self, id, alias, parent):
        self.id = id
        self.alias = alias
        self.parent = parent

    def getPath(self):
        l = [self.alias]
        currentNode = self
        while currentNode.parent is not None:
            l.insert(0, currentNode.parent.alias)
            currentNode = currentNode.parent
        return l
        
    def printPath(self):
        path = self.getPath()
        print(" -> ".join(path))
        return len(path)


    def isNodeInPath(self, newNodeAlias):
        currentNode = self
        while currentNode is not None:
            if(newNodeAlias == currentNode.alias):
                return True
            currentNode = currentNode.parent
        return False



class Graph:
    def __repr__(self):
        graph = ""
        for (k,v) in self.__dict__.items() :
            graph += "{} = {}\n".format(k,v)
        return(graph)

    def __init__(self, nodeLabels, adjacencyMatrix, initialState, finalStates):
        self.nodeLabels = nodeLabels
        self.adjacencyMatrix = adjacencyMatrix
        self.nrNodes = len(adjacencyMatrix)
        self.initialState = initialState
        self.finalStates = finalStates

    def nodeIndex(self, n):
        return self.nodeLabels.index(n)

    def generateSuccessors(self, currentNode):
        successors = []

        for i in range(self.nrNodes):
            if self.adjacencyMatrix[currentNode.id][i] == 1 and not currentNode.isNodeInPath(self.nodeLabels[i]):
                s = Node(i, self.nodeLabels[i], currentNode)
                successors.append(s)
        return successors
        
    def testFinalState(self, currentNode):
        return currentNode.alias in self.finalStates
    



##############################################################################################	
#                                 Initializare problema                                      #
##############################################################################################		
		
nodeLabels = ["a","b","c","d","e","f","g","h","i","j"]
initialState = "a"
finalStates = ["f", "j"]
adjacencyMatrix = [
    [0,1,0,1,1,0,0,0,0,0],
	[1,0,1,0,0,1,0,0,0,0],
	[0,1,0,0,0,1,0,1,0,0],
    [1,0,0,0,0,0,1,0,0,0],
    [1,0,0,0,0,0,0,1,0,0],
    [0,1,1,0,0,0,0,0,0,0],
    [0,0,0,1,0,0,0,0,0,0],
    [0,0,1,0,1,0,0,0,1,1],
    [0,0,0,0,0,0,0,1,0,0],
    [0,0,0,0,0,0,0,1,0,0]]

gr = Graph(nodeLabels, adjacencyMatrix, initialState, finalStates)



#### algoritm BF
#presupunem ca vrem mai multe solutii (un numar fix) prin urmare vom folosi o variabilă numită nrSolutiiCautate
#daca vrem doar o solutie, renuntam la variabila nrSolutiiCautate
#si doar oprim algoritmul la afisarea primei solutii

def BFS (gr, nrSolutions = 1):
    c = [Node(gr.nodeLabels.index(gr.initialState), gr.initialState, None)]
    print("Coada actuala: " + str(c))


    while len(c) > 0:
        successors = gr.generateSuccessors(c.pop(0))
        c.extend(successors)
        print("Coada actuala: " + str(c))

        for s in successors:
            if gr.testFinalState(s):
                print("Solutie:")
                s.printPath()
                nrSolutions -= 1
                if nrSolutions == 0:
                    return


def queueBFS (gr, nrSolutions = 1):
    c = Queue()
    c.put(Node(gr.nodeLabels.index(gr.initialState), gr.initialState, None))

    print("Solutions:")

    while not c.empty():
        currentNode = c.get()

        if gr.testFinalState(currentNode):
            currentNode.printPath()
            nrSolutions -= 1
            if nrSolutions == 0:
                return

        successors = gr.generateSuccessors(currentNode)
        for s in successors:
            c.put(s)


def DFS (gr, nrSolutions = 1):
	DF(Node(gr.nodeLabels.index(gr.initialState), gr.initialState, None), nrSolutions)

				
def DF(currentNode, nrSolutions):
    print(currentNode.parent, "Expandeaza ->", currentNode)
    if nrSolutions <= 0:
        return nrSolutions

    print("Stiva actuala: " + " -> ".join(currentNode.getPath()))
    if gr.testFinalState(currentNode):
        print("Solutie: ", end = "")
        currentNode.printPath()
        print("\n----------------\n")
        nrSolutions -= 1
        if nrSolutions == 0:
            return nrSolutions

    successors = gr.generateSuccessors(currentNode)	
    for s in successors:
        if nrSolutions != 0:
            nrSolutions = DF(s, nrSolutions)

    print(currentNode, "Se intoarce ->", currentNode.parent)
    return nrSolutions



def DFI(currentNode, maxDepth, nrSolutions, dict):
    dict[currentNode.alias] += 1
    print("Stiva actuala: " + " -> ".join(currentNode.getPath()))

    if maxDepth == 1 and gr.testFinalState(currentNode):
        print("Solutie: ", end = "")
        currentNode.printPath()
        print(dict)
        print("\n----------------\n")
        nrSolutions -= 1
        if nrSolutions == 0:
            return nrSolutions
    if maxDepth > 1:
        successors = gr.generateSuccessors(currentNode)	
        for s in successors:
            if nrSolutions != 0:
                nrSolutions = DFI(s, maxDepth - 1, nrSolutions, dict)
    return nrSolutions

def DFSI(gr, nrSolutions = 1):
    for depth in range(gr.nrNodes):
        if nrSolutions == 0:
            return
        
        print("**************\nAdancime maxima: ", depth + 1)
        countDict = {}.fromkeys(gr.nodeLabels, 0)
        nrSolutions = DFI(Node(gr.nodeLabels.index(gr.initialState), gr.initialState, None), depth + 1, nrSolutions, countDict)



#BFS(gr, nrSolutions = 4)
#cProfile.run("BFS(gr, nrSolutions = 4)")

#DFS(gr, nrSolutions = 5)
#cProfile.run("DFS(gr, nrSolutions = 5)")

DFSI(gr, nrSolutions = 4)