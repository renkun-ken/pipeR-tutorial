# Pipe operator

Pipe operator `%>>%` is the single operator the package provides. The operator basically pipes the left-hand side value forward to the right-hand side expression which is evaluated according to its syntax.

Many functions in R and packages are pipe-friendly, that is, they take the data as the first argument. Therefore `%>>%` supports first-argument piping, as has been demonstrated in the first example.

For those functions that are not so friendly to pipe operation, `%>>%` allows to evaluate any expression with the left-hand side value.

The code are often made fluent and readable using pipeline. However, sometimes we need some side-effect such as plotting graphics and printing intermediate result. If we directly call them, the pipeline would be broken because the returned value may not be desired for further piping. `%>>%` supports side effect piping that only evaluates expression for its side effect.

One useful implication of side-effect piping is that it allows saving intermediate value in a pipeline.

Sometimes it is also useful to extract the element from the input object, which is also supported by `%>>%`.

The question is how does `%>>%` know what the user wants to do? Its behavior is fully determined by the syntax of the expression the user specifies. This chapter will introduce to you in great detail the syntactic rules of `%>>%`.
