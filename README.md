# UNIdealPointsJulia

Julia replication of the Bayesian ideal point estimator from:

Bailey, Strezhnev, and Voeten (2017),  
*Estimating Dynamic State Preferences from United Nations Voting Data*.

## Online report

Project documentation and replication report:

<https://valeriafarinola.github.io/UNIdealPointsJulia/>

---

# Installation

Clone the repository and activate the Julia environment:

```julia
using Pkg

Pkg.activate(".")
Pkg.instantiate()
```

Load the package:

```julia
using UNIdealPointsJulia
```

---

# Main replication interface

The project is organized around:

```julia
UNIdealPointsJulia.run_replication(; dataset, test)
```

Arguments:

- `dataset = :all`
  - All-votes dataset;

- `dataset = :important`
  - Important-votes dataset;

- `test = true`
  - lightweight smoke test;

- `test = false`
  - full MCMC replication.

---

# Main commands

## Smoke test

```julia
using UNIdealPointsJulia

UNIdealPointsJulia.run_replication(
    dataset = :all,
    test = true
)
```

## Full replication — Important votes

```julia
using UNIdealPointsJulia

UNIdealPointsJulia.run_replication(
    dataset = :important,
    test = false
)
```

## Full replication — All votes

```julia
using UNIdealPointsJulia

UNIdealPointsJulia.run_replication(
    dataset = :all,
    test = false
)
```

---

# Wrapper scripts

The same runs can also be executed through the wrapper scripts:

```text
scripts/run_mcmc_smoke_test.jl
scripts/run_mcmc_full.jl
scripts/run_mcmc_full_all.jl
```

Example:

```bash
julia --project=. scripts/run_mcmc_full_all.jl
```

---

# Repository structure

```text
UNIdealPointsJulia/
│
├── src/
├── scripts/
├── data/
├── output/
├── figures/
├── notes/
├── report.qmd
├── README.md
└── Project.toml
```

---

# Main outputs

Main generated outputs:

```text
output/ThetaEst_full.csv
output/ThetaEst_full_all.csv
output/dyadic_distances_full_all.csv
figures/p5_ideal_points_julia.png
```

---

# Package tests

Run package tests with:

```julia
using Pkg
Pkg.test()
```

---

# Original source

Original R/Rcpp implementation:

<https://github.com/evoeten/United-Nations-General-Assembly-Votes-and-Ideal-Points>