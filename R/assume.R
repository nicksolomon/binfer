#' Assume
#'
#' Assume a posterior distribution.
#'
#' @param x The output of \code{\link{define}()}.
#' @param prior A formula with the left hand side equal to the name of a
#'        function.
#'
#' @return The dataframe \code{x} with the prior as an attribute.
#' @export
#'

assume <- function(x, prior) {

  attr(x, "prior") <- as.character(rlang::f_rhs(prior))

  if (! "likelihood" %in% names(attributes(x))){
    stop("The input doesn't have a likelihood. Is it the output of `define()`?")
  }

  tryCatch(
    match.fun(attr(x, "prior")),
    error = function(e){
      e$message <- paste0("Couldn't find function ", attr(x, "prior"), ".")
      stop(e)
    }
  )
  class(x) <- c("binfer", class(x))
  return(x)
}
