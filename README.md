# `binfer`

This package aims to make doing Bayesian things a little easier by giving a clear set of steps that you can easily use to simulate draws from a posterior distribution defined by a specific likelihood and prior.

## The steps

1. `define` a likelihood
  - Input: A data frame, a formula with the response variable and the name of a function that is your likelihood.
  - Output: A data frame with the name of the function given at input as an attribute
2. `assume` a prior distribution
  - Input: A data frame and a function of a single variable
  - Ouput: A data frame with the name of the function added as an attribute
3. `simulate` the posterior distribution
  - Input: A data frame, a control parameter
  - Output: A data frame of draws from the posterior distribution
4. `diagnose` the chain:
  - Input: a data frame of draws from the posterior
  - Output: The same data frame and a bunch of diagnostic plots
5. `clean` the chain
  - Input: Draws from the posterior
  - Output: Burned-in and subsampled draws from the posterior
6. Construct your confidence interval or p-value
  - Use `dplyr` for this
