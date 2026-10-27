#include <Rcpp.h>
#include "tstk.h"

using Rcpp::wrap;
using Rcpp::NumericVector;
using Rcpp::as;
// using tstk::acf; 

extern "C" SEXP lag_cpp(SEXP x_, SEXP k_, SEXP fill_) {
    return wrap(tstk::acf(
        as<NumericVector>(x_),
        as<int>(k_),
        as<double>(fill_)
    ));
}

extern "C" SEXP acf_cpp(SEXP x_, SEXP lag_max_, SEXP frequency_) {
    return wrap(tstk::acf(
        as<NumericVector>(x_),
        as<Nullable<int>>(lag_max_),
        as<Nullable<int>>(frequency_)
    ));
}

extern "C" SEXP pacf_cpp(SEXP x_, SEXP lag_max_, SEXP frequency_) {
    return wrap(tstk::pacf(
        as<NumericVector>(x_),
        as<Nullable<int>>(lag_max_),
        as<Nullable<int>>(frequency_)
    ));
}

