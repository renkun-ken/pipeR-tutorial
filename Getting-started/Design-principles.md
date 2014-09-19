

# Design principles

pipeR is designed to make R code easier to read, write, and maintain using pipeline operations. It tries to define intuitive syntax rather than a collection of symbols to avoid ambiguity and give users full control of the piping behavior.

pipeR avoids introducing too many symbols because symbols are too small to distinguish in a glimpse. Suppose pipeR defines a set of symbols, each of which plays a different role, one probably cannot quickly find out the input value of each line at first look. In this case, to understand how one line works one must refer to the operator in end of the previous line, or maybe  several lines above. This makes the code even harder to read. That is why pipeR carefully designs syntax rather than introduces new operators for a feature.

In fact, with old functions deprecated, pipeR v0.5 only has one operator `%>>%` and one function `Pipe()` for users but provides many features useful in building pipelines.

