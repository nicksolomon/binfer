#' Title
#'
#' @param x
#' @param likelihood
#'
#' @return
#' @export
#'
#' @examples
define <- function(x, likelihood) {
  attr(x, "response") <- as.character(rlang::f_lhs(likelihood))
  attr(x, "likelihood") <- as.character(rlang::f_rhs(likelihood))

  x <- dplyr::select(x, attr(x, "response"))
  return(x)
}
