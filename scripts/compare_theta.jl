# This script compares the Julia-estimated ideal points against the
# original R/Rcpp replication output for the Important-votes dataset.
#
# The goal is to evaluate whether the Julia implementation reproduces
# the same latent ideal point structure as the original estimator.
#
# The script computes:
#   - the correlation between Julia and R estimates;
#   - basic diagnostic output;
#   - a comparison of the first estimated values.



include("../src/UNIdealPointsJulia.jl")

using Statistics
using DelimitedFiles

const DATA_PATH = joinpath(@__DIR__, "..", "data")
const OUTPUT_PATH = joinpath(@__DIR__, "..", "output")

println("Loading Julia theta estimates")

theta_julia_path = joinpath(
    OUTPUT_PATH,
    "ThetaEst_full.csv"
)

ThetaJulia = vec(readdlm(theta_julia_path, ','))

println(length(ThetaJulia))

println("Loading R theta estimates")

theta_r_path = joinpath(
    DATA_PATH,
    "ThetaSaveRW_Important_Apr2020.txt"
)

ThetaR = vec(readdlm(theta_r_path))

println(length(ThetaR))

# Compute correlation between the Julia and R estimates.

corr_value = cor(ThetaJulia, ThetaR)

println("Correlation Julia vs R:")
println(corr_value)

println("First 10 Julia estimates:")
println(ThetaJulia[1:10])

println("First 10 R estimates:")
println(ThetaR[1:10])