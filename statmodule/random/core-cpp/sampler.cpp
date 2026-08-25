#include <Rcpp.h>
#include <dqrng_generator.h>
#include <dqrng_distribution.h>
#include <boost/random/uniform_real_distribution.hpp>
#include <boost/random/normal_distribution.hpp>

extern "C" SEXP draw_uniform(SEXP n, SEXP min, SEXP max) {
    int n_int = Rcpp::as<int>(n);
    double lo = Rcpp::as<double>(min);
    double hi = Rcpp::as<double>(max);
    
    auto rng = dqrng::generator();
    boost::random::uniform_real_distribution<double> dist(lo, hi);
    
    Rcpp::NumericVector out(n_int);
    for (int i = 0; i < n_int; ++i) out[i] = dist(*rng);
    return Rcpp::wrap(out);
}

extern "C" SEXP draw_normal(SEXP n, SEXP mean, SEXP sd) {
    int n_int = Rcpp::as<int>(n);
    double mu = Rcpp::as<double>(mean);
    double sigma = Rcpp::as<double>(sd);
    
    auto rng = dqrng::generator();
    boost::random::normal_distribution<double> dist(mu, sigma);
    
    Rcpp::NumericVector out(n_int);
    for (int i = 0; i < n_int; ++i) out[i] = dist(*rng);
    return Rcpp::wrap(out);
}
