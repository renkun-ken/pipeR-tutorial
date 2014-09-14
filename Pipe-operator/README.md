# Pipe operator

Pipe operator `%>>%` is the single operator the package provides. The operator basically pipes the left-hand side value forward to the right-hand side expression which is evaluated according to its syntax.

In summary, `%>>%` supports to pipe left-hand side value

1. To first argument of a function
2. To `.` in an expression
3. By formula to avoid ambiguity in symbol names.
4. To an expression only for its side effect.
5. To an expression and save the intermediate results.
6. To a symbol in order to extract that element

The question is: **How does `%>>%` know which one the user is trying to do?** Basically, the behavior of the operator is fully determined by the syntax of the expression that follows the operator. This chapter will introduce to you in great detail the syntactic rules of `%>>%`.
