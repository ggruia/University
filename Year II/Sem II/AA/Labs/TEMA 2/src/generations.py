from re import split
from math import log2
from random import randint, random, shuffle
from bisect import bisect_left
from copy import deepcopy
from individual import Individual


fin = open("input.txt", "r")
fout = open("output.txt", "w")

stages = 0



def parseInput():
    global stages

    dim = int(fin.readline().split(" = ")[1])
    interv = [float(x) for x in split("\[|\]|, | = |\n", fin.readline())[1:] if x]
    coeff = [float(x) for x in split("\[|\]|, | = |\n", fin.readline())[1:] if x]
    prec = int(fin.readline().split(" = ")[1])
    probRec = float(fin.readline().split(" = ")[1])
    probMut = float(fin.readline().split(" = ")[1])
    stages = int(fin.readline().split(" = ")[1])

    init(interv, coeff, prec, probRec, probMut, dim)


def init(interv, coeff, prec, probRec, probMut, dim):
    global individuals

    Individual.interval = interv
    Individual.coefficients = coeff
    Individual.chromosomeLength = round(log2(abs(interv[1] - interv[0]) * (10**prec)))
    Individual.crossoverProbability = probRec
    Individual.mutationProbability = probMut

    individuals = [Individual() for _ in range(dim)]
    


individuals = []
maxFitnessIndividual = None

selectionLikelihood = []
selectionIntervals = []
selectedIndividuals = []

crossoverProbabilities  = []
selectedForCrossover = []
splicedIndividuals = []
crossoverIndividuals = []

mutatedChromosomes = []
mutatedIndividuals = []


# SELECTS "n" traits from the current generation to create the next generation:
#   - best FITNESS individual
#   - another n - 1 individuals at random based on their FITNESS
def select():
    global individuals, maxFitnessIndividual, selectionLikelihood, selectionIntervals, selectedIndividuals

    def binarySearch(list, el):
        return bisect_left(list, el) - 1

    totalFitness = sum([ind.fitness for ind in individuals])
    
    selectionLikelihood = [ind.fitness / totalFitness for ind in individuals]

    threshold = 0
    selectionIntervals = [threshold]
    for i in range(Individual.nrIndividuals):
        threshold += selectionLikelihood[i]
        selectionIntervals.append(threshold)
    selectionIntervals[Individual.nrIndividuals] = round(threshold)


    maxFitnessIndividual = max(individuals)
    selectedIndividuals = [maxFitnessIndividual]
    for _ in range(Individual.nrIndividuals - 1):
        index = binarySearch(selectionIntervals, random())
        selectedIndividuals.append(deepcopy(individuals[index]))


def crossover():
    global selectedIndividuals, selectedForCrossover, crossoverProbabilities, splicedIndividuals, crossoverIndividuals
    crossoverIndividuals = deepcopy(selectedIndividuals)
    crossoverIndividuals[0] = maxFitnessIndividual

    def splice(a, b, indexA, indexB):
        chA = a.chromosome
        chB = b.chromosome
        i = randint(1, Individual.chromosomeLength - 2)

        newChA = chA[:i] + chB[i:]
        newChB = chB[:i] + chA[i:]

        splicedIndividuals.append(((indexA, chA, newChA), (indexB, chB, newChB),  i))

        a.changeChromosome(newChA)
        b.changeChromosome(newChB)
    
    for i, ind in enumerate(crossoverIndividuals):
        p = random()
        if p <= Individual.crossoverProbability:
            if ind is not maxFitnessIndividual:
                selectedForCrossover.append((i, ind))
        crossoverProbabilities.append((deepcopy(ind), p))
    
    if len(selectedForCrossover) % 2:
        selectedForCrossover.pop()
    shuffle(selectedForCrossover)

    for i in range(0, len(selectedForCrossover), 2):
        splice(selectedForCrossover[i][1], selectedForCrossover[i + 1][1], selectedForCrossover[i][0], selectedForCrossover[i + 1][0])


def mutate():
    global crossoverIndividuals, mutatedChromosomes, mutatedIndividuals, maxFitnessIndividual
    mutatedIndividuals = deepcopy(crossoverIndividuals)
    mutatedIndividuals[0] = maxFitnessIndividual
    
    for j, ind in enumerate(mutatedIndividuals):
        ch = list(ind.chromosome)

        for i in range(Individual.chromosomeLength):
            p = random()
            if p <= Individual.mutationProbability and ind is not maxFitnessIndividual:
                ch[i] = '1' if ch[i] == '0' else '0'
                mutatedChromosomes.append((j, i))

        ch = "".join(ch)
        if ind.chromosome != ch:
            ind.changeChromosome(ch)





def showInputData():
    fout.write("INPUT DATA:\n")
    fout.write("-----------\n")

    fout.write(f"Dimensiune populatie: {Individual.nrIndividuals}\n")
    fout.write(f"Domeniu definitie functie: {Individual.interval}\n")
    coeff = Individual.coefficients
    eq = ""
    for i, c in enumerate(coeff[:-2]):
        eq += f"{c}x^{len(coeff) - i - 1} + "
    eq += f"{coeff[-2]}x + "
    eq += f"{coeff[-1]}"
    fout.write(f"Lege functie: f(x) = {eq}\n")
    fout.write(f"Probabilitate RECOMBINARE: {round(Individual.crossoverProbability * 100, 3)}%\n")
    fout.write(f"Probabilitate MUTATIE: {round(Individual.mutationProbability * 100, 3)}%\n")
    fout.write(f"Numar etape: {stages}\n\n\n")


def showInitialState():
    fout.write("INITIAL POPULATION:\n")
    fout.write("-------------------\n")

    for i, ind in enumerate(individuals):
        fout.write(f"{i+1}. {ind}\n")
    fout.write("\n\n")


def showSelectionProcess():
    fout.write("SELECTION PROCESS:\n")
    fout.write("------------------\n")

    fout.write("PROBABILITIES:\n")
    for i, pr in enumerate(selectionLikelihood):
        fout.write(f"{i+1}. {round(pr * 100, 2)}%\n")

    fout.write("\nINTERVALS:\n")
    for i in range(Individual.nrIndividuals):
        fout.write(f"{i+1}. {list(zip(selectionIntervals[:Individual.nrIndividuals], selectionIntervals[1:]))[i]}\n")

    fout.write("\nSELECTED:\n")
    fout.write(f"{1}. {selectedIndividuals[0]}   < FITTEST\n")
    for i, ind in enumerate(selectedIndividuals[1:]):
        fout.write(f"{i+2}. {ind}   < Ch.{individuals.index(ind) + 1}\n")
    fout.write("\n\n")


def showCrossoverProcess():
    fout.write("CROSSOVER PROCESS:\n")
    fout.write("------------------\n")

    fout.write("PROBABILITIES:\n")
    for i, prob in enumerate(crossoverProbabilities):
        if prob[1] <= Individual.crossoverProbability:
            fout.write(f"{i+1}. Chromosome {prob[0].chromosome}: p = {round(prob[1] * 100, 3)}%   < {round(Individual.crossoverProbability * 100, 3)}%\n")
        else:
            fout.write(f"{i+1}. Chromosome {prob[0].chromosome}: p = {round(prob[1] * 100, 3)}%\n")

    fout.write("\nSPLICING:\n")
    for i, spl in enumerate(splicedIndividuals):
        fout.write(f"{i+1}) Splicing chr. {spl[0][0] + 1}: {spl[0][1]} with chr. {spl[1][0] + 1}: {spl[1][1]} on bp. {spl[2]}:\n")
        fout.write(f"Resulting in {spl[0][2]} and {spl[1][2]}\n")

    fout.write("\nCROSSOVER:\n")
    for i, ind in enumerate(crossoverIndividuals):
        fout.write(f"{i+1}. {ind}\n")
    fout.write("\n\n")


def showMutationProcess():
    fout.write("MUTATION PROCESS:\n")
    fout.write("------------------\n")

    fout.write("MUTATIONS:\n")
    for chrom in mutatedChromosomes:
        fout.write(f"Mutated ch. {chrom[0] + 1} at pos. {chrom[1] + 1};\n")

    fout.write("\nMUTATED:\n")
    for i, ind in enumerate(mutatedIndividuals):
        fout.write(f"{i+1}. {ind}\n")
    fout.write("\n\n")


def simulateGenerations():
    global individuals, maxFitnessIndividual, \
        selectionLikelihood, selectionIntervals, selectedIndividuals, \
            crossoverProbabilities, selectedForCrossover, splicedIndividuals, crossoverIndividuals, \
                mutatedChromosomes, mutatedIndividuals

    fout.write("--------------------------------------------\n")
    fout.write(f"Max FITNESS Individual for FIRST Generation: {maxFitnessIndividual}\n")
    fout.write("--------------------------------------------\n")
    fout.write("\n\n")
    

    fout.write("SIMULATE GENERATIONS:\n")
    fout.write("---------------------\n")
    for _ in range(1, stages):
        individuals = deepcopy(mutatedIndividuals)
        maxFitnessIndividual = None

        selectionLikelihood = []
        selectionIntervals = []
        selectedIndividuals = []

        crossoverProbabilities  = []
        selectedForCrossover = []
        splicedIndividuals = []
        crossoverIndividuals = []

        mutatedChromosomes = []
        mutatedIndividuals = []

        select()
        crossover()
        mutate()

        fout.write(f"Max FITNESS: {maxFitnessIndividual}\n")



# Practic, ALGORITMUL gaseste valoarea x din R, pentru care f(x) e maxim.

parseInput()
showInputData()
showInitialState()

select()
showSelectionProcess()

crossover()
showCrossoverProcess()

mutate()
showMutationProcess()

simulateGenerations()

fin.close()
fout.close()