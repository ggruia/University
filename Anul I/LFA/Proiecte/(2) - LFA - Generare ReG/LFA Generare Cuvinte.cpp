#include <fstream>
#include <vector>
#include <string>
using namespace std;

ifstream fin("generare.in");
ofstream fout("generare.out");


void generareCuv(vector<pair<string, string>>prod, string cuv, string NT, int nrLitere)
{
	for (int i = 0; i < prod.size(); i++)
	{
		if (NT == prod[i].first)
		{
			if (prod[i].second == "lmb" && nrLitere == 0)
				fout << cuv + " "; //afisare caz lambda

			else
				if (prod[i].second.length() == 1 && nrLitere == 1)
					fout << cuv + prod[i].second << " "; //afisare caz final

				else
					if (prod[i].second.length() == 2 && nrLitere)
						generareCuv(prod, cuv + prod[i].second[0], prod[i].second.substr(1, 1), nrLitere - 1);
		}
	}
}


int main()
{
	int nrN, nrP, nrT, nrLitere;

	fin >> nrN;
	vector<string> listaN(nrN); //vector neterminale
	for (int i = 0; i < nrN; i++)
		fin >> listaN[i];

	fin >> nrT;
	vector<string> listaT(nrT); //vector terminale
	for (int i = 0; i < nrT; i++)
		fin >> listaT[i];

	fin >> nrP;
	vector<pair<string, string>> listaP(nrP); //vector productii
	for (int i = 0; i < nrP; i++)
		fin >> listaP[i].first >> listaP[i].second;

	fin >> nrLitere;
	fout << "Cuvintele generate, de lungime " << nrLitere << ", sunt: ";

	generareCuv(listaP, "", "S", nrLitere);
}
