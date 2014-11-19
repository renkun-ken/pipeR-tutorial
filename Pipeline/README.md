# Pipeline

This chapter demonstrates the features of `pipeline()`. This function evaluates both argument-based and expression-based pipelines. What makes it special is that it does not require using pipe operator `%>>%`, nor does it create a `Pipe` object as a wrapper. Using `pipeline()`, you will be able to write cleaner pipeline expressions with less noise.

In other words, `pipeline()` implements two similar operator-free mechanisms for building a pipeline. The good thing is that you don't have to sacrifice any feature to use it, that is, all features of `%>>%` are supported in `pipeline()` and some are even made easier to use.
