# UNIdealPointsJulia

Julia replication of the Bayesian ideal point estimator from:

Bailey, Strezhnev, and Voeten (2017),
"Estimating Dynamic State Preferences from United Nations Voting Data".

## Online report

Project documentation and replication report:

<https://valeriafarinola.github.io/UNIdealPointsJulia/>

## Quick start

```julia
using UNIdealPointsJulia

UNIdealPointsJulia.run()
```

This prints the main replication scripts and the link to the online report.

## Goal

This project aims to:

1. replicate the original R/Rcpp estimator in Julia;
2. reproduce the estimated UN voting ideal points;
3. compute dyadic ideological distances;
4. reproduce the main figures from the paper.

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

## Main outputs

Main generated outputs:

- `output/ThetaEst_full_all.csv`
  - final Julia ideal point estimates for the All votes dataset;

- `output/dyadic_distances_full_all.csv`
  - pairwise ideological distances between countries within each UNGA session;

- `figures/p5_ideal_points_julia.png`
  - Julia replication of the P5 ideal points figure.

## Main scripts

- `scripts/run_mcmc_full_all.jl`
  - full MCMC estimation for the All votes dataset;

- `scripts/plot_p5.jl`
  - replication of the P5 ideal points figure;

- `scripts/compute_dyadic_distances.jl`
  - computation of dyadic ideological distances.

## Replication result

The Julia implementation successfully reproduces the main dynamics of the original R/Rcpp implementation from Bailey, Strezhnev, and Voeten (2017), including the temporal trajectories of the five permanent members of the UN Security Council.

## Repository structure

- `src/` → Julia source code
- `scripts/` → executable replication scripts
- `notes/` → replication log and implementation notes

## Original source

Original R/Rcpp implementation:
<https://github.com/evoeten/United-Nations-General-Assembly-Votes-and-Ideal-Points>