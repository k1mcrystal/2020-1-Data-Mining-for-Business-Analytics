rm(list = ls())

# 1. Import data
ebay.df <- read.csv("eBayAuctions.csv", na.strings = "")
dim(ebay.df)

# 2. Convert data type
ebay.df$Duration <- factor(ebay.df$Duration)
ebay.df$Competitive <- factor(ebay.df$Competitive)
class(ebay.df$Duration)
class(ebay.df$Competitive)

# 3. Partition(train60% valid40%)
set.seed(1)
train.index <- sample(c(1:dim(ebay.df)[1]), dim(ebay.df)[1]*0.6)
train.df <- ebay.df[train.index,]
dim(train.df)
valid.df <- ebay.df[-train.index,]
dim(valid.df)

# 4. Fit a classification tree using all predictors & Plot the tree
library(rpart)
library(rpart.plot)

default.ct <- rpart(Competitive~., data = train.df, method = "class")
default.ct
prp(default.ct, type = 1, extra = 1, under = TRUE, split.font = 1, varlen = -10,
    box.col = ifelse(default.ct$frame$var == "<leaf>", 'gray', 'white'))

# 5. Confusion Matrix
library(caret)

default.ct.point.pred.train <- predict(default.ct, train.df, type = "class")
confusionMatrix(default.ct.point.pred.train, train.df$Competitive)
default.ct.point.pred.valid <- predict(default.ct, valid.df, type = "class")
confusionMatrix(default.ct.point.pred.valid, valid.df$Competitive)

# 6. minbucket = 80, maxdepth = 5
ploan.ct <- rpart(Competitive~., data = train.df, method = "class", minbucket = 80, maxdepth = 5)
prp(ploan.ct, type = 1, extra = 1, under = TRUE, split.font = 1, varlen = -10,
    box.col = ifelse(ploan.ct$frame$var == "<leaf>", 'gray', 'white'))

# 7. Confusion Matrix
ploan.ct.point.pred.train <- predict(ploan.ct, train.df, type = "class")
confusionMatrix(ploan.ct.point.pred.train, train.df$Competitive)
ploan.ct.point.pred.valid <- predict(ploan.ct, valid.df, type = "class")
confusionMatrix(ploan.ct.point.pred.valid, valid.df$Competitive)

# 8. Get the rules
rpart.rules(ploan.ct)
