#include <Rcpp.h>
#include "tstk.h"
#include <cmath>          

using Rcpp::NumericVector;
using Rcpp::Nullable;
using Rcpp::as;
using Rcpp::sum;
using Rcpp::na_omit;
using Rcpp::mean;

namespace tstk {
NumericVector acf(NumericVector x, Nullable<int> lag_max, Nullable<int> frequency) {
    int n = x.size();
    int n_series = 1;              
    int lag_max_new;
    if (lag_max.isNull()) {
        int freq = frequency.isNull() ? 1 : as<int>(frequency);
        lag_max_new = static_cast<int>(
            std::max(
                10.0 * (
                    std::log10(static_cast<double>(n)) -
                        std::log10(static_cast<double>(n_series))
                ),
                2.0 * freq
            )
        );
    } else {
        lag_max_new = as<int>(lag_max);
    }

    NumericVector res(lag_max_new + 1);
    double mu = mean(x);
    double denom = sum(pow(na_omit(x - mu), 2.0));

    for (int k = 0; k <= lag_max_new; ++k) {
        NumericVector lagged = tstk::lag(x, k);
        NumericVector prod = (x - mu) * (lagged - mu);
        double num = sum(na_omit(prod));
        res[k] = num / denom;
    }

    return res;
}
} // namespace tstk