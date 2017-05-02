"
*****************
*** Chapter 3 ***
*****************
Cell data set from Applied Predictive Modeling.
" 
#install.packages("AppliedPredictiveModeling")
library(AppliedPredictiveModeling)
data("segmentationOriginal")

"
# This particular data set has it's own variable identifying that it is
# a training set or a testing set. We just want to use the subset command
# to reach into this data set and pull it only on the columnName = desiredName
# this returns just the data set holding the training data
"
segData <- subset(segmentationOriginal, Case == "Train")

cellID <- segData$Cell
class <- segData$Class
case <- segData$Case

"
# get everything BUT columns 1 through 3 and store it into segData
"
segData <- segData[,-(1:3)] 

"
# get column name with Status in it. Use grep helper for this.
"
statusColNum <- grep("Status", names(segData))
statusColNum # just indices that HAVE status in the name.

"
# get everything BUT the predictors that have Status and store them into segData
"
segData <- segData[,-statusColNum]

"
# Some features exhibit significant skewness. The 'skewness' function in e1071
# package calculates the sample skewness statistics for each predictor:
"
#install.packages("e1071")
library(e1071)
# For one predictor:
skewness(segData$AngleCh1)



"
Since all the predictors are numeric columns,
the apply function can be used to compute the skewness accross columns
Usage:
apply(X, MARGIN, FUN, ...)
Arguments 

MARGIN ... for a matrix ...
--> 1 indicates rows
--> 2 indicates columns
--> c(1,2) indicates rows and columns.
So apply on dataset X=segData, 2=over each column, skewness=the function.
"

"
# Equivalent to the apply function, but gets specifically for skewness.
"
get_skewness_df <- function(df){
  
  "
  The goal is to get a df that looks like this:
  # +-------------------------+
  # | col1 col2 col3 ... colN |
  # | sk1  sk2  sk3  ... skN  |
  # +-------------------------+
  "
  
  "
  # Construct the object we want to build -- 1xN matrix
  "
  y = data.frame(matrix(rep(0,1), 
                        nrow = 1, 
                        ncol = length(colnames(df))))
  
  "
  # Copy the column names
  "
  colnames(y) <- colnames(df)
  
  "
  # Apply the function to every column
  "
  for(i in 1:length(colnames(df))){
    y[,i] = skewness(df[,i])
  }
  
  "
  # Return the construct skewness object
  "
  return(y)
}

head(col_skewness_df(segData))

skewValues <- apply(segData, 2, skewness)
skewValues # every predictor and its skewness.

"
The skewness helps guide us into prioritizing the values for visualization the distribution. 
We can use hist, or histogram from lattice. To determine the type of transformation that SHOULD be used, 
the MASS package contains the boxcox function. Although this function estimates lambda, it does not create the transformed variables. 
A caret function, BoxCoxTrans, can find the appropriate transormation and apply them to the new data.
"
#install.packages("caret")
library(caret)
Ch1AreaTrans <- BoxCoxTrans(segData$AreaCh1)
Ch1AreaTrans

head(segData$AreaCh1)

"
Description
Using a previously built model and new data, predicts the class value and probabilities for classification problem and function value for regression problem.

Usage -- Example
predict(object, newdata, ..., costMatrix=NULL, 
type=c(both,class,probability))

Predict on our transformation=Ch1AreaTrans, data=head(segData$AreaCh1)
"
predict(Ch1AreaTrans, head(segData$AreaCh1))
# (819^(-0.9) - 1)/(-0.9)

"
Another caret function, preProcess, applies this transformation to a set of predictors.
The base R function prcomp can be used for PCA (A commonly used data reduction technique; 
This model finds linear combinations of the predictors, known as principal compoennts (PC's) which capture the most possible variance).
"
pcaObject <- prcomp(segData, 
                    center = TRUE,
                    scale. = TRUE)

"
# Calculate the cululative percentage of variance which each component accounts for.
"
percentVariance <- pcaObject$sd^2/ sum(pcaObject$sd^2) * 100
percentVariance[1:3] #[1] 20.91236 17.01330 11.88689
names(pcaObject)     #[1] "sdev"     "rotation" "center"   "scale"    "x"   

"
The transformed values are stored in pcaObject as a sub-object called x:
Another sub-object called rotation stores the variable loadings, where rows correspond to predictor variables and columns are associated with the compoents:
"
head(pcaObject$x[,1:5])
head(pcaObject$rotation[,1:3])

"
Also, these data do not have missing values for imputation. To impute missing values, the impute package has a function, 
impute.knn, that uses K-nearest neighbors  to estimate the missing data.  The previously mentioned preProcess function applies 
imputation methods based on K-nearest neighbors or bagged trees.

To administer a series of transformations to multiple data sets, the caret class preProcess has the ability to 
transform, center, scale, or impute values, as well as apply the spatial sign transofmration and feature extraction. 
The function calculates the required quantities for the transformation. After calling the preProcess function, the predict method applies
the results to a set of data. For example, to Box-Cox transform, center, and scale the data, then execute PCA for signal extraction, 
the syntax would be:
"
trans <- preProcess(segData, method = c("BoxCox", "center", "scale", "pca"))
trans

"
Apply the transformations:
These values are different than the previous PCA components since they were transformed prior to PCA

The order in which the possible transformation are applied is transformation, centering, scaling, imputation, feature extraction, and then spatial sign. 

Many of the modeling functions have options to center and scale prior to modeling. For example, when using the train function, there is an option to use 
preProcess prior to modeling within the resampling iterations.
"
transformed <- predict(trans, segData)
head(transformed[,1:5])


"
Filtering:
To filter for near-zero variance predictors, the caret package function nearZeroVar will return the column numbers of any predictors that fulfill the conditions outlined in Sect 3.5. For cell segmentation data, there are no problematic predictors:

When predictors should be removed, a vector of integers is returned that indicate which columns should be removed.
"
nearZeroVar(segData)

correlations <- cor(segData)
dim(correlations)
correlations[1:4,1:4]

"
To visually examine the coorrelation structure of the data, corrplot package contains an excellent function of the same name. The function has many options including one that will reorder the variables in a way that reveals clusters of highly correlated predictors. The following command was used to produce Figure 3.10:
"
#install.packages("corrplot")
library(corrplot)
corrplot(correlations, order="hclust")

highCorr <- findCorrelation(correlations, cutoff=.75)
length(highCorr)
head(highCorr)

#everything but the high correlations
filteredSegData <- segData[,-highCorr]

library(caret)
data("cars")

carSubset <- subset(cars)

"
At this point I want to add a new column with Type representing 
1/5 1/0 values in columns 14:18 represented in the vector 'types'
"
types <- c("convertible","coupe", "hatchback", "sedan", "wagon")

"
# Helper function to add a column to a data frame and populate 
# based on a codition
"
addColumnToDF <- function(df, newColumnName){
  
  # Add the column
  df$newColumnName <- NULL
  # Create our vector we will append as a column
  newSubset <- c()
  
  # Iterate over the rows named in 'types' grabbing each observation
  # while grabbibg the index of the observation with a 1 telling us
  # which column it is, then grabbing that value in types and storing
  # it row by row into our vector we will append. This gives us a new
  # column with corresponding row values
  
  newSubset <- apply(df[,types],
                     1, 
                     function(obs){
                       hit_index <- which(obs == 1)
                       newSubset <- types[hit_index]
                     })
  df$Type <- cbind(Type = newSubset)
  df <- df[, (which(!names(df) %in% types))]
  return(df)
}

"
# Apply my little function to add the new column and return a 
# updated dataframe. 
"
carSubset <- addColumnToDF(carSubset, "Type")
carSubset$Type <- as.factor(carSubset$Type)
levels(carSubset[,"Type"])

"
To model the price as a function of mileage and type of car, we can use the function dummyVars to determine encodings for the predictors. Suppose our first model assumes that the price can be modeled as a simple additive function of the mileage and type:

To generate the dummy variables for the training set or any new samples, the predict method is used in conjunction with the dummyVars object.
"
simpleMod <- dummyVars(~Mileage + Type,
                       data = carSubset)

predict(simpleMod, head(carSubset))

"
The Type field was expanded into five variables for five factor levels. The model is simple because it assumes that effect of the mileage is the same for every type of car. To fit a more advanced model, we could asume that there is a joint effect of mileage and car type. This type of effect is referred to as an interaction. In the model formula, a colon between factors indicates that an interaction should be generated. For thes data, this adds another five predictors to the data frame:
"

withInteraction <- dummyVars(~Mileage + Type + Mileage:Type,
                             data = carSubset,
                             levelsOnly = TRUE)
withInteraction
head(predict(withInteraction, carSubset))
