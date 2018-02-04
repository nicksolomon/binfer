#' Clean
#'
#' Remove a burn in period and subsample for independence
#'
#' @param x The output of \code{draw()}
#' @param burnin The number of observations to disgard at the beginning of the
#'        chain.
#' @param subsample The number of observations to skip to reduce serial correlation.
#'
#' @return A cleaned up chain of draws from the posterior distribution.
#' @export
#'
clean <- function(x, burnin = 0, subsample = 1){
  if (! "binfer.posterior" %in% class(x)){
    stop("The input is not a `binfer` posterior. Have you called `draw()`?")
  }

  out <- x %>%
    mutate(index = 1:nrow(x))

  out <- out %>%
    filter(index > burnin) %>%
    filter(index %% subsample == 0)

  out <- out %>%
    select(-index)

  class(out) <- class(x)

  out
}
