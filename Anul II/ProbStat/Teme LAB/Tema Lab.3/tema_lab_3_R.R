#TEMA LABORATOR 3 - R:


#
# PROBLEMA 8
#
fourWeeks = matrix(c(106, 123, 123, 111, 125, 113, 130, 
                     113, 114, 100, 120, 130, 118, 114, 
                     127, 112, 121, 114, 120, 119, 127, 
                     114, 108, 127, 131, 157, 102, 133), 4, 7, byrow = TRUE)

colnames(fourWeeks) = c("L", "Ma", "Mi", "J", "V", "S", "D")
rownames(fourWeeks) = c("S1", "S2", "S3", "S4")
names(colnames(fourWeeks)) = c("Luni", "Marti", "Miercuri", "Joi", "Vineri", "Sambata", "Duminica")


sumDays = colSums(fourWeeks)

maxDay = max(sumDays)
indMaxDay = which(sumDays == maxDay)
dMax = names(indMaxDay)
minDay = min(sumDays)
indMinDay = which(sumDays == minDay)
dMin = names(indMinDay)

values = which(fourWeeks > 120, arr.ind = TRUE, useNames = TRUE)

selection120 = data.frame(Week = rownames(fourWeeks)[values[, 1]],
                          Day = colnames(fourWeeks)[values[, 2]])
selection120 = selection120[order(selection120[, 1], selection120[, 2]), ]

print(fourWeeks)

print(values)

cat("Cel mai mult s-a vorbit in zilele de", names(which(colnames(fourWeeks) == dMax)), "\n")
cat("Cel mai putin s-a vorbit in zilele de", names(which(colnames(fourWeeks) == dMin)), "\n")
cat("Zilele in care s-a vorbit > 120 min sunt: ")
print(selection120)


#
# PROBLEMA 9
#
# a
transmissionA = (mtcars[which(mtcars$am == 0), ])[, 6]
transmissionM = (mtcars[which(mtcars$am == 1), ])[, 6]

meanTransmissionA = mean(transmissionA)
meanTransmissionM = mean(transmissionM)

cat("Greutatea medie a masinilor cu Transmisie Automata:", meanTransmissionA, "\n")
cat("Greutatea medie a masinilor cu Transmisie Manuala:", meanTransmissionM, "\n")

# b
cylinders4 = (mtcars[which(mtcars$cyl == 4), ])[, 6]
cylinders6 = (mtcars[which(mtcars$cyl == 6), ])[, 6]
cylinders8 = (mtcars[which(mtcars$cyl == 8), ])[, 6]

meanCylinders4 = mean(cylinders4)
meanCylinders6 = mean(cylinders6)
meanCylinders8 = mean(cylinders8)

cat("Greutatea medie a masinilor cu 4 Cilindrii:", meanCylinders4, "\n")
cat("Greutatea medie a masinilor cu 6 Cilindrii:", meanCylinders6, "\n")
cat("Greutatea medie a masinilor cu 8 Cilindrii:", meanCylinders8, "\n")

# c
sel = mtcars[, c(9, 2, 1)]

transmissionTypes = unique(sel[, 1])
cylinderTypes = unique(sel[, 2])
cylNames = c("4 cyl", "6 cyl", "8 cyl")
trNames = c("automat", "manual")

fr = data.frame(matrix(nrow = length(transmissionTypes), ncol = length(cylinderTypes)))
rownames(fr) = trNames
colnames(fr) = cylNames

for(i in 1:length(transmissionTypes))
  for(j in 1:length(cylinderTypes))
    fr[i, j] = mean((sel[which(sel$am == transmissionTypes[i] & sel$cyl == cylinderTypes[j]), ])[, 3])

cat("Media consumului masinilor, in functie de tipul transmisiei si al nr. cilindrilor:")
print(fr)


#
# PROBLEMA 10
#
funM = function(i, j)
{
  res = 1/ (sqrt(abs(i - j) + 1))
}

funN = function(i, j)
{
  res = i/ (j ^ 2)
}


i = 1:10
j = 1:10


matM = outer(i, j, funM)
matN = outer(i, j, funN)

colnames(matM) = i
rownames(matM) = j
colnames(matN) = i
rownames(matN) = j