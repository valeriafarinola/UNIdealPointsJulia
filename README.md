# UNIdealPointsJulia

Julia replication of the Bayesian ideal point estimator from:

Bailey, Strezhnev, and Voeten (2017),  
"Estimating Dynamic State Preferences from United Nations Voting Data".

## Online report

Project documentation and replication report:

<https://valeriafarinola.github.io/UNIdealPointsJulia/>

---

## Quick start

Activate the project environment and install dependencies:

```julia
using Pkg

Pkg.activate(".")
Pkg.instantiate()
```

Load the package:

```julia
using UNIdealPointsJulia
```

Display the package entry point and replication instructions:

```julia
UNIdealPointsJulia.run()
```

---

## Main replication interface

The replication package is organized around the function:

```julia
UNIdealPointsJulia.run_replication(; dataset, test)
```

### Arguments

#### Dataset selection

```julia
dataset = :all
```

Uses the All-votes dataset.

```julia
dataset = :important
```

Uses the Important-votes dataset.

#### Execution mode

```julia
test = true
```

Runs a lightweight smoke test with a reduced number of MCMC iterations.

```julia
test = false
```

Runs the full Bayesian MCMC replication.

---

## Replication examples

### Smoke test on the All-votes dataset

```julia
using UNIdealPointsJulia

UNIdealPointsJulia.run_replication(
    dataset = :all,
    test = true
)
```

### Smoke test on the Important-votes dataset

```julia
using UNIdealPointsJulia

UNIdealPointsJulia.run_replication(
    dataset = :important,
    test = true
)
```

### Full replication on the Important-votes dataset

```julia
using UNIdealPointsJulia

UNIdealPointsJulia.run_replication(
    dataset = :important,
    test = false
)
```

### Full replication on the All-votes dataset

```julia
using UNIdealPointsJulia

UNIdealPointsJulia.run_replication(
    dataset = :all,
    test = false
)
```

---

## Goal

This project aims to:

1. replicate the original R/Rcpp estimator in Julia;
2. reproduce the estimated UN voting ideal points;
3. compute dyadic ideological distances;
4. reproduce the main figures from the paper.

---

## Current status

Implemented and replicated:

- full Bayesian MCMC estimator in Julia;
- theta update step;
- gamma threshold update step;
- latent Z update step;
- beta update step;
- lagged theta prior construction;
- theta normalization;
- full MCMC loop with burn-in and thinning;
- replication of ideal point estimates for:
  - Important votes dataset;
  - All votes dataset;
- replication of the P5 ideal points figure from the original paper;
- computation of dyadic ideological distances between countries.

---

## Main outputs

Main generated outputs:

- `output/ThetaEst_full_all.csv`
  - final Julia ideal point estimates for the All-votes dataset;

- `output/ThetaEst_full.csv`
  - final Julia ideal point estimates for the Important-votes dataset;

- `output/dyadic_distances_full_all.csv`
  - pairwise ideological distances between countries within each UNGA session;

- `figures/p5_ideal_points_julia.png`
  - Julia replication of the P5 ideal points figure.

---

## Wrapper scripts

The `scripts/` directory contains lightweight wrapper scripts calling the
main replication API implemented in:

```text
src/replication.jl
```

Available wrappers:

- `scripts/run_mcmc_smoke_test.jl`
- `scripts/run_mcmc_full.jl`
- `scripts/run_mcmc_full_all.jl`

Additional post-processing scripts:

- `scripts/plot_p5.jl`
- `scripts/plot_p5_important.jl`
- `scripts/compute_dyadic_distances.jl`

---

## Repository structure

- `src/`
  - core Julia source code and replication logic;

- `scripts/`
  - lightweight executable wrapper scripts;

- `output/`
  - generated MCMC estimates and replication outputs;

- `figures/`
  - replicated figures from the paper;

- `notes/`
  - replication logs and implementation notes.

---

## Repository portability

All scripts use repository-relative paths based on `@__DIR__`, so the
repository can be executed without machine-specific file paths.

---

## Reproducibility

To run package tests:

```julia
Pkg.test()
```

### Smoke test

A lightweight MCMC smoke test is provided through:

```julia
UNIdealPointsJulia.run_replication(
    dataset = :all,
    test = true
)
```

or equivalently:

```text
scripts/run_mcmc_smoke_test.jl
```

The smoke test runs the full Bayesian sampling pipeline with a substantially
smaller number of iterations than the full replication runs.

Its purpose is to verify that:

- the sampler executes successfully;
- all update steps are functioning correctly;
- the repository environment and dependencies are configured properly.

The smoke test is intended for diagnostic and reproducibility verification
purposes only.

Final replication results are produced by:

```julia
UNIdealPointsJulia.run_replication(
    dataset = :important,
    test = false
)

UNIdealPointsJulia.run_replication(
    dataset = :all,
    test = false
)
```

---

## Replication result

The Julia implementation successfully reproduces the main dynamics of the
original R/Rcpp implementation from Bailey, Strezhnev, and Voeten (2017),
including the temporal trajectories of the five permanent members of the
UN Security Council.

---

## Original source

Original R/Rcpp implementation:

<https://github.com/evoeten/United-Nations-General-Assembly-Votes-and-Ideal-Points>