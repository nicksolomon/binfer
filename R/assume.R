assume <- function(x, prior) {
  attr(x, "prior") <- as.character(rlang::f_rhs(prior))
  return(x)
}
