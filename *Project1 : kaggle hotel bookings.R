rm(list = ls())

hotel.df = read.csv("hotel_bookings.csv",na.strings = "")
str(hotel.df)
summary(hotel.df)
names(hotel.df)

###   STEP1   ### 
#Arrival_date_year, arrival_date_week_number, arrival_date_day_of_month,
#agent, company, adr, required_car_parking_spaces, reservation_status, reservation_status_date 
#not suitable for applying to general hospitality industry

hotel.df = hotel.df[,-c(4,6,7,24,25,28,29,31,32)]
names(hotel.df)



###   STEP2   ###
#Market_segment, distribution_channel 
#didnt have enough information

hotel.df = hotel.df[,-c(12,13)]
names(hotel.df)



###   STEP3   ###
#int -> fac (already have factor information)

hotel.df$hotel = factor(hotel.df$hotel)
hotel.df$is_canceled = factor(hotel.df$is_canceled)
hotel.df$arrival_date_month = factor(hotel.df$arrival_date_month)
hotel.df$meal = factor(hotel.df$meal)
hotel.df$country = factor(hotel.df$country)
hotel.df$is_repeated_guest = factor(hotel.df$is_repeated_guest)
hotel.df$reserved_room_type = factor(hotel.df$reserved_room_type)
hotel.df$assigned_room_type = factor(hotel.df$assigned_room_type)
hotel.df$deposit_type = factor(hotel.df$deposit_type)
hotel.df$customer_type = factor(hotel.df$customer_type)
str(hotel.df)

###   STEP4   ###
#change NA values in children to 0

hotel.df$children[hotel.df$children=="NA"] = 0
hotel.df$children = as.integer(hotel.df$children)
table(hotel.df$children)


###   STEP5   ###
#use only city hotel data

hotel.df = hotel.df[hotel.df$hotel=="City Hotel",]
hotel.df = hotel.df[,-1]



###   STEP6   ###
#make new useful variables

#total stays nights
hotel.df$stays_nights = hotel.df$stays_in_week_nights + hotel.df$stays_in_weekend_nights

#total number of people
hotel.df$people = hotel.df$adults+hotel.df$children+hotel.df$babies

#total number of people not adults
hotel.df$not_adults = hotel.df$children + hotel.df$babies

#dummy variable which shows if the booking includes not_adults
hotel.df$has_child = ifelse(hotel.df$not_adults>0,1,0)

#total number of previous bookings
hotel.df$previous_bookings = hotel.df$previous_bookings_not_canceled + hotel.df$previous_cancellations

#whether the assigned room type is same as reserved
hotel.df$is_r_n_a_same = ifelse(as.character(hotel.df$reserved_room_type) == as.character(hotel.df$assigned_room_type),1,0)

#whether the customer is native
hotel.df$native_or_not = ifelse(hotel.df$country=="PRT",1,0)

#whehter the customer had special request
hotel.df$has_special_request = ifelse(hotel.df$total_of_special_requests>0,1,0)

#change into factor
hotel.df$has_child = factor(hotel.df$has_child)
hotel.df$is_r_n_a_same = factor(hotel.df$is_r_n_a_same)
hotel.df$native_or_not = factor(hotel.df$native_or_not)
hotel.df$has_special_request = factor(hotel.df$has_special_request)


###   STEP7   ###
#int -> fac

#change directly into factor(has less than 7 levels)
hotel.df$babies = factor(hotel.df$babies)
hotel.df$children = factor(hotel.df$children)
hotel.df$adults = factor(hotel.df$adults)
hotel.df$total_of_special_requests = factor(hotel.df$total_of_special_requests)
hotel.df$not_adults = factor(hotel.df$not_adults)

#binning to make them have categories with same frequency
range_name5 = c("very low","low","middle","high","very high")
range_name3 = c("low","middle","high")
range_name2 = c("low","high")
range_name4 = c("very low","low","high","very high")


library(classInt)

classIntervals(hotel.df$lead_time,5,style = "quantile")
classIntervals(hotel.df$stays_in_weekend_nights,2,style = "quantile")
classIntervals(hotel.df$stays_in_week_nights,3,style = "quantile")
classIntervals(hotel.df$stays_nights,4,style = "quantile")

b1 = classIntervals(hotel.df$lead_time,5,style = "quantile")[[2]]
b2 = classIntervals(hotel.df$stays_in_weekend_nights,2,style = "quantile")[[2]]
b3 = classIntervals(hotel.df$stays_in_week_nights,3,style = "quantile")[[2]]
b4 = classIntervals(hotel.df$stays_nights,4,style = "quantile")[[2]]

for (i in 1:5){
  hotel.df$lead_time_b = ifelse( b1[i] <= hotel.df$lead_time, range_name5[i], hotel.df$lead_time_b)
}

for (i in 1:2){
  hotel.df$stays_in_weekend_nights_b = ifelse( b2[i] <= hotel.df$stays_in_weekend_nights, range_name2[i], hotel.df$stays_in_weekend_nights_b)
}

for (i in 1:3){
  hotel.df$stays_in_week_nights_b = ifelse( b3[i] <= hotel.df$stays_in_week_nights, range_name3[i], hotel.df$stays_in_week_nights_b)
}

for (i in 1:4){
  hotel.df$stays_nights_b = ifelse( b4[i] <= hotel.df$stays_nights, range_name4[i], hotel.df$stays_nights_b)
}

hotel.df$lead_time_b = factor(hotel.df$lead_time_b)
hotel.df$stays_in_weekend_nights_b =factor(hotel.df$stays_in_weekend_nights_b)
hotel.df$stays_in_week_nights_b = factor(hotel.df$stays_in_week_nights_b)
hotel.df$stays_nights_b = factor(hotel.df$stays_nights_b)

#previous_cancellations / previous_bookings_not_canceld /booking_changes/previou_bookings/days_in_waiting_list
#have too much 0 values -> change into dummy which shows whether 0 or not

table(hotel.df$previous_bookings_not_canceled,hotel.df$is_repeated_guest)
table(hotel.df$previous_cancellations,hotel.df$is_repeated_guest)

hotel.df$has_previous_cancellation = ifelse(hotel.df$previous_cancellations>0,1,0)
hotel.df$has_previous_bookings_not_canceled = ifelse(hotel.df$previous_bookings_not_canceled>0,1,0)
hotel.df$has_booking_changes = ifelse(hotel.df$booking_changes>0,1,0)
hotel.df$has_previous_bookings = ifelse(hotel.df$previous_bookings>0,1,0)
hotel.df$has_been_in_waiting_list = ifelse(hotel.df$days_in_waiting_list>0,1,0)


hotel.df$has_previous_cancellation = factor(hotel.df$ has_previous_cancellation)                                 
hotel.df$has_previous_bookings_not_canceled = factor(hotel.df$ has_previous_bookings_not_canceled)
hotel.df$has_booking_changes = factor(hotel.df$has_booking_changes)
hotel.df$has_previous_bookings = factor(hotel.df$has_previous_bookings)
hotel.df$has_been_in_waiting_list = factor(hotel.df$has_been_in_waiting_list)


#people: notable decrease in number from 5 -> maky dummy with the standard of 5
table(hotel.df$people)
hotel.df$people_more_than = ifelse(hotel.df$people>4,1,0)
hotel.df$people_more_than = factor(hotel.df$people_more_than)

str(hotel.df)


###   STEP 8   ###
#delete remaining int values

names(hotel.df)
hotel.df = hotel.df[,-c(2,4,5,12,13,16,18,21,22,25)]
str(hotel.df)

###   STEP9   ###
#country has too many levels -> unable to run rf -> delete
hotel.df = hotel.df[,-7]

###   STEP10   ###
#train:valid = 6:4

#rejecting the less important parameters
#rf model used is below the code
names(hotel.df)
hotel.df = hotel.df[,-c(5, 8,9,17,25,13,14,27)]
str(hotel.df)

set.seed(99)
train.index = sample(row.names(hotel.df),dim(hotel.df)[1]*0.6)
valid.index = setdiff(row.names(hotel.df),train.index)
train.df = hotel.df[train.index,]
valid.df = hotel.df[valid.index,]

#write.csv(hotel.df, file = "hotel_preprocessed.csv", row.names = FALSE)
# write.csv(train.df, file = "train.csv", row.names = FALSE)
# write.csv(valid.df, file = "valid.csv", row.names = FALSE)




###########################################
## Naive Bayes ##
###########################################
library(e1071)

## running NaiveBayes
nb_hotel<-naiveBayes(is_canceled~.,data=train.df)
nb_hotel

##ConfusionMatrix
library(caret)
nb.train.pred<-predict(nb_hotel,newdata=train.df)
nb.valid.pred<-predict(nb_hotel,newdata=valid.df)
confusionMatrix(nb.train.pred,train.df$is_canceled)
confusionMatrix(nb.valid.pred,valid.df$is_canceled)

##ROC curve
library(pROC)
pred.prob<-predict(nb_hotel,newdata=valid.df,type="raw")
ROC_hotel<-roc(ifelse(valid.df$is_canceled==1,1,0),pred.prob[,1])
plot(ROC_hotel,col="blue")
AUC_hotel<-auc(ROC_hotel)
AUC_hotel

##Lift Charts
library("gains")
gain<-gains(ifelse(valid.df$is_canceled==1,1,0),pred.prob[,1],groups=200)
plot(c(0,gain$cume.pct.of.total*sum(valid.df$is_canceled==1))~c(0,gain$cume.obs),xlab="#cases",ylab="Cumulative",type="l")
lines(c(0,sum(valid.df$is_canceled==1))~c(0,dim(valid.df)[1]),lty=2)


###########################################
## Decision Tree ##
###########################################

library(rpart)
library(rpart.plot)
library(caret)

## 1. full tree
## to check the maximum of train accuracy and sensitivity
deeper.ct <- rpart(is_canceled~., data = train.df, method = "class", cp = 0, minsplit = 1)
prp(deeper.ct, type = 1, extra = 1, under = TRUE, split.font = 1, varlen = -10,
    box.col = ifelse(deeper.ct$frame$var == "<leaf>", 'gray', 'white'))
# train confusion matrix
deeper.ct.point.pred.train <- predict(deeper.ct, train.df, type = "class")
confusionMatrix(deeper.ct.point.pred.train, train.df$is_canceled)
# valid confusion matrix
deeper.ct.point.pred.valid <- predict(deeper.ct, valid.df, type = "class")
confusionMatrix(deeper.ct.point.pred.valid, valid.df$is_canceled)
# get rules
rpart.rules(deeper.ct)

## 2. default tree
default.ct <- rpart(is_canceled~., data = train.df, method = "class")
default.ct
prp(default.ct, type = 1, extra = 1, under = TRUE, split.font = 1, varlen = -10,
    box.col = ifelse(default.ct$frame$var == "<leaf>", 'gray', 'white'))
# train confusion matrix
default.ct.point.pred.train <- predict(default.ct, train.df, type = "class")
confusionMatrix(default.ct.point.pred.train, train.df$is_canceled)
#  valid confusion matrix
default.ct.point.pred.valid <- predict(default.ct, valid.df, type = "class")
confusionMatrix(default.ct.point.pred.valid, valid.df$is_canceled)
# get rules
rpart.rules(default.ct)

## 3. parameter tunning
## cp = 0.005
ploan.ct1 <- rpart(is_canceled~., data = train.df, method = "class", cp = 0.005)
prp(ploan.ct1, type = 1, extra = 1, under = TRUE, split.font = 1, varlen = -10,
    box.col = ifelse(ploan.ct1$frame$var == "<leaf>", 'gray', 'white'))
# train confusion matrix
ploan.ct1.point.pred.train <- predict(ploan.ct1, train.df, type = "class")
confusionMatrix(ploan.ct1.point.pred.train, train.df$is_canceled)
# valid confusion matrix
ploan.ct1.point.pred.valid <- predict(ploan.ct1, valid.df, type = "class")
confusionMatrix(ploan.ct1.point.pred.valid, valid.df$is_canceled)
# get rules
rpart.rules(ploan.ct1)

## ct = 0.001
ploan.ct2 <- rpart(is_canceled~., data = train.df, method = "class", cp = 0.001)
prp(ploan.ct2, type = 1, extra = 1, under = TRUE, split.font = 1, varlen = -10,
    box.col = ifelse(ploan.ct2$frame$var == "<leaf>", 'gray', 'white'))
# train confusion matrix
ploan.ct2.point.pred.train <- predict(ploan.ct2, train.df, type = "class")
confusionMatrix(ploan.ct2.point.pred.train, train.df$is_canceled)
# valid confusion matrix
ploan.ct2.point.pred.valid <- predict(ploan.ct2, valid.df, type = "class")
confusionMatrix(ploan.ct2.point.pred.valid, valid.df$is_canceled)
# get rules
rpart.rules(ploan.ct2)

## cp = 0.0005
ploan.ct3 <- rpart(is_canceled~., data = train.df, method = "class", cp = 0.0005)
prp(ploan.ct3, type = 1, extra = 1, under = TRUE, split.font = 1, varlen = -10,
    box.col = ifelse(ploan.ct3$frame$var == "<leaf>", 'gray', 'white'))
# train confusion matrix
ploan.ct3.point.pred.train <- predict(ploan.ct3, train.df, type = "class")
confusionMatrix(ploan.ct3.point.pred.train, train.df$is_canceled)
# valid confusion matrix
ploan.ct3.point.pred.valid <- predict(ploan.ct3, valid.df, type = "class")
confusionMatrix(ploan.ct3.point.pred.valid, valid.df$is_canceled)
# get rules
rpart.rules(ploan.ct3)


###########################################
## random forest ##
###########################################

library(randomForest)
rf = randomForest(is_canceled~., data = train.df, ntree = 500, importance = TRUE)
varImpPlot(rf, type = 1)
varImpPlot(rf, type = 2)

rf.pred.train <- predict(rf, train.df)
rf.pred.valid <- predict(rf, valid.df)
confusionMatrix(rf.pred.train, train.df$is_canceled)
confusionMatrix(rf.pred.valid, valid.df$is_canceled)

###########################################
## Boosting model ##
###########################################

## random sampling
set.seed(2)
sample.index = sample(row.names(hotel.df),10000)
hotel.df.sampling = hotel.df[sample.index,]
set.seed(99)
train.index = sample(row.names(hotel.df.sampling),dim(hotel.df.sampling)[1]*0.6)
valid.index = setdiff(row.names(hotel.df.sampling),train.index)
train.df = hotel.df.sampling[train.index,]
valid.df = hotel.df.sampling[valid.index,]

library("adabag")

boost <- boosting(is_canceled ~., data = train.df)
bt.pred.train <- predict(boost, train.df)
confusionMatrix(factor(bt.pred.train$class), train.df$is_canceled)
bt.pred.valid <- predict(boost, valid.df)
confusionMatrix(factor(bt.pred.valid$class), valid.df$is_canceled)


###########################################
## Neural Net ##
###########################################

###writing csv#####
write.csv(hotel.df,file="hotel.csv")
## loading library of NeuralNet
library(nnet)
library(neuralnet)
hotel1<-read.csv("hotel.csv")
hotel1<-hotel1[,c(-1)]
head(hotel1)
str(hotel1)
## preprocessing for NeuralNet: making dummy variables
dummy_df1<-data.frame(cbind(class.ind(hotel1$arrival_date_month),class.ind(hotel1$meal),class.ind(hotel1$deposit_type),class.ind(hotel1$customer_type)))
head(dummy_df1)
dummy_df2<-data.frame(cbind(class.ind(hotel1$lead_time_b),class.ind(hotel1$stays_in_weekend_nights_b),class.ind(hotel1$stays_in_week_nights_b),class.ind(hotel1$stays_nights_b),class.ind(hotel1$is_canceled)))
head(dummy_df2)
names(dummy_df2)=c(paste("lead_time_",c("high","low","middle","veryhigh","verylow"),sep=""),
                   paste("stays_in_weekend_nights_",c("high","low"),sep=""),
                   paste("stays_in_week_nights_",c("high","low","middle"),sep=""),
                   paste("stays_nights_",c("high","low","veryhigh","verylow"),sep=""),paste("canceled_",c("no","yes"),sep=""))
hotel1_1<-cbind(hotel1,dummy_df1,dummy_df2)
str(hotel1_1)
hotel1_1<-hotel1_1[,c(1,3,4,6,9,10,11,16:58)]

## random sampling
sample.index = sample(row.names(hotel1_1),10000)
hotel1_1 = hotel1_1[sample.index,]

## partition 
set.seed(2)
train.index.nn=sample(rownames(hotel1_1),dim(hotel1_1)[1]*0.6)
train.df.nn<-hotel1_1[train.index.nn,]
dim(train.df.nn)
valid.index=setdiff(row.names(hotel1_1),train.index.nn)
valid.df.nn<-hotel1_1[valid.index,]
dim(valid.df.nn)

## hidden layer=1,hidden nodes=2
nn<-neuralnet(canceled_no+canceled_yes~adults+children+is_repeated_guest+total_of_special_requests+is_r_n_a_same+native_or_not+has_previous_cancellation+has_previous_bookings_not_canceled+has_booking_changes+has_been_in_waiting_list+April+August+December+February+January+July+June+March+May+November+October+September+BB+FB+HB+SC+No.Deposit+Non.Refund+Refundable+Contract+Group+Transient+Transient.Party+lead_time_high+lead_time_low+lead_time_middle+lead_time_veryhigh+lead_time_verylow+stays_in_weekend_nights_high+stays_in_weekend_nights_low+stays_in_week_nights_high+stays_in_week_nights_low+stays_nights_veryhigh+stays_nights_verylow,data=train.df.nn,hidden=2,stepmax = 1e6)
plot(nn)

#ConfusionMatrix
training.pred.nn<-compute(nn,train.df.nn[,c(2:48)])
training.class.nn<-apply(training.pred.nn$net.result,1,which.max)-1
confusionMatrix(factor(training.class.nn),factor(train.df.nn$canceled_yes))

validation.pred.nn<-compute(nn,valid.df.nn[,c(2:48)])
validation.class.nn<-apply(validation.pred.nn$net.result,1,which.max)-1
confusionMatrix(factor(validation.class.nn),factor(valid.df.nn$canceled_yes))


