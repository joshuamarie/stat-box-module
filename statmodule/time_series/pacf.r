box::use(
    vctrs[
        cast = vec_c,
        array = vec_data,
        new_vctr
    ],

    lazy(. / hook[dll]),
)

phi = function(x, ...) {
    UseMethod("phi")
}

phi.numeric = function(x, lag_max = 10L, na.action = na.fail, ...) {
    x = na.action(x)

    # acf = array(rho(x, lag_max = lag_max, ...))[-1]
    # prev = acf[1]
    # res = numeric(lag_max)
    # res[1] = acf[1]
    #
    # for (k in 2:lag_max) {
    #     num = acf[k] - sum(prev * acf[(k - 1):1])
    #     denom = 1 - sum(prev * acf[1:(k - 1)])
    #     phi_kk = num / denom
    #     prev = c(prev - phi_kk * rev(prev), phi_kk)
    #     res[k] = phi_kk
    # }

    res = .Call(
        dll$pacf_cpp,
        x = x,
        lag_max = if (is.null(lag_max)) {
            NULL
        } else {
            cast(lag_max, ptype = integer())
        },
        frequency = 1L
    )
    new_vctr(res, class = "partial_correl_ts")
}

phi.ts = function(
    x,
    lag_max = NULL,
    frequency = NULL,
    na.action = na.fail,
    ...
) {
    x = na.action(x)
    x = cast(x, ptype = numeric())

    res = .Call(
        dll$pacf_cpp,
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
    xx = diff(AirPassengers)
    print(phi(xx))
    cat("\n\n")
    cat("Compared to the `foreacst::Pacf()`: ", "\n\n")
    print(forecast::Pacf(xx, plot = FALSE))
}
