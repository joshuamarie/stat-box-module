
<!-- README.md is generated from README.Rmd. Please edit that file -->

# statmodule: Collection of statistical methods in R

<!-- badges: start -->

<!-- badges: end -->

`{statmodule}` is a collection of tools and functions for numerical
computation, scientific computing, and statisticial methods in R using
C++ at its core. This includes probability distributions, generation of
random numbers, and tools for functional programming. This is still an R
package, not CRAN-style, rather a module that must be accessed through
`{box}` R package.

## Installation

You need to install `{baler}` first. See the [installation
guide](https://baler-dev.github.io/baler/installation.html) for the
details.

The package has no pre-built binaries yet, so the installation of
`{statmodule}` has to be built from scratch.

``` bash
baler install --git https://github.com/joshuamarie/stat-box-module --install-deps
```

## Usage

You can’t use `{statmodule}` by attaching it through `library()` or
`::`, you need `{box}` R package. Currently, the current version of
`{box}` cannot import `{statmodule}` being managed by `{baler}`, you
have to install the patched forked version of `{box}` (see
[details](https://baler-dev.github.io/baler/installation.html#the-box-fork)).

``` r
box::use(sm = statmodule)
```

<!-- ### Standard Math Module -->

<!-- `{statmodule}` has collection of mathematical functions, some were imported from the base R itself.  -->

<!-- ```{r} -->

<!-- sm$square(5) -->

<!-- ``` -->

### Regression models

The standard linear regression (through `ols`) and generalized linear
model (GLM) are available under `regression` submodule. They depend on
`{RcppEigen}` package, which itself depends on `{Eigen}` C++ library.
Here’s the following example:

``` r
sm$regression$ols$linear_reg(mpg ~ disp + hp + wt + drat, data = mtcars, vif = TRUE)
```

     Custom Linear Regression output: 

    ────────────────────────────────────────────────────────────────────
      terms  coefficients  std_err  t_statistic  pval  vif   tolerance  
    ────────────────────────────────────────────────────────────────────
      beta0     29.15       6.29       4.63      0.00                   
      disp       0.00       0.01       0.35      0.73  8.21    0.12     
       hp       -0.03       0.01       -3.00     0.01  2.89    0.34     
       wt       -3.48       1.08       -3.23     0.00  5.10    0.20     
      drat       1.77       1.32       1.34      0.19  2.28    0.44     
    ────────────────────────────────────────────────────────────────────

### Random Number Generation

`{statmodule}`’s submodule `random` contains the function to generate
random numbers. By default, it depends on Boost’s probability
distribution library and `{dqrng}`’s fast pseudo random number
generator.

``` r
set.seed(123)
sm$random$draw$normal(10L)
#>  [1] -0.84261734  0.11714644 -0.02699628 -0.77240142 -1.42960313 -0.91115376
#>  [7]  0.20852974 -1.02841980  0.31423014 -0.36288550
```
