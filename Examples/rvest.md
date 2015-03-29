

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
# 2015-03-29 09:02:30: downloading
# number of packages: 6457
# 2015-03-29 09:02:39: text extracted
# 2015-03-29 09:02:41: task complete
```

```
# <Pipe: array>
# .
#           data       analysis         models           with      functions 
#            978            822            542            451            398 
#     regression     estimation        package          model          using 
#            340            311            301            289            273 
#          tools          based           from       bayesian         linear 
#            264            255            219            197            197 
#        methods           time      interface   multivariate    statistical 
#            189            184            182            147            137 
#    generalized           test     clustering         series          tests 
#            132            121            117            117            117 
#      inference   distribution     statistics      selection         random 
#            111            109            109            107            103 
#      algorithm        spatial       multiple       modeling     simulation 
#             99             99             95             94             91 
#          mixed  distributions     likelihood         method      modelling 
#             89             83             83             80             79 
#        network         sparse         robust classification           sets 
#             79             79             77             76             73 
#        mixture       survival       sampling        effects           high 
#             71             69             68             67             67
```

As we have pointed out, the side effects use special syntax so it is easy to distinguish mainstream pipeline and side effect steps.
