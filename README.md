
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fastnum: Collection of fast numerical computation tools in R

<!-- badges: start -->

<!-- badges: end -->

`{fastnum}` is a collection of tools and functions for numerical
computation and scientific computing using C++ at its core. This
includes probability distributions, generation of random numbers, and
tools for functional programming. This is still an R package, not
CRAN-style, rather a module that must be accessed through `{box}` R
package.

## Installation

You need to install `carrier` first. See the [installation
guide](https://joshuamarie.com/carrier/installation.html) for the
details.

The package has no pre-built binaries yet, so the installation of
`fastnum` has to be built from scratch.

``` bash
carrier install gh:joshuamarie/fastnum-module --install-deps
```

## Usage

You can’t use `fastnum` by loading it through `library()` or `::`, you
need `{box}` R package. Currently, the current version of `{box}` cannot
import `fastnum` being managed by `carrier`, you have to install the
patched forked version of `{box}` (see
[details](https://joshuamarie.com/carrier/installation.html#the-box-fork)).

``` r
box::use(fastnum)
```

### Standard Math Module

`fastnum` has collection of mathematical functions, some were imported
from the base R itself.

``` r
fastnum$square(5)
#> [1] 25
```

### Random Number Generation

`fastnum`’s submodule `random` contains the function to generate random
numbers. By default, it depends on Boost’s probability distribution
library and `{dqrng}`’s fast pseudo random number generator.

``` r
set.seed(123)
fastnum$random$draw$normal(10L)
#>  [1] -0.84261734  0.11714644 -0.02699628 -0.77240142 -1.42960313 -0.91115376
#>  [7]  0.20852974 -1.02841980  0.31423014 -0.36288550
```
