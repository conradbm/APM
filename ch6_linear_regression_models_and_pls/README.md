## Pro-tip: Online R-interpreter shell here at [R-Fiddle](http://www.r-fiddle.org/#/fiddle?id=czRYN6Xg). 


<h1> Applied Predictive Modeling Chapter 6</h1>

<h2> PLS </h2>

<ul> 
<li> PLS is basically the same as PCA except the objective is only slightly different. We now take into account the covariance relationship to our response in PLS, where in PCA we are simply maximizing variance along our predictors. </li>

</ul>

<h2> Ridge Regression </h2>

<ul> 
<li> (Allows a penalty parameter, thus decreasing standard regressions bais/variance trade-off so we can make it more general to new data)</li>
<li>Ridge Regression is also explained in the script. This basically allows us to define a sequence of values we want caret to train over to find the least RMSE’s associated lambda. This is all you need to start doing real production time predictions if this is your model of choice.  </li>
</ul>