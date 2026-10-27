phi.numeric = function(x, lag_max = 10L, ...) {
    acf = arrayed(rho(x, lag_max = lag_max, ...))[-1]
    phi = matrix(nrow = lag_max, ncol = lag_max)
    phi[1, 1] = acf[1]

    for (k in 2:lag_max) {
        num = acf[k]
        denom = 1

        for (j in 1:(k - 1)) {
            num = num - phi[k - 1, j] * acf[k - j]
        }

        for (j in 1:(k - 1)) {
            denom = denom - phi[k - 1, j] * acf[j]
        }

        phi[k, k] = num / denom

        for (j in 1:(k - 1)) {
            phi[k, j] = phi[k - 1, j] - phi[k, k] * phi[k - 1, k - j]
        }
    }

    res = diag(phi)
    res
}
