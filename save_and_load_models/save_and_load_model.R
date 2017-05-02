" 
Resuing a model in R
"

set.seed(345)
df <- data.frame(x = rnorm(20))
head(df)
df <- transform(df, y = 5 + (2.3 * x) + rnorm(20))
#input is x, output is y, the transformation
head(df)

## model -- predict y based on x with dataframe df
m1 <- lm(y ~ x, data = df)

## save the model
save(m1, file = "my_model1.rda")
 
## new data
newdf <- data.frame(x = rnorm(20))

## load the model
load("my_model1.rda")

## predict for the new `x`s in `newdf`
predict(m1, newdata = newdf)