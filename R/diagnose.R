diagnose <- function(x) {
  with_diagnostics <- x %>%
    mutate(index = 1:nrow(x),
           accepted = chain == dplyr::lag(chain))
  message(paste0("Acceptance rate: ", mean(with_diagnostics$accepted, na.rm = TRUE)))
  trace_plot <- ggplot2::ggplot(with_diagnostics, aes(x = index, y = chain)) +
    geom_line()
  dens_plot <- ggplot2::ggplot(with_diagnostics, aes(x = chain)) +
    geom_density()
  print(trace_plot)
  print(dens_plot)
  return(x)
}
