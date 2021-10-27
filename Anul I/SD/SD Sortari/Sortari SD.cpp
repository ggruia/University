/* IMPLEMENTARE ALGORITMI SORTARE:
  1. STL sort
  2. BUBBLE sort
  3. COUNT sort
  4. RADIX sort
  5. MERGE sort
  6. QUICK sort */

#include <iostream>
#include <fstream>
#include <algorithm>
#include <time.h>
using namespace std;

ifstream fin("in.txt");
ofstream fout("out.txt");

int v[10000000], copv[10000000], aux[10000000], lungime, maxim, nrTeste, tipArray;

#pragma region Sorting Algorithms
void stlSort()
{
    sort(v, v + lungime);
}


void bubbleSort()
{
    for (int i = 0; i < lungime; i++)
    {
        for (int j = 0; j < lungime - 1; j++)
        {
            if (v[j] > v[j + 1])
                swap(v[j], v[j + 1]);
        }
    }
}


void countSort()
{
    int l = 0;
    for (int i = 0; i < lungime; i++)
        aux[v[i]]++;

    for (int i = 0; i <= maxim; i++)
        while (aux[i])
        {
            v[l] = i;
            l++;
            aux[i]--;
        }
}


void LSDSort(int pow)
{
    int digit[10] = { 0 };

    for (int i = 0; i < lungime; i++)
        digit[(v[i] / pow) % 10]++;

    for (int i = 1; i <= 9; i++)
        digit[i] += digit[i - 1];

    for (int i = lungime - 1; i >= 0; i--)
    {
        int digIndex = (v[i] / pow) % 10;
        aux[digit[digIndex] - 1] = v[i];
        digit[digIndex]--;
    }

    for (int i = 0; i < lungime; i++)
        v[i] = aux[i];
}

void radixSort()
{
    int maxPow = 1;
    int m = maxim;
    while (m)
    {
        maxPow *= 10;
        m /= 10;
    }

    for (int pow = 1; maxPow / pow >= 1; pow = pow * 10)
        LSDSort(pow);
}


void interclasare(int p, int q)
{
    int m = (p + q) / 2;
    int st = p;
    int dr = m + 1;
    int k = 0;
    while (st <= m and dr <= q)
    {
        if (v[st] <= v[dr])
        {
            aux[k] = v[st];
            k++;
            st++;
        }
        else
        {
            aux[k] = v[dr];
            k++;
            dr++;
        }
    }
    while (st <= m)
    {
        aux[k] = v[st];
        st++;
        k++;
    }
    while (dr <= q)
    {
        aux[k] = v[dr];
        dr++;
        k++;
    }
    for (int i = p; i <= q; i++)
        v[i] = aux[i - p];
}

void mergeSort(int p, int q)
{
    if (q - p < 2)
    {
        if (v[p] > v[q])
            swap(v[p], v[q]);
    }
    else
    {
        int m = (p + q) / 2;
        mergeSort(p, m);
        mergeSort(m + 1, q);
        interclasare(p, q);

    }
}


int medianaTrei(int p, int q)
{
    int mij = (p + q) / 2;

    if ((v[p] > v[mij]) xor (v[p] > v[q]))
        return p;

    if ((v[mij] > v[p]) xor (v[mij] > v[q]))
        return mij;

    return q;
}

void quickSort(int p, int q)
{
    int indexPivot = medianaTrei(p, q);
    int pivot = v[indexPivot];

    int i = p, j = q;

    while (i <= j)
    {
        while (v[i] < pivot)
            i++;

        while (v[j] > pivot)
            j--;

        if (i <= j)
        {
            swap(v[i], v[j]);
            i++;
            j--;
        }
    }

    if (p < j)quickSort(p, j);
    if (i < q)quickSort(i, q);
}
#pragma endregion

#pragma region Array Types
void randomArray()
{
    for (int i = 0; i < lungime; i++)
        v[i] = rand() % maxim + 1;

    tipArray = 1;
}

void constArray()
{
    int x = rand() % maxim + 1;
    fill_n(v, lungime, x);

    tipArray = 2;
}

void ascSortedArray()
{
    randomArray();
    mergeSort(0, lungime - 1);

    tipArray = 3;
}

void descSortedArray()
{
    ascSortedArray();
    for (int i = 0; i < (lungime / 2); i++)
        swap(v[i], v[lungime - i - 1]);

    tipArray = 4;
}

void almostSortedArray()
{
    ascSortedArray();
    for (int i = 0; i < lungime / 10; i++)
    {
        int a = rand() % (lungime / 10) + 1;
        int b = rand() % (lungime / 10) + 1;
        swap(v[a], v[b]);
    }
    tipArray = 5;
}
#pragma endregion

void arrayGen(int arrayType)
{
    switch (arrayType)
    {
    case 1:
        randomArray();
        fout << "Sorting a RANDOM array with:";
        break;

    case 2:
        constArray();
        fout << "Sorting a CONSTANT array with:";
        break;

    case 3:
        ascSortedArray();
        fout << "Sorting an ASCENDANT - SORTED array with:";
        break;

    case 4:
        descSortedArray();
        fout << "Sorting a DESCENDANT - SORTED array with:";
        break;

    case 5:
        almostSortedArray();
        fout << "Sorting an ALMOST - SORTED array with:";
        break;
    }
}

#pragma region Rulare & Testare
bool testSort()
{
    for (int i = 0; i < lungime - 1; i++)
        if (v[i] > v[i + 1])
            return false;
    return true;
}

void rulareSortare(int nrSortare)
{
    for (int i = 0; i < lungime; i++)
        copv[i] = v[i];

    for (int i = 0; i < lungime; i++)
        fout << v[i] << ' ';
    fout << '\n';

    switch (nrSortare)
    {
#pragma region STL
    case 1:
    {
        clock_t timp = clock();
        stlSort();
        timp = double((clock() - timp)) / CLOCKS_PER_SEC;

        if (testSort())
            fout << "STL - Sort Completed Successfully in: " << timp << " s";
        else
            fout << "Sortarea nu a fost efectuata corect!";

        fill_n(aux, lungime, 0);
    }
    break;
#pragma endregion

#pragma region Bubble
    case 2:
    {
        if (lungime <= 10000)
        {
            clock_t timp = clock();
            bubbleSort();
            timp = double((clock() - timp)) / CLOCKS_PER_SEC;

            if (testSort())
                fout << "BUBBLE - Sort Completed Successfully in: " << timp << " s";
            else
                fout << "Sortarea nu a fost efectuata corect!";
        }
        else
            fout << "BUBBLE - Sort too Slow; sorting Aborted!";

        fill_n(aux, lungime, 0);
    }
    break;
#pragma endregion

#pragma region Count
    case 3:
    {
        if (maxim <= 10000000)
        {
            clock_t timp = clock();
            countSort();
            timp = double((clock() - timp)) / CLOCKS_PER_SEC;

            if (testSort())
                fout << "COUNT - Sort Completed Successfully in: " << timp << " s";
            else
                fout << "Sortarea nu a fost efectuata corect!";

            fill_n(aux, lungime, 0);
        }
        else
            fout << "COUNT - Sort unable to sort: values too High; sorting Aborted";
    }
    break;
#pragma endregion

#pragma region RadixLSD
    case 4:
    {
        clock_t timp = clock();
        radixSort();
        timp = double((clock() - timp)) / CLOCKS_PER_SEC;

        if (testSort())
            fout << "RADIX - Sort Completed Successfully in: " << timp << " s";
        else
            fout << "Sortarea nu a fost efectuata corect!";

        fill_n(aux, lungime, 0);
    }
    break;
#pragma endregion

#pragma region Merge
    case 5:
    {
        clock_t timp = clock();
        mergeSort(0, lungime - 1);
        timp = double((clock() - timp)) / CLOCKS_PER_SEC;

        if (testSort())
            fout << "MERGE - Sort Completed Successfully in: " << timp << " s";
        else
            fout << "Sortarea nu a fost efectuata corect!";

        fill_n(aux, lungime, 0);
    }
    break;
#pragma endregion

#pragma region Quick
    case 6:
    {
        if ((lungime > 10000) && (tipArray == 3 || tipArray == 4 || tipArray == 5))
            fout << "QUICK - Sort too Slow on Sorted Arrays; sorting Aborted!";
        else
        {
            clock_t timp = clock();
            quickSort(0, lungime - 1);
            timp = double((clock() - timp)) / CLOCKS_PER_SEC;

            if (testSort())
                fout << "QUICK - Sort Completed Successfully in: " << timp << " s";
            else
                fout << "Sortarea nu a fost efectuata corect!";

            fill_n(aux, lungime, 0);
        }
    }
    break;
#pragma endregion
    }
    fout << '\n';

    for (int i = 0; i < lungime; i++)
        fout << v[i] << ' ';
    fout << '\n';

    for (int i = 0; i < lungime; i++)
        v[i] = copv[i];
}
#pragma endregion


int main()
{
    srand(time(NULL));
    fin >> nrTeste;

    while (nrTeste)
    {
        fin >> lungime >> maxim;

        for (int k = 1; k <= 5; k++)
        {
            tipArray = k;
            arrayGen(tipArray);

            fout << "\nNumere = " << lungime << "     Maxim = " << maxim << "\n\n";

            for (int i = 1; i <= 6; i++)
                rulareSortare(i);

            fout << "\n\n\n";
        }
        nrTeste--;
    }
}