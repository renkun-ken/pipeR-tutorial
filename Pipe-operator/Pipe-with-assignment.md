

# Pipe with assignment

Previously, we covered side effect piping, that is, if an enclosed expression that follows `%>>%` starts with `~`, it tells the operator to evaluate the expression only for its side effect.

Functions having side effects can be categorized into several types. We have shown side effects such as printing (`print()` objects), message (`cat()`, `message()`), and graphics (`plot()`).

In addition to printing and plotting, one may need to save an intermediate value to the environment by assigning it to a variable (or symbol). Perhaps assignment is the most important side effect among all. Just imagine a version of R in which we cannot assign.

Therefore, assignment as a side effect deserves a set of syntax to be made easier. If one needs to assign the value to a symbol, just insert a step like `(~ symbol)`, then the input value of that step will be assigned to `symbol` in the current environment. 

This syntax is probably the simplest case for an side effect. Since evaluating a symbol for side effect rarely makes sense, it is instead interpreted as assigning input value to the given symbol.


```r
mtcars %>>%
  subset(select = c(mpg, wt, cyl)) %>>%
  (~ sub_mtcars) %>>% # assign subsetted mtcars to sub_mtcars
  lm(formula = mpg ~ wt + cyl) %>>%
  (~ lm_mtcars) %>>%  # assign linear model to lm_mtcars
  summary
```

```
# 
# Call:
# lm(formula = mpg ~ wt + cyl, data = .)
# 
# Residuals:
#     Min      1Q  Median      3Q     Max 
# -4.2893 -1.5512 -0.4684  1.5743  6.1004 
# 
# Coefficients:
#             Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  39.6863     1.7150  23.141  < 2e-16 ***
# wt           -3.1910     0.7569  -4.216 0.000222 ***
# cyl          -1.5078     0.4147  -3.636 0.001064 ** 
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 2.568 on 29 degrees of freedom
# Multiple R-squared:  0.8302,	Adjusted R-squared:  0.8185 
# F-statistic: 70.91 on 2 and 29 DF,  p-value: 6.809e-12
```

Then we can inspect the environment and see what is in it.


```r
ls.str()
```

```
# lm_mtcars : List of 12
#  $ coefficients : Named num [1:3] 39.69 -3.19 -1.51
#  $ residuals    : Named num [1:32] -1.279 -0.465 -3.452 1.019 2.053 ...
#  $ effects      : Named num [1:32] -113.65 -29.12 -9.34 1.33 1.6 ...
#  $ rank         : int 3
#  $ fitted.values: Named num [1:32] 22.3 21.5 26.3 20.4 16.6 ...
#  $ assign       : int [1:3] 0 1 2
#  $ qr           :List of 5
#  $ df.residual  : int 29
#  $ xlevels      : Named list()
#  $ call         : language lm(formula = mpg ~ wt + cyl, data = .)
#  $ terms        :Classes 'terms', 'formula' length 3 mpg ~ wt + cyl
#  $ model        :'data.frame':	32 obs. of  3 variables:
# sub_mtcars : 'data.frame':	32 obs. of  3 variables:
#  $ mpg: num  21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
#  $ wt : num  2.62 2.88 2.32 3.21 3.44 ...
#  $ cyl: num  6 6 4 6 8 6 8 4 4 6 ...
```

These two variables are exactly the intermediate results we wanted to save to the environment.

However, sometimes we don't want to directly save the input value but the value after some transformation. Then we can use `=` to specify a lambda expression to tell what to be saved. In pipeR v0.5, `<-` and more natural `->` are allowed in assignment too, which may make the code more readable.


```r
mtcars %>>%
  subset(select = c(mpg, wt, cyl)) %>>%
  (~ summ = summary(.)) %>>%  # side-effect assignment
  lm(formula = mpg ~ wt + cyl)
```

```
# 
# Call:
# lm(formula = mpg ~ wt + cyl, data = .)
# 
# Coefficients:
# (Intercept)           wt          cyl  
#      39.686       -3.191       -1.508
```

Then we can notice that `summ` is saved to the environment.


```r
summ
```

```
#       mpg              wt             cyl       
#  Min.   :10.40   Min.   :1.513   Min.   :4.000  
#  1st Qu.:15.43   1st Qu.:2.581   1st Qu.:4.000  
#  Median :19.20   Median :3.325   Median :6.000  
#  Mean   :20.09   Mean   :3.217   Mean   :6.188  
#  3rd Qu.:22.80   3rd Qu.:3.610   3rd Qu.:8.000  
#  Max.   :33.90   Max.   :5.424   Max.   :8.000
```

Like side effect expression can be a lambda expression, so can the expression being assigned following `=`.

```r
mtcars %>>%
  subset(select = c(mpg, wt, cyl)) %>>%
  (~ summ = df ~ summary(df)) %>>%  # side-effect assignment
  lm(formula = mpg ~ wt + cyl)
```

Note that the all above assignment operations works purely as side effect, they do not influence the value being piped. In other words, if these lines are removed, the input value will continue piping but without being assigned to given symbol.

What if one really wants the result not only to be assigned to a symbol but also to continue the flow to the next expression?

Two methods meet the demand:

1. Use `(~ symbol)` after the expression for assignment.
2. Use `(symbol = expression)` to assign the value of `expression` to `symbol`.

Note that the second method is fresh here but it should look natural because it can be easily distinguished from `(~ symbol = expression)` which is only for side effect.


```r
mtcars %>>%
  subset(select = c(mpg, wt, cyl)) %>>%
  (~ summ = df ~ summary(df)) %>>%  # side-effect assignment
  (model = lm(mpg ~ wt + cyl, data = .)) # pipe and assign
```

To verify the assignment, evaluate `model`.


```r
model
```

```
# 
# Call:
# lm(formula = mpg ~ wt + cyl, data = .)
# 
# Coefficients:
# (Intercept)           wt          cyl  
#      39.686       -3.191       -1.508
```

In pipeR v0.5, the assignment operators are enabled for their job. Note that the merit of a pipeline is its readability, a contributing factor is that the functions in each step are immediately visible so that one can easily figure out what the code does. The `=` syntax for assignment, to some extent, weakens the readability of the code because the functions are put behind, which, by contrast, does not happen with `->` used for assignment.

```r
mtcars %>>%
  (~ summary(.) -> summ)
  
mtcars %>>%
  (~ summ <- summary(.))
```

The `(~ expression -> symbol)` and `(~ symbol <- expression)` syntax work for side-effect assignment, and `(expression -> symbol)` and `(symbol <- assignment)` work for piping with assignment.

```r
mtcars %>>%
  (~ summary(.) -> summ) %>>%  # side-effect assignment
  (lm(formula = mpg ~ wt + cyl, data = .) -> lm_mtcars) %>>%  # continue piping
  summary
```

In addition to all above examples, the assignment feature is more powerful than has been demonstrated. The assignment operators `=`, `<-` and `->` even support subset and element assignment. For example,


```r
results <- list()
mtcars %>>%
  lm(formula = mpg ~ wt + cyl) %>>%
  (~ results$mtcars = . %>>% summary %>>% (r.squared))
```

```
# 
# Call:
# lm(formula = mpg ~ wt + cyl, data = .)
# 
# Coefficients:
# (Intercept)           wt          cyl  
#      39.686       -3.191       -1.508
```

```r
iris %>>%
  lm(formula = Sepal.Length ~ Sepal.Width) %>>%
  (~ results$iris = . %>>% summary %>>% (r.squared))
```

```
# 
# Call:
# lm(formula = Sepal.Length ~ Sepal.Width, data = .)
# 
# Coefficients:
# (Intercept)  Sepal.Width  
#      6.5262      -0.2234
```

Then we can print the results and see the values in it.


```r
results
```

```
# $mtcars
# [1] 0.8302274
# 
# $iris
# [1] 0.01382265
```

The similar code works with `->` or `<-` too, which can be more natural and less disturbing in pipeline.


```r
set.seed(0)
results <- numeric()
rnorm(100) %>>%
  (~ mean(.) -> results["mean"]) %>>%
  (~ median(.) -> results["median"]) %>>%
  summary
```

```
#     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
# -2.22400 -0.56940 -0.03296  0.02267  0.62540  2.44100
```

Print `results` and show the values in it.


```r
results
```

```
#        mean      median 
#  0.02266845 -0.03296148
```

More than simply assigning values to symbols, the expression can also be setting names and others.


```r
numbers <- 1:5
letters %>>%
  sample(length(numbers)) %>>%
  (~ . -> names(numbers))
```

```
# [1] "u" "g" "f" "l" "x"
```

Now the names of `numbers` become the randomly sampled letters.


```r
numbers
```

```
# u g f l x 
# 1 2 3 4 5
```
