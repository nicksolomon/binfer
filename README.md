binfer
================

[![Travis-CI Build Status](https://travis-ci.org/nicksolomon/binfer.svg?branch=master)](https://travis-ci.org/nicksolomon/binfer) [![codecov](https://codecov.io/gh/nicksolomon/binfer/branch/master/graph/badge.svg)](https://codecov.io/gh/nicksolomon/binfer)

This package aims to make doing Bayesian things a little easier by giving a clear set of steps that you can easily use to simulate draws from a posterior distribution defined by a specific likelihood and prior.

The steps
---------

-   `define` a likelihood
-   Input: A data frame, a formula with the response variable and the name of a function that is your likelihood.
-   Output: A data frame with the name of the function given at input as an attribute
-   `assume` a prior distribution
-   Input: A data frame and a function of a single variable
-   Ouput: A data frame with the name of the function added as an attribute
-   `draw` from the posterior distribution
-   Input: A data frame, a control parameter
-   Output: A data frame of draws from the posterior distribution
-   `diagnose` the chain:
-   Input: a data frame of draws from the posterior
-   Output: The same data frame and a bunch of diagnostic plots
-   `clean` the chain
-   Input: Draws from the posterior
-   Output: Burned-in and subsampled draws from the posterior
-   Construct your confidence interval or p-value
-   Use `dplyr` for this

Examples
--------

Estimate the standard deviation of a normal distribution with a gamma prior:

``` r
library(binfer)
library(tidyverse)
#> ── Attaching packages ─────────────────────────────────────────────────────────────────────────────── tidyverse 1.2.1 ──
#> ✔ ggplot2 3.1.0     ✔ purrr   0.2.5
#> ✔ tibble  1.4.2     ✔ dplyr   0.7.8
#> ✔ tidyr   0.8.1     ✔ stringr 1.3.1
#> ✔ readr   1.1.1     ✔ forcats 0.3.0
#> ── Conflicts ────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()

posterior <- define(iris, Sepal.Width ~ dnorm(.data, mean = mean(iris$Sepal.Width), sd = .theta)) %>% 
  assume(prior = ~ dgamma(.theta, shape = 10, rate = 20)) %>% 
  draw(initial = .43, nbatch = 1e5, blen = 1, scale = .05) %>% 
  diagnose() %>% 
  clean(burnin = 0, subsample = 20) %>% 
  diagnose()
#> Acceptance rate: 0.497714977149771
#> Acceptance rate: 1
```

![](man/figures/README-example1-1.png)![](man/figures/README-example1-2.png)

``` r

posterior %>% summarise(mean = mean(chain),
                        sd = sd(chain),
                        lower = quantile(chain, .025),
                        upper = quantile(chain, .975))
#>        mean         sd     lower     upper
#> 1 0.4379123 0.02493545 0.3932932 0.4897541
```

Estimate the probability of success of a binomnial distribution with a beta prior and compare the analytical solution to the approximate one:

``` r
binom_test_data <- rbinom(50, prob = .1, size = 1) %>% 
  tibble(response = .)

posterior2 <- binom_test_data %>% 
  define(response ~ dbinom(.data, prob = .theta, size = 1)) %>% 
  assume(~ dbeta(.theta, 1, 2)) %>% 
  draw(initial = .5, nbatch = 1e5, blen = 1, scale = .15) %>% 
  diagnose() %>% 
  clean(burnin = 1000, subsample = 30) %>% 
  diagnose()
#> Acceptance rate: 0.229552295522955
#> Acceptance rate: 0.998484389208851
```

![](man/figures/README-example2-1.png)![](man/figures/README-example2-2.png)

``` r
posterior2 %>% 
  summarize(mean = mean(chain), 
            sd = sd(chain), 
            lower = quantile(chain, .025), 
            upper = quantile(chain, .975))
#> # A tibble: 1 x 4
#>     mean     sd  lower upper
#>    <dbl>  <dbl>  <dbl> <dbl>
#> 1 0.0568 0.0317 0.0124 0.134

ggplot(posterior2, aes(chain)) + 
  geom_density() +
  stat_function(fun = dbeta, 
                args = list(1 + sum(binom_test_data$response), 
                            2 + nrow(binom_test_data) - sum(binom_test_data$response)),
                color = "red")
```

![](man/figures/README-example2-3.png)

Notice here, there's a quirk in the implementation that throws warnings. This happens because the metropolis sampler can inadvertantly try to walk into areas where the likelihood is undefined for the given parameter value. When this happens, `binfer` will automatically replace these `NaN`s with `0`. From a Bayesian perspective, this is just fine. When the likelihood is zero, so is the posterior, so the sampler will never actually move into these areas. However, `R` still doesn't like it when we try to evaluate, for example, `dbinom(1, prob = 1.5, size = 1)` and will throw a warning. The way around this is to do something like

``` r
my_dbinom <- function(x, prob, size) {
  if (prob > 0 & prob < 1) {
    dbinom(x, prob, size)
  } else {
    0
  }
}
```

and use `my_dbinom()` as your likelihood. However, these warnings can be safely ignored.
