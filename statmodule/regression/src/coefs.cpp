#include <Rcpp.h>
#include <RcppEigen.h>

using Rcpp::as;
using Rcpp::stop;
using Rcpp::wrap;
using Eigen::MatrixXd;
using Eigen::VectorXd;
using Eigen::Map;

extern "C" SEXP coef_calc(SEXP X_r, SEXP y_r) {
    if (Rf_isMatrix(y_r) && Rf_ncols(y_r) > 1) {
        stop("The response variable `y` must contain only 1 variable");
    }

    Map<MatrixXd> X = as<Map<MatrixXd>>(X_r);
    Map<VectorXd> y = as<Map<VectorXd>>(y_r);

    int n = X.rows();
    int p = X.cols();

    MatrixXd X_design(n, p + 1);
    X_design.col(0) = VectorXd::Ones(n);
    X_design.rightCols(p) = X;

    VectorXd coefs = X_design.colPivHouseholderQr().solve(y);

    return wrap(coefs);
}

extern "C" SEXP se_calc(SEXP X_r, SEXP y_r, SEXP coefs_r) {
    Map<MatrixXd> X = as<Map<MatrixXd>>(X_r);
    Map<VectorXd> y = as<Map<VectorXd>>(y_r);
    Map<VectorXd> coefs = as<Map<VectorXd>>(coefs_r);

    int n = X.rows();
    int p = X.cols();
    int p_design = p + 1;

    if (coefs.size() != p_design) {
        stop("`coefs` length does not match number of design columns");
    }

    MatrixXd X_design(n, p_design);
    X_design.col(0) = VectorXd::Ones(n);
    X_design.rightCols(p) = X;

    VectorXd y_hat = X_design * coefs;
    VectorXd err = y - y_hat;
    double rss = err.dot(err);
    double var_coef = rss / (n - p_design);

    MatrixXd XtX = X_design.transpose() * X_design;
    Eigen::LDLT<MatrixXd> ldlt(XtX);
    if (ldlt.info() != Eigen::Success) {
        stop("Design matrix is singular or near-singular; cannot compute standard errors");
    }

    MatrixXd XtX_inv = ldlt.solve(MatrixXd::Identity(p_design, p_design));
    VectorXd se_coefs = (var_coef * XtX_inv.diagonal()).array().sqrt();

    return wrap(se_coefs);
}
