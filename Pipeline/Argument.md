

# Argument-based pipeline

Argument-based pipeline is an initial value and a series of pipeline expressions input as arguments.

For the following example written with `%>>%`,

```r
mtcars$mpg %>>%
  sample(size = 10000, replace = TRUE) %>>%
  density(kernel = "gaussian") %>>%
  plot(col = "red", main = "density of mpg (bootstrap)")
```

we can rewrite it with `pipeline()` by writing each partial function as an argument.

```r
pipeline(mtcars$mpg,
  sample(size = 10000, replace = TRUE),
  density(kernel = "gaussian"),
  plot(col = "red", main = "density of mpg (bootstrap)"))
```

Internally, `pipeline()` translate such a function call into expressions connected by `%>>%` so as to produce the same result. 

In this case, `pipeline(x, ...)` works in a way that `x` is regarded as the initial input of the pipeline, and `...` receives a series of expressions to transform the previous result sequentially. The syntax for `%>>%` also works here. For example,

```r
pipeline(mtcars$mpg,
  (? length(.)),
  sample(size = 10000, replace = TRUE),
  (~ mtcars_sample),
  density(kernel = "gaussian"),
  plot(col = "red", main = "density of mpg (bootstrap)"))
```

The `(? expr)` syntax and `(~ symbol)` syntax work exactly the same way as in pipeline built by `%>>%`.
