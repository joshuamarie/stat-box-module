#include <Rcpp.h>
#include <RcppEigen.h>
#include "glm.h"

using Rcpp::wrap;
using Rcpp::as;
using Rcpp::Function;
using Rcpp::Named;
using Eigen::MatrixXd;
using Eigen::VectorXd;
using Eigen::Map;

List glm_solve(Map<MatrixXd> X, Map<VectorXd> y, List family, double tol) {
    int n = X.rows();
    int p = X.cols();
    MatrixXd Xb(n, p + 1);
    Xb.col(0) = VectorXd::Ones(n);
    Xb.rightCols(p) = X;

    VectorXd beta = VectorXd::Zero(p + 1);
    double err = R_PosInf;
    int count = 0;

    // Auxilliary Functions from `family`
    // Used on GLMs
    Function linkinv = family["linkinv"];
    Function variance = family["variance"];
    Function mu_eta = family["mu.eta"];

    while (err > tol) {
        Rcpp::checkUserInterrupt();

        // 1. Calculate linear predictor (in eta)
        VectorXd eta = Xb * beta;

        // 2. Calculate fitted values (in mu)
        VectorXd mu = as<VectorXd>(linkinv(eta));

        // 3. Calculate weights
        VectorXd V = as<VectorXd>(variance(mu));
        VectorXd gradient = as<VectorXd>(mu_eta(eta));
        VectorXd w_vec = (gradient.array().square() / V.array()).matrix();

        // 4. Working response
        VectorXd z = (eta.array() + (y.array() - mu.array()) / gradient.array()).matrix();

        // 5. Update coefficients by solving weighted least squares
        MatrixXd XtWX = Xb.transpose() * w_vec.asDiagonal() * Xb;
        VectorXd XtWz = Xb.transpose() * (w_vec.array() * z.array()).matrix();
        VectorXd beta_new = XtWX.ldlt().solve(XtWz);
        err = (beta_new - beta).array().abs().maxCoeff();

        // Return the output
        beta = beta_new;
        count++;
    }

    return List::create(
        Named("coefficients") = beta,
        Named("n_iter") = count
    );
}

extern "C" SEXP glm_cpp(SEXP X_, SEXP y_, SEXP family_, SEXP tol_) {
    return wrap(glm_solve(
        as<Map<MatrixXd>>(X_),
        as<Map<VectorXd>>(y_),
        as<List>(family_),
        as<double>(tol_)
    ));
}
