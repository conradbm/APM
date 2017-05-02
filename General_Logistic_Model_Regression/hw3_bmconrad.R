# ---------------------------------------------------------------
# Author: Blake Conrad
# Purpose: 
#  ~ HW3: 
#  ~ Register for kaggle titanic competition
#  ~ Download the data
#  ~ Fit a logistic regression model to the data (glm function)
#  ~ Make a submission
#  ~ Screenshot the results, and upload with the code.
# ---------------------------------------------------------------


# ---------------------------------------------------------------
# Import the data
# ---------------------------------------------------------------
setwd("/Users/bmc/Desktop/CSCI-49000/week_2/hw3")
df_train <- read.csv("train.csv", header=TRUE)
df_test <- read.csv("test.csv", header=TRUE)
names(df_train)
names(df_test)
# ---------------------------------------------------------------

# ---------------------------------------------------------------
# Fit logistic regression model to the data and predict
# ---------------------------------------------------------------
model <- glm(Survived ~ Pclass + Sex*Age,
             data=df_train,
             family="binomial")
summary(model)
df_test$Survived <- round(predict(model, 
                            newdata = df_test, 
                            type = "response"))
df_test$Survived <- round(predict(model, df_test, type="response"))
df_test$Survived[is.na(df_test$Survived)] = 0
write.csv(df_test[,c("PassengerId","Survived")], "submission.csv", row.names=F)
# ---------------------------------------------------------------
# Put predictions in submission format (PassengerId, Survived)
# ---------------------------------------------------------------
# ---------------------------------------------------------------

