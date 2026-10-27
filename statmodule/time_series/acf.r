box::use(
    vctrs[cast = vec_c, new_vctr],
    stats[na.fail],

    # lazy(. / utils[lag]),
    . / hook[dll],
)

#' @export
rho = function(x, ...) {
    UseMethod("rho")
}

rho.numeric = function(x, lag_max = NULL, na.action = na.fail, ...) {
    x = na.action(x)
    res = .Call(
        dll$acf_cpp,
        x = x,
        lag_max = if (is.null(lag_max)) {
            NULL
        } else {
            cast(lag_max, ptype = integer())
        },
        frequency = 1L
    )
    new_vctr(res, class = "correl_ts")
}

rho.ts = function(
    x,
    lag_max = NULL,
    frequency = NULL,
    na.action = na.fail,
    ...
) {
    x = na.action(x)
    x = cast(x, ptype = numeric())

    res = .Call(
        dll$acf_cpp,
        x = x,
        lag_max = if (is.null(lag_max)) {
            NULL
        } else {
            cast(lag_max, ptype = integer())
        },
        frequency = if (is.null(frequency)) {
            NULL
        } else {
            cast(frequency, ptype = integer())
        }
    )
    new_vctr(res, class = "correl_ts")
}

if (is.null(box::name())) {
    # xx = as.numeric(AirPassengers)
    # print(rho(xx))
    print(rho(AirPassengers))
    cat("\n\n")
    cat("Compared to the `foreacst::Pacf()`: ", "\n\n")
    print(forecast::Acf(AirPassengers, plot = FALSE))
}
