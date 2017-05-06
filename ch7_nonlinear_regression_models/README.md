<h1>Chapter 7: Non Linear Regression Models</h1>
<hr>

<h2>Neural Networks</h2>

<p>In essence, neural nets are a uni-directional graph. In order to go from one node to the next, we apply a dot product. The set up is by layers, typically annotated the <em>start layer</em>,<em>hidden layer(s)</em>, and <em>outcome layer</em>. Each of the layers has an associated constant associated with it, <strong>these can be tuned as a hyper parameter</strong>. We are basically doing dot products of the current layer, with each of the units in the next layer (Plus each hidden units individual bias (constant)). This value is then passed into the logistic (sigmoidal) to detect non-linearities (If we suspect the data is not linearly related, ex. images, text data, ect..). </p>

<p>The model parameters are found by the <strong>back propogation algorithm</strong>, which uses gradient descent which uses derivatives to find the optimal parameters. </p>

<h2>Multivariate Adaptive Regression Splines</h2>

<p>In essence, breaks the predictors up into two groups and sees how well each of those groups does as a predictors with the outcome of the group.</p>
<p>You can decide how many of those groups you want as new features by optimizing the solution.</p>

<h2>Support Vector Machines</h2>

<p>Find the best hyperplane (defined by its support vectors) which separates two classes of data points. </p>

<p>The hyperparameters defined by this are:
<ul> 
<li>the C value, which allows us to introduce some bias error (points in the the margin) </li>
<li></li>
</ul>
</p>

<h2>K-Nearest Neighbor</h2>

<p>A great solution to missing data in a data set. We can use it for imputation. A new sample is imputed by finding the samples in the training set "closest to it" and averages these nearby points (K of them) to fill in the value</p>
<p></p>
<p></p>