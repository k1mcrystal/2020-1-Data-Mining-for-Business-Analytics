rm(list = ls())

data(iris)
iris.df <- iris

# 1. Partition the data into train, valid, test and report the dimension

set.seed(111)
spl <- sample(c(1:3), size = nrow(iris.df), replace = TRUE, prob = c(0.6, 0.2, 0.2))

train.df <- iris.df[spl == 1, ]
dim(train.df)
valid.df <- iris.df[spl == 2, ]
dim(valid.df)
test.df <- iris.df[spl == 3, ]
dim(test.df)


# 2. Normalize values in the train, valid, and test data, based on the values in the train data
# Report the first three records of each

train.norm.df <- train.df
valid.norm.df <- valid.df
test.norm.df <- test.df

library(caret)
norm.values <- preProcess(train.df[, 1:4], method = c("center", "scale"))

train.norm.df[, 1:4] <- predict(norm.values, train.df[, 1:4])
head(train.norm.df, n = 3)

valid.norm.df[, 1:4] <- predict(norm.values, valid.df[, 1:4])
head(valid.norm.df, n = 3)

test.norm.df[, 1:4] <- predict(norm.values, test.df[, 1:4])
head(test.norm.df, n = 3)


# 3. Use the valid data to find the best k value
# Display "accuracy.df" (from k = 1 to 10)

library(FNN)

accuracy.df <- data.frame(k = seq(1,10,1), accuracy = rep(0,10)) 

for(i in 1:10){
  knn.pred <- knn(train = train.norm.df[, 1:4], test = valid.norm.df[, 1:4], cl = train.norm.df[, 5], k = i)
  accuracy.df[i,2] <- confusionMatrix(knn.pred, valid.norm.df[, 5])$overall[1]
}
options(digits = 2)
accuracy.df


# 4. Show the output of knn() to report the classification for the records in the test data(k = 5)
nn_test <- class::knn(train.norm.df[, 1:4], test.norm.df[, 1:4], cl = train.norm.df[, 5], k = 5)
nn_test


# 5. Show the output of confusionMatrix()
nn_test <- knn(train.norm.df[, 1:4], test.norm.df[, 1:4], cl = train.norm.df[, 5], k = 5)
confusionMatrix(nn_test, test.norm.df[, 5])


# 6. Classify new data with the following characteristics using a k-NN model (k = 5)
# Show the output of knn() to report the result of the classification
new.df <- data.frame(Sepal.Length = c(8.0, 6.3, 4.2), Sepal.Width = c(2.7, 3.0, 3.3), Petal.Length = c(5.2, 4.5, 4.0), Petal.Width = c(2.0, 1.6, 1.2))
new.df

new.norm.df <- predict(norm.values, new.df)
new.norm.df

nn_new <- class::knn(train = train.norm.df[, 1:4], test = new.norm.df, cl = train.norm.df[,5], k = 5)
nn_new


# 7. Report a matrix with the row names of the five nearest neighbors for each of the new records in Q6
nn_new <- knn(train = train.norm.df[, 1:4], test = new.norm.df, cl = train.norm.df[,5], k = 5)
nn_new

row.names <- rbind(row.names(train.df)[attr(nn_new,"nn.index")[1, 1:5]], row.names(train.df)[attr(nn_new,"nn.index")[2, 1:5]], row.names(train.df)[attr(nn_new,"nn.index")[3, 1:5]])
row.names
