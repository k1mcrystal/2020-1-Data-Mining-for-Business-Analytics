rm(list = ls())

# 1. Read file and report dimension

titanic.df <- read.csv("titanic_hw.csv", na.strings = "")
dim(titanic.df)

# 2. Create bins for Age and report the data type of AgeG

titanic.df$AgeG <- floor(titanic.df$Age/10)
class(titanic.df$AgeG)
titanic.df$AgeG <- factor(titanic.df$AgeG)  # integer to factor

# 3. Convert data types of variables to factors(if necessary)
## Report the data type of Pclass, Sex, Survived

titanic.df$Pclass <- factor(titanic.df$Pclass)  # integer to factor
titanic.df$Survived <- factor(titanic.df$Survived)  # integer to factor

class(titanic.df$Pclass)
class(titanic.df$Sex)
class(titanic.df$Survived)

# 4. Partition the data(training 70%, validation 30%)
## Use set.seed(2)
### Report dimension
set.seed(2)

head(titanic.df)
selected.var <- c(3,5,13,2)  # Selected column: Pclass, Sex, AgeG, Survived 

train.index <- sample(c(1:dim(titanic.df)[1]), dim(titanic.df)[1]*0.7)  # train/valid split
train.df <- titanic.df[train.index, selected.var]
valid.df <- titanic.df[-train.index, selected.var]

dim(train.df)  # report dimension
dim(valid.df)

# 5. Run Naive Bayes and report predicted probabilities, predicted class
library(e1071)
titanic.nb <- naiveBayes(Survived ~., data = train.df)
titanic.nb

pred.prob <- predict(titanic.nb, newdata = valid.df, type = "raw")
head(pred.prob, n=10)

pred.class <- predict(titanic.nb, newdata = valid.df)
head(pred.class, n=10)

# 6. Report actual class, predicted class, and predicted probabilities of the following record in the valid data 
## Sex = "female", Pclass = "3" and AgeG = "3" 
df <- data.frame(actual = valid.df$Survived, predicted = pred.class, pred.prob)
head(df, n = 10)
df[valid.df$Sex == "female" & valid.df$Pclass == "3" & valid.df$AgeG == "3", ]

# 7. Predict Survived with new data

new.record1.df <- data.frame(Sex = 'female', Pclass = '2', AgeG = '30')
new.record1.df
new.record2.df <- data.frame(Sex = 'female', Pclass = '3', AgeG = '40')
new.record2.df
new.record3.df <- data.frame(Sex = 'male', Pclass = '2', AgeG = '40')
new.record3.df

pred.class.new.record1 <- predict(titanic.nb, newdata = new.record1.df)
pred.class.new.record1
pred.class.new.record2 <- predict(titanic.nb, newdata = new.record2.df)
pred.class.new.record2
pred.class.new.record3 <- predict(titanic.nb, newdata = new.record3.df)
pred.class.new.record3

# 8. Plot ROC curve and report AUC
library(pROC)

ROC_titanic <- roc((ifelse(valid.df$Survived == "1", 1, 0)), pred.prob[,1])
plot(ROC_titanic, col = "blue")

AUC_titanic <- auc(ROC_titanic)
AUC_titanic

# 9. Plot a lift chart
library(gains)

gain <- gains((ifelse(valid.df$Survived == "1", 1, 0)), pred.prob[,1], groups = 10)
gain

plot(c(0, gain$cume.pct.of.total*sum(valid.df$Survived == "1"))~c(0,gain$cume.obs), xlab = '# cases', ylab = "Cumulative", main = "", type = "l")
lines(c(0,sum(valid.df$Survived == "1"))~c(0, dim(valid.df)[1]),lty = 1)

# 10. Report a confusion matrix for each of the train and valid data
library(caret)

pred.class <- predict(titanic.nb, newdata = train.df)
confusionMatrix(pred.class, train.df$Survived)

pred.class <- predict(titanic.nb, newdata = valid.df)
confusionMatrix(pred.class, valid.df$Survived)
