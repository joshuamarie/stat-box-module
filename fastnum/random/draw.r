box::use(./hook[dll])

#' Calling native code example 4: Random Number Generator for Uniform Distribution
#'
#' Template function that calls into the module's compiled code.
#'
#' @param n Number of samples being drawn.
#' @param min The lower limit of the distribution. 
#' @param max The upper limit of the distribution. 
#'
#' @return Uniformly distributed numbers
#'
#' @export
uniform = function(n, min = 0, max = 1) {
    .Call(dll$draw_uniform, n, min, max)
}

#' Calling native code example 5: Random Number Generator for Normal Distribution
#'
#' Template function that calls into the module's compiled code.
#'
#' @param n Number of samples being drawn.
#' @param mean The population mean of the distribution. 
#' @param sd The population standard deviation of the distribution. 
#'
#' @return Normally distributed numbers
#'
#' @export
normal = function(n, mean = 0, sd = 1) {
    .Call(dll$draw_normal, n, mean, sd)
}
