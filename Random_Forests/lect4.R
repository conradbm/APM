# -----------------
# Lecture 4 Notes
# -----------------

#logistic regression
#random forest

install.packages("rpart")
install.packages("party")
library(tree)
library(randomForest)
library(caret)

#1-10,000 trees should be built, more never hurts you accuracy only performance.

# the main draw back to random forests, is that it is hard to quantitaviely explain what a random forest is doing because of all the decision trees
df_train$Survived <- as.factor(df_train$Survived)
df_train$Survived[is.na(df_train$Survived)] = 0
df_train$Age[is.na(df_train$Age)] = 0
df_train$Pclass[is.na(df_train$Pclass)] = 0

df_test$Survived <- as.factor(df_test$Survived)
df_test$Survived[is.na(df_test$Survived)] = 0
df_test$Age[is.na(df_test$Age)] = 0
df_test$Pclass[is.na(df_test$Pclass)] = 0

rf_model <- randomForest(Survived~Age+Pclass+Sex,data=df_train,ntree=1000)
importance(rf_model) # the higher the MeanDecreaseGini the better
pred<- predict(rf_model,df_test)
auc(d2$Survived, pred[,1], type="prob")
pred[1]