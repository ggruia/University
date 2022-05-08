import copy
import itertools
import utils



class Node():
    """
    class Node:

    - param list config: N x M matrix - stores map cell heights
    - param list ants: list of tuples (X, Y) - coordinates of K agents
    - param Node parent: Node - reference to the node that generated "self"
    - param int cost: integer - total cost until the creation of "self"
    - param int estimate: integer - estimate until solution is found
    """

    nrAnts = 0
    diff = 0
    colony = None


    def __init__(self, config, ants, parent=None, cost=0, estimate=0):
        self.depth = parent.depth + 1 if parent else 1
        self.config = config
        self.ants = ants
        self.parent = parent
        self.cost = cost
        self.estimate = estimate
        self.total = self.cost + self.estimate

    def __repr__(self):
        """
        function __repr__:
            String representation of <class Node> objects
            
        :template:

        0)\n
        Furnica de la (0, 0) s-a mutat la (0, 0)\n
        Furnica de la (0, 0) s-a mutat la (0, 0) cu bob\n
        f0 1 0 1\n
        1 0 1 0\n
        0 1 0 1\n
        1 0 1 0\n
        
        :return str: string representation of <class Node> object
        """
        
        rep = f"{self.depth})\n"
        if self.parent:
            for i, ant in enumerate(self.ants):
                pAnt = self.parent.ants[i]
                if ant != pAnt:
                    if self.config != self.parent.config:
                        rep += f"Furnica de la {pAnt} s-a deplasat la {ant} cu bob\n"
                    else:
                        rep += f"Furnica de la {pAnt} s-a deplasat la {ant}\n"
        for i, line in enumerate(self.config):
            rep += " ".join([f"f{x}" if (i, j) in self.ants else f"{x}" for j, x in enumerate(line)]) + "\n"
        return rep

    def __lt__(self, other):
        if self.total < other.total:
            return True
        elif self.total == other.total and self.cost > other.cost:
            return True
        return False

    def __eq__(self, other):
        if self.config == other.config and self.ants == other.ants:
            return True
        return False

    def __contains__(self, other):
        current = self
        while current:
            if current == other:
                return True
            current = current.parent
        return False


    def printPath(self):
        if self.parent is None:
            return f"{self}\n"
        return self.parent.printPath() + f"{self}\n"



    def getSuccessors(self, heuristic="obvious"):
        """
        class Node function:
            Generates every node that can be created from self, with regard to heuristics and limitations:

                - diff
                - cost
                - distance

        :return list: list of <Node objects>, children of self
        """

        # Cele 4 directii posibile in ordine: [Sus, Dreapta, Jos, Stanga]
        moves = [(-1, 0), (0, 1), (1, 0), (0, -1)]

        # Verifica in care dintre cele 4 directii se poate misca furnica:
        availableMatrix = utils.fill(self.config, self.ants, __class__.diff)
        validMoves = [[] for _ in self.ants]
        for id, (xAnt, yAnt) in enumerate(self.ants):
            for move in moves:
                i, j = move
                xNew = xAnt + i
                yNew = yAnt + j
                if (self.isValidPosition((xNew, yNew))
                    and availableMatrix[xNew][yNew]
                    and abs(self.config[xAnt][yAnt] - self.config[xNew][yNew]) <= __class__.diff):
                        validMoves[id].append(((xNew, yNew), False))
                        if self.config[xAnt][yAnt]:
                            validMoves[id].append(((xNew, yNew), True))

        successors = []
        moves = list(itertools.product(*validMoves))
        for move in moves:
            matrix = copy.deepcopy(self.config)
            antsConfig = []
            cost=0
            for i in range(len(self.ants)):
                ant = move[i][0]
                prevAnt = self.ants[i]
                withBlock = move[i][1]
                antsConfig.append(ant)
                if withBlock:
                    matrix[prevAnt[0]][prevAnt[1]] -= 1
                    matrix[ant[0]][ant[1]] += 1
                    if self.isInColony(prevAnt):
                        cost += 1
                    else:
                        cost += utils.manhattanDistance(ant, __class__.colony) * (abs(matrix[prevAnt[0]][prevAnt[1]] - matrix[ant[0]][ant[1]]) + 1)
                else:
                    cost += utils.manhattanDistance(ant, __class__.colony)
            if Node(matrix, antsConfig) not in self:
                successors.append(Node(matrix, antsConfig, self, self.cost + cost, self.getScore(matrix, antsConfig, heuristic)))
        return successors



    def remainingInColony(self, matrix):
        d = list(itertools.product([-1, 0, 1], repeat=2))
        d = [(__class__.colony[0] + i, __class__.colony[1] + j) for (i, j) in d]
        count = 0
        for x, y in d:
            if self.isValidPosition((x, y)):
                count += matrix[x][y]
        return count

    def isInColony(self, pos):
        d = list(itertools.product([-1, 0, 1], repeat=2))
        d = [(__class__.colony[0] + i, __class__.colony[1] + j) for (i, j) in d]
        for x, y in d:
            if self.isValidPosition((x, y)):
                if pos in d:
                    return True
        return False

    def isFinal(self):
        if self.remainingInColony(self.config):
            return False
        return True
    
    def isBlocked(self):
        """
        class Node function:
            Checks if the subtree of self leads to any valid configurations

        :return bool: true or false value if subtree is blocked or not
        """

        d = list(itertools.product([-1, 0, 1], repeat=2))
        d = [(__class__.colony[0] + i, __class__.colony[1] + j) for (i, j) in d]
        available = utils.fill(self.config, self.ants, __class__.diff)
        for x, y in d:
            if self.isValidPosition((x, y)):
                if available[x][y]:
                    return False
        return True

    def isValidPosition(self, pos):
        i, j = pos
        if 0 <= i < len(self.config) and 0 <= j < len(self.config[0]):
            return True
        return False



    def getScore(self, matrix, ants, heuristic = "obvious"):
        """
        class Node function:
            Assigns a score to the node, based on a chosen heuristic, an estimate of cost left until a solution is found
        
        :param list matrix: heights of towers from each cell
        :param list ants: list of tuples; represents position of each agent in node.config
        :param str heuristic: string that will match the case; represents a strategy in computing the estimate cost

        - Euristica TRIVIALA:
            0 daca starea este finala, 1 altfel;
            Aceasta euristica genereaza cel mai mare numar de mutari dintre toate euristicile,
            pana se ajunge la starea scop.
        
        - Euristica ADMISIBILA 1:
            Minimul dintre Distantele Manhattan (Di) de la furnica 'i' pana la musuroi,
            adunat la dublul numarului de boabe de nisip ramase in musuroi:
                min([Di]) + 2 * nrBoabeRamase;
            Aceasta euristica forteaza furnica cea mai apropiata de musuroi sa mute cat mai multe boabe.

        - Euristica ADMISIBILA 2:
            Maximul dintre Distantele Manhattan (Di) de la furnica 'i' pana la musuroi,
            adunat la dublul numarului de boabe de nisip ramase in musuroi:
                max([Di]) + 2 * nrBoabeRamase;
            Aceasta euristica forteaza si furnicile cele mai departate de musuroi sa mute cat mai multe boabe.

        - Euristica INADMISIBILA:
            Aceasta euristica estimeaza distanta de la furnica la musuroi ca fiind semiperimetrul matricei.

        :return int: estimate based on heuristic
        """

        match heuristic:
            case "obvious":
                return 0 if self.isFinal else 1
            case "first":
                distances = [utils.manhattanDistance(ant, __class__.colony) for ant in ants]
                return min(distances) + 2 * self.remainingInColony(matrix)
            case "second":
                distances = [utils.manhattanDistance(ant, __class__.colony) for ant in self.ants]
                return max(distances) + 2 * self.remainingInColony(matrix)
            case _:
                rows = len(self.config)
                cols = len(self.config[0])
                return rows + cols + 2 * self.remainingInColony(matrix)