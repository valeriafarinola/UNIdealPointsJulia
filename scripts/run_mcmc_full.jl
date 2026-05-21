# Wrapper script for the full MCMC replication on the Important-votes dataset.
#
# This script calls the main replication API:
#
#     run_replication(dataset = :important, test = false)
#
# The full estimation logic is implemented in:
#
#     src/replication.jl

using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using UNIdealPointsJulia

UNIdealPointsJulia.run_replication(
    dataset = :important,
    test = false
)