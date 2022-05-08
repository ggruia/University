from pickle import NONE
from random import randint


class Individual:
    nrIndividuals = 0
    interval = None
    coefficients = None
    chromosomeLength = None
    crossoverProbability = None
    mutationProbability = None


    def __init__(self, chromosome=None, position=None, fitness=None):
        self.chromosome = chromosome if chromosome else self.setChromosome()
        self.position = position if position else self.setPosition()
        self.fitness = fitness if fitness else self.setFitness()
        __class__.nrIndividuals += 1
    
    def __repr__(self):
        rep = "Individual (chromosome: {}, pos: {}, fitness: {})".format(self.chromosome, self.position, self.fitness)
        return rep

    def __gt__(self, other):
        return self.fitness > other.fitness
    
    def __eq__(self, other):
        return self.chromosome == other.chromosome


    def setChromosome(self):
        return "".join([str(randint(0, 1)) for _ in range(__class__.chromosomeLength)])
    
    def setPosition(self):
        return abs(__class__.interval[1] - __class__.interval[0]) / (2 ** __class__.chromosomeLength - 1) * int("0b" + self.chromosome, base=2) + min(__class__.interval)

    def setFitness(self):
        fit = 0
        for i, c in enumerate(__class__.coefficients):
            fit += c * self.position ** (len(__class__.coefficients) - i - 1)
        return fit
    
    def changeChromosome(self, newChromosome):
        self.chromosome = newChromosome
        self.position = self.setPosition()
        self.fitness = self.setFitness()