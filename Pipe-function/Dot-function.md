

# Dot function

As we have mentioned earlier, not all functions are pipe-friendly. While `%>>%` accepts `{}` and `()` on the right side, `Pipe` object provides `.()` to perform exactly the same set of features with `x %>>% (...)` which is powerful enough to meet a wide variety of demands in piping.

## Pipe to dot

If you supply an ordinary function call in `.()` it will evaluate it with `.` being the piped value.


```r
Pipe(mtcars)$
  .(lm(mpg ~ cyl + wt, data = .))
```

```
# $value : lm 
# ------
# 
# Call:
# lm(formula = mpg ~ cyl + wt, data = .)
# 
# Coefficients:
# (Intercept)          cyl           wt  
#      39.686       -1.508       -3.191
```

## Pipe by formula

To avoid ambiguity, one can write a formula in `.()` to define the symbol representing `mtcars`.


```r
Pipe(mtcars)$
  .(df ~ lm(mpg ~ cyl + wt, data = df))
```

```
# $value : lm 
# ------
# 
# Call:
# lm(formula = mpg ~ cyl + wt, data = df)
# 
# Coefficients:
# (Intercept)          cyl           wt  
#      39.686       -1.508       -3.191
```

## Pipe for side effect

The syntax of one-sided formula is also interpreted as side effect in `.()`.


```r
Pipe(mtcars)$
  subset(mpg >= quantile(mpg, 0.05) & mpg <= quantile(mpg, 0.95),
    c(mpg, cyl, wt))$
  .(~ cat("rows:",nrow(.),"\n"))$
  lm(formula = mpg ~ .)$
  summary()$
  coef()
```

```
# rows: 28
```

```
# $value : matrix 
# ------
#              Estimate Std. Error   t value     Pr(>|t|)
# (Intercept) 36.630834  1.6127431 22.713372 3.299463e-18
# cyl         -1.418216  0.3533452 -4.013684 4.783302e-04
# wt          -2.528175  0.7657771 -3.301450 2.894825e-03
```

The question mark works too.


```r
Pipe(mtcars)$
  subset(vs == 1, c(mpg, cyl, wt))$
  .(? nrow(.))$
  .(? data ~ ncol(data))$
  summary()
```

```
# ? nrow(.)
# [1] 14
# ? data ~ ncol(data)
# [1] 3
```

```
# $value : table 
# ------
#       mpg             cyl              wt       
#  Min.   :17.80   Min.   :4.000   Min.   :1.513  
#  1st Qu.:21.40   1st Qu.:4.000   1st Qu.:2.001  
#  Median :22.80   Median :4.000   Median :2.623  
#  Mean   :24.56   Mean   :4.571   Mean   :2.611  
#  3rd Qu.:29.62   3rd Qu.:5.500   3rd Qu.:3.209  
#  Max.   :33.90   Max.   :6.000   Max.   :3.460
```

The debugging function `browser()` works exactly the same.

```r
mtcars %>>% 
  subset(vs == 1, c(mpg, cyl, wt)) %>>%
  (~ browser()) %>>%
  lm(formula = mpg ~ cyl + wt) %>>%
  summary
```

## Pipe with assignment

As we have previously mentioned that assignment may be the most important side effect so it deserves a syntax. One-sided formula with a symbol on the right indicates the input value should be assigned to that symbol. The syntax works in `.()` too.


```r
pmodel <- Pipe(mtcars)$
  subset(select = c(mpg, wt, cyl))$
  .(~ sub_mtcars)$ # assign subsetted mtcars to sub_mtcars
  lm(formula = mpg ~ wt + cyl)

summary(sub_mtcars)
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

Note that `=` in function argument will be interpreted as argument selection, therefore `=` cannot be used to assign value in `.()` function.

The way to perform side-effect assignment is to use `<-` or `->` introduced by pipeR v0.5 with `~`, like the following:


```r
Pipe(mtcars)$
  lm(formula = mpg ~ wt + cyl)$
  .(~ summary(.) -> summ)$
  coef()
```

```
# $value : numeric 
# ------
# (Intercept)          wt         cyl 
#   39.686261   -3.190972   -1.507795
```

```r
summ$r.squared
```

```
# [1] 0.8302274
```

If `~` in is removed, the assignment will be done and the value of `summary()` will go on piping.


```r
Pipe(mtcars)$
  lm(formula = mpg ~ wt + cyl)$
  .(summary(.) -> summ)$
  coef()
```

```
# $value : matrix 
# ------
#              Estimate Std. Error   t value     Pr(>|t|)
# (Intercept) 39.686261  1.7149840 23.140893 3.043182e-20
# wt          -3.190972  0.7569065 -4.215808 2.220200e-04
# cyl         -1.507795  0.4146883 -3.635972 1.064282e-03
```

```r
summ$r.squared
```

```
# [1] 0.8302274
```

Note that the output of two `Pipe`s are different. The `Pipe` with `~ summary(.)` results in a numeric vector of the coeffecients of the linear model because the summary is only a side effect while the `Pipe` without `~` results in a comprehensive matrix showing the summary of the linear coefficients because `coef()` works on the summary.

## Extract element

Element extraction also works in `.()` if a symbol name is supplied.


```r
Pipe(mtcars)$
  lm(formula = mpg ~ wt + cyl)$
  summary()$
  .(r.squared)
```

```
# $value : numeric 
# ------
# [1] 0.8302274
```

## Dot function as closure

Note that `.()` is only defined within a `Pipe` object and is not an exported function in pipeR, you cannot directly call `.()` outside a `Pipe()`. 

In fact, if you are familiar with functional programming, it is called a *closure*, which is basically defined as a function returned by a function. However, you can save `.()` in a `Pipe` object to a symbol as a shortcut to call it elsewhere.


```r
model <- Pipe(mtcars)$
  lm(formula = mpg ~ wt + cyl)$
  .

model()
```

```
# $value : lm 
# ------
# 
# Call:
# lm(formula = mpg ~ wt + cyl, data = .)
# 
# Coefficients:
# (Intercept)           wt          cyl  
#      39.686       -3.191       -1.508
```

```r
model(coefficients)
```

```
# $value : numeric 
# ------
# (Intercept)          wt         cyl 
#   39.686261   -3.190972   -1.507795
```

```r
model()$summary()$coef()
```

```
# $value : matrix 
# ------
#              Estimate Std. Error   t value     Pr(>|t|)
# (Intercept) 39.686261  1.7149840 23.140893 3.043182e-20
# wt          -3.190972  0.7569065 -4.215808 2.220200e-04
# cyl         -1.507795  0.4146883 -3.635972 1.064282e-03
```
