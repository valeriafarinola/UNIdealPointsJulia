# Lightweight MCMC smoke-test wrapper.
#
# The full replication logic is implemented in:
#
#   src/replication.jl
#
# This script runs the master replication function in test mode.

using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using UNIdealPointsJulia

UNIdealPointsJulia.run_replication(
    dataset = :all,
    test = true
)
