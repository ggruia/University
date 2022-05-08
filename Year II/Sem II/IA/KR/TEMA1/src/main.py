import utils
import algorithm
from node import Node


inputFile = "inputs/input3.txt"
outputFile = "outputs/output3.txt"


nrAnts, ants, config, colony, diff = utils.parseInput(inputFile)
availableMatrix = utils.fill(config, ants, diff)

Node.nrAnts = nrAnts
Node.colony = colony
Node.diff = diff


# messageAStar = algorithm.aStar(outputFile, Node(config, ants), 3, "first", timeout=30)
# if messageAStar:
#     print(messageAStar)


# messageAStarOpt = algorithm.aStarOpt(outputFile, Node(config, ants), "first", timeout=30)
# if messageAStarOpt:
#     print(messageAStarOpt)


# messageBFS = algorithm.BFS(outputFile, Node(config, ants), timeout=30)
# if messageBFS:
#     print(messageBFS)


# messageDFS = algorithm.DFS(outputFile, Node(config, ants), timeout=30)
# if messageDFS:
#     print(messageDFS)