"
Exercise 3.1
Glass Identification Data Set
"

"
Standard data importing.
"
install.packages("mlbench")
library(mlbench)
data(Glass)
str(Glass)

"
Some data logistics.

214 obervations
10 predictors, 9 nums 1 factor with 6 levels.

(a) Using visualizations, 
  explore the predictor variables to 
    understand their distributions 
    as well as the relationships between predictors.

(b) Do there appear to be any outliers in the data? Are any predictors skewed?

(c) Are there any relevant transofmrations of one or more predictors that might improve the classification model?
"

#install.packages("corrplot")
#install.packages("caret")
#install.packages("e1071")
library(corrplot)
library(caret)
library(e1071)

"
(a) Visualizations to see correlations.
"

"
# Notice: The last column is named Type and is of type: factor, not numeric
# put all non-numeric variables in that dynamic vector to exclude them.
# Find all correlations amongst numeric variables
"
correlations <- cor(Glass[,which(!names(Glass) %in% c("Type"))])
dim(correlations)
correlations

corrplot(correlations, order="hclust")

highCorr <- findCorrelation(correlations, cutoff=.75)
length(highCorr)
head(highCorr)

#everything but the high correlations
filteredGlassData <- Glass[,-highCorr]
head(filteredGlassData)

"
(b) Visualizations to see if any outliars exist in our predictors.
"

skewValues <- apply(Glass[,which(!names(Glass) %in% c("Type"))],
                    2, 
                    skewness)
"
Seems like we have a right skewed distribution
"
hist(skewValues)

"
(c) Relevant transformation of one or more predictors.
"


"
With skewed data, we should apply the Box-Cox after we pass the skewnesses to it to find the lambda value necessary for tuning the model parameters. 

Also, these data do not have missing values for imputation. To impute missing values, the impute package has a function, 
impute.knn, that uses K-nearest neighbors  to estimate the missing data.  The previously mentioned preProcess function applies 
imputation methods based on K-nearest neighbors or bagged trees.

To administer a series of transformations to multiple data sets, the caret class preProcess has the ability to 
transform, center, scale, or impute values, as well as apply the spatial sign transofmration and feature extraction. 
The function calculates the required quantities for the transformation. After calling the preProcess function, the predict method applies
the results to a set of data. For example, to Box-Cox transform, center, and scale the data, then execute PCA for signal extraction, 
the syntax would be:
"
trans <- preProcess(Glass[,which(!names(Glass) %in% c("Type"))],
                    method = c("BoxCox", "center", "scale", "pca"))

"
Apply the transformations:
These values are different than the previous PCA components since they were transformed prior to PCA

The order in which the possible transformation are applied is transformation, centering, scaling, imputation, feature extraction, and then spatial sign. 

Many of the modeling functions have options to center and scale prior to modeling. For example, when using the train function, there is an option to use 
preProcess prior to modeling within the resampling iterations.
"
transformed <- predict(trans, Glass[,which(!names(Glass) %in% c("Type"))])
head(transformed[,1:5])

