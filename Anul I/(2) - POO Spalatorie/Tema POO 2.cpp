#include <iostream>
#include <vector>
#include <cstdlib>
#include <string>
using namespace std;


// Implementarea proceselor tehnologice dintr-o spalatorie:
// Hainele (sunt) pot fi supuse la 4 procese:
// - spalare: se spala toate hainele in masini de spalat de 2 tipuri, folosindu-se o cantitate de detergent la o temperatura minima/maxima si de o culoare, fara a se amesteca;
// - stoarcere: unele haine se storc intr-o anumita perioada de timp;
// - uscare: toate hainele se usuca;
// - calcare: unele haine se calca intr-o anumita perioada de timp.
//


bool inMenu = true, citireMasini = false, citireHaine = false;
bool spalate, stoarse, uscate, calcate;

int nrMasini, nrClienti, nrHaine, copNrHaine;
int nrSpalari, nrStoarceri, nrUscari, nrCalcari;


class Haina
{
	static int nrHaine;

protected:
	float greutate; //0 - 10;
	bool culoare; //0 = deschis, 1 = inchis;
	bool varTemp; //0 = < , 1 = >;
	float temperatura; //0 - 100;
	float detergent; //1000 gr.

	string procese;
	bool spalat;
	bool stors;
	bool uscat;
	bool calcat;

public:
	Haina()
	{
		greutate = 0;
		culoare = 0;
		temperatura = 0;
		varTemp = 0;
		procese = "";
		detergent = 1000;
	}

	Haina(float weight, bool colour, float temperature, bool moreOrLessTemp)
	{
		greutate = weight;
		culoare = colour;
		temperatura = temperature;
		varTemp = moreOrLessTemp;
	}

	Haina(Haina& h)
	{
		greutate = h.greutate;
		culoare = h.culoare;
		varTemp = h.varTemp;
		temperatura = h.temperatura;
		detergent = h.detergent;
		procese = h.procese;
		spalat = h.spalat;
		stors = h.stors;
		uscat = h.uscat;
		calcat = h.calcat;
	}

	~Haina()
	{
		greutate = 0;
		culoare = 0;
		temperatura = 0;
		varTemp = 0;
		procese = "";
		detergent = 0;
	}

#pragma region Getters & Setters
	void setNrHaine(int x)
	{
		nrHaine = x;
	}

	int getNrHaine()
	{
		return nrHaine;
	}

	float getWeight()
	{
		return greutate;
	}
	void setWeight(float x)
	{
		greutate = x;
	}

	bool getColour()
	{
		return culoare;
	}
	void setColour(bool x)
	{
		culoare = x;
	}

	float getTemp()
	{
		return temperatura;
	}
	void setTemp(float x)
	{
		temperatura = x;
	}

	char getVarTemp()
	{
		if (varTemp)
			return '>';
		return '<';
	}
	void setVarTemp(bool x)
	{
		varTemp = x;
	}

	string getProcess()
	{
		return procese;
	}
	void setProcess(string x)
	{
		procese += x;
	}


	virtual float getDetergent()
	{
		return detergent;
	}


	bool getSpalat()
	{
		return spalat;
	}
	void setSpalat()
	{
		spalat = true;
	}

	bool getStors()
	{
		return stors;
	}
	void setStors()
	{
		stors = true;
	}

	bool getUscat()
	{
		return uscat;
	}
	void setUscat()
	{
		uscat = true;
	}

	bool getCalcat()
	{
		return calcat;
	}
	void setCalcat()
	{
		calcat = true;
	}
#pragma endregion

#pragma region Overloaded Operators
	friend istream& operator>> (istream& citire, Haina& h) //suprasciu >>
	{
		cout << "Greutatea (in kilograme): ";
		citire >> h.greutate;
		cout << "Nuanta (0 - deschisa, 1 - inchisa): ";
		citire >> h.culoare;
		cout << "Constraint-ul pentru temperatura (0 - <T, 1 - >T): ";
		citire >> h.varTemp;
		cout << "Temperatura (in grade): ";
		citire >> h.temperatura;
		return citire;
	}

	friend ostream& operator<< (ostream& afisare, Haina& h) //suprascriu <<
	{
		afisare << "   -> greutatea: " << h.greutate << "kg\n";

		afisare << "   -> nuanta: ";
		if (h.culoare == 0)
			afisare << "deschisa\n";
		else
			afisare << "inchisa\n";

		afisare << "   -> temperatura spalare: ";
		if (h.varTemp == 0)
			afisare << "< ";
		else
			afisare << "> ";
		afisare << h.temperatura << "*\n";

		afisare << "   -> detergent necesar: " << h.detergent << "gr.\n";

		return afisare;
	}

	Haina& operator= (Haina& x)
	{

	}
#pragma endregion
};

#pragma region Derived Clothes
class Pantalon :public Haina
{
public:
	Pantalon() :Haina()
	{
		spalat = 0;
		stors = 0;
		uscat = 0;
		calcat = 0;
		detergent = 200;
	}

	Pantalon(float weight, bool colour, float temperature, bool moreOrLessTemp): Haina(weight, colour, temperature, moreOrLessTemp)
	{

	}

	~Pantalon();

	/*Pantalon(const Pantalon& p)
	{
		greutate = p.greutate;
		culoare = p.culoare;
		varTemp = p.varTemp;
		temperatura = p.temperatura;
		detergent = p.detergent;
		procese = p.procese;
		spalat = p.spalat;
		stors = p.stors;
		uscat = p.uscat;
		calcat = p.calcat;
	}

	friend istream& operator>> (istream& citire, Pantalon& p);*/

	friend ostream& operator<< (ostream& afisare, Pantalon& p)
	{
		afisare << "   -> tipul: pantalon\n";
		afisare << (Haina&)p;
		return afisare;
	}

	Pantalon& operator= (Pantalon& x)
	{

	}

	void setDetergent()
	{
		if(culoare == 1)
			detergent = 2000;
		else
			detergent = 1000;
	}
};

class Rochie :public Haina
{
public:
	Rochie() :Haina()
	{
		spalat = 0;
		stors = 0;
		uscat = 0;
		calcat = 0;
		detergent = 1000;
	}

	Rochie(float weight, bool colour, float temperature, bool moreOrLessTemp) : Haina(weight, colour, temperature, moreOrLessTemp)
	{

	}

	~Rochie();

	/*Rochie(const Rochie& p)
	{
		greutate = p.greutate;
		culoare = p.culoare;
		varTemp = p.varTemp;
		temperatura = p.temperatura;
		detergent = p.detergent;
		procese = p.procese;
		spalat = p.spalat;
		stors = p.stors;
		uscat = p.uscat;
		calcat = p.calcat;
	}

	friend istream& operator>> (istream& citire, Rochie& r);*/

	friend ostream& operator<< (ostream& afisare, Rochie& r)
	{
		afisare << "   -> tipul: rochie\n";
		afisare << (Haina&)r;
		return afisare;
	}

	Rochie& operator= (Rochie& x)
	{

	}

	void setDetergent()
	{
		detergent = 1000;
	}
};

class Camasa :public Haina
{
public:
	Camasa() :Haina()
	{
		spalat = 0;
		stors = 0;
		uscat = 0;
		calcat = 0;
		detergent = 1000;
	}

	Camasa(float weight, bool colour, float temperature, bool moreOrLessTemp) : Haina(weight, colour, temperature, moreOrLessTemp)
	{

	}

	~Camasa();

	/*Camasa(const Camasa& p)
	{
		greutate = p.greutate;
		culoare = p.culoare;
		varTemp = p.varTemp;
		temperatura = p.temperatura;
		detergent = p.detergent;
		procese = p.procese;
		spalat = p.spalat;
		stors = p.stors;
		uscat = p.uscat;
		calcat = p.calcat;
	}

	friend istream& operator>> (istream& citire, Camasa& c);*/

	friend ostream& operator<< (ostream& afisare, Camasa& c)
	{
		afisare << "   -> tipul: camasa\n";
		afisare << (Haina&)c;
		return afisare;
	}

	Camasa& operator= (Camasa& x)
	{

	}

	void setDetergent()
	{
		detergent = 1000;
	}
};

class Palton :public Haina
{
public:
	Palton() :Haina()
	{
		spalat = 0;
		stors = 0;
		uscat = 0;
		calcat = 0;
	}

	Palton(float weight, bool colour, float temperature, bool moreOrLessTemp) : Haina(weight, colour, temperature, moreOrLessTemp)
	{

	}

	~Palton();

	/*Palton(const Palton& p)
	{
		greutate = p.greutate;
		culoare = p.culoare;
		varTemp = p.varTemp;
		temperatura = p.temperatura;
		detergent = p.detergent;
		procese = p.procese;
		spalat = p.spalat;
		stors = p.stors;
		uscat = p.uscat;
		calcat = p.calcat;
	}

	friend istream& operator>> (istream& citire, Palton& pa);*/

	friend ostream& operator<< (ostream& afisare, Palton& pa)
	{
		afisare << "   -> tipul: palton\n";
		afisare << (Haina&)pa;
		return afisare;
	}

	Palton& operator= (Palton& x)
	{

	}

	void setDetergent()
	{
		detergent = greutate * 100;
	}
};

class Geaca :public Haina
{
public:
	Geaca() :Haina()
	{
		spalat = 0;
		stors = 0;
		uscat = 0;
		calcat = 0;
	}

	Geaca(float weight, bool colour, float temperature, bool moreOrLessTemp) : Haina(weight, colour, temperature, moreOrLessTemp)
	{

	}

	~Geaca();

	/*Geaca(const Geaca& p)
	{
		greutate = p.greutate;
		culoare = p.culoare;
		varTemp = p.varTemp;
		temperatura = p.temperatura;
		detergent = p.detergent;
		procese = p.procese;
		spalat = p.spalat;
		stors = p.stors;
		uscat = p.uscat;
		calcat = p.calcat;
	}

	friend istream& operator>> (istream& citire, Geaca& g);*/

	friend ostream& operator<< (ostream& afisare, Geaca& g)
	{
		afisare << "   -> tipul: geaca\n";
		afisare << (Haina&)g;
		return afisare;
	}

	Geaca& operator= (Geaca& x)
	{

	}

	void setDetergent()
	{
		detergent = greutate * 100;
	}
};

class Costum :public Haina
{
public:
	Costum() :Haina()
	{
		spalat = 0;
		stors = 0;
		uscat = 0;
		calcat = 0;
		detergent = 1000;
	}

	Costum(float weight, bool colour, float temperature, bool moreOrLessTemp) : Haina(weight, colour, temperature, moreOrLessTemp)
	{

	}

	~Costum();

	/*Costum(const Costum& p)
	{
		greutate = p.greutate;
		culoare = p.culoare;
		varTemp = p.varTemp;
		temperatura = p.temperatura;
		detergent = p.detergent;
		procese = p.procese;
		spalat = p.spalat;
		stors = p.stors;
		uscat = p.uscat;
		calcat = p.calcat;
	}

	friend istream& operator>> (istream& citire, Costum& co);*/

	friend ostream& operator<< (ostream& afisare, Costum& co)
	{
		afisare << "   -> tipul: costum\n";
		afisare << (Haina&)co;
		return afisare;
	}

	Costum& operator= (Costum& x)
	{

	}

	void setDetergent()
	{
		detergent = greutate * 100;
	}
};
#pragma endregion


class Masina
{
protected:
	float durataFunctionare; //0 - 100;
	vector<Haina*> haineInMasina;

public:
	Masina()
	{
		durataFunctionare = 0;
	}

	Masina(float time)
	{
		durataFunctionare = time;
	}

	Masina(Masina& m)
	{
		durataFunctionare = m.durataFunctionare;
		haineInMasina = m.haineInMasina;
	}

	~Masina()
	{
		durataFunctionare = 0;
	}

#pragma region Getters & Setters
	virtual float getProcessTime()
	{
		return durataFunctionare;
	}
	void setProcessTime(float x)
	{
		durataFunctionare = x;
	}

	vector<Haina*> getClothesList()
	{
		return haineInMasina;
	}

	void setClothesList(Haina* h)
	{
		haineInMasina.push_back(h);
	}
#pragma endregion

#pragma region Overloaded Operators
	friend istream& operator>> (istream& citire, Masina& m) //suprasciu >>
	{
		cout << "\nTimpul de functionare (in secunde): ";
		citire >> m.durataFunctionare;
		return citire;
	}

	friend ostream& operator<< (ostream& afisare, Masina& m) //suprascriu <<
	{
		afisare << "\n   -> timp functionare: " << m.durataFunctionare << "s";
		return afisare;
	}

	Masina& operator= (Masina& x)
	{

	}
#pragma endregion
};

#pragma region Derived Machines
class Spalat: public Masina
{
protected:
	bool culoare; //0 = deschis, 1 = inchis;
	float capacitateMaxima, capacitateOcupata; //0 - 100;
	float tMax, tMin;

public:
	Spalat()
	{
		culoare = 0;
		capacitateMaxima = capacitateOcupata = 0;
		tMax = 99;
		tMin = 10;
	}

	Spalat(float time, float capacity): Masina(time)
	{
		capacitateMaxima = capacity;
	}

	Spalat(Spalat& s)
	{
		culoare = s.culoare;
		capacitateMaxima = s.capacitateMaxima;
		capacitateOcupata = s.capacitateOcupata;
		tMax = s.tMax;
		tMin = s.tMin;
	}

	~Spalat()
	{
		culoare = 0;
		capacitateMaxima = capacitateOcupata = 0;
		tMax = 99;
		tMin = 10;
	}

#pragma region Getters & Setters
	bool getColour()
	{
		return culoare;
	}
	void setColour(bool x)
	{
		culoare = x;
	}

	float getMaxCap()
	{
		return capacitateMaxima;
	}
	void setMaxCap(float x)
	{
		capacitateMaxima = x;
	}

	float getUsedCap()
	{
		return capacitateOcupata;
	}
	void setUsedCap(float x)
	{
		capacitateOcupata = x;
	}

	float getTempMin()
	{
		return tMin;
	}
	void setTempMin(float x)
	{
		tMin = x;
	}

	float getTempMax()
	{
		return tMax;
	}
	void setTempMax(float x)
	{
		tMax = x;
	}
#pragma endregion

	friend istream& operator>> (istream& citire, Spalat& s) //suprasciu >>
	{
		citire >> (Masina&)s;
		cout << "\nCapacitatea maxima (in kilograme): ";
		citire >> s.capacitateMaxima;
		return citire;
	}

	friend ostream& operator<< (ostream& afisare, Spalat& s) //suprascriu <<
	{
		afisare << (Masina&)s;
		afisare << "\n   -> capacitate maxima: " << s.capacitateMaxima << "kg";
		for(int i = 0; i< s.haineInMasina.size(); i++)
			afisare << s.haineInMasina[i] << " ";
		afisare << "\n";
		return afisare;
	}

	Spalat& operator= (Spalat& x)
	{

	}

	virtual void spalare()
	{
		for (int i = 0; i < haineInMasina.size(); i++)
		{
			string x = "SPALATA in ";
			x += to_string(durataFunctionare).substr(0, 4);
			x += " secunde intre temperaturile ";
			x += to_string(tMin).substr(0, 2);
			x += " si ";
			x += to_string(tMax).substr(0, 2);
			x += " cu o cantitate de ";
			x += to_string(haineInMasina[i]->getDetergent()).substr(0, 6);
			x += " grame detergent; ";
			haineInMasina[i]->setProcess(x);
		}

		haineInMasina.clear();
	}
};
class Spalat_O: public Spalat
{
public:

	/*friend istream& operator>> (istream& citire, Spalat_O& s);*/

	friend ostream& operator<< (ostream& afisare, Spalat_O& s0) //suprascriu <<
	{
		afisare << "\n   -> tip: obisnuit";
		afisare << (Spalat&)s0;
		return afisare;
	}
};
class Spalat_S: public Spalat
{
public:

	/*friend istream& operator>> (istream& citire, Spalat_S& s);*/

	friend ostream& operator<< (ostream& afisare, Spalat_S& s1) //suprascriu <<
	{
		afisare << "\n   -> tip: special";
		afisare << (Spalat&)s1;
		return afisare;
	}
};

class Stors: public Masina
{
	float capacitateMaxima, capacitateOcupata; //0 - 100;

public:
#pragma region Getters & Setters
	float getMaxCap()
	{
		return capacitateMaxima;
	}
	void setMaxCap(float x)
	{
		capacitateMaxima = x;
	}

	float getUsedCap()
	{
		return capacitateOcupata;
	}
	void setUsedCap(float x)
	{
		capacitateOcupata = x;
	}
#pragma endregion

	friend istream& operator>> (istream& citire, Stors& t) //suprasciu >>
	{
		citire >> (Masina&)t;
		cout << "\nCapacitatea maxima (in kilograme): ";
		citire >> t.capacitateMaxima;
		return citire;
	}

	friend ostream& operator<< (ostream& afisare, Stors& t) //suprascriu <<
	{
		afisare << (Masina&)t;
		afisare << "\n   -> capacitate maxima: " << t.capacitateMaxima << "kg";
		return afisare;
	}

	Stors& operator= (Stors& x)
	{

	}

	void stoarcere()
	{
		for (int i = 0; i < haineInMasina.size(); i++)
		{
			if (typeid(*haineInMasina[i]) == typeid(Pantalon) || typeid(*haineInMasina[i]) == typeid(Rochie) || typeid(*haineInMasina[i]) == typeid(Camasa) || typeid(*haineInMasina[i]) == typeid(Costum))
			{
				string x = "STOARSA in ";
				x += to_string(durataFunctionare).substr(0, 4);
				x += " secunde; ";
				haineInMasina[i]->setProcess(x);
			}
			else
				haineInMasina[i]->setProcess("NU a fost STOARSA; ");
		}

		haineInMasina.clear();
	}
};

class Uscat: public Masina
{
	short capacitateMaxima, capacitateOcupata; //0 - 100;

public:
#pragma region Getters & Setters
	short getMaxCap()
	{
		return capacitateMaxima;
	}
	void setMaxCap(short x)
	{
		capacitateMaxima = x;
	}

	short getUsedCap()
	{
		return capacitateOcupata;
	}
	void setUsedCap(short x)
	{
		capacitateOcupata = x;
	}
#pragma endregion

	friend istream& operator>> (istream& citire, Uscat& u) //suprasciu >>
	{
		citire >> (Masina&)u;
		cout << "\nCapacitatea maxima (nr articole): ";
		citire >> u.capacitateMaxima;
		return citire;
	}

	friend ostream& operator<< (ostream& afisare, Uscat& u) //suprascriu <<
	{
		afisare << (Masina&)u;
		afisare << "\n   -> capacitate maxima: " << u.capacitateMaxima << " articole";
		return afisare;
	}

	Uscat& operator= (Uscat& x)
	{

	}

	void uscare()
	{
		for (int i = 0; i < haineInMasina.size(); i++)
		{
			string x = "USCATA in ";
			x += to_string(durataFunctionare).substr(0, 4);
			x += " secunde; ";
			haineInMasina[i]->setProcess(x);
		}

		haineInMasina.clear();
	}
};

class Calcat: public Masina
{
	bool inUse;

public:
#pragma region Getters & Setters
	bool getUse()
	{
		return inUse;
	}
	void setUse(bool x)
	{
		inUse = x;
	}
#pragma endregion

	friend istream& operator>> (istream& citire, Calcat& c) //suprasciu >>
	{
		citire >> (Masina&)c;
		return citire;
	}

	friend ostream& operator<< (ostream& afisare, Calcat& c) //suprascriu <<
	{
		afisare << (Masina&)c;
		afisare << "\n   -> capacitate maxima: 1 articol";
		return afisare;
	}

	Calcat& operator= (Calcat& x)
	{

	}

	void calcare()
	{
		for (int i = 0; i < haineInMasina.size(); i++)
		{
			if (typeid(*haineInMasina[i]) == typeid(Pantalon) || typeid(*haineInMasina[i]) == typeid(Rochie) || typeid(*haineInMasina[i]) == typeid(Camasa) || typeid(*haineInMasina[i]) == typeid(Costum))
			{
				string x = "CALCATA in ";
				x += to_string(durataFunctionare).substr(0, 4);
				x += " secunde;\n";
				haineInMasina[i]->setProcess(x);
			}
			else
				haineInMasina[i]->setProcess("NU a fost CALCATA;\n");
		}

		haineInMasina.clear();
	}
};
#pragma endregion


vector<Haina*> listaHaine;

vector<Spalat*> listaMasiniSpalat;
vector<Stors*> listaMasiniStors;
vector<Uscat*> listaMasiniUscat;
vector<Calcat*> listaMasiniCalcat;


#pragma region Procese Tehnologice
bool testMasinaSpalat(Spalat *m, Haina* h)
{
	if (m->getUsedCap() == 0 && ((m->getMaxCap() - h->getWeight()) >= 0)) //daca masina e goala punem haina in ea SI ii schimbam caracteristicile pentru viitoarele haine;
	{
		if (typeid(*m) == typeid(Spalat_O) && (typeid(*h) == typeid(Pantalon) || typeid(*h) == typeid(Rochie) || typeid(*h) == typeid(Camasa) || typeid(*h) == typeid(Costum))) //daca tipul masinii (OBSINUITA) corespunde cu tipul hainei verifica:
		{
			m->setUsedCap(m->getUsedCap() + h->getWeight());
			m->setColour(h->getColour());

			if (h->getVarTemp() == true)
				m->setTempMin(h->getTemp());
			else
				m->setTempMax(h->getTemp());

			return true;
		}
		else
			if (typeid(*m) == typeid(Spalat_S) && (typeid(*h) == typeid(Palton) || typeid(*h) == typeid(Geaca) || typeid(*h) == typeid(Costum))) //daca tipul masinii (SPECIALA) corespunde cu tipul hainei verifica:
			{
				m->setUsedCap(m->getUsedCap() + h->getWeight());
				m->setColour(h->getColour());

				if (h->getVarTemp() == true)
					m->setTempMin(h->getTemp());
				else
					m->setTempMax(h->getTemp());

				return true;
			}
	}
	else //daca masina nu e goala verificam caracteristicile ultimei haine introduse pentru viitoarele haine;
	{
		if (m->getMaxCap() - m->getUsedCap() - h->getWeight() >= 0) //daca mai e loc in masina pentru haina curenta verifica:
		{
			if((typeid(*m) == typeid(Spalat_O) && (typeid(*h) == typeid(Pantalon) || typeid(*h) == typeid(Rochie) || typeid(*h) == typeid(Camasa))||
			   (typeid(*m) == typeid(Spalat_S) && (typeid(*h) == typeid(Geaca) || typeid(*h) == typeid(Palton) || typeid(*h) == typeid(Costum))))) //daca tipul masinii corespunde cu tipul hainei verifica:
			{
				if (m->getColour() == h->getColour()) //daca culoarea setata a masinii corespunde cu culoarea hainei verifica:
				{
					if (h->getVarTemp() == true) //daca masina accepta haine cu temperaturi mai mari decat tempMin:
					{
						if ((m->getTempMin() <= h->getTemp()) && (m->getTempMax() >= h->getTemp())) //daca temperatura hainei e mai mica decat tempMax e OK;
						{
							m->setTempMax(h->getTemp());
							
							return true;
						}
					}
					else //daca masina accepta haine cu temperaturi mai mici decat tempMax:
					{
						if ((m->getTempMax() >= h->getTemp()) && (m->getTempMin() <= h->getTemp())) //daca temperatura hainei e mai mare decat tempMin e OK;
						{
							m->setTempMin(h->getTemp());

							return true;
						}
					}
				}
			}
			else
			{
				if (typeid(*h) == typeid(Costum) && typeid(m->getClothesList().back()) == typeid(Costum))
				{
					if (m->getColour() == h->getColour()) //daca culoarea setata a masinii corespunde cu culoarea hainei verifica:
					{
						if (h->getVarTemp() == false) //daca masina accepta haine cu temperaturi mai mici decat tempMax:
						{
							if ((m->getTempMax() >= h->getTemp()) && (m->getTempMin() <= h->getTemp())) //daca temperatura hainei e mai mare decat tempMin e OK;
							{
								m->setTempMin(h->getTemp());

								return true;
							}
						}
						else //daca masina accepta haine cu temperaturi mai mare decat tempMin:
							if ((m->getTempMin() <= h->getTemp()) && (m->getTempMax() >= h->getTemp())) //daca temperatura hainei e mai mica decat tempMax e OK;
							{
								m->setTempMax(h->getTemp());

								return true;
							}
					}
				}
			}
		}
	}
	return false;
}

void Spalare()
{
	copNrHaine = nrHaine;
	while (copNrHaine > 0)
	{
		for (int i = 0; i < listaHaine.size(); i++)
		{
			if (listaHaine[i]->getSpalat() == 0)
				for (int j = 0; j < listaMasiniSpalat.size(); j++)
				{
					if (testMasinaSpalat(listaMasiniSpalat[j], listaHaine[i]) == true)
					{
						listaHaine[i]->setSpalat();
						listaMasiniSpalat[j]->setClothesList(listaHaine[i]);
						copNrHaine--;
						break;
					}
				}
		}

		for (int j = 0; j < listaMasiniSpalat.size(); j++)
		{
			listaMasiniSpalat[j]->spalare();
			listaMasiniSpalat[j]->setUsedCap(0);
		}
		nrSpalari++;
	}
}


bool testMasinaStors(Stors* m, Haina* h)
{
	if (m->getMaxCap() - m->getUsedCap() - h->getWeight() >= 0) //verificam daca haina are loc in masina de stors;
	{
		if (typeid(*h) == typeid(Pantalon) || typeid(*h) == typeid(Rochie) || typeid(*h) == typeid(Camasa) || typeid(*h) == typeid(Costum))
		{
			m->setUsedCap(m->getUsedCap() + h->getWeight());
			return 1;
		}
		else
		{
			return 1;
		}
	}
	return 0;
}

void Stoarcere()
{
	copNrHaine = nrHaine;
	while (copNrHaine > 0)
	{
		for (int i = 0; i < listaHaine.size(); i++)
		{
			if (listaHaine[i]->getStors() == 0)
				for (int j = 0; j < listaMasiniStors.size(); j++)
				{
					if (testMasinaStors(listaMasiniStors[j], listaHaine[i]) == true)
					{
						listaHaine[i]->setStors();
						listaMasiniStors[j]->setClothesList(listaHaine[i]);
						copNrHaine--;
						break;
					}
				}
		}

		for (int j = 0; j < listaMasiniStors.size(); j++)
		{
			listaMasiniStors[j]->stoarcere();
			listaMasiniStors[j]->setUsedCap(0);
		}
		nrStoarceri++;
	}
}


bool testMasinaUscat(Uscat* m, Haina* h)
{
	if (m->getMaxCap() - m->getUsedCap() - 1 >= 0) //verificam daca haina are loc in masina de uscat;
	{
		m->setUsedCap(m->getUsedCap() + 1);
		return 1;
	}
	return 0;
}

void Uscare()
{
	copNrHaine = nrHaine;
	while (copNrHaine > 0)
	{
		for (int i = 0; i < listaHaine.size(); i++)
		{
			if (listaHaine[i]->getUscat() == 0)
				for (int j = 0; j < listaMasiniUscat.size(); j++)
				{
					if (testMasinaUscat(listaMasiniUscat[j], listaHaine[i]) == true)
					{
						listaHaine[i]->setUscat();
						listaMasiniUscat[j]->setClothesList(listaHaine[i]);
						copNrHaine--;
						break;
					}
				}
		}

		for (int j = 0; j < listaMasiniUscat.size(); j++)
		{
			listaMasiniUscat[j]->uscare();
			//listaMasiniUscat[j]->getClothesList().clear();
			listaMasiniUscat[j]->setUsedCap(0);
		}
		nrUscari++;
	}
}


bool testMasinaCalcat(Calcat* m, Haina* h)

{
	if (m->getUse() == 0) //verificam daca se poate realiza calcarea;
	{
		if (typeid(*h) == typeid(Pantalon) || typeid(*h) == typeid(Rochie) || typeid(*h) == typeid(Camasa) || typeid(*h) == typeid(Costum))
		{
			m->setUse(true);
			return 1;
		}
		else
			return 1;
	}
	return 0;
}

void Calcare()
{
	copNrHaine = nrHaine;
	while (copNrHaine > 0)
	{
		for (int i = 0; i < listaHaine.size(); i++)
		{
			if (listaHaine[i]->getCalcat() == 0)
				for (int j = 0; j < listaMasiniCalcat.size(); j++)
				{
					if (testMasinaCalcat(listaMasiniCalcat[j], listaHaine[i]) == true)
					{
						listaHaine[i]->setCalcat();
						listaMasiniCalcat[j]->setClothesList(listaHaine[i]);
						copNrHaine--;
						break;
					}
				}
		}

		for (int j = 0; j < listaMasiniCalcat.size(); j++)
		{
			listaMasiniCalcat[j]->calcare();
			//listaMasiniCalcat[j]->getClothesList().clear();
			listaMasiniCalcat[j]->setUse(0);
		}
		nrCalcari++;
	}
}
#pragma endregion


void meniu()
{
	while (inMenu)
	{
	#pragma region Meniu Principal
		cout << "========== MENIU ==========\n\n";
		cout << ">> BINE ATI VENIT LA SPALATORIA *ULTRA CLEAN*! <<\n\n\n";
		cout << "Va rugam selectati o optiune dintre urmatoarele:\n\n";

		cout << "Citire date masini - 1\n";
		cout << "Citire date clienti & haine - 2\n\n";

		cout << "Afisare date masini - 3\n";
		cout << "Afisare date clienti & haine - 4\n\n";

		cout << "Executare spalare - 5\n";
		cout << "Executare stoarcere - 6\n";
		cout << "Executare uscare - 7\n";
		cout << "Executare calcare - 8\n\n";

		cout << "Executare procese - 9\n\n";

		cout << "Incheiere proces - 0\n\n\n";
		cout << "Optiune: ";

		short option;
		cin >> option;

		system("cls");
#pragma endregion

		switch (option)
		{
		#pragma region Citire Masini (case 1)
		case 1:
			cout << "========== CITIRE MASINI ==========\n\n";
			if (!citireMasini)
			{
				cout << "Introduceti numarul de masini: ";
				cin >> nrMasini;
				cout << "\n";

				for(int i = 0; i < nrMasini; i++)
				{
					cout << "\n\nIntroduceti caracteristicile masinii " << i + 1 << ":";
					cout << "\nTipul (1 - spalat, 2 - stors, 3 - uscat, 4 - calcat): ";

					Masina* masina;

					string tip;
					bool masinaCitita = false;

					while (!masinaCitita)
					{
						cin >> tip;
						try
						{
							if (stoi(tip) <= 4 && stoi(tip) >= 1 && tip.length() == 1)
							{
								if (stoi(tip) == 1)
								{
									string tipSpalat;
									bool citireMasinaSpalat = false;

									cout << "\nIntroduceti caracteristicile masinii de spalat:\n";
									cout << "Tipul (0 - obisnuita, 1 - speciala): ";

									while (!citireMasinaSpalat)
									{
										cin >> tipSpalat;
										try
										{
											if ((stoi(tipSpalat) == 1 || stoi(tipSpalat) == 0) && tipSpalat.length() == 1)
											{
												if (stoi(tipSpalat) == 0)
												{
													masina = new Spalat_O();
													cin >> *dynamic_cast<Spalat_O*>(masina);
													listaMasiniSpalat.push_back(dynamic_cast<Spalat_O*>(masina));
													masinaCitita = true;
												}
												else
													if (stoi(tipSpalat) == 1)
													{
														masina = new Spalat_S();
														cin >> *dynamic_cast<Spalat_S*>(masina);
														listaMasiniSpalat.push_back(dynamic_cast<Spalat_S*>(masina));
														masinaCitita = true;
													}
												citireMasinaSpalat = true;
											}
											else
												throw(tip);
										}
										catch (...)
										{
											cout << "\nValoarea introdusa nu este 0 sau 1; Introduceti alta valoare corespunzatoare: ";
										}
									}
								}
								else
									if (stoi(tip) == 2)
									{
										masina = new Stors();
										cin >> *dynamic_cast<Stors*>(masina);
										listaMasiniStors.push_back(dynamic_cast<Stors*>(masina));
										masinaCitita = true;
									}
									else
										if (stoi(tip) == 3)
										{
											masina = new Uscat();
											cin >> *dynamic_cast<Uscat*>(masina);
											listaMasiniUscat.push_back(dynamic_cast<Uscat*>(masina));
											masinaCitita = true;
										}
										else
											if (stoi(tip) == 4)
											{
												masina = new Calcat();
												cin >> *dynamic_cast<Calcat*>(masina);
												listaMasiniCalcat.push_back(dynamic_cast<Calcat*>(masina));
												masinaCitita = true;
											}
							}
							else
								throw (tip);
						}
						catch (...)
						{
							cout << "\nValoarea introdusa nu este 1 - 4; Introduceti alta valoare corespunzatoare: ";
						}
					}
				}
				citireMasini = true;
			}
			else
			{
				cout << "Masinile au fost citite si caracterizate deja...";
			}

			cout << "\n\n\nReturn to Menu\n";
			system("pause");
			system("cls");

			break;
#pragma endregion

		#pragma region Citire Haine (case 2)
		case 2:
			cout << "========== CITIRE HAINE ==========\n\n";
			if (!citireHaine)
			{
				cout << "Introduceti numarul de clienti: ";
				cin >> nrClienti;
				cout << "\n\n";

				for (int i = 0; i < nrClienti; i++)
				{
					cout << "\nIntroduceti numarul de articole al clientului " << i + 1 << ": ";
					int nrArticole;
					cin >> nrArticole;

					for (int j = 0; j < nrArticole; j++)
					{
						string tip;

						cout << "\nIntroduceti caracteristicile articolului " << j + 1 << ": ";
						cout << "\nTipul (1 - pantalon, 2 - rochie, 3 - camasa, 4 - palton, 5 - geaca, 6 - costum): ";

						bool hainaCitita = false;
						while (!hainaCitita)
						{
							cin >> tip;
							try
							{
								if (stoi(tip) == 1 && tip.length() == 1)
								{
									listaHaine.push_back(new Pantalon());
									cin >> *dynamic_cast<Pantalon*>(listaHaine.back());
									dynamic_cast<Pantalon*>(listaHaine.back())->setDetergent();
									hainaCitita = true;
								}
								else
									if (stoi(tip) == 2 && tip.length() == 1)
									{
										listaHaine.push_back(new Rochie());
										cin >> *dynamic_cast<Rochie*>(listaHaine.back());
										dynamic_cast<Rochie*>(listaHaine.back())->setDetergent();
										hainaCitita = true;
									}
									else
										if (stoi(tip) == 3 && tip.length() == 1)
										{
											listaHaine.push_back(new Camasa());
											cin >> *dynamic_cast<Camasa*>(listaHaine.back());
											dynamic_cast<Camasa*>(listaHaine.back())->setDetergent();
											hainaCitita = true;
										}
										else
											if (stoi(tip) == 4 && tip.length() == 1)
											{
												listaHaine.push_back(new Palton());
												cin >> *dynamic_cast<Palton*>(listaHaine.back());
												dynamic_cast<Palton*>(listaHaine.back())->setDetergent();
												hainaCitita = true;
											}
											else
												if (stoi(tip) == 5 && tip.length() == 1)
												{
													listaHaine.push_back(new Geaca());
													cin >> *dynamic_cast<Geaca*>(listaHaine.back());
													dynamic_cast<Geaca*>(listaHaine.back())->setDetergent();
													hainaCitita = true;
												}
												else
													if (stoi(tip) == 6 && tip.length() == 1)
													{
														listaHaine.push_back(new Costum());
														cin >> *dynamic_cast<Costum*>(listaHaine.back());
														dynamic_cast<Costum*>(listaHaine.back())->setDetergent();
														hainaCitita = true;
													}
													else
														throw(tip);
							}
							catch (...)
							{
								cout << "\nValoarea introdusa nu este 1 - 6; Introduceti alta valoare corespunzatoare: ";
							}
						}
						nrHaine++;
					}
				}
				citireHaine = true;
			}
			else
			{
				cout << "Articolele au fost citite si caracterizate deja...\n\n";
			}

			cout << "\n\n\nReturn to Menu\n";
			system("pause");
			system("cls");

			break;
#pragma endregion

		#pragma region Afisare Masini (case 3)
		case 3:
			cout << "========== AFISARE MASINI ==========\n\n";

			for (int i = 0; i < listaMasiniSpalat.size(); i++)
			{
				cout << "\nMasina de spalat " << i + 1 << ": ";

				if (typeid(*listaMasiniSpalat[i]) == typeid(Spalat_O))
					cout << *dynamic_cast<Spalat_O*>(listaMasiniSpalat[i]);
				else
					if (typeid(*listaMasiniSpalat[i]) == typeid(Spalat_S))
						cout << *dynamic_cast<Spalat_S*>(listaMasiniSpalat[i]);
			}
			cout << "\n";

			for (int i = 0; i < listaMasiniStors.size(); i++)
				cout << "\n\nMasina de stors " << i + 1 << ": " << *listaMasiniStors[i];
			cout << "\n\n";

			for (int i = 0; i < listaMasiniUscat.size(); i++)
				cout << "\n\nMasina de uscat " << i + 1 << ": " << *listaMasiniUscat[i];
			cout << "\n\n";

			for (int i = 0; i < listaMasiniCalcat.size(); i++)
				cout << "\n\nMasina de calcat " << i + 1 << ": " << *listaMasiniCalcat[i];
			cout << "\n";

			cout << "\n\n\nReturn to Menu\n";
			system("pause");
			system("cls");

			break;
#pragma endregion

		#pragma region Afisare Articole (case 4)
		case 4:
			cout << "========== AFISARE ARTICOLE ==========\n\n";

			for (int i = 0; i < nrHaine; i++)
			{
				cout << "Articolul " << i + 1 << ": \n";

				if (typeid(*listaHaine[i]) == typeid(Pantalon))
					cout << *dynamic_cast<Pantalon*>(listaHaine[i]) << "\n";

				if (typeid(*listaHaine[i]) == typeid(Rochie))
					cout << *dynamic_cast<Rochie*>(listaHaine[i]) << "\n";

				if (typeid(*listaHaine[i]) == typeid(Camasa))
					cout << *dynamic_cast<Camasa*>(listaHaine[i]) << "\n";

				if (typeid(*listaHaine[i]) == typeid(Palton))
					cout << *dynamic_cast<Palton*>(listaHaine[i]) << "\n";

				if (typeid(*listaHaine[i]) == typeid(Geaca))
					cout << *dynamic_cast<Geaca*>(listaHaine[i]) << "\n";

				if (typeid(*listaHaine[i]) == typeid(Costum))
					cout << *dynamic_cast<Costum*>(listaHaine[i]) << "\n";
			}

			cout << "\n\nReturn to Menu\n";
			system("pause");
			system("cls");

			break;
#pragma endregion

		#pragma region Spalare (case 5)
		case 5:
			cout << "========== EXECUTARE SPALARE ==========\n\n";

			if (!spalate)
			{
				Spalare();

				cout << "\nHainele au fost spalate in " << nrSpalari << " transe...\n\n\n";

				for (int i = 0; i < nrHaine; i++)
					cout << "Haina " << i + 1 << ": " << listaHaine[i]->getProcess() << "\n\n";

				spalate = true;
			}
			else
				cout << "Hainele au fost spalate deja...\n";

			cout << "\n\n\nReturn to Menu\n";
			system("pause");
			system("cls");

			break;
#pragma endregion

		#pragma region Stoarcere (case 6)
		case 6:
			cout << "========== EXECUTARE STOARCERE ==========\n\n";

			if (!stoarse)
			{
				Stoarcere();

				cout << "\nHainele au fost stoarse in " << nrStoarceri << " transe...\n\n\n";

				for (int i = 0; i < nrHaine; i++)
					cout << "Haina " << i + 1 << ": " << listaHaine[i]->getProcess() << "\n\n";

				stoarse = true;
			}
			else
				cout << "Hainele au fost stoarse deja...\n";

			cout << "\n\n\nReturn to Menu\n";
			system("pause");
			system("cls");

			break;
#pragma endregion

		#pragma region Uscare (case 7)
		case 7:
			cout << "========== EXECUTARE USCARE ==========\n\n";

			if (!uscate)
			{
				Uscare();

				cout << "\nHainele au fost uscate in " << nrUscari << " transe...\n\n\n";

				for (int i = 0; i < nrHaine; i++)
					cout << "Haina " << i + 1 << ": " << listaHaine[i]->getProcess() << "\n\n";

				uscate = true;
			}
			else
				cout << "Hainele au fost uscate deja...\n";

			cout << "\n\n\nReturn to Menu\n";
			system("pause");
			system("cls");

			break;
#pragma endregion

		#pragma region Calcare (case 8)
		case 8:
			cout << "========== EXECUTARE CALCARE ==========\n\n";

			if (!calcate)
			{
				Calcare();

				cout << "\nHainele au fost calcate in " << nrCalcari << " ture...\n\n\n";

				for (int i = 0; i < nrHaine; i++)
					cout << "Haina " << i + 1 << ": " << listaHaine[i]->getProcess() << "\n";

				calcate = true;
			}
			else
				cout << "Hainele au fost calcate deja...\n";

			cout << "\n\n\nReturn to Menu\n";
			system("pause");
			system("cls");

			break;
#pragma endregion

		#pragma region Toate Procesele (case 9)
		case 9:
			cout << "========== EXECUTARE PROCESE ==========\n\n";

			if (spalate == false)
				Spalare();

			if (stoarse == false)
				Stoarcere();

			if (uscate == false)
				Uscare();

			if (calcate == false)
				Calcare();

			cout << "\nHainele au fost curatate...\n\n";

			for (int i = 0; i < nrHaine; i++)
			{
				cout << "Haina " << i + 1;
				cout << " (";
				if (typeid(*listaHaine[i]) == typeid(Pantalon))
					cout << "Pantalon): ";
				else
					if (typeid(*listaHaine[i]) == typeid(Rochie))
						cout << "Rochie): ";
					else
						if (typeid(*listaHaine[i]) == typeid(Camasa))
							cout << "Camasa): ";
						else
							if (typeid(*listaHaine[i]) == typeid(Palton))
								cout << "Palton): ";
							else
								if (typeid(*listaHaine[i]) == typeid(Geaca))
									cout << "Geaca): ";
								else
									if (typeid(*listaHaine[i]) == typeid(Costum))
										cout << "Costum): ";
				cout << listaHaine[i]->getProcess() << "\n";
			}

			cout << "\n\n\nReturn to Menu\n";
			system("pause");
			system("cls");

			break;
#pragma endregion

		#pragma region End Tasks (case default)
		default:
			cout << "========== END TASKS ==========\n\n";

			cout << "\n\n\n   --> VA MULTUMIM CA ATI APELAT LA SPALATORIA *ULTRA CLEAN*! VA MAI ASTEPTAM PE LA NOI.. <--\n\n";

			inMenu = false;
			break;
#pragma endregion
		}
	}
}


int main()
{
	meniu();
}