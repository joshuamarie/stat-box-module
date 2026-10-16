#!/usr/bin/env rscript
box::use(
    stats[runif, rnorm], 
    statmodule / random / draw, 
    dqrng[dqrunif, dqrnorm, dqset.seed], 
)

# In this example, you want to estimate the following:
#                     E[(X + U)^2]
# 
# where:
# -  X ~ N(2, 1)
# -  U ~ Uniform(0, 1)
# -  And suppose that X and U are independent
# 
# Assuming that this number is so hard to estimate
# Although the exact theoretical value of it is around 
# You just have to square inside E[]
# You'll get:
#  
# = E[X^2] + E[2XU] + E[U^2]
# = E[X^2] + 2 * E[X] * E[U] + E[U^2]
# = Var[X] + (E[X])^2 + 2 * E[X] * E[U] + Var[U] + (E[U])^2
# 
# From the given, you'll have the following:
# E[X] = 2 ; Var[X] = 1
# E[U] = 1 / 2 ; Var[U] = 1 / 12
#
# => (1) + (2)^2 + 2 * (2) * (1 / 2) + (1 / 12) + (1 / 2)^2 = 22 / 3
#
# Thus the estimate should be close to 22 / 3 or 7.333333...

true_val = 22 / 3
n = 1e6L

base_r = function() {
    set.seed(123)
    x = rnorm(n, mean = 2, sd = 1)
    u = runif(n, min = 0, max = 1)
    
    mc_estimate = mean((x + u)^2)
    
    structure(
        list(
            method = "Base R", 
            mc_estimate = mc_estimate
        ), 
        class = "mc_sim"
    )
}

statModule = function() {
    set.seed(123)
    x = draw$normal(n, mean = 2, sd = 1)
    u = draw$uniform(n, min = 0, max = 1)
    
    mc_estimate = mean((x + u)^2)
    
    structure(
        list(
            method = "statModule", 
            mc_estimate = mc_estimate
        ), 
        class = "mc_sim"
    )
}

dqrng = function() {
    dqset.seed(123)
    x = dqrnorm(n, mean = 2, sd = 1)
    u = dqrunif(n, min = 0, max = 1)
    
    mc_estimate = mean((x + u)^2)
    
    structure(
        list(
            method = "dqrng", 
            mc_estimate = mc_estimate
        ), 
        class = "mc_sim"
    )
}

print.mc_sim = function(x, ...) {
    cat("\n\n")
    cat(glue::glue("{x$method} version"))
    cat("\n\n")
    cat("Monte Carlo estimate :", round(x$mc_estimate, 5), "\n")
    cat("Theoretical value    :", round(true_val, 5), "\n")
    cat("Absolute error       :", round(abs(x$mc_estimate - true_val), 5), "\n")
}

cat("\n\n")
cat("Output: ")
base_r()
statModule()
dqrng()
cat("\n\n")

cat("Benchmark: ")
bench::mark(
    `base R` = invisible(base_r()), 
    statModule = invisible(statModule()), 
    dqrng = invisible(dqrng()), 
    check = FALSE, 
    iterations = 3L
)
