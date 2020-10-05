rm(list = ls())

bank.df <- read.csv("bank.csv", na.strings = "")
head(bank.df)
str(bank.df)

library(neuralnet)
library(nnet)
library(caret)

## 1. Scale age, balance, campaign, and previous to [0:1]
## Use min() and max() functions
## Report the first 6 records
bank.df$age <- scale(bank.df$age, center = min(bank.df$age), scale = max(bank.df$age) - min(bank.df$age))
bank.df$balance <- scale(bank.df$balance, center = min(bank.df$balance), scale = max(bank.df$balance) - min(bank.df$balance))
bank.df$campaign <- scale(bank.df$campaign, center = min(bank.df$campaign), scale = max(bank.df$campaign) - min(bank.df$campaign))
bank.df$previous <- scale(bank.df$previous, center = min(bank.df$previous), scale = max(bank.df$previous) - min(bank.df$previous))
head(bank.df, n = 6)

## 2. Create dummy variables for education and y
## Make a dataframe named bank.df1
bank.df1 <- cbind(bank.df, class.ind(bank.df$education), class.ind(bank.df$y))
names(bank.df1)[18:23] <- c(paste("edu_", c(1,2,3,9), sep = ""), paste("term_d_", c("yes","no"), sep = ""))
names(bank.df1)

## 3. Select attributes
vars = c("age", "balance", "campaign", "previous", "edu_1", "edu_2", "edu_3", "edu_9", "term_d_yes", "term_d_no")
bank.df2 <- bank.df1[,vars]
names(bank.df2)

## 4. Partition the data(train60% valid40%)
set.seed(2)
train.index = sample(rownames(bank.df2), dim(bank.df2)[1]*0.6)
valid.index = setdiff(row.names(bank.df2), train.index)
train.df = bank.df2[train.index,]
valid.df = bank.df2[valid.index,]
dim(train.df)
dim(valid.df)

## 5. Fit NN and plot
nn <- neuralnet(term_d_yes + term_d_no ~.,data = train.df, hidden = c(3,2))
plot(nn)

## 6. report the output of confusionMatrix
#(a)
training.prediction <- compute(nn, train.df[, -c(9:10)])
head(training.prediction$net.result)
training.class <- apply(training.prediction$net.result, 1, which.max)-1
head(training.class, n = 20)
confusionMatrix(factor(training.class), factor(train.df$term_d_no))

#(b)
validation.prediction <- compute(nn, valid.df[,-c(9:10)])
validation.class <- apply(validation.prediction$net.result, 1, which.max)-1
head(validation.class, n = 20)
confusionMatrix(factor(validation.class), factor(valid.df$term_d_no))

