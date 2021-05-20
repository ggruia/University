#include <iostream>
#include <time.h>
#include <windows.h>

#pragma region Definitii
#define cin std::cin
#define cout std::cout
#define fileIn std::ifstream
#define fileOut std::ofstream
#define istream std::istream
#define ostream std::ostream
#pragma endregion

#pragma region Initializari
const int nrMaxIndivizi = 30;
int currentIndex = 0;
int nrIndivizi;
bool inMenu = true;
bool citire = false;
#pragma endregion

class Individ
{
#pragma region Variables
private:
    int index; //pozitia (dintr-un tablou unidimensional de 30 de elemente declarat static in main)
    char tip; //„numele” speciei ('+' sau '0')
    int varsta; //varsta (de la 0 la 100)
    double energie; //energia curenta
    bool viu; //este 1 daca e viu si 0 daca e mort

    static Individ* Indivizi; //pointer la lista de indivizi
#pragma endregion

#pragma region Constructors & Destructors
public:
    Individ()
    {
        index = currentIndex;
        tip = '-';
        varsta = 0;
        energie = 0;
        viu = false;
        currentIndex++;
    }

    Individ(int poz, char specie)
    {
        index = poz;
        tip = specie;
        varsta = 1;
        energie = 50;
        viu = true;
    }

    ~Individ()
    {

    }
#pragma endregion

#pragma region Overloaded Operators
    friend istream& operator>> (istream& citire, Individ& individCurent) //suprasciu >>
    {
        return citire;
    }

    friend ostream& operator<< (ostream& afisare, Individ& individCurent) //suprascriu <<
    {
        return afisare;
    }

    Individ& operator= (Individ &copiator) //suprascriu = si pentru linking
    {
        index = copiator.getPosition();
        tip = copiator.getSpecies();
        varsta = copiator.getAge();
        energie = copiator.getEnergy();
        viu = copiator.getAlive();

        return *this;
    }
#pragma endregion

#pragma region Setters & Getters
    static Individ* getIndivizi()
    {
        return Indivizi;
    }
    static void setIndivizi(Individ* arr)
    {
        Indivizi = arr;
    }

    void setPosition(int pos)
    {
        index = pos;
    }
    int getPosition()
    {
        return index;
    }


    void setSpecies(char type)
    {
        tip = type;
    }
    char getSpecies()
    {
        return tip;
    }


    void setAge(int age)
    {
        varsta = age;
    }
    int getAge()
    {
        return varsta;
    }


    void setEnergy(double energy)
    {
        energie = energy;
    }
    double getEnergy()
    {
        return energie;
    }


    void setAlive(bool aliveStatus)
    {
        viu = aliveStatus;
    }
    bool getAlive()
    {
        return viu;
    }
#pragma endregion

#pragma region Private Methods
private:
    void hraneste()
    {
        double energieRandom = (double(rand() % 900) + 100)/100.00;
        energie += energieRandom;

        if (energie > 200)
            energie = 200;
    }

    void inmulteste()
    {
        if (varsta > 0)
        {
            bool inmultit = false;

            if (index > 0)
            {
                Individ* childLeft = &Indivizi[index - 1];

                if (childLeft->viu == false && inmultit == false)
                {
                    childLeft->viu = true;
                    childLeft->varsta = 0;
                    childLeft->energie = energie * 1.2;
                    childLeft->tip = tip;

                    if (childLeft->energie > 120)
                        childLeft->energie = 120;
                    Indivizi[index - 1] = *childLeft;

                    inmultit = true;
                }

                if (index < nrMaxIndivizi - 1)
                {
                    Individ* childRight = &Indivizi[index + 1];

                    if (childRight->viu == false && inmultit == false)
                    {
                        childRight->viu = true;
                        childRight->varsta = 0;
                        childRight->energie = energie * 1.2;
                        childRight->tip = tip;

                        if (childRight->energie > 120)
                            childRight->energie = 120;
                        Indivizi[index + 1] = *childRight;

                        inmultit = true;
                    }
                }
            }

            if (index == 0)
            {
                Individ childRight = Indivizi[index + 1];

                if (childRight.viu == false && inmultit == false)
                {
                    childRight.viu = true;
                    childRight.varsta = 0;
                    childRight.energie = energie * 1.2;
                    childRight.tip = tip;

                    if (childRight.energie > 120)
                        childRight.energie = 120;
                    Indivizi[index + 1] = childRight;

                    inmultit = true;
                }
            }
        }
    }

    void moare()
    {
        viu = false;
        energie = 0;
        varsta = 0;
    }

    void ataca()
    {
        if (index > 0)
        {
            Individ* bullyLeft = &Indivizi[index - 1];

            if (bullyLeft->esteViu() == true && bullyLeft->energie < energie && bullyLeft->tip != tip)
            {
                energie -= bullyLeft->energie;
                bullyLeft->moare();
            }
        }

        if (index < nrMaxIndivizi - 1)
        {
            Individ* bullyRight = &Indivizi[index + 1];

            if (bullyRight->esteViu() == true && bullyRight->energie < energie && bullyRight->tip != tip)
            {
                energie -= bullyRight->energie;
                bullyRight->moare();
            }
        }
    }

    void imbatraneste()
    {
        varsta++;
        energie -= 5;

        if (varsta >= 100 || energie <= 0)
            moare();
    }
#pragma endregion

#pragma region Public Methods
public:
    void actualizare()
    {
        hraneste();
        inmulteste();
        ataca();
        imbatraneste();
    }

    bool esteViu()
    {
        return viu;
    }
    
    char getTip()
    {
        return tip;
    }
#pragma endregion
};

Individ listaIndivizi[30];
Individ* Individ::Indivizi;

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

void afisareMatrice()
{
#pragma region Stocare Date Matrice
    std::string linie[20];
    double energieMatrice[30];

    for (int i = 0; i < nrMaxIndivizi; i++)
        energieMatrice[i] = listaIndivizi[i].getEnergy();

    for (int j = 0; j < 20; j++)
    {
        linie[j] = "|";
        for (int i = 0; i < nrMaxIndivizi; i++)
        {
            if (listaIndivizi[i].esteViu() == false)
                linie[j] += "  |";

            else
            {
                if (energieMatrice[i] <= 0)
                {
                    linie[j] += "  |";
                }
                else
                {
                    linie[j] += listaIndivizi[i].getTip();
                    linie[j] += listaIndivizi[i].getTip();
                    linie[j] += "|";
                    energieMatrice[i] -= 10;
                }
            }
        }
    }
#pragma endregion

#pragma region Afisare Energie
    for (int i = 19; i >= 0; i--)
    {
        for (int j = 0; j < 91; j++)
        {
            if (linie[i][j] == '|')
            {
                color(8);
                cout << linie[i][j];
            }
            else
                if (linie[i][j] == '+' || linie[i][j] == '0')
                {
                    color(7);
                    cout << linie[i][j];
                }
                else
                    cout << " ";
        }

        color(14);
        cout << " - ";
        if ((i + 1) * 10 < 100)
            cout << ' ' << (i + 1) * 10 << " energy\n";
        else
            cout << (i + 1) * 10 << " energy\n";
    }

    color(8);
    for (int i = 0; i < nrMaxIndivizi; i++)
        cout << "===";
    cout << "=\n\n";
#pragma endregion

#pragma region Upper Margin
    color(11);
    for (int i = 0; i < nrMaxIndivizi; i++)
        cout << "===";
    cout << "=\n";
#pragma endregion

#pragma region Position
    for (int i = 0; i < nrMaxIndivizi; i++)
    {
        color(7);
        cout << '|';

        color(3);
        if (listaIndivizi[i].getPosition() < 9)
            cout << '0' << listaIndivizi[i].getPosition() + 1;

        else
            cout << listaIndivizi[i].getPosition() + 1;
    }
    color(7);
    cout << "| = position\n";
#pragma endregion

#pragma region Delimitor
    color(7);
    for (int i = 0; i < nrMaxIndivizi; i++)
        cout << "+--";
    cout << "+\n";
#pragma endregion

#pragma region Age
    for (int i = 0; i < nrMaxIndivizi; i++)
    {
        color(7);
        cout << '|';

        color(10);
        if (listaIndivizi[i].getAge() < 10)
            cout << '0' << listaIndivizi[i].getAge();

        else
            if (listaIndivizi[i].getAge() > 10 && listaIndivizi[i].getAge() < 100)
                cout << listaIndivizi[i].getAge();
            else
                cout << "00";
    }
    color(7);
    cout << "| = age\n";
#pragma endregion

#pragma region Lower Margin
    color(11);
    for (int i = 0; i < nrMaxIndivizi; i++)
        cout << "===";
    cout << "=\n";
#pragma endregion
}

void meniu()
{
#pragma region Initializare
    srand(time(NULL));
    Individ::setIndivizi(listaIndivizi);
#pragma endregion

    while (inMenu)
    {
#pragma region Meniu Principal
        color(14);
        cout << "-=+=O=+=- MENIU -=+=O=+=-\n\n\n";
        cout << "Alegeti o optiune dintre urmatoarele:\n\n";
        color(7);
        cout << "Citire date indivizi - 1\n";
        cout << "Actualizare indivizi - 2\n";
        cout << "Afisare indivizi vii - 3\n";
        cout << "Afisare tip indivizi - 4\n";
        cout << "Reprezentare grafica - 5\n";
        cout << "Incheiere simulare - 0\n\n";
        color(14);
        cout << "Optiune: ";

        unsigned int option;
        color(12);
        cin >> option;

        std::string choice = "";
        bool actualizare = true;

        system("cls");
#pragma endregion

        switch (option)
        {
#pragma region Citire Indivizi (case 1)
        case 1:
            color(11);
            cout << "========== CITIRE INDIVIZI ==========\n\n";
            if (!citire)
            {
                color(14);
                cout << "Introduceti numarul de indivizi (";
                color(12);
                cout << "1";
                color(14);
                cout << " - ";
                color(12);
                cout << "30";
                color(14);
                cout << " ): ";
                color(10);
                cin >> nrIndivizi;
                cout << "\n\n";

                for (int i = 0; i < nrIndivizi; i++)
                {
                    int index;
                    char tip;

                    color(14);
                    cout << "Introduceti caracteristicile individului ";
                    color(3);
                    cout << i + 1;
                    color(14);
                    cout<< ":\n";

                    color(7);
                    cout << "Pozitia (";
                    color(12);
                    cout << "1";
                    color(7);
                    cout << " - ";
                    color(12);
                    cout << "30";
                    color(7);
                    cout << "): ";
                    color(10);
                    cin >> index;

                    color(7);
                    cout << "Tipul (";
                    color(12);
                    cout << "+";
                    color(7);
                    cout << " sau ";
                    color(12);
                    cout << "0";
                    color(7);
                    cout << "): ";
                    color(10);
                    cin >> tip;
                    cout << '\n';

                    Individ aux = Individ(index - 1, tip);
                    listaIndivizi[index - 1] = aux;
                }
                citire = true;
            }
            else
            {
                color(12);
                cout << "Indivizii au fost cititi si caracterizati deja...\n\n";
            }

            color(14);
            cout << "Return to Menu\n";
            color(8);
            system("pause");
            system("cls");

            break;
#pragma endregion

#pragma region Actualizare (case 2)
        case 2:
            color(11);
            cout << "========== ACTUALIZARE ==========\n\n";

            for (int i = 0; i < nrMaxIndivizi; i++)
            {
                if (listaIndivizi[i].esteViu() == true)
                    listaIndivizi[i].actualizare();
            }
            color(2);
            cout << "Toti indivizii au fost actualizati!\n\n";

            color(14);
            cout << "Return to Menu\n";
            color(8);
            system("pause");
            system("cls");

            break;
#pragma endregion

#pragma region Afisare Status (case 3)
        case 3:
            color(11);
            cout << "========== STATUS INDIVIZI ==========\n\n";

            color(14);
            cout << "Status indivizi: (";
            color(7);
            cout << "viu - ";
            color(10);
            cout << "1";
            color(14);
            cout << "; ";
            color(7);
            cout << "mort - ";
            color(12);
            cout << "0";
            color(14);
            cout << ")\n\n";

            for (int i = 0; i < nrMaxIndivizi; i++)
                if (listaIndivizi[i].esteViu())
                {
                    color(10);
                    cout << listaIndivizi[i].esteViu() << ' ';
                }
                else
                {
                    color(12);
                    cout << listaIndivizi[i].esteViu() << ' ';
                }

            color(2);
            cout << "\n\nS-a afisat statusul tuturor indivizilor!\n\n";

            color(14);
            cout << "Return to Menu\n";
            color(8);
            system("pause");
            system("cls");

            break;
#pragma endregion

#pragma region Afisare Tip (case 4)
        case 4:
            color(11);
            cout << "========== TIP INDIVIZI ==========\n\n";

            color(14);
            cout << "Tip indivizi: (";
            color(11);
            cout << "+";
            color(7);
            cout << " sau ";
            color(9);
            cout << "0 ";
            color(14);
            cout << ")\n\n";

            for (int i = 0; i < nrMaxIndivizi; i++)
                if (listaIndivizi[i].getTip() != '-')
                {
                    if (listaIndivizi[i].getTip() == '+')
                    {
                        color(11);
                        cout << listaIndivizi[i].getTip() << ' ';
                    }
                    else
                    {
                        color(9);
                        cout << listaIndivizi[i].getTip() << ' ';
                    }
                }
                else
                {
                    color(12);
                    cout << "- ";
                }
            
            color(2);
            cout << "\n\nS-a afisat tipul tuturor indivizilor!\n\n";

            color(14);
            cout << "Return to Menu\n";
            color(8);
            system("pause");
            system("cls");

            break;
#pragma endregion

#pragma region Interfata Grafica (case 5)
        case 5:
            color(11);
            cout << "========== INTERFATA GRAFICA ==========\n\n";

            while (actualizare)
            {
                afisareMatrice();

                color(14);
                cout << "\n\nDoriti sa se efectueze inca o actualizare?\n";
                color(7);
                cout << "Confirmare - 1\n";
                cout << "Return to Menu - 0\n\n";
                color(14);
                cout << "Optiune: ";

                char i;
                color(12);
                cin >> i;

                if (i == '0')
                {
                    system("cls");
                    break;
                }
                else
                {
                    system("cls");

                    for (int i = 0; i < nrMaxIndivizi; i++)
                    {
                        if (listaIndivizi[i].esteViu() == true)
                            listaIndivizi[i].actualizare();
                    }
                }
            }
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