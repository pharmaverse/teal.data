#' @section Combining:
#' `c(...)` combines multiple `teal_data` objects, merging their environments,
#' code, `join_keys`, and verification status.
#'
#' @rdname teal_data
#'
#' @examples
#' # Combining
#' d1 <- teal_data(
#'   iris = iris,
#'   join_keys = join_keys(join_key("iris", "iris", "iris_key"))
#' )
#' d2 <- teal_data(
#'   mtcars = mtcars,
#'   join_keys = join_keys(join_key("mtcars", "mtcars", "mtcars_key"))
#' )
#' c(d1, d2)
#'
#' @export
c.teal_data <- function(...) {
  out <- NextMethod("c")
  if (!inherits(out, "teal_data")) {
    return(out)
  }

  dots <- rlang::list2(...)
  td_dots <- Filter(function(x) inherits(x, "teal_data"), dots)

  out@join_keys <- do.call(c, lapply(td_dots, join_keys))
  out@verified <- all(vapply(td_dots, methods::slot, logical(1L), "verified"))
  out
}
