#include <cmath>
#include <Rcpp.h>
#include <RcppEigen.h>

using Rcpp::NumericVector;
using Rcpp::as;
using Eigen::MatrixXd;
using Eigen::VectorXd;
using Eigen::Map;
using Rcpp::wrap;

extern "C" SEXP vif_score(SEXP X_r) {
    Map<MatrixXd> X = as<Map<MatrixXd>>(X_r);
    int n = X.rows();
    int p = X.cols();

    NumericVector out(p);

    for (int i = 0; i < p; ++i) {
        VectorXd X_curr = X.col(i);
        MatrixXd X_other(n, p);
        X_other.col(0) = VectorXd::Ones(n);
        int col_idx = 1;

        for (int j = 0; j < p; ++j) {
            if (j == i) continue;
            X_other.col(col_idx) = X.col(j);
            col_idx += 1;
        }

        VectorXd coefs_vif = X_other.colPivHouseholderQr().solve(X_curr);
        VectorXd y_hat_vif = X_other * coefs_vif;

        double mu_y = X_curr.mean();
        double ssr = (y_hat_vif.array() - mu_y).square().sum();
        double sst = (X_curr.array() - mu_y).square().sum();

        out[i] = 1 / (1 - ssr / sst);
    }

    return wrap(out);
}
