# `binfer`

## The steps

1. Specify a likelihood
  - Input: A data frame, a column name (bare), a vectorized function of a single variable
  - Output: A data frame with the name of the function given at input as an attribute
2. Assume a prior distribution
  - Input: A data frame and a function of a single variable
  - Ouput: A data frame with the name of the function added as an attribute
3. Simulate the posterior distribution
  - Input: A data frame, a control parameter
  - Output: A data frame of draws from the posterior distribution
4. Diagnose the chain:
  - Input: a data frame of draws from the posterior
  - Output: The same data frame and a bunch of diagnostic plots
5. Trim and sample the chain
  - Input: Draws from the posterior
  - Output: Burned-in and subsampled draws from the posterior
6. Construct your confidence interval or p-value
  - Use `dplyr` for this
