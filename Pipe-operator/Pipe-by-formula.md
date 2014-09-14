

# Pipe by formula

Now that we have covered the features of first-argument piping and dot piping. In both cases, we can use `.` to refer to the value being piped. Sometimes, however, it may look confusing to use `.` to represent the value being piped. For example,


```r
mtcars %>>%
  (lm(mpg ~ ., data = .))
```

```

Call:
lm(formula = mpg ~ ., data = .)

Coefficients:
(Intercept)          cyl         disp           hp         drat  
   12.30337     -0.11144      0.01334     -0.02148      0.78711  
         wt         qsec           vs           am         gear  
   -3.71530      0.82104      0.31776      2.52023      0.65541  
       carb  
   -0.19942  
```

The code above works correctly even though the two dots in the second line have different meanings:

* `.` in formula `mpg ~ .` represents all variables other than `mpg` in `mtcars`, as interpreted by `lm()`.
* `.` in `data = .` represents `mtcars`, as interpreted by `%>>%`.

`%>>%` provides a way to reduce ambiguity. It accepts formula enclosed by parentheses like `(x ~ f(x))` so that `x` represents the value being piped. This formula is also called *lambda expression* which is a general term to denote an expression that associate the symbol of an object and an expression to evaluate. 

For example, the above code can be rewritten using lambda expression like


```r
mtcars %>>%
  (df ~ lm(mpg ~ ., data = df))
```

```

Call:
lm(formula = mpg ~ ., data = df)

Coefficients:
(Intercept)          cyl         disp           hp         drat  
   12.30337     -0.11144      0.01334     -0.02148      0.78711  
         wt         qsec           vs           am         gear  
   -3.71530      0.82104      0.31776      2.52023      0.65541  
       carb  
   -0.19942  
```

where the formula tells `%>>%` to use `df` to represent `mtcars` so that the expression of linear model fit won't look ambiguous any more.

The following example mixes first argument piping and piping by formula.


```r
mtcars %>>%
  subset(select = c(mpg, wt, cyl)) %>>%
  (x ~ lm(mpg ~ ., data = x))
```

```

Call:
lm(formula = mpg ~ ., data = x)

Coefficients:
(Intercept)           wt          cyl  
     39.686       -3.191       -1.508  
```

One thing to notice is that the formula must be enclosed in `()` and cannot function in `{}` as we have noted before.

Since formula is, in essence, a pair of expressions connected by `~`, its right-hand side can be an expression enclosed in `{}` which does more things. For example,


```r
mtcars %>>%
  subset(select = c(mpg, wt, cyl)) %>>%
  (x ~ {
    summ <- lm(mpg ~ ., data = x) %>>%
      summary
    list(n = nrow(x), r.squared = summ$r.squared)
  })
```

```
$n
[1] 32

$r.squared
[1] 0.8302274
```

