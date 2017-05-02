## Pro-tip: Online R-interpreter shell here at [R-Fiddle](http://www.r-fiddle.org/#/fiddle?id=czRYN6Xg). 


```markdown
- Neural nets phase 1: Each node in the layer, get its linear combination (plus some constant for model tuning)
	- This is essentially each node in the input layer transposed times the inputlayer as a column vector, this returns a scalar
	- This scalar is then put into a non-linear logistic (i.e., sigmoidal) function, which makes it nonlinear
	- If the value beats a threshold, we light up that node with a 1 for the input layer and store the value, else 0 not used
	- An example of how one might determine what the best type of neural net is **is to set a sequence of weight decay (regularization, just a tuning parameter) and a sequence of hidden layers, train the model, predict, get an RSME, then plot each of them in the sequence against each other. Find the best one and use it (lowest RMSE).
	-
	
- Multivariate Adaptive Regression Splines (MARS)
	- MARS, breaks predictors down into two groups and models linear relationships between the predictor and the outcome in each group, this **piecewise linear model** is created where each new feature models an isolated portion of the original data.
	
```