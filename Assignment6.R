rm(list = ls())

## 1. Import data and report dimension, summary
count.course.df <- read.csv("Coursetopics_hw.csv", na.strings = "")
dim(count.course.df)
summary(count.course.df)

## 2. If values are greater than 1, convert them to 1
incid.course.df <- ifelse(count.course.df>0, 1, 0)
summary(incid.course.df)

## 3. Create a binary incidence matrix
incid.course.mat <- as.matrix(incid.course.df)
head(incid.course.mat, 10)

## 4. Generate frequent itemsets with a support value of at least 0.03
library("arules")
course.trans <- as(incid.course.mat, "transactions")
freq1 <- apriori(course.trans, parameter = list(supp = 0.03, target = "frequent itemsets"))
inspect(freq1)

## 5. Generate frequent itemsets with a support value of at least 0.02 and a minimum length of 2
freq2 <- apriori(course.trans, parameter = list(supp = 0.02, minlen = 2, target = "frequent itemsets"))
inspect(freq2)

## 6. Generate association rules
# supp = 0.02, conf = 0.5, minlen = 2
# descending order by lift
rules <- apriori(course.trans, parameter = list(supp = 0.02, conf = 0.5, minlen = 2, target = "rules"))
inspect(sort(rules, by = "lift"))

## 7. Interpret the first rule using confidence and lift