# box::use(Rcpp[...])

#' @export
dll = NULL

.on_load = function(ns) {
    ns$dll = dyn.load(
        box::file(".lib", paste0("core-cpp", .Platform$dynlib.ext))
    )
}

.on_unload = function(ns) {
    dyn.unload(
        box::file(".lib", paste0("core-cpp", .Platform$dynlib.ext))
    )
}
