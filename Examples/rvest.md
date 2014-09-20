

# rvest

[rvest](https://github.com/hadley/rvest) is a new R package to make it easy to scrape information from web pages. In this example, we show a simple scraping task using pipeR's `Pipe()` together with side effects to indicate scraping process.

In this example, we scrape the description of [CRAN packages](http://cran.r-project.org/web/packages/available_packages_by_date.html) and list the most popular keywords.

First, we load the libaries we need.


```r
library(rvest) # devtools::install_github("hadley/rvest")
library(rlist) # devtools::install_github("rlist","renkun-ken")
library(pipeR)
```

Then we build a pipeline to scrape the texts in the description column, split the texts into words, create a table in which the most popular keywords are listed. To monitor the process, we add some side effects using `message()` to indicate the working progress.


```r
url <- "http://cran.r-project.org/web/packages/available_packages_by_date.html"
Pipe(url)$
  .(~ message(Sys.time(),": downloading"))$
  html()$
  html_nodes(xpath = "//tr//td[3]")$
  .(~ message("number of packages: ", length(.)))$
  html_text(trim = TRUE)$
  .(~ message(Sys.time(),": text extracted"))$
  list.map(Pipe(.)$
      strsplit("[^a-zA-Z]")$
      unlist(use.names = FALSE)$
      tolower()$
      list.filter(nchar(.) > 3L)$
      value)$
    # put everything in a large character vector
  unlist()$
  # create a table of word count
  table()$
  # sort the table descending
  sort(decreasing = TRUE)$
  # take out the first 100 elements
  head(50)$
  .(~ message(Sys.time(),": task complete"))
```

```
# 2014-09-20 11:52:23: downloading
# number of packages: 5862
# 2014-09-20 11:52:51: text extracted
# 2014-09-20 11:52:53: task complete
```

```
# $value : array 
# ------
# .
#           data       analysis         models           with      functions 
#            884            721            498            415            373 
#        package     regression     estimation          model          based 
#            333            315            279            253            241 
#          using          tools           from       bayesian         linear 
#            241            236            202            178            177 
#        methods           time      interface   multivariate    statistical 
#            174            168            163            136            125 
#           test    generalized     clustering         series          tests 
#            113            112            109            106            106 
#      inference         random   distribution     statistics      selection 
#            102            100             99             98             96 
#        spatial       multiple      algorithm       modeling     simulation 
#             91             90             88             86             83 
#          mixed     likelihood  distributions         method classification 
#             81             78             77             77             72 
#      modelling           sets        network        mixture         robust 
#             71             71             69             68             66 
#        effects         sparse       survival       sampling           gene 
#             65             65             62             61             60
```

As we have pointed out, the side effects use special syntax so it is easy to distinguish mainstream pipeline and side effect steps.
