
really <- function(fun, otherwise) {
  out_fun <- function(...) {
    out <- fun(...)
    out[which(is.na(out))] <- otherwise
    return(out)
  }

  return(out_fun)
}
