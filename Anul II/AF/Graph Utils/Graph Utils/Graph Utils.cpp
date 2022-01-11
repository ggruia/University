#include <iostream>
#include <fstream>
#include <vector>
#include <stack>
#include <queue>
#include <algorithm>
#include <climits>
using namespace std;

constexpr int INF = INT_MAX;
constexpr bool Directed = true, unDirected = false, Weighted = true, unWeighted = false, Flowing = true, unFlowing = false;


ifstream fin("input");
ofstream fout("output");



struct Edge
{
    // easier, cleaner and more expandable alternative to using a tuple for Storing sourceNodes, destinationNodes, weights, capacities etc...

    int src;
    int dest;
    int cost;
    struct flow
    {
        int curfl;
        int maxfl;
    } cap;


    Edge ()
    {
        src = 0;
        dest = 0;
        cost = 0;
        cap.curfl = 0;
        cap.maxfl = 0;
    }

    Edge(int s, int d, int c = 0, int mf = 0, int cf = 0)
    {
        src = s;
        dest = d;
        cost = c;
        cap.maxfl = mf;
        cap.curfl = cf;
    }

    Edge getReverse()
    {
        Edge revEdge(dest, src, cost, cap.maxfl, cap.curfl);
        return revEdge;
    }

    bool operator< (const Edge& edge) const
    {
        return cost < edge.cost;
    }
};



class Graph
{
    // Implementation of  << UTILITARY Functions >>  for (UN)Directed, (UN)Weighted & (UN)Flowing  << Graphs >> ;

    bool isDirected;
    bool isWeighted;
    bool isFlowing;

    int nrNodes;
    int nrEdges;

    vector<vector<Edge>> adjacencyList;


public:

    // Graph constructor with default params
    Graph(int n = 0, int m = 0, bool d = false, bool w = false, bool f = false) : nrNodes(n), nrEdges(m), isDirected(d), isWeighted(w), isFlowing(f) {}

    // reads and creates the adjacency list from input file
    void readAdjacencyList();

    // prints the adjacency list to output file
    void printAdjacencyList();

    // reads and creates the adjacency matrix from input file
    void readAdjacencyMatrix();

    // prints the adjacency matrix (with cost as printed value) to output file
    void printAdjacencyMatrix();

    // converts the adjacency matrix to adjacency list
    vector<vector<Edge>> getAdjacencyListFromMatrix(vector<vector<int>>& adjMatrix);

    // converts the adjacency list to adjacency matrix
    vector<vector<int>> getAdjacencyMatrixFromList(vector<vector<Edge>>& adjList);

    // adds a new edge to graph
    void addEdge(Edge edge);

    // removes an edge (defined by source and destination) from graph; provided that there can be only one edge from node A to node B
    void removeEdge(int src, int dst);


    // returns the shortest distances from one node to all other nodes;
    // wrapper that calls BFS
    vector<int> getUnweightedDistances(int startingNode);

    // returns the number of connected components of an undirected graph
    // wrapper that calls DFS
    vector<vector<int>> getConnectedComponents();

    // returns the list of strongly connected components of a directed graph
    // wrapper that calls TarjanDFS (implementation of Tarjan's algorithm, used for finding SCCs)
    vector<vector<int>> getStronglyConnectedComponents();

    // returns the list of biconnected components of a graph
    // wrapper that calls BiconnectedDFS (modification of Tarjan's algorithm, used for finding BCCs)
    vector<vector<int>> getBiconnectedComponents();

    // returns the list of critical edges (as a pair of [source, destination]) of an undirected graph
    // wrapper that calls CriticalEdgesDFS (modification of Tarjan's algorithm, used for finding Critical Edges)
    vector<pair<int, int>> getCriticalEdges();

    // returns the topological order list
    // wrapper that calls TopologicalOrderDFS (modification of DFS, used for finding a topological traversal through a graph) 
    deque<int> getTopologicalOrder();

    // returns TRUE if the degree sequence is graphical; FALSE otherwise
    // wrapper that calls HavelHakimi
    bool getValidGraph();

    // implements the disjoint sets data structure
    // wrapper that calls Union and Find in conjunction, used for searching and merging disjoint sets of edges
    void disjointSetsWrapper(int nrOp);

    // implements Bellman-Ford or Dijkstra
    // wrapper that calls Dijkstra if there are no edges with negative weights, Bellman-Ford otherwise
    vector<int> getWeightedDistances(int startingNode);

    // returns the list of edges (as a pair of [source, destination]) that form the minimum spanning tree associated to the graph
    // wrapper that calls Kruskal (implementation of Kruskal's algorithm using disjoint sets DS, used for finding the MST of a graph)
    vector<pair<int, int>> getMinimumSpanningTree(int& minimumCost);

    // computes the diameter (longest chain) of the tree associated to the graph
    // runs 2 BFSs, and computes the longest distance between 2 nodes in a tree
    int getTreeDiameter();

    // implements Roy-Floyd-Warshall algorithm for finding the shortest distances between all nodes
    // wrapper that calls Roy-Floyd and returns the shortest distances matrix
    vector<vector<int>> getAllMinimumDistances();

    // implements Edmonds-Karp algorithm used for finding the maximum flow in a flow network
    // wrapper that calls CheckAugmentingPath and stores a flow network as an adjacency matrix
    int getMaxFlow(int source, int sink);

    // implements a modified DFS that returns the eulerian chain of a graph (if possible)
    // wrapper that calls EulerianCycleDFS (modification of DFS, every edge has an ID, making it possible to store multiple edges with the same source and destination)
    // !!! before using this method, graph must be Weighted and reading must be changed to accomodate IDs in place of weights !!!
    vector<int> getEulerianCycle();


private:

    void BFS(int startingNode, vector<int>& dist);

    void DFS(int currentNode, vector<bool>& isVisited, vector<int>& connectedComponent);

    void TarjanDFS(int currentNode, vector<int>& discOrder, vector<int>& lowLink, stack<int>& path, vector<bool>& onStack, vector<vector<int>>& SCClist);

    void BiconnectedDFS(int currentNode, int currentLevel, vector<int>& level, vector<int>& lowLink, stack<int>& path, vector<vector<int>>& BCClist);

    void CriticalEdgesDFS(int startingNode, int previous, vector<int>& discOrder, vector<int>& lowLink, vector<pair<int, int>>& CElist);

    void TopologicalOrderDFS(int startingNode, vector<bool>& isVisited, deque<int>& TOlist);

    void HavelHakimi(vector<int>& degrees, bool& valid);

    int Find(int targetNode, vector<int>& parent);

    void Union(int targetNode1, int targetNode2, vector<int>& parent);

    void Dijkstra(int startingNode, vector<int>& dist);

    void BellmanFord(int startingNode, vector<int>& dist);

    void Kruskal(int& minimumCost, vector<Edge>& edgeList, vector<int>& parent, vector<pair<int, int>>& MSTlist);

    void RoyFloyd(vector<vector<int>>& distanceMatrix);

    bool CheckAugmentingPath(int source, int sink, vector<int>& parent, vector<bool>& isVisited, vector<vector<Edge>>& flowNetwork);

    void EulerianCycleDFS(int startingNode, vector<bool>& visitedEdges, vector<int>& EClist);
};



#pragma region Definitions

void Graph :: readAdjacencyList()
{
    adjacencyList.resize(nrNodes + 1);


    for (int i = 0; i < nrEdges; i++)
    {
        Edge edge;
        fin >> edge.src >> edge.dest;

        if (isWeighted)
            fin >> edge.cost;
            //edge.cost = i + 1;

        if (isFlowing)
            fin >> edge.cap.maxfl;


        addEdge(edge);
        nrEdges--;
    }
}

void Graph :: printAdjacencyList()
{
    fout << "\n>   nrNodes = " << nrNodes;
    fout << "\n>   nrEdges = " << nrEdges;

    fout << "\n\n\n>   The ADJACENCY LIST associated to the ";
    isDirected ? fout << "DIRECTED" : fout << "UNDIRECTED";
    isWeighted ? fout << ", WEIGHTED" : fout << ", UNWEIGHTED";
    fout << " graph <G>:";

    for (int i = 1; i <= nrNodes; i++)
        if (adjacencyList[i].size())
        {
            fout << "\n\nNode " << i << ":\n";
            for (auto& edge : adjacencyList[i])
            {
                fout << edge.src << " ---> " << edge.dest;
                if (isWeighted && isFlowing)
                    fout << "  (" << edge.cost << ", " << edge.cap.maxfl << ")";
                else if (isWeighted)
                    fout << "  |" << edge.cost << "|";
                else if (isFlowing)
                    fout << "  /" << edge.cap.maxfl << "/";
                fout << "\n";
            }
        }
}

void Graph :: readAdjacencyMatrix()
{
    int edgeCount = 0;
    adjacencyList.resize(nrNodes + 1);

    for (int i = 1; i <= nrNodes; i++)
        for (int j = 1; j <= nrNodes; j++)
        {
            int val;
            fin >> val;

            if (val)
            {
                edgeCount++;

                if (isWeighted)
                {
                    Edge e(i, j, val);
                    adjacencyList[i].push_back(e);
                }
                else if (isWeighted)
                {
                    Edge e(i, j, 0, val, 0);
                    adjacencyList[i].push_back(e);
                }
                else
                {
                    Edge e(i, j);
                    adjacencyList[i].push_back(e);
                }
            }
        }

    nrEdges = edgeCount;
}

void Graph :: printAdjacencyMatrix()
{
    fout << "\n>   nrNodes = " << nrNodes;
    fout << "\n>   nrEdges = " << nrEdges;

    fout << "\n\n\n>   The ADJACENCY MATRIX associated to the ";
    isDirected ? fout << "DIRECTED" : fout << "UNDIRECTED";
    isWeighted ? fout << ", WEIGHTED" : fout << ", UNWEIGHTED";
    fout << " graph <G>:\n\n\n";

    vector<vector<int>> adjacencyMatrix = getAdjacencyMatrixFromList(adjacencyList);

    for (int i = 1; i <= nrNodes; i++)
    {
        for (int j = 1; j <= nrNodes; j++)
            fout << adjacencyMatrix[i][j] << " ";
        fout << "\n";
    }
}

vector<vector<Edge>> Graph :: getAdjacencyListFromMatrix(vector<vector<int>>& adjacencyMatrix)
{
    vector<vector<Edge>> adjList(nrNodes + 1);

    for (int i = 1; i <= nrNodes; i++)
        for (int j = 1; j <= nrNodes; j++)
        {
            if (adjacencyMatrix[i][j])
            {
                if (isWeighted)
                {
                    Edge e(i, j, adjacencyMatrix[i][j]);
                    adjacencyList[i].push_back(e);
                }
                else if (isFlowing)
                {
                    Edge e(i, j, 0, adjacencyMatrix[i][j], 0);
                    adjacencyList[i].push_back(e);
                }
                else
                {
                    Edge e(i, j);
                    adjacencyList[i].push_back(e);
                }
            }
        }

    return adjList;
}

vector<vector<int>> Graph :: getAdjacencyMatrixFromList(vector<vector<Edge>>& adjList)
{
    vector<vector<int>> adjMatrix(nrNodes + 1);
    for (auto& line : adjMatrix)
    {
        line.resize(nrNodes + 1);
        fill(line.begin(), line.end(), 0);
    }

    for (auto& node : adjList)
        for (auto& edge : node)
        {
            if(isWeighted)
                adjMatrix[edge.src][edge.dest] = edge.cost;
            else if(isFlowing)
                adjMatrix[edge.src][edge.dest] = edge.cap.maxfl;
            else
                adjMatrix[edge.src][edge.dest] = 1;
        }

    return adjMatrix;
}

void Graph :: addEdge(Edge newEdge)
{
    adjacencyList[newEdge.src].push_back(newEdge);

    if(!isDirected)
        adjacencyList[newEdge.dest].push_back(newEdge.getReverse());

    nrEdges++;
}

void Graph :: removeEdge(int src, int dst)
{
    for (int i = 0; i < adjacencyList[src].size(); i++)
        if (adjacencyList[src][i].src == src && adjacencyList[src][i].dest == dst)
            adjacencyList[src].erase(adjacencyList[src].begin() + i);

    if (!isDirected)
        for (int i = 0; i < adjacencyList[dst].size(); i++)
            if (adjacencyList[dst][i].src == src && adjacencyList[dst][i].dest == dst)
                adjacencyList[dst].erase(adjacencyList[dst].begin() + i);

    nrEdges--;
}



vector<int> Graph :: getUnweightedDistances(int startingNode)
{
    vector<int> distances(nrNodes + 1, -1);

    Graph :: BFS(startingNode, distances);

    return distances;
}

vector<vector<int>> Graph :: getConnectedComponents()
{
    vector<vector<int>> CClist;
    vector<bool> isVisited(nrNodes + 1, false);

    for (int i = 1; i <= nrNodes; i++)
        if (!isVisited[i])
        {
            vector<int> connectedComponent;
            Graph :: DFS(i, isVisited, connectedComponent);

            CClist.push_back(connectedComponent);
        }

    return CClist;
}

vector<vector<int>> Graph :: getStronglyConnectedComponents()
{
    vector<vector<int>> SCClist;

    vector<int> discoveryOrder(nrNodes + 1, 0);
    vector<int> lowestLink(nrNodes + 1, 0);
    vector<bool> onStack(nrNodes + 1, false);
    stack<int> path;

    for (int i = 1; i <= nrNodes; i++)
        if (!discoveryOrder[i])
            Graph :: TarjanDFS(i, discoveryOrder, lowestLink, path, onStack, SCClist);

    return SCClist;
}

vector<vector<int>> Graph :: getBiconnectedComponents()
{
    vector<vector<int>> BCClist;

    vector<int> levels(nrNodes + 1, 0);
    vector<int> lowestLink(nrNodes + 1, 0);
    stack<int> path;

    Graph :: BiconnectedDFS(1, 1, levels, lowestLink, path, BCClist);

    return BCClist;
}

vector<pair<int, int>> Graph :: getCriticalEdges()
{
    vector<pair<int, int>> CElist;

    vector<int> discoveryOrder(nrNodes + 1, 0);
    vector<int> lowestLink(nrNodes + 1, 0);

    Graph :: CriticalEdgesDFS(1, 0, discoveryOrder, lowestLink, CElist);

    return CElist;
}

deque<int> Graph :: getTopologicalOrder()
{
    deque<int> TOlist;
    vector<bool> isVisited(nrNodes + 1, false);

    for (int i = 1; i <= nrNodes; i++)
        if (!isVisited[i])
            Graph :: TopologicalOrderDFS(i, isVisited, TOlist);

    return TOlist;
}

bool Graph :: getValidGraph()
{
    bool validity;
    vector<int> degrees;

    int deg;
    while (fin >> deg)
        degrees.push_back(deg);

    Graph :: HavelHakimi(degrees, validity);

    return validity;
}

void Graph :: disjointSetsWrapper(int nrOp)
{
    vector<int> parent;
    parent.push_back(0);

    for (int i = 1; i <= nrNodes; i++)
        parent.push_back(i);


    for (int i = 0; i < nrOp; i++)
    {
        int op, x, y;
        fin >> op >> x >> y;

        if (op == 1)
            Graph :: Union(x, y, parent);
        else
        {
            if (Graph :: Find(x, parent) == Graph :: Find(y, parent))
                fout << "DA\n";
            else
                fout << "NU\n";
        }
    }
}

vector<int> Graph :: getWeightedDistances(int startingNode)
{
    vector<int> distance(nrNodes + 1, INF);
    bool hasNegativeEdge = false;

    for (auto& node : adjacencyList)
    {
        for (auto& edge : node)
            if (edge.cost < 0)
            {
                hasNegativeEdge = true;
                break;
            }
        if (hasNegativeEdge)
            break;
    }

    if(hasNegativeEdge)
        Graph :: BellmanFord(startingNode, distance);
    else
        Graph :: Dijkstra(startingNode, distance);

    return distance;
}

vector<pair<int, int>> Graph :: getMinimumSpanningTree(int& minimumCost)
{
    vector<int> parent(nrNodes + 1, 0);
    vector<pair<int, int>> MSTlist;
    vector<Edge> edgeList;

    for (int i = 1; i <= nrNodes; ++i)
        parent[i] = i;

    for (int i = 1; i <= nrNodes; i++)
        for (auto& edge : adjacencyList[i])
            edgeList.push_back(edge);

    Graph :: Kruskal(minimumCost, edgeList, parent, MSTlist);

    return MSTlist;
}

int Graph :: getTreeDiameter()
{
    int diameter;
    vector<int> bfs1, bfs2;

    bfs1 = getUnweightedDistances(1);
    auto maxInd = distance(bfs1.begin(), max_element(bfs1.begin(), bfs1.end())) + 1;    // index of element with max-value

    bfs2 = getUnweightedDistances(maxInd);
    diameter = *max_element(bfs2.begin(), bfs2.end()) + 1;

    return diameter;
}

vector<vector<int>> Graph :: getAllMinimumDistances()
{
    vector<vector<int>> distMatrix = getAdjacencyMatrixFromList(adjacencyList);

    Graph :: RoyFloyd(distMatrix);

    return distMatrix;
}

int Graph :: getMaxFlow(int source, int sink)
{
    int maxFlow = 0;
    vector<int> parent(nrNodes + 1, 0);
    vector<bool> isVisited(nrNodes + 1, false);
    vector<vector<Edge>> fluxNetwork(nrNodes + 1, vector<Edge>(nrNodes + 1));

    for (auto& line : adjacencyList)
        for (auto& edge : line)
        {
            Edge backEdge = edge.getReverse();
            backEdge.cap.maxfl = 0;
            fluxNetwork[edge.src][edge.dest] = edge;
            fluxNetwork[edge.dest][edge.src] = backEdge;
        }


    while (CheckAugmentingPath(source, sink, parent, isVisited, fluxNetwork) == true)   // Edmonds-Karp algorithm
    {
        for (auto& edge : fluxNetwork[sink])
        {
            int currentNode = edge.dest;

            if ((fluxNetwork[currentNode][sink].cap.curfl != fluxNetwork[currentNode][sink].cap.maxfl) && isVisited[currentNode])
            {
                int bottleNeckValue = INF;
                int node = sink;
                parent[sink] = currentNode;

                while (node != source)
                {
                    bottleNeckValue = min(bottleNeckValue, fluxNetwork[parent[node]][node].cap.maxfl - fluxNetwork[parent[node]][node].cap.curfl);
                    node = parent[node];
                }

                //cout << bottleNeckValue << "\n";

                if (bottleNeckValue)
                {
                    int n = sink;

                    while (n != source)
                    {
                        fluxNetwork[parent[n]][n].cap.curfl += bottleNeckValue;
                        fluxNetwork[n][parent[n]].cap.curfl -= bottleNeckValue;
                        n = parent[n];
                    }
                }

                maxFlow += bottleNeckValue;
            }
        }

        fill(isVisited.begin(), isVisited.end(), false);
    }

    return maxFlow;
}

vector<int> Graph :: getEulerianCycle()
{
    vector<bool> isVisitedEdge(nrEdges + 1, false);
    vector<int> EClist;


    for (int i = 1; i <= nrNodes; i++)
    {
        if (adjacencyList[i].size() % 2)
        {
            EClist.push_back(0);
            return EClist;
        }
    }

    EulerianCycleDFS(1, isVisitedEdge, EClist);

    if (count(isVisitedEdge.begin(), isVisitedEdge.end(), true) != nrEdges)     // if the graph is not connected, an Eulerian Cycle is not possible
        EClist.push_back(0);

    return EClist;
}



void Graph :: BFS(int startingNode, vector<int>& dist)
{
    queue<int> inProcessing;    // stores the order of the bfs traversal

    inProcessing.push(startingNode);
    dist[startingNode] = 0;

    while (!inProcessing.empty())
    {
        int last = inProcessing.front();    // extracts the first node from the queue, to push its adjacent nodes in the queue
        inProcessing.pop();

        for (auto& edge : adjacencyList[last])
            if (dist[edge.dest] == -1)    // checks for unvisited adjacent nodes
            {
                inProcessing.push(edge.dest);
                dist[edge.dest] = dist[last] + 1;
            }
    }

    dist.erase(dist.begin());
}

void Graph :: DFS(int currentNode, vector<bool>& isVisited, vector<int>& connectedComponent)
{
    isVisited[currentNode] = true;    // every time recursion takes place on an unvisited node, it's marked as visited, not to be includee in more than 1 connected component;
    connectedComponent.push_back(currentNode);

    for (auto& edge : adjacencyList[currentNode])    // traverses every node in the current node's adjacency list and (if it hadn't already been included in a connected component), continues recursion from it;
        if (!isVisited[edge.dest])
            DFS(edge.dest, isVisited, connectedComponent);
}

void Graph :: TarjanDFS(int currentNode, vector<int>& discOrder, vector<int>& lowLink, stack<int>& path, vector<bool>& onStack, vector<vector<int>>& SCClist)
{
    static int currentID = 1;    // increments and keeps value after each recursion
    discOrder[currentNode] = lowLink[currentNode] = currentID++;    // discOrder: assigns an ID to each node, representing the DFS traversal order;   lowLink: point to the lowest ID that a node can return to

    path.push(currentNode);    // stores the DFS traversal path
    onStack[currentNode] = true;    // to check if a node is on the current traversal path


    for (auto& edge : adjacencyList[currentNode])    // for each node adjacent to the current node
    {
        if (discOrder[edge.dest])    // if the adjacent node had been processed and is part of the current traversal path
            if (onStack[edge.dest])
                lowLink[edge.src] = min(lowLink[edge.src], discOrder[edge.dest]);    // update the lowest returning point of the adjacent node

            else    // if the adjacent node hadn't been processed yet, start recursion from it
            {
                TarjanDFS(edge.dest, discOrder, lowLink, path, onStack, SCClist);
                lowLink[edge.src] = min(lowLink[edge.src], lowLink[edge.dest]);    // after the recursion callback, update the lowest returning point of the adjacent node
            }
    }


    if (lowLink[currentNode] == discOrder[currentNode])    // if the lowest returning point of a node is also its discovery ID, it means that the node is the root of its strongly connected component
    {
        vector<int> connectedComp;
        int last;

        do    // removes all the nodes, until the SCC's root, from the path's stack and inserts them into a new strongly connected component
        {
            last = path.top();
            path.pop();
            onStack[last] = false;

            connectedComp.push_back(last);
        } while (currentNode != last);

        SCClist.push_back(connectedComp);
    }
}

void Graph :: BiconnectedDFS(int currentNode, int currentLevel, vector<int>& level, vector<int>& lowLink, stack<int>& path, vector<vector<int>>& BCClist)
{
    path.push(currentNode);    // stores the DFS traversal path
    level[currentNode] = lowLink[currentNode] = currentLevel;    // level: the "depth" of each node in the DFS traversal's tree;   lowLink: point to the lowest "depth" that a node can return to

    for (auto& edge : adjacencyList[currentNode])
    {
        if (level[edge.dest]) // daca nodul vecin a fost explorat
            lowLink[edge.src] = min(lowLink[edge.src], level[edge.dest]); // adancimea minima a nodului curent S = min (adancimea sa minima curenta; adancimea vecinilor sai)

        else
        {
            BiconnectedDFS(edge.dest, currentLevel + 1, level, lowLink, path, BCClist);
            lowLink[edge.src] = min(lowLink[edge.src], lowLink[edge.dest]); // la intoarcerea din recursie, nodurile cu adancimea < adancimea nodului pe care s-a facut recursia
                                                                            // isi minimizeaza adancimea minima lowLink cu a succesorilor;
            if (lowLink[edge.dest] == level[edge.src]) // cand ajungem la succesorul radacinii componentei, eliminam nodurile pana la radacina din stiva, formand o componenta biconexa;
            {
                vector<int> biconnectedComp;
                int last;

                do
                {
                    last = path.top();
                    path.pop();

                    biconnectedComp.push_back(last);
                } while (edge.dest != last);

                biconnectedComp.push_back(edge.src);
                BCClist.push_back(biconnectedComp);
            }
        }
    }
}

void Graph :: CriticalEdgesDFS(int startingNode, int previous, vector<int>& discOrder, vector<int>& lowLink, vector<pair<int, int>>& CElist)
{
    static int currentID = 1;
    discOrder[startingNode] = lowLink[startingNode] = currentID++;

    for (auto& edge : adjacencyList[startingNode])
    {
        if (discOrder[edge.dest])
        {
            if (edge.dest != previous)
                lowLink[edge.src] = min(lowLink[edge.src], discOrder[edge.dest]);
        }
        else
        {
            CriticalEdgesDFS(edge.dest, edge.src, discOrder, lowLink, CElist);
            lowLink[edge.src] = min(lowLink[edge.src], lowLink[edge.dest]);

            if (lowLink[edge.dest] > discOrder[edge.src])
                CElist.push_back(make_pair(edge.src, edge.dest));
        }
    }
}

void Graph :: TopologicalOrderDFS(int startingNode, vector<bool>& isVisited, deque<int>& TOlist)
{
    isVisited[startingNode] = true;

    for (auto& edge : adjacencyList[startingNode])
        if (!isVisited[edge.dest])
            TopologicalOrderDFS(edge.dest, isVisited, TOlist);

    TOlist.push_front(startingNode);
}

void Graph :: HavelHakimi(vector<int>& degrees, bool& valid)
{
    while (!degrees.empty())
    {
        sort(degrees.begin(), degrees.end());

        if (degrees[0] == 0)
        {
            valid = true;
            break;
        }

        if (degrees[0] > degrees.size() - 1)
        {
            valid = false;
            break;
        }

        for (int i = 1; i <= degrees[0]; i++)
        {
            degrees[i]--;

            if (degrees[i] < 0)
            {
                valid = false;
                break;
            }
        }

        degrees.erase(degrees.begin());
    }
}

int Graph :: Find(int targetNode, vector<int>& parent)
{
    if (targetNode != parent[targetNode])
        parent[targetNode] = Find(parent[targetNode], parent);

    return parent[targetNode];
}

void Graph :: Union(int targetNode1, int targetNode2, vector<int>& parent)
{
    targetNode1 = Graph :: Find(targetNode1, parent);
    targetNode2 = Graph :: Find(targetNode2, parent);


    if (targetNode1 == targetNode2)
        return;

    parent[targetNode1] = targetNode2;
}

void Graph :: Dijkstra(int startingNode, vector<int>& dist)
{
    priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> inProcessing;

    inProcessing.push(make_pair(0, startingNode));
    dist[startingNode] = 0;

    while (!inProcessing.empty())
    {
        int nearestNode = inProcessing.top().second;
        int currentDistance = inProcessing.top().first;
        inProcessing.pop();

        if (currentDistance <= dist[nearestNode])
        {
            for (auto& edge : adjacencyList[nearestNode])
            {

                if (dist[edge.dest] == INF && dist[nearestNode] + edge.cost < dist[edge.dest])
                {
                    dist[edge.dest] = dist[nearestNode] + edge.cost;
                    inProcessing.push(make_pair(dist[edge.dest], edge.dest));
                }
            }
        }
    }

    for (auto& d : dist)
        if (d == INF) d = 0;
}

void Graph :: BellmanFord(int startingNode, vector<int>& dist)
{
    queue<int> processingQueue;
    vector<bool> inQueue(nrNodes + 1, false);
    vector<int> countIterations(nrNodes + 1, 0);

    dist[startingNode] = 0;
    processingQueue.push(startingNode);
    inQueue[startingNode] = true;


    while (!processingQueue.empty())
    {
        int currentNode = processingQueue.front();
        processingQueue.pop();
        inQueue[currentNode] = false;

        countIterations[currentNode]++;
        if (countIterations[currentNode] == nrNodes)
        {
            dist[0] = 0;
            break;
        }

        for (auto& edge : adjacencyList[currentNode])
        {
            if (dist[edge.dest] > dist[currentNode] + edge.cost)
            {
                dist[edge.dest] = dist[currentNode] + edge.cost;

                if (!inQueue[edge.dest])
                {
                    processingQueue.push(edge.dest);
                    inQueue[edge.dest] = true;
                }
            }
        }
    }
}

void Graph :: Kruskal(int& minimumCost, vector<Edge>& edgeList, vector<int>& parent, vector<pair<int, int>>& MSTlist)
{
    sort(edgeList.begin(), edgeList.end());

    for (auto edge : edgeList)
    {
        int t1 = Graph :: Find(edge.src, parent);
        int t2 = Graph :: Find(edge.dest, parent);

        if (t1 != t2)
        {
            MSTlist.push_back(make_pair(edge.src, edge.dest));
            Graph :: Union(t1, t2, parent);
            minimumCost += edge.cost;
        }
    }
}

void Graph :: RoyFloyd(vector<vector<int>>& distMatrix)
{
    for (int k = 1; k <= nrNodes; k++)
        for (int i = 1; i <= nrNodes; i++)
            for (int j = 1; j <= nrNodes; j++)
                if ((distMatrix[k][j] && distMatrix[i][k]) && (distMatrix[i][j] == 0 || distMatrix[i][j] > distMatrix[i][k] + distMatrix[k][j]) && (i != j))
                    distMatrix[i][j] = distMatrix[i][k] + distMatrix[k][j];

}

bool Graph :: CheckAugmentingPath(int source, int sink, vector<int>& parent, vector<bool>& isVisited, vector<vector<Edge>>& flowNetwork)
{
    queue<int> path;
    path.push(source);

    while (!path.empty())
    {
        int currentNode = path.front();
        isVisited[currentNode] = true;
        path.pop();

        cout << currentNode << " ";

        if (currentNode != sink)
            for (auto& edge : flowNetwork[currentNode])
                if (!isVisited[edge.dest] && (edge.cap.maxfl != edge.cap.curfl))
                {
                    path.push(edge.dest);
                    parent[edge.dest] = currentNode;
                }
    }

    for (int i = 1; i <= 100; i++)
    {
        for (int j = 1; j <= 100; j++)
            if (flowNetwork[i][j].dest != 0) fout << flowNetwork[i][j].dest << " ";
        fout << "\n";
    }

    for (auto x : isVisited)
        cout << x << " ";
    cout << "\n";

    return isVisited[sink];
}

void Graph :: EulerianCycleDFS(int startingNode, vector<bool>& visitedEdges, vector<int>& EClist)
{
    for(auto& edge : adjacencyList[startingNode])
        if (!visitedEdges[edge.cost])
        {
            visitedEdges[edge.cost] = true;
            EulerianCycleDFS(edge.dest, visitedEdges, EClist);
        }

    EClist.push_back(startingNode);
}

#pragma endregion




int main()
{
    int nodes, edges, start, operations;
    fin >> nodes >> edges;

    // G(nodes, edges, isDirected, isWeighted, isFlowing)
    Graph G(nodes, edges, unDirected, unWeighted, unFlowing);

    G.readAdjacencyList();
    //G.printAdjacencyList();


#pragma region Public_Methods_Calls

/* ---> MINIMAL DISTANCES (UNWEIGHTED) <--- */

    /*
    vector<int> minDistances_UW = G.getUnweightedDistances(start);

    for (auto dist : minDistances_UW)
        fout << dist << " ";
    */

    
/* ---> CONNECTED COMPONENTS <--- */

    
    vector<vector<int>> CClist = G.getConnectedComponents();

    fout << CClist.size();
    


/* ---> STRONGLY CONNECTED COMPONENTS <--- */

    /*
    vector<vector<int>> SCClist = G.getStronglyConnectedComponents();

    fout << SCClist.size() << "\n";

    for (auto SCC : SCClist)
    {
        for (auto node : SCC)
            fout << node << " ";
        fout << "\n";
    }
    */


/* ---> BICONNECTED COMPONENTS <--- */

    /*
    vector<vector<int>> BCClist = G.getBiconnectedComponents();

    fout << BCClist.size() << "\n";

    for (auto BCC : BCClist)
    {
        for (auto node : BCC)
            fout << node << " ";
        fout << "\n";
    }
    */


/* ---> CRITICAL EDGES <--- */

    /*
    vector<pair<int, int>> CElist = G.getCriticalEdges();

    fout << CElist.size() << "\n";

    for (auto edge : CElist)
        fout << "(" << edge.first << " " << edge.second << ")" << "\n";
    */


/* ---> TOPOLOGICAL ORDER <--- */

    /*
    vector<int> TOlist = G.getTopologicalOrder();

    for (auto node : TOlist)
        fout << node << " ";
    */


/* ---> GRAPHICAL SEQUENCE <-- - */

    /*
    bool HH = G.getValidGraph();

    HH ? fout << "Yes" : fout << "No";
    */


/* ---> MINIMAL DISTANCE (WEIGHTED) <--- */

    /*
    vector<int> minDistances_W = G.getWeightedDistances(1);

    for (int i = 2; i <= nodes; i++)
        fout << minDistances_W[i] << " ";
    */


/* ---> DISJOINT SETS <--- */

    /*
    G.getDisjointSets(operations);
    */


/* ---> MINIMUM SPANNING TREE <--- */

    /*
    int minCost = 0;
    vector<pair<int, int>> MST = G.getMinimumSpanningTree(minCost);

    fout << minCost << "\n" << MST.size() << "\n";

    for (auto edge : MST)
        fout << edge.first << " " << edge.second << "\n";
    */


/* ---> TREE DIAMETER <--- */

    /*
    int diameter =  G.getTreeDiameter();
    fout << diameter;
    */


/* ---> ALL MINIMAL DISTANCES <--- */

    /*
    vector<vector<int>> allMin_Dist = G.getAllMinimumDistances();

    for (int i = 1; i <= nodes; i++)
    {
        for (int j = 1; j <= nodes; j++)
            fout << allMin_Dist[i][j] << " ";
        fout << "\n";
    }
    */


/* ---> MAX FLOW <--- */

    /*
    int maxFlow = G.getMaxFlow(1, nodes);
    fout << maxFlow;
    */


/* ---> EULERIAN CYCLE <--- */

    /*
    vector<int> EClist = G.getEulerianCycle();

    if (!EClist.back())
        fout << -1;
    else
    {
        EClist.pop_back();
        for (auto x : EClist)
            fout << x << " ";
    }
    */
    

#pragma endregion


    fin.close();
    fout.close();

    return 0;
}