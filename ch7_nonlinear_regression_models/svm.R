
# Libraries
library(caret)
library(ggplot2)
library(AppliedPredictiveModeling)
library(e1071) #svm model
install.packages('kernlab')
#Warning message:
#package ‘kernlab’ is not available (for R version 3.2.4) 
library(kernlab) # has the radial basis function RBF

# Import Data
data(solubility)
ls(pattern="solT")
sample(names(solTrainX), 8)
ls(pattern="solT")


# SVM

svmFit <- ksvm(x = solTrainXtrans, y = solTrainY,
				# kernel="polydot" for nonlinear
				# kernel="vanilladot" for basic linear
				kernel="rbfdot", 
				kpar = "automatic",
				C = 1, epsilon = 0.1)
				
svmRTuned <- train(solTrainXtrans, solTrainY,
					method="svmRadial",
					preProc = c("center", "scale"),
					tuneLength = 14,
					trControl = trainControl(method="cv"))
svmRTuned
svmRTuned$finalModel
