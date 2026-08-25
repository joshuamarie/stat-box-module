box::use(./hook[dll])

#' Calling native code example 3: Square a number
#'
#' Template function that calls into the module's compiled code.
#'
#' @param x A number to be squared
#'
#' @return The sum of `x` and `y`, as a double.
#'
#' @export
square = function(x) {
    .Call(dll$square, x)
}
