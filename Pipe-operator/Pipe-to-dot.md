

# Pipe to dot

Not all functions are pipe-friendly in every case: You may find some functions do not take your data produced by a pipeline as the first argument. In this case, you can enclose your expression by `{}` or `()` so that `%>>%` will use `.` to represent the value on the left and evaluate the enclosed expression.

For the linear model example, one can rewrite `lm(formula = )` to


```r
mtcars %>>%
  { lm(mpg ~ cyl + wt, data = .) }
```

```

Call:
lm(formula = mpg ~ cyl + wt, data = .)

Coefficients:
(Intercept)          cyl           wt  
     39.686       -1.508       -3.191  
```

or 


```r
mtcars %>>%
  { lm(mpg ~ cyl + wt, data = .) }
```

```

Call:
lm(formula = mpg ~ cyl + wt, data = .)

Coefficients:
(Intercept)          cyl           wt  
     39.686       -1.508       -3.191  
```

The difference between `{}` and `()` used above is

1. `{}` accepts more than one expressions within the braces and its value is determined by the last one; but `()` accepts only one expression.
2. `{}` has only one feature: pipe to `.` in the enclosed expression while `()` has more features (we will cover them soon).

