

# Expression-based pipeline

Expression-based pipeline is a group of expressions being evaluated as a pipeline, that is, the whole expression is not evaluated in standard way but regarded as a series of pipeline expressions.

For the following example written with `%>>%`,

```r
mtcars$mpg %>>%
  sample(size = 10000, replace = TRUE) %>>%
  density(kernel = "gaussian") %>>%
  plot(col = "red", main = "density of mpg (bootstrap)")
```

we can use `pipeline({ ... })` to rewrite it as

```r
pipeline({
  mtcars$mpg
  sample(size = 10000, replace = TRUE)
  density(kernel = "gaussian")
  plot(col = "red", main = "density of mpg (bootstrap)")  
})
```

Note that this is different from the way we write argument-based pipeline. Instead of supplying the expressions as arguments, we only supply to the first argument an expression enclosed by `{}` in which each line represents a pipeline step.

Expression-based pipeline differs from argument-based pipeline in that the expression should be quoted by `{}` and each step must by written in a new line. This is useful because such style, in most cases, makes the code cleaner than without any line breaks.

In addition to the syntactic distinctions, the expression supplied to `pipeline()` does not require `()` to enclose task expressions involving symbols that are specially defined in local scope like `~` and `?`. In the following example,

```r
mtcars$mpg %>>%
  sample(size = 10000, replace = TRUE) %>>%
  (? length(.)) %>>%
  (~ mtcars_sample) %>>%
  density(kernel = "gaussian") %>>%
  plot(col = "red", main = "density of mpg (bootstrap)")
```

Both `? length(.)` and `~ mtcars_sample` should be enclosed by `()` because of operator priority issues. In `pipeline()` expressions, such issues do not arise. Therefore, we can perform such special pipeline tasks without enclosing the expression by `()`.

```r
pipeline({
  mtcars$mpg
  sample(size = 10000, replace = TRUE)
  ? length(.)
  ~ mtcars_sample
  density(kernel = "gaussian")
  plot(col = "red", main = "density of mpg (bootstrap)")  
})
```

All other features works in `pipeline()` too. For example, we can ask labeled question in pipeline.


```r
pipeline({
  mtcars
  "Total number of records" ? nrow(.)
  subset(mpg >= quantile(mpg, 0.05) & mpg <= quantile(mpg, 0.95))
  "Qualified number of records" ? nrow(.)
  lm(formula = mpg ~ wt + cyl)
  summary
  "R Squared" ? .$r.squared
  coef
})
```

```
# ? Total number of records 
# [1] 32
# ? Qualified number of records 
# [1] 28
# ? R Squared 
# [1] 0.8252262
```

```
#              Estimate Std. Error   t value     Pr(>|t|)
# (Intercept) 36.630834  1.6127431 22.713372 3.299463e-18
# wt          -2.528175  0.7657771 -3.301450 2.894825e-03
# cyl         -1.418216  0.3533452 -4.013684 4.783302e-04
```
