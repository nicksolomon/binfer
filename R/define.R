#' Define a likelihood
#'
#' @param x A \code{date.frame}.
#' @param likelihood A formula where the right hand side is a variable in
#'        \code{x} and the left hand side is a the name of a function.
#'
#' @return A \code{data.frame} with the likelihood as an attribute.
#' @export
#'

define <- function(x, likelihood) {
  attr(x, "response") <- as.character(rlang::f_lhs(likelihood))
  attr(x, "likelihood") <- as.character(rlang::f_rhs(likelihood))

  x <- dplyr::select(x, attr(x, "response"))
  return(x)
}
