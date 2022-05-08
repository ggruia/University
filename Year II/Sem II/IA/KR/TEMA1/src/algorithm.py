from queue import Queue, PriorityQueue, LifoQueue
from solution import Solution
import time
from stopit import threading_timeoutable as timeout



@timeout(default="A* timed out!\n")
def aStar(outputFile, startNode, nrSolutions=1, heuristic="obvious"):
    fout = open(outputFile, "w")
    states = PriorityQueue()
    states.put(startNode)

    if startNode.isBlocked():
        fout.write("NO SOLUTION EXISTS!\n")
        return
    
        
    Solution.startTime = time.time()
    nrInstances = 1
    instancesInCollection = 1
    maxInstances = 1

    while not states.empty():
        current = states.get()
        instancesInCollection -= 1

        if current.isFinal():
            sol = Solution(current, nrInstances, maxInstances)
            fout.write(str(sol))
            nrSolutions -= 1
            if not nrSolutions:
                return

        successors = current.getSuccessors(heuristic)
        for s in successors:
            states.put(s)

        nrInstances += len(successors)
        instancesInCollection += len(successors)
        maxInstances = max(maxInstances, instancesInCollection)
    fout.close()



@timeout(default="Optimised A* timed out!\n")
def aStarOpt(outputFile, startNode, heuristic="obvious"):
    fout = open(outputFile, "w")
    openStates = PriorityQueue()
    openStates.put(startNode)
    closedStates = Queue()
    
    if startNode.isBlocked():
        fout.write("NO SOLUTION EXISTS!\n")
        return
    

    Solution.startTime = time.time()
    nrInstances = 1
    instancesInCollection = 1
    maxInstances = 1

    while not openStates.empty():
        current = openStates.get()
        closedStates.put(current)

        if current.isFinal():
            sol = Solution(current, nrInstances, maxInstances)
            fout.write(str(sol))
            return

        successors = current.getSuccessors(heuristic)
        for s in successors:
            foundNode = False
            for node in openStates.queue:
                if s == node:
                    foundNode = True
                    if s.total >= node.total:
                        successors.remove(s)
                    else:
                        openStates.queue.remove(node)
                    break
            if not foundNode:
                for node in closedStates.queue:
                    if s == node:
                        if s.total >= node.total:
                            successors.remove(s)
                        else:
                            closedStates.queue.remove(node)
                        break
        for s in successors:
            openStates.put(s)

        nrInstances += len(successors)
        instancesInCollection += len(successors)
        maxInstances = max(maxInstances, instancesInCollection)
    fout.close()



@timeout(default="BFS timed out!\n")
def BFS(outputFile, startNode, nrSolutions=1):
    fout = open(outputFile, "w")
    states = Queue()
    states.put(startNode)

    if startNode.isBlocked():
        fout.write("NO SOLUTION EXISTS!\n")
        return
    
        
    Solution.startTime = time.time()
    nrInstances = 1
    instancesInCollection = 1
    maxInstances = 1

    while not states.empty():
        current = states.get()
        instancesInCollection -= 1

        if current.isFinal():
            sol = Solution(current, nrInstances, maxInstances)
            fout.write(str(sol))
            nrSolutions -= 1
            if not nrSolutions:
                return

        successors = current.getSuccessors()
        for s in successors:
            states.put(s)

        nrInstances += len(successors)
        instancesInCollection += len(successors)
        maxInstances = max(maxInstances, instancesInCollection)
    fout.close()



@timeout(default="DFS timed out!\n")
def DFS(outputFile, startNode, nrSolutions=1):
    fout = open(outputFile, "w")
    states = LifoQueue()
    states.put(startNode)

    if startNode.isBlocked():
        fout.write("NO SOLUTION EXISTS!\n")
        return
    
        
    Solution.startTime = time.time()
    nrInstances = 1
    instancesInCollection = 1
    maxInstances = 1

    while not states.empty():
        current = states.get()
        instancesInCollection -= 1

        if current.isFinal():
            sol = Solution(current, nrInstances, maxInstances)
            fout.write(str(sol))
            nrSolutions -= 1
            if not nrSolutions:
                return

        successors = current.getSuccessors()
        for s in successors:
            states.put(s)

        nrInstances += len(successors)
        instancesInCollection += len(successors)
        maxInstances = max(maxInstances, instancesInCollection)
    fout.close()