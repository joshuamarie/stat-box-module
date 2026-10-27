#include <Rcpp.h>
#include "tstk.h"

using Rcpp::NumericVector; 
using Rcpp::Range; 

namespace tstk {
NumericVector lag(NumericVector x, int k = 1, double fill) {
    int n = x.size(); 
    if (k < 1) return x;
    NumericVector out(n, fill);
      
    if (k > 0 && k < n) {
        for (int i = k; i < n; ++i)
            out[i] = x[i - k];
    }
    
    return out; 
}
}