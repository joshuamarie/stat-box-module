#include <Rcpp.h>
#include <cmath>

extern "C" SEXP square(SEXP x) {
    double res = std::pow(Rcpp::as<double>(x), 2);
    return Rcpp::wrap(res);
}
