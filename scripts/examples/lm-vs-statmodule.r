#!/usr/bin/env rscript
box::use(
    stats[lm],
    statmodule / regression / ols[linear_reg],
    dplyr[slice_sample],
    bench,
)

cat("-------------------\n\n")
cat("        Usage      \n\n")
cat("-------------------\n\n")

mtcars_large = slice_sample(mtcars, by = am, n = 100000L, replace = TRUE)

cat("From base R: ", "\n\n")

lm(mpg ~ disp + hp + wt + drat, data = mtcars) |>
    summary()

cat("\n\n")
cat("From this module: ", "\n\n")

linear_reg(mtcars, mpg ~ disp + hp + wt + drat)

cat("-------------------\n\n")
cat("     Benchmark     \n\n")
cat("-------------------\n\n")

bench$mark(
    `base R` = lm(mpg ~ disp + hp + wt + drat, data = mtcars_large),
    statmodule = linear_reg(mtcars, mpg ~ disp + hp + wt + drat),
    check = FALSE,
    iterations = 3L
)
