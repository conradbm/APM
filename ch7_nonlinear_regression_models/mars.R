
# Libraries
library(caret)
library(ggplot2)
library(AppliedPredictiveModeling)
install.packages('earth')
#Warning message:
#package ‘earth’ is not available (for R version 3.2.4) 

library(earth)
# Import Data
data(solubility)
ls(pattern="solT")
sample(names(solTrainX), 8)
ls(pattern="solT")

# MARS

marsFit <- earth(solTrainXtrans, solTrainY)
marsFit
summary(marsFit)

# Define the candidate models to test
marsGrid <- expand.grid(.degree = 1:2, .nprune = 2:38)

# Fix the seed so that the results can be reproduced
set.seed(100)
marsTuned <- train(solTrainXtrans, 
					solTrainY, 
					method = "earth", 
					tuneGrid = marsGrid,
					trControl = trainControl(method="cv"))
marsTuned
head(predict(marsTuned, solTestXtrans))