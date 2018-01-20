#' Title
#'
#' @param x The output of \code{deine()}.
#' @param prior A formula with the left hand side equal to the name of a
#'        function.
#'
#' @return The dataframe \code{x} with the prior as an attribute.
#' @export
#'

assume <- function(x, prior) {

  attr(x, "prior") <- as.character(rlang::f_rhs(prior))

  if (! "binfer" %in% class(x)){
    stop("The input isn't a `binfer` object. Is it the output of `assume()`?")
  }

  return(x)
}
