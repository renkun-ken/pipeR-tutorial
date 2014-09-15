

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

## Pipe with assignment

## Extract element
