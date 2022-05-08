/*
+---------------------------------------------------------- ENCRYPTOR ---------------------------------------------------------------------+
|                                                                                                                                          |
| Sa se implementeze un encriptor/decriptor care primeste un fisier de intrare cu diferite cuvinte.                                        |
|                                                                                                                                          |
|   - Programul mapeaza fisierul de intrare in memorie si porneste mai multe procese care vor aplica o permutare random pt fiecare cuvant. |
|   - Permutarile vor fi scrise intr-un fisier de iesire. Programul poate primi ca argument doar fisierul de intrare,                      |
|       in acest caz va face criptarea cuvintelor; sau va primi fisierul avand cuvintele criptate si permutarile folosite pt criptare,     |
|       caz in care va genera fisierul de output avand cuvintele decriptate.                                                               |
|                                                                                                                                          |
+------------------------------------------------------------------------------------------------------------------------------------------+
*/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <math.h>
#include <time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <sys/wait.h>


// generates a radom permutation of (n);
int* permutation (int n)
{
    int* perm = malloc(n * sizeof(int));
    
    for (int i = 0; i < n; i++)
        perm[i] = i;

    for (int i = 0; i < n; i++)
    {
	    int idx, aux;
	    idx = rand() % (n - i) + i;

	    aux = perm[idx];
        perm[idx] = perm[i];
        perm[i] = aux;
    }

    return perm;
}

// encrypts a string (word) by a permutation (code);    => inverse decryption
char* encryptWord(char* word, int* code)
{
    char* result = malloc(strlen(word) * sizeof(char));

    for(int i = 0; i < strlen(word); i++)
        result[i] = word[code[i]];

    return result;
}

// decrypts a string (word) by a permutation (code);    => inverse encryption
char* decryptWord(char* word, int* code)
{
    char* result = malloc(strlen(word) * sizeof(char));

    for(int i = 0; i < strlen(word); i++)
        result[code[i]] = word[i];

    return result;
}



int main(int argc, char** argv)
{
    if(argc != 3 && argc != 4)
    {
        printf("Incorrect number of arguments!\n");
        return 0;
    }

    // seed the rand function with current time to create pseudo-randomness;
    srand(time(NULL));

    // get inputFile's filedescriptor (fd) and statbuffer (sb);
    int fd = open(argv[1], O_RDWR, S_IRUSR | S_IWUSR);
    struct stat sb;

    if(fstat(fd, &sb) == -1)
        perror("Can't access file size!\n");

    // map inputFile in memory;
    char* mappedInputFile = mmap(NULL, sb.st_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);

    // current word's length;
    int currentLength = 0;
    // current allocated memory blocks;
    int memBlocks = 1;

    int nrWords = 0;
    int* wordLengths = malloc(sizeof(int));

    for(int i = 0; i <= sb.st_size; i++)
    {
        // dynamic memory allocation (when already allocated memory gets full, reallocate twice as much to save execution time with (nrWords) reallocs);
        if(nrWords + 1 > memBlocks)
        {
            memBlocks *= 2;
            wordLengths = realloc(wordLengths, memBlocks * sizeof(int));
        }

        // character by character iteration of the mapped inputFile;
        if(mappedInputFile[i] != ' ' && mappedInputFile[i] != '\n' && i != sb.st_size)
            currentLength++;
        else
        {
            wordLengths[nrWords] = currentLength;
            currentLength = 0;
            nrWords++;
        }
    }


    // needed for keeping child processes' execution in order;
    pid_t pid_list[nrWords];

    int** permutationsList = malloc(nrWords * sizeof(int*));
    char** child_ptr_list = malloc(nrWords * sizeof(char*));

    int pos = 0;


    if(argc == 3)   // argv = [<name>, input, output] ---> encrypt
    {
        FILE* outputFile;
        if((outputFile = fopen(argv[2], "w")) == NULL)
        {
            perror("Can't open output file!\n");
            return errno;
        }

        FILE* codeFile;
        if((codeFile = fopen("passwords", "w")) == NULL)
        {
            perror("Can't open passwords file!\n");
            return errno;
        }

        for(int i = 0; i < nrWords; i++)
        {
            // fork (nrWords) processes, each encrypting a word;
            pid_list[i] = fork();

            if(pid_list[i] == 0)
            {
                // pointer arithmetics to find corresponding memory address for each word
                child_ptr_list[i] = mappedInputFile + pos;
                
                char* cuvant = malloc(wordLengths[i] + 1);

                permutationsList[i] = permutation(wordLengths[i]);

                strncpy(cuvant, child_ptr_list[i], wordLengths[i]);
                strncpy(cuvant, encryptWord(cuvant, permutationsList[i]), wordLengths[i]);
                cuvant[wordLengths[i]] = '\0';

                fprintf(outputFile, "%s ", cuvant);

                for(int j = 0; j < wordLengths[i]; j++)
                    fprintf(codeFile, "%d ", permutationsList[i][j]);
                fprintf(codeFile, "\n");

                return 0;
            }

            pos += wordLengths[i] + 1;
            waitpid(pid_list[i], NULL, 0);
        }

        fclose(outputFile);
        fclose(codeFile);
    }

    else if(argc == 4)   // argv = [<name>, input, output, codes] ---> decrypt
    {
        FILE* outputFile;
        if((outputFile = fopen(argv[2], "w")) == NULL)
        {
            perror("Can't open output file!\n");
            return errno;
        }

        FILE* codeFile;
        if((codeFile = fopen(argv[3], "r")) == NULL)
        {
            perror("Can't open passwords file!\n");
            return errno;
        }
 
        // read code matrix from codeFile and store it in permutationsList
        for(int i = 0; i < nrWords; i++)
        {
            int x;

            permutationsList[i] = malloc(wordLengths[i] * sizeof(int));

            for(int j = 0; j < wordLengths[i]; j++)
            {
                fscanf(codeFile, "%d", &x);
                permutationsList[i][j] = x;
            }
        }

        for(int i = 0; i < nrWords; i++)
        {
            // fork (nrWords) processes, each decrypting a word;
            pid_list[i] = fork();

            if(pid_list[i] == 0)
            {
                // pointer arithmetics to find corresponding memory address for each word
                child_ptr_list[i] = mappedInputFile + pos;
                
                char* cuvant = malloc(wordLengths[i] + 1);

                strncpy(cuvant, child_ptr_list[i], wordLengths[i]);
                strncpy(cuvant, decryptWord(cuvant, permutationsList[i]), wordLengths[i]);
                cuvant[wordLengths[i]] = '\0';

                fprintf(outputFile, "%s ", cuvant);

                return 0;
            }

            pos += wordLengths[i] + 1;
            waitpid(pid_list[i], NULL, 0);
        }

        fclose(outputFile);
        fclose(codeFile);
    }
    

    // unmap the file from memory and free it;
    munmap(mappedInputFile, sb.st_size);
    close(fd);

    return 0;
}