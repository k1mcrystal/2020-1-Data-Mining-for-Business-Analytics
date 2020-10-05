##################################
### (1) Naive Bayes  #############
##################################

## 1. Import data
rm(list = ls())
df = read.csv("Fundraising_final_exam_sp20.csv")

## 2. Delete unnecessary columns
# don't use Row.ID, TARGET_D
df <- df[, -c(1, 24)]

## 3. Change data type
# have to change all variables to factor

## 3-1. dummy variables: change binary variables to factor
# zip codes, HOMEOWNER, GENDER, TARGET_B
df$zipconvert_1 <- as.factor(df$zipconvert_1)
df$zipconvert_2 <- as.factor(df$zipconvert_2)
df$zipconvert_3 <- as.factor(df$zipconvert_3)
df$zipconvert_4 <- as.factor(df$zipconvert_4)
df$zipconvert_5 <- as.factor(df$zipconvert_5)
df$HOMEOWNER <- as.factor(df$HOMEOWNER)
df$GENDER <- as.factor(df$GENDER)
df$TARGET_B <- as.factor(df$TARGET_B)

## 3-2. multinomial variables: change int variables to factor
# NUMCHLD, INCOME, WEALTH
df$NUMCHLD <- as.factor(df$NUMCHLD)
df$INCOME <- as.factor(df$INCOME)
df$WEALTH <- as.factor(df$WEALTH)

## 3-3. binning: change integer(or numeric) to factor
# use unit size that can separate the data into about 10 groups
# HV : unit size is 1000 (0~1000, 1000~2000, 2000~3000, 3000~4000, 4000~5000, 5000~6000)
print(c(min(df$HV),max(df$HV)))
df$HV <- as.factor(floor(df$HV/1000))
# ICmed : unit size is 100 (0~100, 100~200 ... 1500~1600)
print(c(min(df$ICmed),max(df$ICmed)))
df$ICmed <- as.factor(floor(df$ICmed/100))
# ICavg : unit size is 100 (0~100, 100~200 ... 1300~1400)
print(c(min(df$ICavg),max(df$ICavg)))
df$ICavg <- as.factor(floor(df$ICavg/100))
# IC15 : unit size is 10 (0~10, 10~20 ... 90~100)
print(c(min(df$IC15),max(df$IC15)))
df$IC15 <- as.factor(floor(df$IC15/10))
# NUMPROM : unit size is 10 (10~20, 20~30 ... 150~160)
print(c(min(df$NUMPROM),max(df$NUMPROM)))
df$NUMPROM <- as.factor(floor(df$NUMPROM/10))
# RAMNTALL : unit size is 1000 (0~1000, ... 5000~6000)
print(c(min(df$RAMNTALL),max(df$RAMNTALL)))
df$RAMNTALL <- as.factor(floor(df$RAMNTALL/1000))
# MAXRAMNT : unit size is 100 (0~100, ... 1000~1100)
print(c(min(df$MAXRAMNT),max(df$MAXRAMNT)))
df$MAXRAMNT <- as.factor(floor(df$MAXRAMNT/100))
# LASTGIFT : unit size is 20 (0~20, ... 200~220)
print(c(min(df$LASTGIFT),max(df$LASTGIFT)))
df$LASTGIFT <- as.factor(floor(df$LASTGIFT/20))
# TOTALMONTHS : unit size is 1
print(c(min(df$TOTALMONTHS),max(df$TOTALMONTHS)))
df$TOTALMONTHS <- as.factor(df$TOTALMONTHS)
# TIMELAG : unit size is 10 (0~10, ... 70~80)
print(c(min(df$TIMELAG),max(df$TIMELAG)))
df$TIMELAG <- as.factor(floor(df$TIMELAG/10))
# AVGGIFT : unit size is 10 (0~10, ... 120~130)
print(c(min(df$AVGGIFT),max(df$AVGGIFT)))
df$AVGGIFT <- as.factor(floor(df$AVGGIFT/10))

str(df)

## 4. Split the data into train(60%) and valid(40%)
set.seed(2)
# select index number randomly
train.index <- sample(row.names(df), 0.6*dim(df)[1]) # train data 60%
valid.index <- setdiff(row.names(df), train.index) # valid data 40%
# select rows with index number
train.df <- df[train.index, ]
valid.df <- df[valid.index, ]

## 5. Run Naive Bayes
library(e1071)
nb <- naiveBayes(TARGET_B ~., data = train.df)
# predict probability of train.df
pred.prob.train <- predict(nb, newdata = train.df, type = "raw")
head(pred.prob.train)
# predict class of train.df
pred.class.train <- predict(nb, newdata = train.df)
head(pred.class.train)
# predict probability of valid.df
pred.prob.valid <- predict(nb, newdata = valid.df, type = "raw")
head(pred.prob.valid)
# predict class of valid.df
pred.class.valid <- predict(nb, newdata = valid.df)
head(pred.class.valid)
# create dataframe to show actual class, predicted class, predicted probability
df <- data.frame(actual = valid.df$TARGET_B, predicted = pred.class.valid, pred.prob.valid)
head(df, n = 10)

## 6. ROC & AUC
library(pROC)
# ROC
ROC <- roc(valid.df$TARGET_B, pred.prob.valid[,1])
plot(ROC, col = "blue")
# AUC
AUC <- auc(ROC)
AUC

## 7. Confusion Matrix
library(caret)
# train
confusionMatrix(pred.class.train, train.df$TARGET_B)
# valid
confusionMatrix(pred.class.valid, valid.df$TARGET_B)


##################################
### (2) Classification Tree  #####
##################################

## 1. Import data
rm(list = ls())
df = read.csv("Fundraising_final_exam_sp20.csv")

## 2. Delete unnecessary columns
# don't use Row.ID, TARGET_D
df <- df[, -c(1, 24)]

## 3. Change data type
# integer(or numeric) to factor
# binary : zip codes, HOMEOWNER, GENDER, TARGET_B
df$zipconvert_1 <- as.factor(df$zipconvert_1)
df$zipconvert_2 <- as.factor(df$zipconvert_2)
df$zipconvert_3 <- as.factor(df$zipconvert_3)
df$zipconvert_4 <- as.factor(df$zipconvert_4)
df$zipconvert_5 <- as.factor(df$zipconvert_5)
df$HOMEOWNER <- as.factor(df$HOMEOWNER)
df$GENDER <- as.factor(df$GENDER)
df$TARGET_B <- as.factor(df$TARGET_B)

## 4. Split the data into train(60%) and valid(40%)
set.seed(2)
# select index number randomly
train.index <- sample(row.names(df), 0.6*dim(df)[1]) # train data 60%
valid.index <- setdiff(row.names(df), train.index) # valid data 40%
# select rows with index number
train.df <- df[train.index, ]
valid.df <- df[valid.index, ]

## 5. Create classification tree
library(rpart)
library(rpart.plot)

## 5-1. Default Tree
default.ct <- rpart(TARGET_B~., data = train.df, method = "class")
default.ct
# plot
# prp(default.ct, type = 1, extra = 1, under = TRUE, split.font = 1, varlen = -10,
box.col = ifelse(default.ct$frame$var == "<leaf>", 'gray', 'white'))
# Confusion Matrix
library(caret)
# train accuracy
default.ct.point.pred.train <- predict(default.ct, train.df, type = "class")
confusionMatrix(default.ct.point.pred.train, train.df$TARGET_B)
# valid accuracy
default.ct.point.pred.valid <- predict(default.ct, valid.df, type = "class")
confusionMatrix(default.ct.point.pred.valid, valid.df$TARGET_B)

# 5.2 Parameter tunning
# change max depth
ploan.ct1 <- rpart(TARGET_B~., data = train.df, method = "class", maxdepth = 3)
ploan.ct1.point.pred.train <- predict(ploan.ct1, train.df, type = "class")
confusionMatrix(ploan.ct1.point.pred.train, train.df$TARGET_B)
ploan.ct1.point.pred.valid <- predict(ploan.ct1, valid.df, type = "class")
confusionMatrix(ploan.ct1.point.pred.valid, valid.df$TARGET_B)
# valid accuracy is increased

# change minbucket
ploan.ct2 <- rpart(TARGET_B~., data = train.df, method = "class", minbucket = 15)
ploan.ct2.point.pred.train <- predict(ploan.ct2, train.df, type = "class")
confusionMatrix(ploan.ct2.point.pred.train, train.df$TARGET_B)
ploan.ct2.point.pred.valid <- predict(ploan.ct2, valid.df, type = "class")
confusionMatrix(ploan.ct2.point.pred.valid, valid.df$TARGET_B)
# no difference

# change minsplit
ploan.ct3 <- rpart(TARGET_B~., data = train.df, method = "class", minsplit = 10)
ploan.ct3.point.pred.train <- predict(ploan.ct3, train.df, type = "class")
confusionMatrix(ploan.ct3.point.pred.train, train.df$TARGET_B)
ploan.ct3.point.pred.valid <- predict(ploan.ct3, valid.df, type = "class")
confusionMatrix(ploan.ct3.point.pred.valid, valid.df$TARGET_B)
# no difference

# change cp
ploan.ct4 <- rpart(TARGET_B~., data = train.df, method = "class", cp = 0.005)
ploan.ct4.point.pred.train <- predict(ploan.ct4, train.df, type = "class")
confusionMatrix(ploan.ct4.point.pred.train, train.df$TARGET_B)
ploan.ct4.point.pred.valid <- predict(ploan.ct4, valid.df, type = "class")
confusionMatrix(ploan.ct4.point.pred.valid, valid.df$TARGET_B)
# valid accuracy is decreased

## ploan.ct1 is the best !!
# print rule of ploan.ct1
rpart.rules(ploan.ct1)

## 6. Random Forest
library("randomForest")
rf <- randomForest(TARGET_B ~ ., data = train.df, ntree = 500, importance = TRUE)
# variable importance plot
varImpPlot(rf, type = 1)
# Use HV, ICmed, ICavg, IC15, AVGGIFT, WEALTH, LASTGIFT at NN
## Confusion Matrix
rf.pred.train <- predict(rf, train.df[, 1:21])
confusionMatrix(rf.pred.train, train.df$TARGET_B)
rf.pred.valid <- predict(rf, valid.df)
confusionMatrix(rf.pred.valid, valid.df$TARGET_B)



##################################
### (3) KNN  #####################
##################################

## 1. Import data
rm(list = ls())
df = read.csv("Fundraising_final_exam_sp20.csv")

## 2. delete unnecessary columns
# don't use Row.ID, TARGET_D, zip codes, HOMEOWNER, GENDER
df <- df[, -c(1:7, 10, 24)]

## 3. Change data type
# outcome variable: integer to factor
# do not have to change predictors' data type (it's already int and num)
df$TARGET_B <- as.factor(df$TARGET_B)

## 4. Split the data into train(60%) and valid(40%)
set.seed(2)
# select index number randomly
train.index <- sample(row.names(df), 0.6*dim(df)[1]) # train data 60%
valid.index <- setdiff(row.names(df), train.index) # valid data 40%
# select rows with index number
train.df <- df[train.index, ]
valid.df <- df[valid.index, ]

## 5. Normalize data
library(caret)
# copy data set
train.norm.df <- train.df
valid.norm.df <- valid.df
## normalize by subtracting mean and dividing by standard deviation
norm.values <- preProcess(train.df[, 1:14], method = c("center", "scale"))
train.norm.df[, 1:14] <- predict(norm.values, train.df[, 1:14])
valid.norm.df[, 1:14] <- predict(norm.values, valid.df[, 1:14])

## 6. Implement KNN
library(FNN)
knn_train <- knn(train = train.norm.df[, 1:14], test = train.norm.df[, 1:14], cl = train.norm.df[, 15], k = 10)
knn_test <- knn(train.norm.df[, 1:14], valid.norm.df[, 1:14], train.norm.df[, 15], k = 10)

## 7. Confusion Matrix
confusionMatrix(knn_train, train.norm.df[,15])
confusionMatrix(knn_test, valid.norm.df[,15])


##################################
### (4) Neural Net  ##############
##################################

## 1. Import data
rm(list = ls())
df = read.csv("Fundraising_final_exam_sp20.csv")

## 2. Delete unnecessary columns
# don't use Row.ID, TARGET_D
# Use HV(12), ICmed(13), ICavg(14), IC15(15), AVGGIFT(22), WEALTH(11), LASTGIFT(19) at NN as predictor
df <- df[, c(11, 12:15, 19, 22, 23)]

## 3. Change data type
# predictors : don't have to change (already int and num)
# outcome variable : integer to factor
df$TARGET_B <-  as.factor(df$TARGET_B)

## 4. Split the data into train(60%) and valid(40%)
set.seed(2)
# select index number randomly
train.index <- sample(row.names(df), 0.6*dim(df)[1]) # train data 60%
valid.index <- setdiff(row.names(df), train.index) # valid data 40%
# select rows with index number
train.df <- df[train.index, ]
valid.df <- df[valid.index, ]

## 5. Scale data
## scale (to become between 0~1)
train_max <- apply(train.df[, 1:7], 2, max)
train_min <- apply(train.df[, 1:7], 2, min)
valid_max <- apply(valid.df[, 1:7], 2, max)
valid_min <- apply(valid.df[, 1:7], 2, min)
train.df[, 1:7] <- scale(train.df[, 1:7], center = train_min, scale = train_max - train_min)
valid.df[, 1:7] <- scale(valid.df[, 1:7], center = valid_min, scale = valid_max - valid_min)
str(train.df)

## 6. Fit neural net
# one hidden layer, 5 hidden nodes
# I got a stepmax error, so I added stepmax parameter
library(neuralnet)
nn <- neuralnet(TARGET_B ~ ., data = train.df, linear.output = F, hidden = 5, stepmax = 2e+05)

## 7. Confusion Matrix
# use compute rather than predict for neuralnet()
library(caret)
# train
train.predict <- compute(nn, train.df[, 1:7])
round(test.predict$net.result,digits = 5)
predicted.class = apply(train.predict$net.result, 1, which.max) -1 # 1,2 to 0,1
predicted.class <- as.factor(predicted.class) # numeric to factor
confusionMatrix(predicted.class, train.df$TARGET_B)
# valid
valid.predict <- compute(nn, valid.df[, 1:7])
round(valid.predict$net.result,digits = 5)
predicted.class = apply(valid.predict$net.result, 1, which.max) -1 # 1,2 to 0,1
predicted.class <- as.factor(predicted.class) # numeric to factor
confusionMatrix(predicted.class, valid.df$TARGET_B)

