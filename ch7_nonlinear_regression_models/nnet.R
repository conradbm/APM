library(caret)
library(ggplot2)
library(AppliedPredictiveModeling)

data(solubility)
ls(pattern="solT")
sample(names(solTrainX), 8)
ls(pattern="solT")
trainX <- solTrainX
trainY <- solTrainY
testX <- solTestX
testY <- solTestY
testXtrans <- solTestXtrans
trainXtrans <- solTrainXtrans

# Neural net example
tooHigh <- findCorrelation(cor(trainXtrans), cutoff = 0.75)
trainXnnet <- trainXtrans[, -tooHigh] #remove highly correlated variables -train
testXnnet <- testXtrans[, -tooHigh]   #remove highly correlated variables -test
nnetGrid <- expand.grid(.decay=c(0,0.01, 0.1),
                        .size=c(1:10),
                        .bag=FALSE)# doesnt work

set.seed(100)
ctrl <- trainControl(method='cv', 
                     number=10)

nnetTune <- train(trainXtrans, trainY,
                  trControl = ctrl,
                #  tuneGrid = nnetGrid,
                  preProc=c("center", "scale"),
                  linout=TRUE,
                  trace=FALSE,
                  MaxNWts = 10 * (ncol(trainXnnet)+1) + 10 + 1,
                  maxit=500
                  )

ggplot(nnetTune)
