# UNIdealPointsJulia

Julia replication of the Bayesian ideal point estimator from:

Bailey, Strezhnev, and Voeten (2017),
"Estimating Dynamic State Preferences from United Nations Voting Data".

## Goal

This project aims to:

1. replicate the original R/Rcpp estimator in Julia;
2. reproduce the estimated UN voting ideal points;
3. compute dyadic ideological distances;
4. reproduce the main figures from the paper.

## Current status

Implemented so far:

- loading intermediate R output files;
- theta update step;
- lagged theta prior;
- normalization of theta draws;
- observation-level theta vector construction.

## Repository structure

- `src/` → Julia source code
- `scripts/` → executable replication scripts
- `notes/` → replication log and implementation notes

## Original source

Original R/Rcpp implementation:
https://github.com/evoeten/United-Nations-General-Assembly-Votes-and-Ideal-Points