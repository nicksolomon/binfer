#' Define
#'
#' Define a likelihood
#'
#' @param x A \code{data.frame}.
#' @param likelihood A formula where the right hand side is a variable in
#'   \code{x} and the left hand side is a \code{purrr}-style anonymous function
#'   using the variables \code{.data} and \code{.theta} that express the
#'   likelihood of a single observation using functions from R. For example:
#'   \code{var ~ dnorm(.data, .theta)}.
#'
#' @return A \code{data.frame} with the likelihood as an attribute.
#' @export
#'
#' @examples
#'
#'   posterior <- define(iris, Sepal.Width ~ dnorm(.data, mean = 3.07333 , sd = .theta)) %>%
#'     assume(prior = ~ dgamma(.theta, shape = 1)) %>%
#'     draw(initial = .43, nbatch = 1e5, blen = 1, scale = .01) %>%
#'     diagnose() %>%
#'     clean(burnin = 0, subsample = 40) %>%
#'     diagnose()

define <- function(x, likelihood) {

  attr(x, "response") <- as.character(rlang::f_lhs(likelihood))

  if (length(likelihood) != 3) {
    stop("The likelihood is not in the correct form.")
  }

  attr(x, "likelihood") <- as.character(likelihood)[3]

  if (! attr(x, "response") %in% names(x)){
    stop("Column ", attr(x, "response"), " not found in x.")
  }

  if (! is.numeric(x[[attr(x, "response")]])){
    stop("Column ", attr(x, "response"), " should be numeric.")
  }

  # tryCatch(
  #   match.fun(attr(x, "likelihood")),
  #   error = function(e){
  #     e$message <- paste0("Couldn't find function ", attr(x, "likelihood"), ".")
  #     stop(e)
  #   }
  # )


  x <- dplyr::select(x, attr(x, "response"))

  return(x)
}
