#' Matrix Multiplication Overriden Operators
#' 
#' @description
#' If loaded, they mask the existing \code{`*`} operator in base R, and this magically supports 
#' matrix multiplications. 
#' 
#' @details
#' These operators are dispatched through different classes, not limited to matrices only.
#' 
#' @param e1 LHS of the operation. This can be a matrix or a numeric. 
#' @param e2 RHS of the operation. This can be a matrix or a numeric. 
#' 
#' @examples
#' box::use(statmodule/matrix_ops[`*`, `^`])
#' 
#' # Solve the following system of equation
#' # 2x + y = 7; x + 2y = 5
#' 
#' A = rbind(
#'     c(2, 1), 
#'     c(1, 2)
#' )
#' B = as.matrix(c(7, 5))
#' A^-1 * B
#' 
#' @export
`*` = function (e1, e2) UseMethod("*")

`*.default` = function (e1, e2) base::`*`(e1, e2)

`*.matrix` = function (e1, e2) {
    if (is.matrix(e1) && is.matrix(e2)) {
        # Check dimensions for matrix multiplication
        if (ncol(e1) == nrow(e2)) {
            return(base::`%*%`(e1, e2))
        } else if (ncol(e2) == nrow(e1)) {
            # Try the other way around if dimensions match
            return(base::`%*%`(e2, e1))
        } else {
            return(base::`*`(e1, e2))
        }
    } else {
        return(base::`*`(e1, e2))
    }
}

`*.array` = function (e1, e2) {
    if (is.array(e1) && is.array(e2)) {
        if (ncol(e1) == nrow(e2)) {
            return(base::`%*%`(e1, e2))
        } else if (ncol(e2) == nrow(e1)) {
            return(base::`%*%`(e2, e1))
        } else {
            return(base::`*`(e1, e2))
        }
    } else {
        return(base::`*`(e1, e2))
    }
}

`*.data.frame` = function (e1, e2) {
    if (is.data.frame(e1)) {
        e1 = as.matrix(e1)
    }
    if (is.data.frame(e2)) {
        e2 = as.matrix(e2)
    }
    
    `*.matrix`(e1, e2)
}

box::register_S3_method("*", "default")
box::register_S3_method("*", "matrix")
box::register_S3_method("*", "array")
box::register_S3_method("*", "data.frame")

#' Matrix exponentiation and inverse
#' 
#' @export
`^` = function (e1, e2) UseMethod("^")

`^.default` = function (e1, e2) base::`^`(e1, e2)

`^.matrix` = function (e1, e2) {
    if (e2 == -1) {
        return(solve(e1)) # It becomes the inverse of the matrix
    } else if (e2 == 1) {
        return(e1)
    } else {
        return(base::`^`(e1, e2))
    }
}

`^.array` = function (e1, e2) {
    if (is.matrix(e1)) {
        return(`^.matrix`(e1, e2))
    }
    
    base::`^`(e1, e2)
}

`^.data.frame` = function (e1, e2) {
    if (is.data.frame(e1)) {
        e1 = as.matrix(e1)
    }
    
    `^.matrix`(e1, e2)
}

box::register_S3_method("^", "default")
box::register_S3_method("^", "matrix")
box::register_S3_method("^", "array")
box::register_S3_method("^", "data.frame")
