rm(list = ls())

# QUESTION 1: Assign the data to a vector named x1
x1 <- c(-2.21, -5.8, 12.3, 3, 8.35, 3.4, 0.74)

# QUESTION 2: Find the maximum and minimum of x1
max(x1)
min(x1)

# QUESTION 3: Which element is the minimum?
which.min(x1)

# QUESTION 4: Sort x1 in increasing order
sort(x1)

# QUESTION 5: Sort x1 in decreasing order
sort(x1, decreasing = TRUE)

# QUESTION 6: Produce vectors(a,b,c)
a <- rep(c(2,1,5), 4)
b <- seq(2,30,by = 4)
c <- rep(c(9,3,5), c(4,2,4))

# QUESTION 7: Compute the number of days from today to Jan 1
myd <- as.Date(c("2020-04-12", "2020-01-01"))
days <- myd[1] - myd[2]
print(days)

# QUESTION 8: Generate 30 uniform random numbers lie in the interval [0.100]
scores <- runif(30, min = 0, max = 100)
print(scores)

# QUESTION 9: Round off the data in the vector to nearest integer
scores_r <- round(scores)

# QUESTION 10: Create a matrix with 5 columns based on scores_r
scores_m <- matrix(scores_r, ncol = 5)

# QUESTION 11: Report a mean for each of the columns in the matrix
apply(scores_m, 2, mean)

# QUESTION 12: Report a mean for each of the rows in the matrix
apply(scores_m, 1, mean)

# QUESTION 13: Read titanic file
titanic <- read.csv("titanic_hw.csv", na.strings = "")

# QUESTION 14: Report how many rows and columns
dim(titanic)

# QUESTION 15: Report column names
colnames(titanic)

# QUESTION 16: Report columns with brief summary
str(titanic)

# QUESTION 17: Display the first three rows
head(titanic, n=3)

# QUESTION 18: Report the number of missing values for each of the columns
colSums(is.na(titanic))

# QUESTION 19: Report how many rows and columns exist in mtcars
data(mtcars)
dim(mtcars)

# QUESTION 20: Convert the data type of a column
mtcars$cyl <- as.factor(mtcars$cyl)
str(mtcars)
