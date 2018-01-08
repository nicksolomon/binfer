#' Title
#'
#' @param x The output of \code{simulate_posterior()}
#' @param burnin The number of observations to disgard at the beginning of the
#'        chain.
#' @param subsample The number of observations to skip to reduce serial correlation.
#'
#' @return
#' @export
#'
#' @examples
clean <- function(x, burnin = 0, subsample = 1){
  out <- x %>%
    mutate(index = 1:nrow(x))

  out <- out %>%
    filter(index > burnin) %>%
    filter(index %% subsample == 0)

  out %>%
    select(-index)
}
