# This script runs the full Bayesian MCMC estimation procedure for the
# All-votes dataset.
#
# The sampler iteratively updates:
#
#   1. theta ideal points
#   2. gamma threshold parameters
#   3. latent Z utilities
#   4. beta discrimination parameters
#
# The script stores posterior draws after burn-in and thinning, and computes
# posterior mean ideal point estimates at the end of the run.

include("../src/UNIdealPointsJulia.jl")
using .UNIdealPointsJulia

# Load processed replication inputs from data/.
include("load_inputs_all.jl")

using Random
using Statistics
using LinearAlgebra
using DelimitedFiles

println("Starting full MCMC run for All votes")

# Fix the random seed for reproducibility.
Random.seed!(123)

# Dynamic prior smoothing parameter.
Smooth = 0.5

# Metropolis-Hastings proposal scale for gamma updates.
sigmaMH = 0.1

# Gaussian prior for beta discrimination parameters.
BetaPrior = 0.0
S2BetaPrior = 1.0

# Initial theta values.
Theta = zeros(length(IndN))

# MCMC settings.
Burn = 4000
Thin = 50
K = 20000

# Number of posterior draws stored after burn-in and thinning.
SavedDraws = Int((K - Burn) / Thin)

# Matrix storing posterior theta draws.
ThetaStore = zeros(SavedDraws, length(Theta))

save_index = 0

# Main MCMC loop.
for iter in 1:K

    global Theta
    global Gamma1
    global Gamma2
    global Z
    global BetaVector

    println("Iteration: ", iter)

    # Expand country-session theta values to the observation level.
    ThetaVector = populate_theta_vector(
        IObsMat,
        Theta,
        IndN,
        length(BetaVector)
    )

    # Build the dynamic lagged prior for theta.
    LagThetaPrior = build_lag_prior(
        Theta,
        CountryList,
        SessionList,
        GapYear
    )

    # Compute posterior theta moments conditional on current parameters.
    ThetaMean, VarTheta = compute_theta_mean_var(
        IObsMat,
        IndN,
        BetaVector,
        Z,
        LagThetaPrior,
        SmoothVector,
        Smooth
    )

    # Draw theta from the conditional Gaussian posterior.
    Theta =
        ThetaMean .+
        sqrt.(VarTheta) .* randn(length(ThetaMean))

    # Apply normalization and truncation used in the original replication.
    Theta = clamp.(Theta, -5, 5)

    Theta =
        (Theta .- mean(Theta)) ./ std(Theta)

    # Rebuild observation-level theta vector after the update.
    ThetaVector = populate_theta_vector(
        IObsMat,
        Theta,
        IndN,
        length(BetaVector)
    )

    # Expand vote-level threshold parameters to observation-level vectors.
    Gamma1Vector = UNIdealPointsJulia.r_rep(Gamma1, VoteN)
    Gamma2Vector = UNIdealPointsJulia.r_rep(Gamma2, VoteN)

    # Construct lower and upper truncation bounds for latent utilities.
    gLo =
        -99 .* (yObs .== 1) .+
        Gamma1Vector .* (yObs .== 2) .+
        Gamma2Vector .* (yObs .== 3)

    gHi =
        Gamma1Vector .* (yObs .== 1) .+
        Gamma2Vector .* (yObs .== 2) .+
        99 .* (yObs .== 3)

    # Metropolis-Hastings update for gamma threshold parameters.
    Gamma1, Gamma2, gLo, gHi, AcceptTemp =
        update_gamma(
            Gamma1,
            Gamma2,
            BetaVector,
            ThetaVector,
            yObs,
            VoteN,
            VoteStartEnd,
            gLo,
            gHi,
            sigmaMH
        )

    # Update latent continuous utilities Z.
    Z = update_z(
        BetaVector,
        ThetaVector,
        gLo,
        gHi,
        length(yObs)
    )

    # Update beta discrimination parameters.
    Beta, BetaVector, BetaMean, VarBeta =
        update_beta(
            ThetaVector,
            Z,
            VoteStartEnd,
            VoteN,
            BetaPrior,
            S2BetaPrior
        )

    # Diagnostic output for monitoring chain behavior.
    println("Theta mean: ", mean(Theta))
    println("Beta mean: ", mean(Beta))
    println("Gamma acceptance: ", mean(AcceptTemp))

    # Store posterior draws after burn-in and according to thinning interval.
    if iter > Burn && ((iter - Burn) % Thin == 0)

        global save_index += 1

        ThetaStore[save_index, :] = Theta

        println("Saved draw: ", save_index)
    end
end

# Posterior mean ideal point estimates.
ThetaEst = vec(mean(ThetaStore, dims = 1))

println("Theta estimates computed")
println(length(ThetaEst))
println(ThetaEst[1:10])

# Save final posterior mean estimates.
OUTPUT_PATH = joinpath(@__DIR__, "..", "output")
mkpath(OUTPUT_PATH)

output_file = joinpath(
    OUTPUT_PATH,
    "ThetaEst_full_all.csv"
)

writedlm(output_file, ThetaEst, ",")

println("Theta estimates saved to:")
println(output_file)

println("Smoke test completed")