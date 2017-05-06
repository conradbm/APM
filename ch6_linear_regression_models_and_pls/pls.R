# APM Chapter 6 
#				-- Robust Linear Regression
#				-- Remove Correlations
#   			-- PLS
#				-- Penalized Regression Models

library(AppliedPredictiveModeling)
data(solubility)
ls(pattern="solT")
sample(names(solTrainX), 8)
trainingData <- solTrainXtrans
trainingData$Solubility <- solTrainY
# Robust Linear Regression - allows for a penalty inside of the RMSE objective function

library(MASS)
rlmFItAllPredictors <- rlm(Solubility ~ ., data=trainingData)
rlmFItAllPredictors

library(caret)
ctrl <- trainControl(method='cv', 
                     number=10)
set.seed(10)
lmFit1 <- train(x=solTrainXtrans,
                y = solTrainY,
                method="lm",
                trControl = ctrl)
lmFit1

"
RMSE       Rsquared 
0.7155509  0.8792096
"

xyplot(solTrainY ~ predict(lmFit1),
       type=c("p","g"),
       xlab = "Predicted", ylab="Observed")

xyplot(resid(lmFit1) ~ predict(lmFit1),
       type=c("p","g"),
       xlab = "Predicted", ylab="Residuals")

# Notice, strong correlations

corThresh <- 0.9
tooHigh <- findCorrelation(cor(solTrainXtrans), corThresh)
corrPred <- names(solTrainXtrans[tooHigh])
trainXfiltered <- solTrainXtrans[, -tooHigh]
testXfiltered <- solTestXtrans[,-tooHigh]
set.seed(12)
lmFiltered <- train(solTrainXtrans, solTrainY, method="lm",
                    trControl=ctrl)

# Pre-process with PCA now
set.seed(100)
rlmPCA <- train(solTrainXtrans, solTrainY,
                method="rlm",
                preProcess = "pca",
                trControl = ctrl)
rlmPCA

# PLS

set.seed(100)
plsTune <- train(solTrainXtrans, solTrainY, method="pls", tuneLength=20, trControl=ctrl, preProc = c("center", "scale"))

library(gpplot)
ggplot(plsTune)

# Ridge Regression -- Note: caret runs this over many lambda and akes the min RSME value

library(MASS)

ridgeModel <- enet(x= as.matrix(solTrainXtrans), y = solTrainY, lambda = 0.001)

ridgePred <- predict(ridgeModel, newx = as.matrix(solTestXtrans), s = 1, mode = "fraction", type ="fit")
head(ridgePred$fit)

ridgeGrid <- data.frame(.lambda = seq(0, .1, length=15))
set.seed(100)
ridgeRegFit <- train(solTrainXTest, solTrainY, method="ridge", tuneGrid=ridgeGrid, trControl=ctrl, preProc=c("center", "scale"))

ggplot(ridgeRegFit)

