#ifndef GLM_H
#define GLM_H

#include <Rcpp.h>
#include <RcppEigen.h>
#include "R_ext/Arith.h"

using Rcpp::List;
using Eigen::MatrixXd;
using Eigen::VectorXd;
using Eigen::Map;

List glm_solve(Map<MatrixXd> X, Map<VectorXd> y, List family, double tol);

#endif
