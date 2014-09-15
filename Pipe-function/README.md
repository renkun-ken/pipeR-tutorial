# Pipe function

`Pipe()` function is the light-weight version of Pipe operator yet has more features.

1. Support all features of `%>>%` but use `$` for command chaining
2. Support direct subsetting, extraction, element assignment

Basically, `Pipe()` creates a `Pipe` object for which `$` is specially defined to perform first-argument piping, and `.(...)` is defined to act like `x %>>% (...)`. Pipe object also supports subsetting (`[]`), extraction (`[[]]`), and their corresponding assignment operations.

Using `Pipe()` the following code 

```r
mtcars %>>%
  lm(formula = mpg ~ wt + cyl) %>>%
  summary
```

can be rewritten like

```r
Pipe(mtcars)$
  lm(formula = mpg ~ wt + cyl)$
  summary
```
