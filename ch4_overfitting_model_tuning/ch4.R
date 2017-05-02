"
****************************************
****** Chater 4 -- Data Splitting ******
****************************************
"

# Data Import
# ---------------------------------------------------------------------------- #
library(AppliedPredictiveModeling)
library(caret)
data(twoClassData)


# KNN Example
# ---------------------------------------------------------------------------- #

str(predictors) #208x2 data.frame object
str(classes) #list of factors object

"
The base R function 'sample' can create simple random splits of the data.
To create stratified random splits of the data (based on classes), the
'createDataPartition' function in the caret package can be used. The percent
of data that will be allocated to the training set should be specified.
"
# for reproducibility
set.seed(1)

"
By default, the numbers are returned as a list. Using list=FALSE, a matrix of row numbers is generated. These samples are allocated to the training set.
"
trainingRows <- createDataPartition(classes, p=0.8, list=FALSE)
head(trainingRows)

"
Use the partitions as a measure to split the data into training and testing sets.
"
trainPredictors <- predictors[trainingRows,]
trainClasses <- classes[trainingRows]
testPredictors <- predictors[-trainingRows,]
testClasses <- classes[-trainingRows]


"
If you really wanted maximum dissimilarity sampling, the caret function maxdissim can be used to sequentially sample the data.
"
str(trainPredictors)
str(testPredictors)

"
The additional argument for createDataPartition, 'times' to generate multiple splits in the data.
"
set.seed(1)
repeatedSplits <- createDataPartition(trainClasses, p=0.8, times = 3)
str(repeatedSplits)


"
Caret also supports createResamples, createFolds, and createMulifolds
"
set.seed(1)
cvSplits <- createFolds(trainClasses, k=10, returnTrain = TRUE)
str(cvSplits)

fold1 <- cvSplits[[1]]
cvPredictor1 <- trainPredictors[fold1,]
cvClasses1 <- trainClasses[fold1]
nrow(trainPredictors)
nrow(cvPredictor1)

"
Basic Model Building in R

Now that we have training and test sets, we could fit the 5-nearest neighbor classification model to the training data and use it to predict the test set. There are multiple R functions for building this model: the 'knn' function in the MASS package, the 'ipredknn' in the ipred package, and the knn3 function in the caret package. The knn3 function can produce class predictions as well as the proportion of neighbors for each class.

There are two main conventions for specifying models in R: the formila interface and the non-formula (or 'matrix') interface. For the former, the predictors are explicitly listed. A basic R formula has two sides: the left-hand side denotes the outcome and the right-hand side describes how the predictors are used. These are separated with a tilde (~). For example, the formula:
modelFunction(price ~ numBedrooms + numBaths + acres,
              data = housingData)
would predict the closing price of a house using three quantitative characteristics. The formula 'y ~ .'can be used to indicate that all of the columns in the data set (except y) should be used as a predictor. The formula interface has many conveniences. For example, transormations such as log(acres) can be specified in-line. Unfortunately, R does not efficiently store the information about the formula. Using this interface with data sets that contain a large number of predictors may unneccesarily slow the computations.

The non-formula interface specifies the predictors for the model using a matrix or data frame (all the predictors in the object are used in the model by default this way). The outcome data are usually passed into the model as a vector object. For example:
modelFunction(x=housePredictors, y=price)

Note that not all R functions have both interfaces.

"

trainPredictors <- as.matrix(trainPredictors) #data.frame --> matrix, easy conversion
knnFit <- knn3(x=trainPredictors, y=trainClasses, k=5)
knnFit

"
At this point the KNN object is ready to predict new samples. To assign new samples to classes, the preict method is used with the model object. The standard convention is as follows:
"
testPredictions <- predict(knnFit, newdata=testPredictors, type="class")
head(testPredictions)
str(testPredictions)
# ---------------------------------------------------------------------------- #




# Data Import
# ---------------------------------------------------------------------------- #
data(GermanCredit)
# ---------------------------------------------------------------------------- #

# SVM Example
# ---------------------------------------------------------------------------- #
set.seed(1056)
svmFit <- train(Class ~ ., #use all predictors to predict 'Class'
                data = GermanCredit,
                method = 'svmRadial')

set.seed(1056)
svmFit <- train(Class ~ ., #use all predictors to predict 'Class'
                data = GermanCredit,
                method = 'svmRadial',
                preProc = c("center","scale"))
set.seed(1056)
svmFit <- train(Class ~ ., #use all predictors to predict 'Class'
                data = GermanCredit,
                method = 'svmRadial',
                preProc = c("center","scale"),
                tuneLength = 10)
set.seed(1056)
svmFit <- train(Class ~ ., #use all predictors to predict 'Class'
                data = GermanCredit,
                method = 'svmRadial',
                preProc = c("center","scale"),
                tuneLength = 10,
                trControl = trainControl(method = "repeatedcv", 
                                         repeats = 5))

# ---------------------------------------------------------------------------- #
