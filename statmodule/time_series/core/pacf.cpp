#include <Rcpp.h>
#include "tstk.h"
#include <cmath> 

using Rcpp::NumericVector;
using Rcpp::Nullable;
using Rcpp::as;
using Rcpp::sum;
using Rcpp::rev; 
using Rcpp::Range; 

namespace tstk {
NumericVector pacf(NumericVector x, Nullable<int> lag_max, Nullable<int> frequency) {
    int n = x.size();
    int n_series = 1;              
    int lag_max_new;
    int freq = frequency.isNull() ? 1 : as<int>(frequency);
    if (lag_max.isNull()) {
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
    
    NumericVector rho = tstk::acf(
        x, 
        Nullable<int>(Rcpp::wrap(lag_max_new)), 
        Nullable<int>(Rcpp::wrap(freq))
    )[Range(1, lag_max_new)];
    NumericVector res(lag_max_new); 
    NumericVector prev(1);
    prev[0] = rho[0]; 
    res[0] = rho[0]; 
    
    for (int k = 1; k <= lag_max_new; ++k) {
        double num = rho[k] - sum(prev * rev(rho[Range(0, k - 1)])); 
        double denom = 1 - sum(prev * rho[Range(0, k - 1)]); 
        double phi_kk = num / denom; 
        NumericVector tmp = prev - phi_kk * rev(prev);
        tmp.push_back(phi_kk);
        prev = tmp;
        res[k] = phi_kk; 
    }
    
    return res; 
}
}

