#include <iostream>
#include <list>
#include <string>
using namespace std;

bool inMenu = true;


class Animal
{
protected:
	string denumire;
	bool habitat; //0 = acvatic, 1 = terestru;
	int marime;
	int durataViata;

public:
	Animal()
	{
		denumire = "";
		habitat = 0;
		marime = 0;
		durataViata = 0;
	}

	Animal(string d, bool h, int m, int v)
	{
		denumire = d;
		habitat = h;
		marime = m;
		durataViata = v;
	}

	Animal(Animal& a)
	{
		denumire = a.getDenumire();
		habitat = a.getHabitat();
		marime = a.getMarime();
		durataViata = a.getDurataViata();
	}

	~Animal()
	{
		denumire = "";
		habitat = 0;
		marime = 0;
		durataViata = 0;
	}

	friend istream& operator>> (istream& citire, Animal& a) //suprasciu >>
	{
		cout << "Denumirea: ";
		citire >> a.denumire;
		cout << "Habitat (0 - acvatic, 1 - terestru): ";
		citire >> a.habitat;
		cout << "Marime (0 - 100): ";
		citire >> a.marime;
		cout << "Durata de viata (0 - 100): ";
		citire >> a.durataViata;
		return citire;
	}

	friend ostream& operator<< (ostream& afisare, Animal& a) //suprascriu <<
	{
		afisare << "\nDenumirea: " << a.denumire;
		afisare << "\n-> Habitat (0 - acvatic, 1 - terestru): " << a.habitat;
		afisare << "\n-> Marime (0 - 500): " << a.marime;
		afisare << "\n-> Durata de viata (0 - 100): " << a.durataViata;

		return afisare;
	}

	void operator= (Animal& a)
	{
		denumire = a.getDenumire();
		habitat = a.getHabitat();
		marime = a.getMarime();
		durataViata = a.getDurataViata();
	}

	virtual void afisare()
	{
		cout << this;
	}

	virtual void citire(Animal a)
	{
		cin >> a;
	}

	string getDenumire()
	{
		return denumire;
	}

	bool getHabitat()
	{
		return habitat;
	}

	int getMarime()
	{
		return marime;
	}

	int getDurataViata()
	{
		return durataViata;
	}
};


// [meduza, sepie, melc, scorpion, stea-de-mare, paianjen, carabus, fluture, vierme, albina];
class Nevertebrata : public Animal
{
public:
	Nevertebrata() : Animal()
	{

	}

	Nevertebrata(string d, bool h, int m, int v) : Animal(d, h, m, v)
	{

	}

	Nevertebrata(Nevertebrata& nv)
	{
		denumire = nv.getDenumire();
		habitat = nv.getHabitat();
		marime = nv.getMarime();
		durataViata = nv.getDurataViata();
	}

	~Nevertebrata()
	{

	}

	friend istream& operator>> (istream& citire, Nevertebrata& nv) //suprasciu >>
	{
		citire >> (Animal&)nv;
		return citire;
	}

	friend ostream& operator<< (ostream& afisare, Nevertebrata& nv) //suprascriu <<
	{
		afisare << (Animal&)nv;
		afisare << "\n\n";
		return afisare;
	}

	virtual void operator= (Nevertebrata& nv)
	{
		denumire = nv.getDenumire();
		habitat = nv.getHabitat();
		marime = nv.getMarime();
		durataViata = nv.getDurataViata();
	}

	void afisare()
	{
		cout << this;
	}

	void citire(Nevertebrata nv)
	{
		cin >> nv;
	}
};

class Vertebrata : public Animal
{
public:
	Vertebrata() : Animal()
	{

	}

	Vertebrata(string d, bool h, int m, int v) : Animal(d, h, m, v)
	{

	}

	Vertebrata(Vertebrata& v)
	{
		denumire = v.getDenumire();
		habitat = v.getHabitat();
		marime = v.getMarime();
		durataViata = v.getDurataViata();
	}

	~Vertebrata()
	{

	}

	friend istream& operator>> (istream& citire, Vertebrata& v) //suprasciu >>
	{
		citire >> (Animal&)v;
		return citire;
	}

	friend ostream& operator<< (ostream& afisare, Vertebrata& v) //suprascriu <<
	{
		afisare << (Animal&)v;
		return afisare;
	}

	virtual void operator= (Vertebrata& v)
	{
		denumire = v.getDenumire();
		habitat = v.getHabitat();
		marime = v.getMarime();
		durataViata = v.getDurataViata();
	}

	void afisare()
	{
		cout << this;
	}

	void citire(Vertebrata v)
	{
		cin >> v;
	}
};


// [stiuca, crap, clean, baracuda, biban, peste-spada, platica, calcan, salau, pastrav];
class Peste : public Vertebrata
{
	bool salinitate; //0 = apa dulce, 1 = apa sarata;
	bool tip; //0 = pasnic, 1 = rapitor;

public:
	Peste() : Vertebrata()
	{
		salinitate = 0;
		tip = 0;
	}

	Peste(string d, bool h, int m, int v, bool s, bool t) : Vertebrata(d, h, m, v)
	{
		salinitate = s;
		tip = t;
	}

	friend istream& operator>> (istream& citire, Peste& p) //suprasciu >>
	{
		citire >> (Vertebrata&)p;
		cout << "Salinitate (0 - apa dulce, 1 - apa salina): ";
		citire >> p.salinitate;
		cout << "Tip (0 - pasnic, 1 - rapitor): ";
		citire >> p.tip;
		return citire;
	}

	friend ostream& operator<< (ostream& afisare, Peste& p) //suprascriu <<
	{
		afisare << (Vertebrata&)p;
		afisare << "\n-> Salinitate (0 - apa dulce, 1 - apa salina): " << p.salinitate;
		afisare << "\n-> Tip (0 - pasnic, 1 - rapitor): " << p.tip;
		afisare << "\n\n";
		return afisare;
	}

	bool getTip()
	{
		return tip;
	}
};

// [cameleon, guster, soparla, iguana, piton, mamba, testoasa, crocodil, caiman, basilisk];
class Reptila : public Vertebrata
{
	int nrOua;
	int dieta; //0 = erbivor, 1 = carnivor, 2 = omnivor;

public:
	Reptila() : Vertebrata()
	{
		nrOua = 0;
		dieta = 0;
	}

	Reptila(string d, bool h, int m, int v, int n, int f) : Vertebrata(d, h, m, v)
	{
		nrOua = n;
		dieta = f;
	}

	friend istream& operator>> (istream& citire, Reptila& r) //suprasciu >>
	{
		citire >> (Vertebrata&)r;
		cout << "Numar oua (0 - 10): ";
		citire >> r.nrOua;
		cout << "Dieta (0 - erbivor, 1 - carnivor, 2 - omnivor): ";
		citire >> r.dieta;
		return citire;
	}

	friend ostream& operator<< (ostream& afisare, Reptila& r) //suprascriu <<
	{
		afisare << (Vertebrata&)r;
		afisare << "\n-> Numar oua (0 - 10): " << r.nrOua;
		afisare << "\n-> Dieta (0 - erbivor, 1 - carnivor, 2 - omnivor): " << r.dieta;
		afisare << "\n\n";
		return afisare;
	}
};

// [cormoran, pelican, vrabie, randunica, curcan, pupaza, ciocanitoare, papagal, cuc, fazan];
class Pasare : public Vertebrata
{
	int nrOua;
	bool tip; //0 = pasnic, 1 = rapitor;

public:
	Pasare() : Vertebrata()
	{
		nrOua = 0;
		tip = 0;
	}

	Pasare(string d, bool h, int m, int v, int n, bool t) : Vertebrata(d, h, m, v)
	{
		nrOua = n;
		tip = t;
	}

	friend istream& operator>> (istream& citire, Pasare& b) //suprasciu >>
	{
		citire >> (Vertebrata&)b;
		cout << "Numar oua (0 - 10): ";
		citire >> b.nrOua;
		cout << "Tip (0 - pasnic, 1 - rapitor): ";
		citire >> b.tip;
		return citire;
	}

	friend ostream& operator<< (ostream& afisare, Pasare& b) //suprascriu <<
	{
		afisare << (Vertebrata&)b;
		afisare << "\n-> Numar oua (0 - 10): " << b.nrOua;
		afisare << "\n-> Tip (0 - pasnic, 1 - rapitor): " << b.tip;
		afisare << "\n\n";
		return afisare;
	}
};

// [ornitorinc, balena, cimpanzeu, soarece, urs, caprioara, leu, veverita, suricata, antilopa];
class Mamifer : public Vertebrata
{
	int perioadaGestatie;
	int dieta; //0 = erbivor, 1 = carnivor, 2 = omnivor;

public:
	Mamifer()
	{
		perioadaGestatie = 0;
		dieta = 0;
	}

	Mamifer(string d, bool h, int m, int v, int pg, int f) : Vertebrata(d, h, m, v)
	{
		perioadaGestatie = pg;
		dieta = f;
	}

	friend istream& operator>> (istream& citire, Mamifer& m) //suprasciu >>
	{
		citire >> (Vertebrata&)m;
		cout << "Dieta (0 - erbivor, 1 - carnivor, 2 - omnivor): ";
		citire >> m.dieta;
		cout << "Perioada gestatie (0 - 100): ";
		citire >> m.perioadaGestatie;
		return citire;
	}

	friend ostream& operator<< (ostream& afisare, Mamifer& m) //suprascriu <<
	{
		afisare << (Vertebrata&)m;
		afisare << "\n-> Dieta (0 - erbivor, 1 - carnivor, 2 - omnivor): " << m.dieta;
		afisare << "\n-> Perioada de gestatie (0 - 100): " << m.perioadaGestatie;
		afisare << "\n\n";
		return afisare;
	}
};


template<class Regn> class AtlasZoologic //template class
{
	int nrAnimale;
	list <Regn*> listaAnimale;

public:
	AtlasZoologic()
	{
		nrAnimale = 0;
	}

	~AtlasZoologic()
	{
		listaAnimale.clear();
		nrAnimale = 0;
	}

	void operator+= (Regn& a)
	{
		listaAnimale.push_back(dynamic_cast<Regn*>(&a));
		nrAnimale++;
	}

	list <Regn*> getAnimalsList()
	{
		return listaAnimale;
	}

	int getNrAnimale()
	{
		return nrAnimale;
	}
};

template<> class AtlasZoologic<Peste> //specializarea template-ului
{
	int nrAnimale;
	int nrRapitori;
	list <Peste*> listaAnimale;

public:
	AtlasZoologic()
	{
		nrAnimale = 0;
		nrRapitori = 0;
	}

	~AtlasZoologic()
	{
		listaAnimale.clear();
		nrAnimale = 0;
		nrRapitori = 0;
	}

	void operator+= (Peste& a)
	{
		listaAnimale.push_back(dynamic_cast<Peste*>(&a));
		nrAnimale++;

		if (a.getTip() && a.getMarime() > 100)
			nrRapitori++;
	}

	list <Peste*> getAnimalsList()
	{
		return listaAnimale;
	}

	int getNrAnimale()
	{
		return nrAnimale;
	}

	bool getNrRapitori()
	{
		return nrRapitori;
	}
};

void meniu()
{
	AtlasZoologic<Vertebrata> atlasZooV;
	AtlasZoologic<Nevertebrata> atlasZooNV;

	while (inMenu)
	{
		cout << "-=+=O=+=- MENIU -=+=O=+=-\n\n\n";
		cout << "Alegeti o optiune dintre urmatoarele:\n\n";
		cout << "Adaugare animale - 1\n";
		cout << "Afisare animale - 2\n";
		cout << "Incheiere simulare - 0\n\n";
		cout << "Optiune: ";

		int op1;
		cin >> op1;
		int s = 0;

		system("cls");

		switch (op1)
		{
		case 1:
			cout << "========== ADAUGARE ANIMALE ==========\n\n";

			cout << "Alegeti o optiune dintre urmatoarele:\n\n";
			cout << "Adaugare nevertebrate - 0\n";
			cout << "Adaugare vertebrate - 1\n";
			cout << "Optiune: ";

			int op2;
			cin >> op2;

			switch (op2)
			{
			case 1:
				cout << "\n\n\n========== ADAUGARE VERTEBRATE ==========\n\n";

				cout << "Alegeti o optiune dintre urmatoarele:\n\n";
				cout << "Adaugare pesti - 1\n";
				cout << "Adaugare reptile - 2\n";
				cout << "Adaugare pasari - 3\n";
				cout << "Adaugare mamifere - 4\n";
				cout << "Optiune: ";

				int op3, n;
				cin >> op3;
				Vertebrata* v;

				switch (op3)
				{
				case 1:
					cout << "\n\n\n========== ADAUGARE PESTI ==========\n\n";

					cout << "Introduceti numarul de specimene pe care doriti sa le adaugati in Atlas: ";
					cin >> n;

					while (n)
					{
						cout << "\n";
						v = new Peste();
						cin >> *dynamic_cast<Peste*>(v);
						//cout << *dynamic_cast<Peste*>(v);

						atlasZooV += *dynamic_cast<Peste*>(v);
						n--;
					}

					cout << "\n\nReturn to Menu\n";
					system("pause");
					system("cls");

					break;

				case 2:
					cout << "\n\n\n========== ADAUGARE REPTILE ==========\n\n";

					cout << "Introduceti numarul de specimene pe care doriti sa le adaugati in Atlas: ";
					cin >> n;

					while (n)
					{
						cout << "\n";
						v = new Reptila();
						cin >> *dynamic_cast<Reptila*>(v);
						//cout << *dynamic_cast<Reptila*>(v);

						atlasZooV += *dynamic_cast<Reptila*>(v);
						n--;
					}

					cout << "\n\nReturn to Menu\n";
					system("pause");
					system("cls");

					break;

				case 3:
					cout << "\n\n\n========== ADAUGARE PASARI ==========\n\n";

					cout << "Introduceti numarul de specimene pe care doriti sa le adaugati in Atlas: ";
					cin >> n;

					while (n)
					{
						cout << "\n";
						v = new	Pasare();
						cin >> *dynamic_cast<Pasare*>(v);
						//cout << *dynamic_cast<Pasare*>(v);

						atlasZooV += *dynamic_cast<Pasare*>(v);
						n--;
					}

					cout << "\n\nReturn to Menu\n";
					system("pause");
					system("cls");

					break;

				case 4:
					cout << "\n\n\n========== ADAUGARE MAMIFERE ==========\n\n";

					cout << "Introduceti numarul de specimene pe care doriti sa le adaugati in Atlas: ";
					cin >> n;

					while (n)
					{
						cout << "\n";
						v = new Mamifer();
						cin >> *dynamic_cast<Mamifer*>(v);
						//cout << *dynamic_cast<Mamifer*>(v);

						atlasZooV += *dynamic_cast<Mamifer*>(v);
						n--;
					}

					cout << "\n\nReturn to Menu\n";
					system("pause");
					system("cls");

					break;
				}

				break;

			default:
				cout << "\n\n\n========== ADAUGARE NEVERTEBRATE ==========\n\n";

				cout << "Introduceti numarul de specimene pe care doriti sa le adaugati in Atlas: ";
				cin >> n;

				while (n)
				{
					cout << "\n";
					Nevertebrata* nv = new Nevertebrata();
					cin >> *nv;

					atlasZooNV += *nv;
					n--;
				}

				cout << "\n\nReturn to Menu\n";
				system("pause");
				system("cls");

				break;
			}

			break;

		case 2:
			cout << "========== AFISARE ANIMALE ==========";

			cout << "\n\n\n----------- NEVERTEBRATE (";
			cout << atlasZooNV.getNrAnimale();
			cout << ") -----------\n\n";

			if (atlasZooNV.getNrAnimale())
			{
				cout << "\n\n    .----.   @   @\n";
				cout << "   / .-'-.`.  \\v/ \n";
				cout << "   | | '\\ \\ \\_/ )\n";
				cout << " ,-\\ `-.' /.' /\n";
				cout << "'---`----'----'\n\n\n";
			}

			for (auto const& animal : atlasZooNV.getAnimalsList())
				cout << *animal;

			cout << "\n\n\n------------ VERTEBRATE (";
			cout << atlasZooV.getNrAnimale();
			cout << ") -----------\n\n";

			/* BAZA AFISARII
			for (auto const& animal : atlasZooV.getAnimalsList())
			{
				if (typeid(*animal) == typeid(Peste))
					cout << *dynamic_cast<Peste*> (animal) << "\n";

				else
					if (typeid(*animal) == typeid(Reptila))
						cout << *dynamic_cast<Reptila*> (animal) << "\n";

					else
						if (typeid(*animal) == typeid(Pasare))
							cout << *dynamic_cast<Pasare*> (animal) << "\n";

						else
							if (typeid(*animal) == typeid(Mamifer))
								cout << *dynamic_cast<Mamifer*> (animal) << "\n";
			}*/

			for (auto const& animal : atlasZooV.getAnimalsList())
				if (typeid(*animal) == typeid(Peste))
				{
					if (s == 0)
					{
						cout << "\n\n      /`-._\n";
						cout << "     /_,.._`:-\n";
						cout << " ,.-'  ,   `-:..-')\n";
						cout << ": o ):';      _  {\n";
						cout << " `-._ `'__,.-'\\`-.)\n";
						cout << "     `\\\\  \\,.-'`\n\n\n";
					}
					s++;
					cout << *dynamic_cast<Peste*> (animal) << "\n";
				}
			s = 0;

			for (auto const& animal : atlasZooV.getAnimalsList())
				if (typeid(*animal) == typeid(Reptila))
				{
					if (s == 0)
					{
						cout << "\n\n               __\n";
						cout << "    .,-;-;-,. /'_\\\n";
						cout << "  _/_/_/_|_\\_\\) /\n";
						cout << "'-<_><_><_><_>=/\\\n";
						cout << "  `/_/====/_/-'\\_\\\n";
						cout << "   ""     ""    ""\n\n\n";
					}
					s++;
					cout << *dynamic_cast<Reptila*> (animal) << "\n";
				}
			s = 0;

			for (auto const& animal : atlasZooV.getAnimalsList())
				if (typeid(*animal) == typeid(Pasare))
				{
					if (s == 0)
					{
						cout << "\n\n    __      ,-/\n";
						cout << " .' \\ `.   / (\n";
						cout << "( \\\\`\\\\_|_;   \\\n";
						cout << " \\\\ _,' // ) ``)\n";
						cout << "  `/ // /// ',/\n";
						cout << "  (// /_,'_,-'\n";
						cout << "   `'-'.l_l_\n\n\n";
					}
					s++;
					cout << *dynamic_cast<Pasare*> (animal) << "\n";
				}
			s = 0;

			for (auto const& animal : atlasZooV.getAnimalsList())
				if (typeid(*animal) == typeid(Mamifer))
				{
					if (s == 0)
					{
						cout << "\n\n       ,::////;::-.\n";
						cout << "      /:'///// ``::>/|/\n";
						cout << "    .',  ||||    `/( e\\\n";
						cout << "-==~-'`-Xm````-mm-' `-_\\\n\n\n";
					}
					s++;
					cout << *dynamic_cast<Mamifer*> (animal) << "\n";
				}
			s = 0;

			cout << "\n\nReturn to Menu\n";
			system("pause");
			system("cls");

			break;

		default:
			cout << "========== INCHEIERE SIMULARE ==========\n\n";

			cout << "\n\n    .----.   @   @\n";
			cout << "   / .-'-.`.  \\v/ \n";
			cout << "   | | '\\ \\ \\_/ )\n";
			cout << " ,-\\ `-.' /.' /\n";
			cout << "'---`----'----'\n";

			cout << "\n\n";

			cout<<"      /`-._\n";
			cout<<"     /_,.._`:-\n";
			cout<<" ,.-'  ,   `-:..-')\n";
			cout<<": o ):';      _  {\n";
			cout<<" `-._ `'__,.-'\\`-.)\n";
			cout<<"     `\\\\  \\,.-'`\n";

			cout << "\n\n";

			cout<<"               __\n";
			cout<<"    .,-;-;-,. /'_\\\n";
			cout<<"  _/_/_/_|_\\_\\) /\n";
			cout<<"'-<_><_><_><_>=/\\\n";
			cout<<"  `/_/====/_/-'\\_\\\n";
			cout<<"   ""     ""    ""\n";

			cout << "\n\n";

			cout<<"    __      ,-/\n";
			cout<<" .' \\ `.   / (\n";
			cout<<"( \\\\`\\\\_|_;   \\\n";
			cout<<" \\\\ _,' // ) ``)\n";
			cout <<"  `/ // /// ',/\n";
			cout<<"  (// /_,'_,-'\n";
			cout<<"   `'-'.l_l_\n";

			cout << "\n\n";

			cout<<"       ,::////;::-.\n";
			cout<<"      /:'///// ``::>/|/\n";
			cout<<"    .',  ||||    `/( e\\\n";
			cout<<"-==~-'`-Xm````-mm-' `-_\\\n";
			
			cout << "\n\n";

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