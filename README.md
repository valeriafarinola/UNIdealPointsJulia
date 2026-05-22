# UNIdealPointsJulia

Julia replication of the Bayesian ideal point estimator from:

Bailey, Strezhnev, and Voeten (2017),  
*Estimating Dynamic State Preferences from United Nations Voting Data*.

## Online report

Project documentation and replication report:

<https://valeriafarinola.github.io/UNIdealPointsJulia/>

---

# Installation

From the repository root, start Julia with:

```bash
julia --project=.
```

Then instantiate the project environment:

```julia
using Pkg
Pkg.instantiate()
```

Load the package:

```julia
using UNIdealPointsJulia
```

Print the package entry point and available replication commands:

```julia
UNIdealPointsJulia.run()
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
UNIdealPointsJulia.run_replication(
    dataset = :all,
    test = true
)
```

## Full replication — Important votes

```julia
UNIdealPointsJulia.run_replication(
    dataset = :important,
    test = false
)
```

## Full replication — All votes

```julia
UNIdealPointsJulia.run_replication(
    dataset = :all,
    test = false
)
```

---

# Generate figures

After running the corresponding full replication, figures can be generated from the repository root.

Important-votes figure:

```bash
julia --project=. scripts/plot_p5_important.jl
```

All-votes figure:

```bash
julia --project=. scripts/plot_p5.jl
```

The plotting scripts require the corresponding full MCMC output files:

```text
output/ThetaEst_full.csv
output/ThetaEst_full_all.csv
```

---

# Wrapper scripts

The same MCMC runs can also be executed through wrapper scripts:

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

```text
output/ThetaEst_full.csv
output/ThetaEst_full_all.csv
output/dyadic_distances_full_all.csv
figures/p5_ideal_points_julia.png
figures/p5_ideal_points_julia_important.png
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