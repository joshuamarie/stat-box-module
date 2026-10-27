box::use(
    vctrs[
        check_size = vec_check_size,
        cast = vec_cast,
        assert = vec_assert,
    ],

    lazy(. / hook[dll]),
)

lag = function(x, k, fill = NA) {
    check_size(k, 1)
    k = cast(k, integer())

    .Call(dll$lag, x, k, as.double(fill))
}

# lag = function(x, k, fill = NA) {
#     check_size(k, 1)
#     # assert(k, numeric())
#     k = cast(k, integer())
#     n = length(x)
#
#     start = rep(fill, k)
#     remain = x[1:(n - k)]
#     new_x = c(start, remain)
#     new_x
# }
