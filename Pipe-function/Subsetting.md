

# Subsetting

`Pipe` object supports direct subsetting using `[]`, element extraction using `[[]]`, and element assignment using `<-`. The operation is done with the value in `Pipe` rather than `Pipe` itself.

## Using `[]`

Traditionally, `[]` is used to subset a vector or list. `Pipe` object implements `[]` too so that you can directly subset the inner value without breaking the `Pipe`.


```r
Pipe(list(a=1,b=2,c=3))[c("a","b")]
```

```
# <Pipe: list>
# $a
# [1] 1
# 
# $b
# [1] 2
```

```r
Pipe(mtcars)[c("mpg","cyl","wt")]$
  head()
```

```
# <Pipe: data.frame>
#                    mpg cyl    wt
# Mazda RX4         21.0   6 2.620
# Mazda RX4 Wag     21.0   6 2.875
# Datsun 710        22.8   4 2.320
# Hornet 4 Drive    21.4   6 3.215
# Hornet Sportabout 18.7   8 3.440
# Valiant           18.1   6 3.460
```

Note that the value after subsetting is still a `Pipe` containing the subsetted value to allow further piping. 

In fact, it does not only supports simple subsetting operations on vectors and lists, it also supports complex and highly customized subsetting such as subsetting a `data.table`.


```r
library(data.table)
set.seed(0)
dt <- data.table(id = 1:6, x = rnorm(6), y = rep(letters[1:3]), key = "id")
dt
```

```
#    id          x y
# 1:  1  1.2629543 a
# 2:  2 -0.3262334 b
# 3:  3  1.3297993 c
# 4:  4  1.2724293 a
# 5:  5  0.4146414 b
# 6:  6 -1.5399500 c
```

```r
Pipe(dt)[1:3] # select by row index
```

```
# <Pipe: data.table data.frame>
#    id          x y
# 1:  1  1.2629543 a
# 2:  2 -0.3262334 b
# 3:  3  1.3297993 c
# 4:  4  1.2724293 a
# 5:  5  0.4146414 b
# 6:  6 -1.5399500 c
```

```r
Pipe(dt)[J(3)] # join by key
```

```
# Error in `[.data.frame`(x, i): could not find function "J"
```

```r
Pipe(dt)[, sum(x), by = list(y)] # group sum
```

```
# Error in `[.data.frame`(x, i, j): object 'x' not found
```

```r
Pipe(dt)[, z := x^2+1] # reference mutate
```

```
# Error in `:=`(z, x^2 + 1): Check that is.data.table(DT) == TRUE. Otherwise, := and `:=`(...) are defined for use in j, once only and in particular ways. See help(":=").
```

The important thing here is that using `Pipe()` you can enjoy smooth piping experience and don't have to worry interruptions by subsetting like them. Therefore, you can enjoy the smoking performance of `data.table` with pipeline operations even though it is not by designed pipe-friendly.

For example, first we convert `mtcars` to `data.table` and put its row names into a new columns called `name` which is set as key. Since the output is a `Pipe` object containing the `data.table`, we name it `pmtcars` to remind ourselves it is a `Pipe` rather than an ordinary object.


```r
pmtcars <- Pipe(mtcars)$
  .(~ rownames(.) -> row_names)$
  as.data.table()[, name := row_names]$
  setkey(name)
```

```
# Error in `:=`(name, row_names): Check that is.data.table(DT) == TRUE. Otherwise, := and `:=`(...) are defined for use in j, once only and in particular ways. See help(":=").
```

We can subset it with `[]` as we showed. Remember, being a `Pipe` object means we can use `$` to pipe its inner value forward.


```r
pmtcars[mpg >= quantile(mpg,0.05)]$
  lm(formula = mpg ~ wt + cyl)$
  summary()$
  coef()
```

```
# Error in `[.data.frame`(., mpg >= quantile(mpg, 0.05)): object 'mpg' not found
```

One thing to notice is that `[]` is evaluated with `.` representing the value in `Pipe`, which makes it easier to use by avoiding redundant references to the value many times.

Traditionally, if we want to move out the last entry from a vector, we have to somehow compute its length.


```r
mtcars$mpg[-length(mtcars$mpg)]
```

```
#  [1] 21.0 21.0 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 17.8 16.4 17.3 15.2
# [15] 10.4 10.4 14.7 32.4 30.4 33.9 21.5 15.5 15.2 13.3 19.2 27.3 26.0 30.4
# [29] 15.8 19.7 15.0
```

Using `Pipe()` the code can be rewritten as 


```r
Pipe(mtcars$mpg)[-length(.)]
```

```
# <Pipe: numeric>
#  [1] 21.0 21.0 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 17.8 16.4 17.3 15.2
# [15] 10.4 10.4 14.7 32.4 30.4 33.9 21.5 15.5 15.2 13.3 19.2 27.3 26.0 30.4
# [29] 15.8 19.7 15.0
```


## Using `[[]]`

Just like `[]`, `[[]]` also behaves according to the same design logic. It extracts an element from vector, list, and environment.


```r
Pipe(mtcars)[["mpg"]]$
  summary()
```

```
# <Pipe: summaryDefault table>
#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#   10.40   15.42   19.20   20.09   22.80   33.90
```

If you prefer not to use element extraction like this, there are various alternative ways to do exactly the same thing.

```r
# work with vector, list, environment, S4 objects.
Pipe(mtcars)$
  .(mpg)$
  summary()
  
# work with list, environment.
Pipe(mtcars)$
  .(summary(.$mpg))

# work with list, environment.
Pipe(mtcars)$
  with(summary(mpg))
```

All the above work and do the same thing. In practice, different approaches may result in different degrees of readability. You have to choose by your preference.

## Assigning values to elements

In addition to subsetting and extracting, `Pipe` object also supports element assignment including element assignment (`$<-` and `[[<-`) and subset assignment (`[<-`).


```r
lst <- Pipe(list(a=1,b=2))
lst
```

```
# <Pipe: list>
# $a
# [1] 1
# 
# $b
# [1] 2
```

```r
lst$a <- 2
lst
```

```
# <Pipe: list>
# $a
# [1] 2
# 
# $b
# [1] 2
```

```r
lst[["b"]] <- NULL
lst
```

```
# <Pipe: list>
# $a
# [1] 2
```

```r
lst$c <- 1:3
lst
```

```
# <Pipe: list>
# $a
# [1] 2
# 
# $c
# [1] 1 2 3
```

```r
lst[c("a","c")] <- list(1:3, 2:5)
lst
```

```
# <Pipe: list>
# $a
# [1] 1 2 3
# 
# $c
# [1] 2 3 4 5
```

