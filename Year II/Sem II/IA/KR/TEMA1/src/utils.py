def parseInput(filename):
    """
    Parseaza inputul din fisierul de intrare si stocheaza datele globale necesare:
        - nrFurnici
        - pozitiile initiale ale furnicilor
        - configuratia initiala a matricei
        - pozitia coloniei de furnici
        - diferenta maxima dintre 2 turnuri intre care se poate misca o furnica
    """
    fin = open(filename, "r")

    nrAnts = int(fin.readline().strip().split()[0][3:])
    antList = [tuple(int(x) for x in fin.readline().strip().split()) for _ in range(nrAnts)]
    diffMax = int(fin.readline().strip().split()[0][4:])
    colonyPosition = tuple(int(f) for f in fin.readline().strip().split())
    colonyLayout = [list(map(lambda x: int(x), line.strip().split())) for line in fin.readlines()]

    return (nrAnts, antList, colonyLayout, colonyPosition, diffMax)



def fill(matrix, ants, diff):
    """
    Implementare a algoritmului FILL pe matrice folosind DFS;
    Returneaza o matrice de elemente din {0, 1}, cu semnificatia:
        - 0: pozitie inaccesibila
        - 1: pozitie accesibila de cel putin o furnica
    """

    rows, cols = (len(matrix), len(matrix[0]))
    d = [(0, -1), (1, 0), (0, 1), (-1, 0)]
    availableMatrix = [[0 for _ in range(cols)] for _ in range(rows)]
    visited = [[False for _ in range(cols)] for _ in range(rows)]

    def validPos(i, j):
        if 0 <= i < rows and 0 <= j < cols and not visited[i][j]:
            return True
        return False

    def dfs(pos, matrix, visited):
        x, y = pos
        visited[x][y] = True
        availableMatrix[x][y] = 1
    
        for p in d:
            xNext = x + p[0]
            yNext = y + p[1]
            if validPos(xNext, yNext) and abs(matrix[x][y] - matrix[xNext][yNext]) <= diff:
                dfs((xNext, yNext), matrix, visited)

    for a in ants:
        dfs(a, matrix, visited)
    return availableMatrix


def manhattanDistance (start, final):
    xS, yS = start
    xF, yF = final
    dist = abs(xF- xS) + abs(yF - yS)
    return dist