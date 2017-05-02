# ------------------------------------------ #
# Author: Blake Conrad                       #
# HW4 - Random Forest to Classify Survival   #
# ------------------------------------------ #

#install.packages("tree")
library(tree)
library(randomForest)
library(doSNOW)

setwd("/Users/bmc/Desktop/CSCI-49000/week_2/hw4")
df_test <- read.csv("test.csv",header=TRUE)
df_train <- read.csv("train.csv",header=TRUE)

#Use the tree package & plot
df_train$Survived <- as.factor(df_train$Survived)
dec_tree <- tree(Survived ~ Age + Pclass + Sex, data=df_train)
summary(dec_tree)
plot(dec_tree); text(dec_tree)

# Because I have 6 cores, parallelize
cl <- makeCluster(6, type = "SOCK")
registerDoSNOW(cl)

# Stupid things that need to be adjusted to the rf will work
df_train$Survived <- as.factor(df_train$Survived)
df_train$Survived[is.na(df_train$Survived)] = 0
df_train$Age[is.na(df_train$Age)] = 0
df_train$Pclass[is.na(df_train$Pclass)] = 0
df_test$Age[is.na(df_test$Age)] = 0
df_test$Pclass[is.na(df_test$Pclass)] = 0

# train the model
rf.train.1 <- randomForest(x=df_train[,c("Pclass","Age","Sex")],
                           y=df_train[,"Survived"],
                           data=df_train,
                           ntree=1000)
# view results
stopCluster(cl)
summary(rf.train.1)
plot(rf.train.1)

# Submit the results in correct format
df_test$Survived <- round(predict(rf.train.1,
                                  newdata=df_test[,c("Pclass","Age","Sex")],
                                  type="prob")[,2])
df_test$Survived[is.na(df_test$Survived)] = 0
write.csv(df_test[,c("PassengerId","Survived")], "submission_2_rf_01192017.csv", row.names=F)

