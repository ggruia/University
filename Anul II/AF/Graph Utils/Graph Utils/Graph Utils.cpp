#include <fstream>
#include <iostream>
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
    int src;
    int dest;
    int cost;
    int cap;

    Edge(int s = 0, int d = 0, int c = 0, int g = 0) : src(s), dest(d), cost(c), cap(g) {}

    friend istream& operator >> (istream& in, Edge& e)
    {
        in >> e.src >> e.dest;
        if (isWeighted) in >> e.cost;
        if (isCappable) in >> e.cap;
            
        return in;
    }

    friend ostream& operator << (ostream& out, Edge& e)
    {
        out << e.src << " ---> " << e.dest << " :  ";
        if (isWeighted) out << e.cost << " (cost)";
        if (isCappable) out << e.cap << " (cap)";
        out << "\n";

        return out;
    }
};


class Graph
{
// Implementation of  << UTILITARY Functions >>  for (UN)Directed, (UN)Weighted & (UN)Cappable << Graphs >>;

#pragma region Data

    int nrNodes;
    int nrEdges;

    vector<list<Edge>> adjacencyList;

#pragma endregion


public:

#pragma region IO_Methods

    Graph(int n = 0, int m = 0) : nrNodes(n), nrEdges(m){}

    void readAdjacencyList()
    {
        adjacencyList.resize(nrNodes + 1);

        for (int i = 0; i < nrEdges; i++)
        {
            Edge edge;
            fin >> edge;
            adjacencyList[edge.src].push_back(edge);
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


#pragma region Unweighted_Graph_Methods

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
        {
            degrees.push_back(deg);
        }

        HavelHakimi(degrees, validity);

        return validity;
    }

#pragma endregion

#pragma region Weighted_Graph_Methods

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

#pragma region Private_Unweighted_Methods

    void BFS(int startingNode, vector<int>& dist)
    {
        vector<bool> isVisited(nrNodes + 1, false);
        queue<int> inProcessing;

        inProcessing.push(startingNode);
        isVisited[startingNode] = true; // adaugam nodul de plecare in coada; pornim BFS
        dist[startingNode] = 0;

        while (!inProcessing.empty())
        {
            int currentNode = inProcessing.front(); // extragem primul nod din coada si ii parcurgem/adaugam vecinii in coada

            inProcessing.pop();

            for (auto& edge : adjacencyList[currentNode]) // vecin.first = nodul din lista de adiacenta a nodului curent
                if (!isVisited[edge.dest])               // adauga toti vecinii nevizitati ai nodului curent in coada
                {
                    inProcessing.push(edge.dest);
                    isVisited[edge.dest] = true;
                    dist[edge.dest] = dist[currentNode] + 1;
                } 
        }

        dist.erase(dist.begin());
    }

    void DFS(int startingNode, vector<bool>& isVisited, set<int>& connectedComponent)
    {
        isVisited[startingNode] = true;
        connectedComponent.insert(startingNode);

        for (auto& edge : adjacencyList[startingNode]) // vecin.first = nodul din lista de adiacenta a nodului curent
            if (!isVisited[edge.dest])          // parcurgem componenta conexa de care apartine nodul de pornire
                DFS(edge.dest, isVisited, connectedComponent);
    }

    void TarjanDFS(int currentNode, vector<int>& discOrder, vector<int>& lowLink, stack<int>& path, vector<bool>& onStack, list<set<int>>& SCClist)
    {
        static int currentID = 1;
        path.push(currentNode);
        onStack[currentNode] = true;
        discOrder[currentNode] = lowLink[currentNode] = currentID++;

        for (auto& edge : adjacencyList[currentNode]) // vecin.first = nodul din lista de adiacenta a nodului curent
        {
            if (discOrder[edge.dest]) // daca nodul vecin a fost explorat si se afla pe stiva de ordine, il incadram intr-o componenta conexa;
            {
                if (onStack[edge.dest])
                    lowLink[edge.src] = min(lowLink[edge.src], discOrder[edge.dest]);
            }
            else  // daca nodul vecin nu a fost explorat, pornim DFS din el, iar la revenirea din recursie, il incadram intr-o componenta conexa;
            {
                TarjanDFS(edge.dest, discOrder, lowLink, path, onStack, SCClist);

                lowLink[edge.src] = min(lowLink[edge.src], lowLink[edge.dest]);
            }
        }

                                                             // daca ID - ul nodului corespunde cu lowLink - value - ul sau, inseamna ca nodul este radacina componentei sale conexe,
        if (lowLink[currentNode] == discOrder[currentNode])  // si putem scoate de pe stiva toate nodurile pana la startingNode, deoarece am terminat de explorat componenta respectiva;
        {
            set<int> connectedComp;
            int last;

            do
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
        path.push(currentNode); // stiva retine parcurgerea DFS a subarborilor grafului
        level[currentNode] = lowLink[currentNode] = currentLevel; // adancimi[x] = nivelul de adancime al nodului X din arborele DFS;     lowLink[x] = adancimea minima la care se poate intoarce nodul X;

        for (auto& edge : adjacencyList[currentNode])
        {
            if (level[edge.dest]) // daca nodul vecin a fost explorat
            {
                lowLink[edge.src] = min(lowLink[edge.src], level[edge.dest]); // adancimea minima a nodului curent S = min (adancimea sa minima curenta; adancimea vecinilor sai)
            }
            else
            {
                BiconnectedDFS(edge.dest, currentLevel + 1, level, lowLink, path, BCClist);
                lowLink[edge.src] = min(lowLink[edge.src], lowLink[edge.dest]); // la intoarcerea din recursie, nodurile cu adancimea < adancimea nodului pe care s-a facut recursia
                                                                         // isi minimizeaza adancimea minima lowLink cu a succesorilor;
                if (lowLink[edge.dest] == level[edge.src])
                {                                          // cand ajungem la succesorul radacinii componentei, eliminam nodurile pana la radacina din stiva, formand o componenta biconexa;
                    set<int> biconnectedCopm;
                    int last;

                    do
                    {
                        last = path.top();
                        path.pop();

                        biconnectedCopm.insert(last);
                    } while (edge.src != last);

                    path.push(edge.src);

                    BCClist.push_back(biconnectedCopm);
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

#pragma region Private_Weighted_Methods

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

    /*vector<int> minDistances_UW = G.getUnweightedDistances(s);

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