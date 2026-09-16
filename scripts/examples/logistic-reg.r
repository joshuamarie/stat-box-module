#!/usr/bin/env rscript
box::use(
    statmodule / regression / GLM
)

cat("\n\n")

cat("--------------------\n\n")
cat("   Using Matrices \n\n")
cat("--------------------\n\n")

with(
    mtcars,
    GLM$glm(
        cbind(wt, disp),
        am,
        family = gaussian()
    )
)


cat("-------------------\n\n")
cat("   Using Formula \n\n")
cat("-------------------\n\n")

GLM$glm(am ~ wt + disp, data = mtcars, family = gaussian())
