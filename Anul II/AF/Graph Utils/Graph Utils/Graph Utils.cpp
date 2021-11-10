#include <fstream>
#include <iostream>
#include <algorithm>
#include <vector>
#include <list>
#include <stack>
#include <queue>
#include <set>
using namespace std;

constexpr auto INF = 2147483647;

bool isDirected;
bool isWeighted;
bool isCappable;

ifstream fin("input");
ofstream fout("output");



struct Edge
{
    // easier, cleaner and more expandable alternative to using a tuple for Storing sourceNodes, destinationNodes, weights, capacities etc.. 

    int src;
    int dest;
    int cost;
    int cap;

    Edge(int s = 0, int d = 0, int c = 0, int g = 0) : src(s), dest(d), cost(c), cap(g) {}

    friend istream& operator >> (istream& in, Edge& e)    // overloaded Reading operator >> in
    {
        in >> e.src >> e.dest;
        if (isWeighted) in >> e.cost;
        if (isCappable) in >> e.cap;
            
        return in;
    }

    friend ostream& operator << (ostream& out, Edge& e)    // overloaded Writing operator << out
    {
        out << e.src << " ---> " << e.dest;
        if (isWeighted) out << " :  " << e.cost << " (cost)";
        if (isCappable) out << e.cap << " (cap)";
        out << "\n";

        return out;
    }
};


class Graph
{
    // Implementation of  << UTILITARY Functions >>  for (UN)Directed, (UN)Weighted & (UN)Cappable  << Graphs >> ;

#pragma region Data

    int nrNodes;
    int nrEdges;

    vector<list<Edge>> adjacencyList;

#pragma endregion


public:

#pragma region IO_Methods

    Graph(int n = 0, int m = 0) : nrNodes(n), nrEdges(m) {} 

    void readAdjacencyList()
    {
        adjacencyList.resize(nrNodes + 1);

        for (int i = 0; i < nrEdges; i++)
        {
            Edge edge;
            fin >> edge;
            adjacencyList[edge.src].push_back(edge);

            if (!isDirected)
            {
                Edge rev = edge;
                swap(rev.src, rev.dest);

                adjacencyList[edge.dest].push_back(rev);
            }
        }
    }

    void printAdjacencyList()
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
                    fout << edge;
            }
    }

#pragma endregion


#pragma region Unweighted_Graph_Wrappers

    vector<int> getUnweightedDistances(int startingNode)
    {
        vector<int> distances(nrNodes + 1, -1);

        BFS(startingNode, distances);

        return distances;
    }

    list<set<int>> getConnectedComponents()
    {
        list<set<int>> CClist;
        vector<bool> isVisited(nrNodes + 1, false);

        for (int i = 1; i <= nrNodes; i++) // parcurgem nodurile pana gasim unul nevizitat, indicand o noua componenta conexa, si pornim DFS din acel nod
            if (!isVisited[i])
            {
                set<int> connectedComponent;
                DFS(i, isVisited, connectedComponent);

                CClist.push_back(connectedComponent);
            }

        return CClist;
    }

    list<set<int>> getStronglyConnectedComponents()
    {
        list<set<int>> SCClist;

        vector<int> discoveryOrder(nrNodes + 1, 0);
        vector<int> lowestLink(nrNodes + 1, 0);
        vector<bool> onStack(nrNodes + 1, false);
        stack<int> path;

        for (int i = 1; i <= nrNodes; i++)
            if (!discoveryOrder[i])
                TarjanDFS(i, discoveryOrder, lowestLink, path, onStack, SCClist);

        return SCClist;
    }

    list<set<int>> getBiconnectedComponents()
    {
        list<set<int>> BCClist;

        vector<int> levels(nrNodes + 1, 0);
        vector<int> lowestLink(nrNodes + 1, 0);
        stack<int> path;

        BiconnectedDFS(1, 1, levels, lowestLink, path, BCClist);

        return BCClist;
    }

    list<pair<int, int>> getCriticalEdges()
    {
        list<pair<int, int>> CElist;

        vector<int> discoveryOrder(nrNodes + 1, 0);
        vector<int> lowestLink(nrNodes + 1, 0);

        CriticalEdgesDFS(1, 0, discoveryOrder, lowestLink, CElist);

        return CElist;
    }

    list<int> getTopologicalOrder()
    {
        list<int> TOlist;
        vector<bool> isVisited(nrNodes + 1, false);

        for (int i = 1; i <= nrNodes; i++)
            if (!isVisited[i])
                TopologicalOrderDFS(i, isVisited, TOlist);

        return TOlist;
    }

    bool getValidGraph()
    {
        bool validity;
        vector<int> degrees;

        int deg;
        while (fin >> deg)
            degrees.push_back(deg);

        HavelHakimi(degrees, validity);

        return validity;
    }

#pragma endregion

#pragma region Weighted_Graph_Wrappers

    vector<int> getWeightedDistances(int startingNode)
    {
        vector<int> distance(nrNodes + 1, INF);

        Dijkstra(startingNode, distance);

        return distance;
    }

    vector<int> getBellmanFordDistances(int startingNode)
    {
        vector<int> distance(nrNodes + 1, INF);

        BellmanFord(startingNode, distance);

        return distance;
    }

#pragma endregion


private:

#pragma region Unweighted_Methods

    void BFS(int startingNode, vector<int>& dist)
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

        dist.erase(dist.begin());    // nu ne place infoarena si indexarea de la 1! :(
    }

    void DFS(int currentNode, vector<bool>& isVisited, set<int>& connectedComponent)
    {
        isVisited[currentNode] = true;    // every time recursion takes place on an unvisited node, it's marked as visited, not to be includee in more than 1 connected component;
        connectedComponent.insert(currentNode);

        for (auto& edge : adjacencyList[currentNode])    // traverses every node in the current node's adjacency list and (if it hadn't already been included in a connected component), continues recursion from it;
            if (!isVisited[edge.dest])
                DFS(edge.dest, isVisited, connectedComponent);
    }

    void TarjanDFS(int currentNode, vector<int>& discOrder, vector<int>& lowLink, stack<int>& path, vector<bool>& onStack, list<set<int>>& SCClist)
    {
        static int currentID = 1;    // increments and keeps value after each recursion
        discOrder[currentNode] = lowLink[currentNode] = currentID++;    // discOrder: assigns an ID to each node, representing the DFS traversal order;   lowLink: point to the lowest ID that a node can return to

        path.push(currentNode);    // stores the DFS traversal path
        onStack[currentNode] = true;    // to check if a node is on the current traversal path
        

        for (auto& edge : adjacencyList[currentNode])    // for each node adjacent to the current node
        {
            if (discOrder[edge.dest])    // if the adjacent node had been processed and is part of the current traversal path
                if(onStack[edge.dest])
                    lowLink[edge.src] = min(lowLink[edge.src], discOrder[edge.dest]);    // update the lowest returning point of the adjacent node

            else    // if the adjacent node hadn't been processed yet, start recursion from it
            {
                TarjanDFS(edge.dest, discOrder, lowLink, path, onStack, SCClist);
                lowLink[edge.src] = min(lowLink[edge.src], lowLink[edge.dest]);    // after the recursion callback, update the lowest returning point of the adjacent node
            }
        }


        if (lowLink[currentNode] == discOrder[currentNode])    // if the lowest returning point of a node is also its discovery ID, it means that the node is the root of its strongly connected component
        {
            set<int> connectedComp;
            int last;

            do    // removes all the nodes, until the SCC's root, from the path's stack and inserts them into a new strongly connected component
            {
                last = path.top();
                path.pop();
                onStack[last] = false;

                connectedComp.insert(last);
            } while (currentNode != last);

            SCClist.push_back(connectedComp);
        }
    }

    void BiconnectedDFS(int currentNode, int currentLevel, vector<int>& level, vector<int>& lowLink, stack<int>& path, list<set<int>>& BCClist)
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
                    set<int> biconnectedComp;
                    int last;

                    do
                    {
                        last = path.top();
                        path.pop();

                        biconnectedComp.insert(last);
                    } while (edge.dest != last);

                    biconnectedComp.insert(edge.src);
                    BCClist.push_back(biconnectedComp);
                }
            }
        }
    }

    void CriticalEdgesDFS(int startingNode, int previous, vector<int>& discOrder, vector<int>& lowLink, list<pair<int, int>>& CElist)
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

    void TopologicalOrderDFS(int startingNode, vector<bool>& isVisited, list<int>& TOlist)
    {
        isVisited[startingNode] = true;

        for (auto& edge : adjacencyList[startingNode])
            if (!isVisited[edge.dest])
                TopologicalOrderDFS(edge.dest, isVisited, TOlist);

        TOlist.push_front(startingNode);
    }

    void HavelHakimi(vector<int>& degrees, bool& valid)
    {
        while (!degrees.empty())
        {
            sort(degrees.begin(), degrees.end(), greater<>());

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

#pragma endregion

#pragma region Weighted_Methods

    void Dijkstra(int startingNode, vector<int>& dist)
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
            d == INF ? d : 0;
    }

    void BellmanFord(int startingNode, vector<int>& dist)
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

#pragma endregion

};



int main()
{
    isDirected = true;
    isWeighted = true;
    isCappable = false;

    int nodes, edges, start;
    fin >> nodes >> edges;

    Graph G(nodes, edges); //G(nodes, edges, isDirected, isWeighted);

    G.readAdjacencyList();
    //G.printAdjacencyList();

#pragma region Public_Methods_Calls

/* ---> MINIMAL DISTANCES (UNWEIGHTED) <--- */

    /*vector<int> minDistances_UW = G.getUnweightedDistances(start);

    for (auto dist : minDistances_UW)
        fout << dist << " ";*/


/* ---> CONNECTED COMPONENTS <--- */

    /*list<set<int>> CClist = G.getConnectedComponents();

    fout << CClist.size();*/


/* ---> STRONGLY CONNECTED COMPONENTS <--- */

    /*list<set<int>> SCClist = G.getStronglyConnectedComponents();

    fout << SCClist.size() << "\n";

    for (auto SCC : SCClist)
    {
        for (auto node : SCC)
            fout << node << " ";
        fout << "\n";
    }*/


/* ---> BICONNECTED COMPONENTS <--- */

    /*list<set<int>> BCClist = G.getBiconnectedComponents();

    fout << BCClist.size() << "\n";

    for (auto BCC : BCClist)
    {
        for (auto node : BCC)
            fout << node << " ";
        fout << "\n";
    }*/


/* ---> CRITICAL EDGES <--- */

    /*list<pair<int, int>> CElist = G.getCriticalEdges();

    fout << CElist.size() << "\n";

    for (auto edge : CElist)
        fout << "(" << edge.first << " " << edge.second << ")" << "\n";*/


/* ---> TOPOLOGICAL ORDER <--- */

    /*list<int> TOlist = G.getTopologicalOrder();

    for (auto node : TOlist)
        fout << node << " ";*/


/* ---> GRAPHICAL SEQUENCE <-- - */

    /*bool HH = G.getValidGraph();

    HH ? fout << "Yes" : fout << "No";*/


/* ---> MINIMAL DISTANCES (WEIGHTED) <--- */

    /*vector<int> minDistances_W = G.getWeightedDistances(1);

    for (int i = 2; i <= nodes; i++)
        fout << minDistances_W[i] << " ";*/


/* ---> MINMAL DISTANCES (W/ NEGATIVE COSTS) <--- */

    /*vector<int> minDistances_NegC = G.getBellmanFordDistances(1);

    if (minDistances_NegC[0] == 0)
        fout << "Ciclu negativ!";
    else
        for (int i = 2; i <= nodes; i++)
            fout << minDistances_NegC[i] << " ";*/

#pragma endregion
}