# -----------
# Lecture 3 R notes
# - This lecture may contain:
#   ~ HW3 Support
#   ~ Competition 1 Support
# -----------

setwd("/Users/bmc/Desktop/CSCI-49000/week_2/hw3")
df_test <- read.csv("test.csv",header=TRUE)
df_train <- read.csv("train.csv", header=TRUE)
head(df_test)
head(df_train)
names(df_test)
names(df_train)

"
Low p-value's for 'Sex' for example, tells us that there is a statistically 
significant link between Sex and Survival

Coefficients:
             Estimate Std. Error z value Pr(>|z|)    
(Intercept)  5.056006   0.502128  10.069  < 2e-16 ***
Pclass      -1.288545   0.139259  -9.253  < 2e-16 ***
Sexmale     -2.522131   0.207283 -12.168  < 2e-16 ***
Age         -0.036929   0.007628  -4.841 1.29e-06 ***

Sexmale     -2.522131   0.207283 -12.168  < 2e-16 ***
"

model <- glm(Survived ~ Pclass + Sex*Age,
             data=df_train,
             family="binomial")
summary(model)

df_train$pred <- predict(model, df_train, type="response")
hist(df_train$pred)

#install.packages("pROC")
library(pROC)
area_under_the_curve <- auc(df_train$Survived, df_train$pred)
area_under_the_curve
df_test$Survived <- round(predict(model, df_test, type="response"))
df_test$Survived[is.na(df_test$Survived)] = 0
write.csv(df_test[,c("PassengerId","Survived")], "submission.csv", row.names=F)

"
Splitting the training data into two separate pieces, then building the model on half, and validating the model on the other half is called: Cross Validation
"

# lect3
dec_tree=tree(Survived ~ Age + Pclass + Sex, data=df_train)
summary(dec_tree)
plot(dec_tree); text(dec_tree)
d1<-df_train[1:500,]
d2<-df_train[501:891,]
dec_tree=tree(Survived ~ Age + Pclass + Sex, data=d1)
pred<-predict(dec_tree,d2)
# % of pairs of people you correctly scored in terms of how you sorted the data
auc(d2$Survived,pred) 

library(randomForest)
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
 