#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
#include <windows.h>
using namespace std;

//ifstream fin("mealy.in");
//ofstream fout("mealy.out");

int noduri, muchii, nrSF, nrCuvinte;
string cuvantIn, cuvantOut, parcurgere = "[0";


class Tranzitie
{
private:
    int nodStart;
    int nodEnd;
    char transitionInput;
    char transitionOutput;

public:
    Tranzitie()
    {
        //inutila, dar imi da Warning asa ca:
        nodStart = 0;
        nodEnd = 0;
        transitionInput = '0';
        transitionOutput = '0';
    }

    ~Tranzitie()
    {

    }

#pragma region Setters & Getters
    int getStartNode()
    {
        return nodStart;
    }
    void setStartNode(int x)
    {
        nodStart = x;
    }

    int getEndNode()
    {
        return nodEnd;
    }
    void setEndNode(int x)
    {
        nodEnd = x;
    }

    char getInputTransition()
    {
        return transitionInput;
    }
    void setInputTransition(char x)
    {
        transitionInput = x;
    }

    char getOutputTransition()
    {
        return transitionOutput;
    }
    void setOutputTransition(char x)
    {
        transitionOutput = x;
    }
#pragma endregion
};

Tranzitie* listaTranzitii;
vector<int> stariParcurse;
vector<int> stariFinale;


bool cmp(Tranzitie a, Tranzitie b)
{
    if (a.getStartNode() != b.getStartNode())
        return a.getStartNode() < b.getStartNode();

    if (a.getEndNode() != b.getEndNode())
        return a.getEndNode() < b.getEndNode();

    if (a.getEndNode() != b.getEndNode())
        return a.getInputTransition() < b.getInputTransition();

    return a.getOutputTransition() < b.getOutputTransition();
}

void color(int colorCode)
{
#pragma region Color Codes
    //  1 = blue;
    //  2 = green;
    //  3 = cyan;
    //  4 = red;
    //  5 = violet;
    //  6 = yellow;
    //  7 = white;
    //  8 = grey;
    //  9 = marine blue;
    // 10 = lime;
    // 11 = light blue;
    // 12 = light red;
    // 13 = magenta;
    // 14 = light yellow;
#pragma endregion

#pragma region Setare Culoare
    HANDLE consoleColor;
    consoleColor = GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleTextAttribute(consoleColor, colorCode);
#pragma endregion
}

bool inVector(int x, vector<int> v)
{
    for (unsigned int i = 0; i < v.size(); i++)
        if (v[i] == x)
            return true;
    return false;
}

bool DFA(string cuvant, int nodCurent)
{
    if (cuvant.size() == 0)
    {
        for (unsigned int i = 0; i < stariFinale.size(); i++)
            if (nodCurent == stariFinale[i])
                return true;
        return false;
    }

    else
    {
        for (int i = 0; i < muchii; i++)
            if ((listaTranzitii[i].getStartNode() == nodCurent) & (listaTranzitii[i].getInputTransition() == cuvant[0]))
            {
                cuvantOut += listaTranzitii[i].getOutputTransition();
                parcurgere += ", ";
                parcurgere += '0' + nodCurent;
                return DFA(cuvant.substr(1, cuvant.size()), listaTranzitii[i].getEndNode());
            }
        return false;
    }
}


void meniu()
{
    bool inMenu = true;
    bool automatCitit = false;

    while (inMenu)
    {
#pragma region Meniu Principal
        parcurgere = "[0";

        color(14);
        cout << "-=+=O=+=- MENIU -=+=O=+=-\n\n\n";
        cout << "Alegeti o optiune dintre urmatoarele:\n\n";
        color(7);
        cout << "Citire automat - 1\n";
        cout << "Afisare muchii - 2\n";
        cout << "Testare cuvant - 3\n";
        cout << "Incheiere simulare - 0\n\n";
        color(14);
        cout << "Optiune: ";

        unsigned int option;
        color(3);
        cin >> option;

        system("cls");
#pragma endregion

        switch (option)
        {
#pragma region Citire Automat (case 1)
        case 1:
            color(11);
            cout << "========== CITIRE AUTOMAT ==========\n\n";
            if (automatCitit == false)
            {
                color(14);
                cout << "Introduceti numarul de noduri si muchii\n";
                color(7);
                cout << "+ Noduri: ";
                color(10);
                cin >> noduri;
                color(7);
                cout << "+ Muchii: ";
                color(10);
                cin >> muchii;
                cout << "\n\n";

                listaTranzitii = new Tranzitie[muchii];

                for (int i = 0; i < muchii; i++)
                {
                    int ns;
                    int ne;
                    char ti;
                    char to;
                    bool sf;

                    color(14);
                    cout << "Introduceti tranzitia ";
                    color(3);
                    cout << i + 1;
                    color(14);
                    cout << ":";

                    color(7);
                    cout << "\nStarea de inceput (0 - stare initiala): ";
                    color(10);
                    cin >> ns;
                    listaTranzitii[i].setStartNode(ns);
                    color(7);
                    if (inVector(ns, stariParcurse) == false)
                    {
                        stariParcurse.push_back(ns);
                        cout << "Stare finala? (";
                        color(12);
                        cout << "0";
                        color(7);
                        cout << " - nu, ";
                        color(3);
                        cout << "1";
                        color(7);
                        cout << " - da): ";
                        color(10);
                        cin >> sf;
                        if (sf == 1)
                            stariFinale.push_back(ns);
                    }

                    color(7);
                    cout << "\nStarea de sfarsit: ";
                    color(10);
                    cin >> ne;
                    listaTranzitii[i].setEndNode(ne);
                    color(7);
                    if (inVector(ne, stariParcurse) == false)
                    {
                        stariParcurse.push_back(ne);
                        cout << "Stare finala? (";
                        color(12);
                        cout << "0";
                        color(7);
                        cout << " - nu, ";
                        color(3);
                        cout << "1";
                        color(7);
                        cout << " - da): ";
                        color(10);
                        cin >> sf;
                        if (sf == 1)
                            stariFinale.push_back(ne);
                    }

                    color(7);
                    cout << "\nLitera de tranzitie dintre starile ";
                    color(3);
                    cout << ns;
                    color(7);
                    cout << " si ";
                    color(3);
                    cout << ne;
                    color(7);
                    cout << ": ";
                    color(10);
                    cin >> ti;
                    listaTranzitii[i].setInputTransition(ti);

                    color(7);
                    cout << "\nOutputul tranzitiei dintre starile ";
                    color(3);
                    cout << ns;
                    color(7);
                    cout << " si ";
                    color(3);
                    cout << ne;
                    color(7);
                    cout << ": ";
                    color(10);
                    cin >> to;
                    listaTranzitii[i].setOutputTransition(to);

                    cout << "\n\n";
                }
                automatCitit = true;
                sort(listaTranzitii, listaTranzitii + muchii, cmp);
            }

            else
            {
                color(12);
                cout << "Starile automatului au fost citite deja...\n\n";
            }

            color(14);
            cout << "Return to Menu\n";
            color(8);
            system("pause");
            system("cls");

            break;
#pragma endregion

#pragma region Afisare Muchii (case 2)
        case 2:
            color(11);
            cout << "========== AFISARE MUCHII ==========\n\n";

            for (int i = 0; i < muchii; i++)
            {
                color(7);
                cout << "Tranzitia ";
                color(9);
                cout << i;
                color(7);
                cout << ": \n";

                if (listaTranzitii[i].getStartNode() == 0)
                    color(2);

                if (inVector(listaTranzitii[i].getStartNode(), stariFinale))
                    color(12);

                else
                    color(14);
                cout << listaTranzitii[i].getStartNode();

                color(7);
                cout << " --- ";

                color(11);
                cout << listaTranzitii[i].getInputTransition();

                color(7);
                cout << " / ";

                color(3);
                cout << listaTranzitii[i].getOutputTransition();

                color(7);
                cout << " --- ";

                if (listaTranzitii[i].getEndNode() == 0)
                    color(2);
                if (inVector(listaTranzitii[i].getEndNode(), stariFinale))
                    color(12);
                else
                    color(14);
                cout << listaTranzitii[i].getEndNode() << "\n\n";
            }

            color(14);
            cout << "Return to Menu\n";
            color(8);
            system("pause");
            system("cls");

            break;
#pragma endregion

#pragma region Testare Cuvant (case 3)
        case 3:
            color(11);
            cout << "========== TESTARE CUVANT ==========\n\n";

            color(7);
            cout << "\nCuvantul: ";
            color(3);
            cin.ignore();
            getline(cin, cuvantIn);
            cuvantOut = "";

            if (DFA(cuvantIn, 0))
            {
                parcurgere += ']';

                color(7);
                cout << "Cuvantul ";

                color(14);
                if (cuvantIn == "")
                    cout << "vid";
                else
                    cout << cuvantIn;

                color(7);
                cout << " a fost acceptat cu output-ul: ";

                color(2);
                if (cuvantIn == "")
                    cout << "vid" << "\n\n";
                else
                    cout << cuvantOut;

                color(7);
                cout << ", urmand drumul: ";
                color(14);
                cout << parcurgere << "\n\n";
            }

            else
            {
                color(12);
                cout << "Cuvantul ";
                color(14);
                if (cuvantIn == "")
                    cout << "vid";
                else
                    cout << cuvantIn;
                color(12);
                cout << " NU a fost acceptat!\n\n";
            }

            color(14);
            cout << "Return to Menu\n";
            color(8);
            system("pause");
            system("cls");

            break;
#pragma endregion

#pragma region End Simulation (case default)
        default:
            color(11);
            cout << "========== END SIMULATION ==========\n\n";

            color(8);
            inMenu = false;

            break;
        }
#pragma endregion
    }
}


int main()
{
    meniu();
}
