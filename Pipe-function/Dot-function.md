

# Dot function

As we have mentioned above, not all functions are pipe-friendly. While `%>>%` accepts `{}` and `()` on the right side, `Pipe` object provides `.()` to perform exactly the same set of features with `x %>>% (...)`.

## Pipe to dot


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


```r
Pipe(mtcars)$
  subset(mpg >= quantile(mpg, 0.05) & mpg <= quantile(mpg, 0.95),
    c(mpg, cyl, wt))$
  .(~ cat("rows:",nrow(.),"\n"))$
  summary()
```

```
# rows: 28
```

```
# $value : table 
# ------
#       mpg             cyl              wt       
#  Min.   :13.30   Min.   :4.000   Min.   :1.513  
#  1st Qu.:15.72   1st Qu.:4.000   1st Qu.:2.732  
#  Median :19.20   Median :6.000   Median :3.325  
#  Mean   :19.85   Mean   :6.214   Mean   :3.152  
#  3rd Qu.:21.82   3rd Qu.:8.000   3rd Qu.:3.570  
#  Max.   :30.40   Max.   :8.000   Max.   :5.345
```



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


```r
mtcars %>>% 
  subset(vs == 1, c(mpg, cyl, wt)) %>>%
  (~ browser()) %>>%
  lm(formula = mpg ~ cyl + wt) %>>%
  summary
```

## Pipe with assignment


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


```r
pmodel$predict(list(wt = 3.5, cyl = 7.5))
```

```
# $value : numeric 
# ------
#       1 
# 17.2094
```

Note that `=` in function argument will be interpreted as argument selection, therefore `=` cannot be used to assign value in `.()` function.

The way to perform assignment is to use `<-` or `->` introduced by pipeR v0.5 like the following:

```r
Pipe(mtcars)$
  .(~ summary(.) -> summ)
  
Pipe(mtcars)$
  .(~ summ <- summary(.))
```

## Extract element


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
