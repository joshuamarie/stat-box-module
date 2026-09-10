#!/usr/bin/env rscript
box::use(
    statmodule / regression / ols
)

cat("\n\n")


cat("-------------------\n\n")
cat("   Using Formula \n\n")
cat("-------------------\n\n")

ols$linear_reg(mtcars, mpg ~ wt + disp, vif = TRUE)

cat("--------------------\n\n")
cat("   Using Matrices \n\n")
cat("--------------------\n\n")

with(
    mtcars,
    ols$linear_reg(
        cbind(wt, disp),
        mpg,
        vif = TRUE
    )
)
