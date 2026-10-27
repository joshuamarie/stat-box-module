#ifndef GLM_H
#define GLM_H

#include <Rcpp.h>

using Rcpp::NumericVector;
using Rcpp::Nullable;

namespace tstk {
NumericVector lag(NumericVector x, int k, double fill = NA_REAL); 
NumericVector acf(NumericVector x, Nullable<int> lag_max, Nullable<int> frequency);
NumericVector pacf(NumericVector x, Nullable<int> lag_max, Nullable<int> frequency);
}

#endif