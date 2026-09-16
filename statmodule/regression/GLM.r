box::use(
    tabstats[draw_table = table_default],
    dplyr[tbl = tibble],
    stats[model.frame, model.matrix, model.response, gaussian],
    . / hook[dll],
)

#' Custom Generalized Linear Model
#'
#' Fits a generalized linear model using iteratively reweighted least
#' squares (IRLS), implemented in C++ via Rcpp and RcppEigen.
#'
#' @param obj An object used to select a method. Can be a formula, or a
#'   matrix/data frame of predictor variables.
#' @param ... Additional arguments passed to methods.
#'
#' @return An object of class \code{custom_glm} containing:
#'   \itemize{
#'     \item \code{out}: A tibble with columns \code{terms} and
#'       \code{coefficients}
#'     \item \code{family}: The family name used for the fit
#'     \item \code{link}: The link function name used for the fit
#'     \item \code{n_iter}: Number of IRLS iterations until convergence
#'   }
#'
#' @examples
#' box::use(
#'     ./module/statistics/models/glm
#' )
#'
#' # Using formula notation
#' glm$glm(mpg ~ wt + disp, data = mtcars)
#'
#' # Using a binomial family
#' glm$glm(am ~ wt + hp, data = mtcars, family = binomial())
#'
#' # Using matrix/data frame directly
#' glm$glm(mtcars[, c("wt", "disp")], mtcars$mpg)
#'
#' @export
glm = function(obj, ...) {
    UseMethod("glm")
}

#' @rdname glm
#' @param data A data frame containing the variables in the formula.
#' @param family A family function, a call to a family function, or a
#'   string naming one (e.g. \code{"binomial"}). Defaults to
#'   \code{gaussian()}.
glm.formula = function(obj, data, family = gaussian(), ...) {
    if (missing(data)) {
        data = environment(obj)
    }

    mf = model.frame(obj, data = data)
    X = mf[, -1, drop = FALSE]
    y = model.response(mf)

    glm.default(X, y, family, ...)
}

#' @rdname glm
#' @param tol Convergence tolerance for the IRLS loop. Default is
#'   \code{1e-7}.
#'
#' @keywords internal
glm.default = function(obj, y, family = gaussian(), tol = 1e-7, ...) {
    if (is.character(family)) {
        family = get(family, mode = "function", envir = parent.frame())
    }
    if (is.function(family)) {
        family = family()
    }
    if (is.null(family$family)) {
        print(family)
        stop("'family' not recognized")
    }

    X = as.matrix(obj)
    storage.mode(X) = "double"
    y = as.double(y)

    raw_fit = .Call(dll$glm_cpp, X, y, family, tol)

    coef_names = colnames(X)
    if (is.null(coef_names)) {
        coef_names = paste0("X", seq_len(ncol(X)))
    }
    coef_names = c("(Intercept)", coef_names)

    out = tbl(
        terms = coef_names,
        coefficients = as.vector(raw_fit$coefficients)
    )

    model_fit = list(
        out = out,
        family = family$family,
        link = family$link,
        n_iter = raw_fit$n_iter
    )
    class(model_fit) = "custom_glm"

    model_fit
}

#' @rdname glm
#' @param x A \code{custom_glm} object.
#' @param digit Number of decimals to be displayed.
#'
#' @export
print.custom_glm = function(x, digits = 2, ...) {
    cat("\n Custom GLM output: \n\n")
    cat(" Family:", x$family, "\n")
    cat(" Link function:", x$link, "\n")
    cat(" Iterations:", x$n_iter, "\n\n")
    draw_table(x$out, digits = digits, ...)
    cat("\n\n")
}

box::register_S3_method("print", "custom_glm")
