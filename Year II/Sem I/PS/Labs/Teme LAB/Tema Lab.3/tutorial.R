# 0. BASICS


# vector = structura omogena de tipuri de date;

# list = structura neomogena de tipuri de date; campurile pot primi nume si pot fi accesate dupa aceste nume;

# matrix = matrix(data, nrow, ncol, byrow, dimnames);

# data frame = data.frame(coumn names and data as vectors of equal lengths); data frames can be merged together


# mean = media aritmetica a elementelor unui vector

# median = elementul situat in mijlocul vectorului (daca lungimea vectorului e para, se face media aritmetica intre elementele mijlocii)

# mode = elementul cu cele mai multe aparitii in vector





# 1. Syntax


myString <- "myString"


b <- TRUE 
print(class(b))

f <- 23.5
print(class(f))

i <- 2L
print(class(i))

x <- 2+5i
print(class(x))

c <- "abc"
print(class(c))



rm(list = ls())     # removes all local scope data (in loc sa apesi pe buton :D)





# 2. Data Types


# Create a vector.
apple <- c('red','green',"yellow")
print(apple)

# Get the class of the vector.
print(class(apple))



# Create a list.
list1 <- list(c(2,5,3),21.3,sin)
print(list1)



# Create a matrix.
M = matrix( c('a','a','b','c','b','a'), nrow = 2, ncol = 3, byrow = TRUE)
print(M)



# Create a vector.
apple_colors <- c('green','green','yellow','red','red','red','green')

# Create a factor object.
factor_apple <- factor(apple_colors)

# Print the factor.
print(factor_apple)
print(nlevels(factor_apple))



# Create the data frame.
BMI <- data.frame(
    gender = c("Male", "Male","Female"), 
    height = c(152, 171.5, 165), 
    weight = c(81,93, 78),
    Age = c(42,38,26))

print(BMI)





# 3. Operators


v <- c( 2,5.5,6)
t <- c(8, 3, 4)


print(v+t)

print(v-t)

print(v*t)

print(v/t)

print(v%%t)     # %% = division remainder

print(v%/%t)    # %/% = division quotient

print(v^t)



v <- c(2,5.5,6,9)
t <- c(8,2.5,14,9)


print(v>t)

print(v<t)

print(v==t)

print(v!=t)

print(v>=t)

print(v<=t)



# a:b = vector(a..b)
v <- 2:8
print(v) 



# x %in% v = checks if element x is present in vector v
v1 <- 8
v2 <- 12
t <- 1:10
print(v1 %in% t) 
print(v2 %in% t)



# %*% = matrix multiplication
M = matrix( c(2,6,5,1,10,4), nrow = 2,ncol = 3,byrow = TRUE)
t = M %*% t(M)
print(t)





# 4. Functions


# Create a function with arguments.
myFunction <- function(a, b, c)     # write default call as: (a = 0, b = 0, c = 0)
{
    result <- a * b + c
    print(result)
}

# Call the function by position of arguments.
myFunction(5, 3, 11)

# Call the function by names of the arguments.
myFunction(a = 11, b = 5, c = 3)





# 5. Strings


a <- 'Start and end with single quote'
print(a)

b <- "Start and end with double quotes"
print(b)

c <- "single quote ' in between double quotes"
print(c)

d <- 'Double quotes " in between single quote'
print(d)



a <- "Hello"
b <- 'How'
c <- "are you? "

print(paste(a,b,c))     # paste <=> strcat

print(paste(a,b,c, sep = "-"))      # separates strings by sep

print(paste(a,b,c, sep = "", collapse = ""))    # removes whitespaces between strings



result <- nchar("Count the number of characters")       # nchar <=> strlen
print(result)



# Extract characters from 5th to 7th position.
result <- substring("Extract", 5, 7)    #substring <=> substr
print(result)





# 6. Vectors


# Accessing vector elements using position.
t <- c("Sun","Mon","Tue","Wed","Thurs","Fri","Sat")
u <- t[c(2,3,6)]
print(u)

# Accessing vector elements using logical indexing.
v <- t[c(TRUE,FALSE,FALSE,FALSE,FALSE,TRUE,FALSE)]
print(v)

# Accessing vector elements using negative indexing.
x <- t[c(-2,-5)]
print(x)

# Accessing vector elements using 0/1 indexing.
y <- t[c(0,0,0,0,0,0,1)]
print(y)



u <- c(1:10)
v <- c(10:1)

t <- c(u, v)    # vector concatenation
print(t)



v <- c(3,8,4,5,0,11, -9, 304)

# Sort the elements of the vector.
sort.result <- sort(v)
print(sort.result)

# Sort the elements in the reverse order.
revsort.result <- sort(v, decreasing = TRUE)
print(revsort.result)





# 7. Lists


# Create a list containing strings, numbers, vectors and logical values.
list_data <- list("Red", "Green", c(21,32,11), TRUE, 51.23, 119.1)
print(list_data)



# Create a list containing a vector, a matrix and a list.
list_data <- list(c("Jan","Feb","Mar"), matrix(c(3,9,5,1,-2,8), nrow = 2),
                  list("green",12.3))

# Give names to the elements in the list.
names(list_data) <- c("1st Quarter", "A_Matrix", "A Inner list")

# Show the list.
print(list_data)

# Access the first element of the list.
print(list_data[1])

# Access the third element. As it is also a list, all its elements will be printed.
print(list_data[3])

# Access the list element using the name of the element.
print(list_data$A_Matrix)


# Add element at the end of the list.
list_data[4] <- "New element"
print(list_data[4])

# Remove the last element.
list_data[4] <- NULL

# Update the 3rd Element.
list_data[3] <- "updated element"
print(list_data[3])



# Create two lists.
list1 <- list(1,2,3)
list2 <- list("Sun","Mon","Tue")

# Merge the two lists.
merged.list <- c(list1,list2)

# Print the merged list.
print(merged.list)



# Convert the lists to vectors.
v1 <- unlist(list1)
v2 <- unlist(list2)

print(v1)
print(v2)





# 8. Data Frames


# Create the data frame.
emp.data <- data.frame(
    emp_id = c (1:5), 
    emp_name = c("Rick","Dan","Michelle","Ryan","Gary"),
    salary = c(623.3,515.2,611.0,729.0,843.25), 
    
    start_date = as.Date(c("2012-01-01", "2013-09-23", "2014-11-15", "2014-05-11",
                           "2015-03-27")),
    stringsAsFactors = FALSE)

# Print the data frame.			
print(emp.data)

# Extract Specific columns.
result <- data.frame(emp.data$emp_name,emp.data$salary)
print(result)

# Extract first two rows.
result <- emp.data[1:2,]
print(result)

# Extract 3rd and 5th row with 2nd and 4th column.
result <- emp.data[c(3,5),c(2,4)]
print(result)





# 9. MISC FUNCTIONS


v <- c(2,1,2,3,1,2,3,4,1,5,5,3,2,3)

meanv = mean(v)
print(meanv)


medianv = median(v)
print(medianv)


getmode <- function(v)
{
    uniqv <- unique(v)
    uniqv[which.max(tabulate(match(v, uniqv)))]
}

modev = getmode(v)
print(modev)



v1 <- c("a1","b2","c1","d2")
v2 <- c("g1","x2","d2","e2","f1","a1","c2","b2","a2")
x <- match(v1,v2, nomatch = 0)



tabulate(c(3,5,4))

tabulate(c(3,5,4,8),nbins=4)



x <- c(1,5,8,4,6)
which(x == 5)
which.max(x)