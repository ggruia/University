#include <iostream>
#include <fstream>
#include <string>
using namespace std;

/* Inspiratie:
	 -	https://www.youtube.com/playlist?list=PL9xmBV_5YoZNqDI8qfOZgzbqahCUmUEin
	 -	https://www.programiz.com/dsa/deletion-from-a-red-black-tree */

ifstream fin("abce.in");
ofstream fout("abce.out");

 /* --> Implementarea C++ a unui RED-BLACK Tree <--

 OPERATII posibile:
 1. INSERAREA unui element;
 2. STERGEREA unui element;
 3. CAUTAREA unui element in multime;
 4. PREDECESORUL unui element X;
 5. SUCCESORUL unui element X;
 6. SORTAREA elementelor dintr-un interval [A, B]. */


class Node
{
public:
	int value;
	bool colour; //0 - black, 1 - red; 
	Node* parent;
	Node* left;
	Node* right;

	Node()
	{
		value = 0;
		colour = 0;

		parent = nullptr;
		left = nullptr;
		right = nullptr;
	}

	Node(int val)
	{
		value = val;
		colour = 1;

		parent = nullptr;
		left = nullptr;
		right = nullptr;
	}
};

// RADACINA arborelui
Node* root;


// CAUTARE valoare
Node* find(Node* currentNode, int val)
{
	if (currentNode == nullptr || currentNode->value == val)
		return currentNode;

	else
		if (val < currentNode->value)
			return find(currentNode->left, val);

		else
			if (val > currentNode->value)
				return find(currentNode->right, val);
}


Node* minRightSubTree(Node* currentNode)
{
	Node* nod = currentNode->right;

	while (nod->left != nullptr)
	{
		nod = nod->left;
	}

	return nod;
}

Node* getSibling(Node* nod)
{
	if (!nod->parent) // root
		return nullptr;

	if (nod == nod->parent->left)
		return nod->parent->right;
	else
		return nod->parent->left;
}


// ROTIRE dupa pivot
void rotateLeft(Node* x)
{
	Node* y = x->right; // setam nodul (y) care va deveni radacina subarborelui

	x->right = y->left; // subarborele stang al y devine subarborele drept al x
	if (y->left != nullptr) //daca subarborele stang al y nu este NIL, il legam la x
		y->left->parent = x;

	y->parent = x->parent; // legam parintele lui x la y

	if (x->parent == nullptr) // daca x este radacina, radacina arborelui devine y
		root = y;
	else
		if (x == x->parent->left)
			x->parent->left = y; // p.left devine y
		else
			x->parent->right = y; // p.right devine y

	y->left = x; // punem subarborele x in stanga arborelui y
	x->parent = y;
}

void rotateRight(Node* x)
{
	Node* y = x->left; // setam nodul (y) care va deveni radacina subarborelui

	x->left = y->right; // subarborele drept al y devine subarborele stang al x
	if (y->right != nullptr) //daca subarborele drept al y nu este NIL, il legam la x
		y->right->parent = x;

	y->parent = x->parent; // legam parintele lui x la y

	if (x->parent == nullptr) // daca x este radacina, radacina arborelui devine y
		root = y;
	else
		if (x == x->parent->right) // p.right devine y
			x->parent->right = y;
		else
			x->parent->left = y; // p.left devine y

	y->right = x; // punem subarborele x in dreapta arborelui y
	x->parent = y;
}


 // BALANSARE dupa inserare
void insertFixUp(Node* newNode)
{
	while (newNode != root && newNode->parent->colour == 1)
	{
		Node* uncle = getSibling(newNode->parent);

		if (newNode->parent == newNode->parent->parent->left) //CASE 2.1: tatal e fiul stang al bunicului
		{
			if (uncle != nullptr && uncle->colour == 1) //CASE 1: unchiul e rosu
			{
				//SOLUTIE: recoloram parintele, bunicul si unchiul

				newNode->parent->parent->colour = 1;
				newNode->parent->colour = 0;
				uncle->colour = 0;

				newNode = newNode->parent->parent;
			}
			else //CASE 2: unchiul e negru
			{
				//SOLUTIE: rotim parintele in sensul invers al nodului

				if (newNode == newNode->parent->right) //CASE 2.1.1: tatal e rosu, iar nodul e fiul drept
				{
					//SOLUTIE: rotim bunicul in sensul invers al nodului si recoloram

					newNode = newNode->parent;
					rotateLeft(newNode);
				}

				newNode->parent->colour = 0;
				newNode->parent->parent->colour = 1;

				rotateRight(newNode->parent->parent);
			}
		}
		else //CASE 2.2: tatal e fiul drept al bunicului
		{
			if (uncle != nullptr && uncle->colour == 1) //CASE 1: unchiul e rosu
			{
				//SOLUTIE: recoloram parintele, bunicul si unchiul

				newNode->parent->parent->colour = 1;
				newNode->parent->colour = 0;
				uncle->colour = 0;

				newNode = newNode->parent->parent;
			}
			else //CASE 2: unchiul e negru
			{
				//SOLUTIE: rotim parintele in sensul invers al nodului

				if (newNode == newNode->parent->left) //CASE 2.1.1: tatal e rosu, iar nodul e fiul stang
				{
					//SOLUTIE: rotim bunicul in sensul invers al nodului si recoloram

					newNode = newNode->parent;
					rotateRight(newNode);
				}

				newNode->parent->colour = 0;
				newNode->parent->parent->colour = 1;

				rotateLeft(newNode->parent->parent);
			}
		}
	}

	//CASE 0: newNode e radacina
	//SOLUTIE: recoloram radacina
	root->colour = 0;
}


// INSERARE valoare
Node* insert(Node* currentNode, Node* newNode)
{
	if (currentNode == nullptr)
		return newNode;
	

	if (newNode->value < currentNode->value)
	{
		currentNode->left = insert(currentNode->left, newNode);
		currentNode->left->parent = currentNode;

		return currentNode;
	}
	else
		if (newNode->value > currentNode->value)
		{
			currentNode->right = insert(currentNode->right, newNode);
			currentNode->right->parent = currentNode;

			return currentNode;
		}
}


void deleteFixUp(Node* nod)
{
	if (nod == root)
		return;

	Node* sibling = getSibling(nod);
	Node* parent = nod->parent;

	if (sibling == nullptr)
		deleteFixUp(parent);
	else
	{
		if (sibling->colour) //fratele e rosu
		{
			parent->colour = 1;
			sibling->colour = 0;

			if (sibling == sibling->parent->left) rotateRight(parent);
			else rotateLeft(parent);

			deleteFixUp(nod);
		}

		else //fratele e negru
		{
			if ((sibling->left && sibling->left->colour) || (sibling->right && sibling->right->colour)) //are cel putin un copil rosu
			{
				if (sibling->left != nullptr && sibling->left->colour == 1)
				{
					if (sibling == sibling->parent->left) //fratele e copilul stang
					{
						sibling->left->colour = sibling->colour;
						sibling->colour = parent->colour;
						rotateRight(parent);
					}
					else //fratele e copilul drept
					{
						sibling->left->colour = parent->colour;
						rotateLeft(sibling);
						rotateLeft(parent);
					}
				}
				else
				{
					if (sibling == sibling->parent->left) //fratele e copilul stang
					{
						sibling->right->colour = parent->colour;
						rotateLeft(sibling);
						rotateRight(parent);
					}
					else //fratele e copilul drept
					{
						sibling->right->colour = sibling->colour;
						sibling->colour = parent->colour;
						rotateLeft(parent);
					}
				}
				parent->colour = false;
			}
			else //copiii fratelui sunt negrii
			{
				sibling->colour = true;
				if (!parent->colour) deleteFixUp(parent);
				else parent->colour = false;
			}
		}
	}
}


void sterge(Node* nod)
{
	bool originalColour = nod->colour;
	Node* x = nullptr;

	if (nod->left == nullptr && nod->right == nullptr) //nodul nu are fii: stergem nodul
	{
		if (nod->parent->left == nod)
			nod->parent->left == nullptr;
		else
			nod->parent->right == nullptr;
	}
	else
		if (nod->left == nullptr) //nodul are 1 fiu: stergem nodul si transplantam fiul
		{
			x = nod->right;
			x->parent = nod->parent;
			nod->parent->right = x;
		}
		else
			if (nod->right == nullptr)
			{
				x = nod->left;
				x->parent = nod->parent;
				nod->parent->left = x;
			}
			else //nodul are 2 fii: inlocuim nodul cu minimul din subarborele drept
			{
				Node* mrst = minRightSubTree(nod);
				originalColour = mrst->colour;
				x = mrst->right;

				if (mrst->parent == nod)
					x->parent = mrst;
				else
				{
					if (mrst->parent->left == mrst) //transplantam minimul din subarborele drept cu nil
					{
						mrst->parent->left = nullptr;
						mrst->left = nod->left;
						mrst->right = nod->right;
						mrst->parent = nod->parent;	
					}
					else
					{
						mrst->parent->right = nullptr;
						mrst->left = nod->left;
						mrst->right = nod->right;
						mrst->parent = nod->parent;
					}
				}

				if (nod->parent->right == nod)
					nod->parent->right = mrst;
				else
					nod->parent->left = mrst;

				mrst->colour = originalColour;
			}

	delete nod;

	if (originalColour == 0)
		deleteFixUp(x);
}

void erase(int x) // verificam ca nodul pe care vrem sa il stergem sa fie in arbore;
{
	Node* nod = find(root, x);

	if (nod == nullptr)
		return;

	sterge(nod);
}


//PREDECESORUL unei valori
Node* predecessor(Node* currentNode, int x)
{
	Node* predecesor = new Node();

	while (currentNode != nullptr)
	{
		if (currentNode->value == x)
			return currentNode;

		if (currentNode->value > x)
			currentNode = currentNode->left;
		else
		{
			predecesor = currentNode;
			currentNode = currentNode->right;
		}
	}

	return predecesor;
}

//SUCCESORUL unei valori
Node* successor(Node* currentNode, int x)
{
	Node* succesor = new Node();

	while (currentNode != nullptr)
	{
		if (currentNode->value == x)
			return currentNode;

		if (currentNode->value < x)
			currentNode = currentNode->right;
		else
		{
			succesor = currentNode;
			currentNode = currentNode->left;
		}
	}

	return succesor;
}


//AFISAREA elementelor din intervalul [A, B] SORTATE
void sortedInterval(Node* currentNode, int st, int dr)
{
	Node* x = successor(currentNode, st);

	while (x->value < dr)
	{
		fout << "(" << ((x == root) ? "R-" : "") << x->value << ", " << ((x->colour == 0) ? "black" : "red")<< ") ";
		x = successor(currentNode, x->value + 1);
	}

	if (x->value == dr)
		fout << "(" << ((x == root) ? "R-" : "") << x->value << ", " << ((x->colour == 0) ? "black" : "red") << ")\n";
}



int main()
{
	int n, op, x;
	fin >> n;

	while (n--)
	{
		fin >> op;

		if (op == 1)
		{
			fin >> x;
			Node* nou = new Node(x);

			root = insert(root, nou);
			insertFixUp(nou);
		}

		if (op == 2)
		{
			fin >> x;
			erase(x);
		}

		if (op == 3)
		{
			fin >> x;

			if (find(root, x) != nullptr)
				fout << 1 << "\n";
			else
				fout << 0 << "\n";
		}

		if (op == 4)
		{
			fin >> x;
			fout << predecessor(root, x)->value << "\n";
		}

		if (op == 5)
		{
			fin >> x;
			fout << successor(root, x)->value << "\n";
		}

		if (op == 6)
		{
			int st, dr;
			fin >> st >> dr;

			st = successor(root, st)->value; // minimul din arbore;
			dr = predecessor(root, dr)->value; // maximul din arbore;

			sortedInterval(root, st, dr);
		}
	}

	//cout << root->value << " " << root->colour << endl;
	//cout << root->left->value << " " << root->left->colour << endl;
	//cout << root->right->value << " " << root->right->colour << endl;
}