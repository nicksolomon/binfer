#' Define
#'
#' Define a likelihood
#'
#' @param x A \code{data.frame}.
#' @param likelihood A formula where the right hand side is a variable in
#'        \code{x} and the left hand side is a the name of a function.
#'
#' @return A \code{data.frame} with the likelihood as an attribute.
#' @export
#'
#' @examples
#'   my_lik <- function(data, theta) {dnorm(data, mean = 3.07333 , sd = theta)}
#'   my_prior <- function(theta) {dgamma(theta, shape = 1)}
#'
#'   posterior <- define(iris, Sepal.Width ~ my_lik) %>%
#'     assume(prior = ~ my_prior) %>%
#'     draw(initial = .43, nbatch = 1e5, blen = 1, scale = .01) %>%
#'     diagnose() %>%
#'     clean(burnin = 0, subsample = 40) %>%
#'     diagnose()

define <- function(x, likelihood) {

  attr(x, "response") <- as.character(rlang::f_lhs(likelihood))
  attr(x, "likelihood") <- as.character(rlang::f_rhs(likelihood))

  if (! attr(x, "response") %in% names(x)){
    stop("Column ", attr(x, "response"), " not found in x.")
  }

  if (! is.numeric(x[[attr(x, "response")]])){
    stop("Column ", attr(x, "response"), " should be numeric.")
  }

  tryCatch(
    match.fun(attr(x, "likelihood")),
    error = function(e){
      e$message <- paste0("Couldn't find function ", attr(x, "likelihood"), ".")
      stop(e)
    }
  )


  x <- dplyr::select(x, attr(x, "response"))

  return(x)
}
