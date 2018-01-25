
#' Diagnose
#'
#' Diagnose the chain
#'
#' @param x The output of \code{siulate_posterior()}
#'
#' @return \code{x} and prints some diagnostic plots.
#' @export
#'
#' @import patchwork
#' @import ggplot2
#' @import dplyr

diagnose <- function(x) {

  if (! "binfer.posterior" %in% class(x)){
    stop("The input is not a `binfer` posterior. Have you called `simulate_posterior()`?")
  }

  with_diagnostics <- x %>%
    mutate(index = 1:nrow(x),
           accepted = chain != dplyr::lag(chain))
  message(paste0("Acceptance rate: ", mean(with_diagnostics$accepted, na.rm = TRUE)))

  trace_plot <- ggplot(with_diagnostics, aes(x = index, y = chain)) +
    geom_line()

  dens_plot <- ggplot(with_diagnostics, aes(x = chain)) +
    geom_density()

  acf_df <- acf(with_diagnostics$chain, plot = FALSE)$acf %>%
    data.frame(correlation = .) %>%
    dplyr::mutate(lag = 0:(nrow(.) - 1))
  conf_int_upper <- qnorm((1 + .95)/2) / sqrt(nrow(with_diagnostics))
  conf_int_lower <- - conf_int_upper

  acf_plot <- ggplot(acf_df, aes(x = lag, y = correlation)) +
    geom_col() +
    geom_hline(yintercept = conf_int_upper) +
    geom_hline(yintercept = conf_int_lower)

  plot_out <- (dens_plot + acf_plot) / trace_plot
  print(plot_out)
  return(x)
}
