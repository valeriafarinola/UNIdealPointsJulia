# This script reproduces one full sequence of sampler updates on the
# Important-votes dataset:
#
#   1. theta update
#   2. gamma threshold update
#   3. latent Z update
#   4. beta update
#
# It is mainly a diagnostic script. It checks that each translated Julia
# update step can be run successfully before combining them in the full MCMC loop.

include("../src/UNIdealPointsJulia.jl")
using .UNIdealPointsJulia

# Load processed Important-votes inputs from data/.
include("load_inputs.jl")

using Random
using Statistics

println("Loaded processed replication inputs")

Smooth = 0.5

# Fix the random seed so that this diagnostic run is reproducible.
Random.seed!(123)

# First-pass theta prior.
# Start with a zero lag prior to obtain initial theta means.
LagThetaPrior0 = zeros(length(IndN))

ThetaMean0, VarTheta0 = compute_theta_mean_var(
    IObsMat,
    IndN,
    BetaVector,
    Z,
    LagThetaPrior0,
    SmoothVector,
    Smooth
)

# Build the dynamic lagged prior using the first-pass theta means.
LagThetaPrior = build_lag_prior(
    ThetaMean0,
    CountryList,
    SessionList,
    GapYear
)

# Recompute theta posterior mean and variance using the dynamic prior.
ThetaMean, VarTheta = compute_theta_mean_var(
    IObsMat,
    IndN,
    BetaVector,
    Z,
    LagThetaPrior,
    SmoothVector,
    Smooth
)

# Draw theta from its Gaussian posterior approximation.
Theta = ThetaMean .+ sqrt.(VarTheta) .* randn(length(ThetaMean))

# Match the normalization used in the original estimation routine.
Theta = clamp.(Theta, -5, 5)
Theta = (Theta .- mean(Theta)) ./ std(Theta)

# Expand country-session theta values to the observation level.
ThetaVector = populate_theta_vector(
    IObsMat,
    Theta,
    IndN,
    length(BetaVector)
)

println("Theta update completed")
println("Length Theta: ", length(Theta))
println("Mean Theta: ", mean(Theta))
println("Std Theta: ", std(Theta))
println("First 10 theta values:")
println(Theta[1:10])
println("First 10 theta-vector values:")
println(ThetaVector[1:10])

# Expand vote-level thresholds to observation-level vectors.
Gamma1Vector = UNIdealPointsJulia.r_rep(Gamma1, VoteN)
Gamma2Vector = UNIdealPointsJulia.r_rep(Gamma2, VoteN)

# Construct lower and upper threshold bounds for each observed vote.
gLo =
    -99 .* (yObs .== 1) .+
    Gamma1Vector .* (yObs .== 2) .+
    Gamma2Vector .* (yObs .== 3)

gHi =
    Gamma1Vector .* (yObs .== 1) .+
    Gamma2Vector .* (yObs .== 2) .+
    99 .* (yObs .== 3)

# Metropolis-Hastings proposal scale for gamma threshold updates.
sigmaMH = 0.1

Gamma1_new, Gamma2_new, gLo_new, gHi_new, AcceptTemp =
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

println("Gamma update completed")
println("Length Gamma1: ", length(Gamma1_new))
println("Accepted gamma proposals: ", sum(AcceptTemp))

# Update latent continuous voting utilities Z conditional on thresholds.
ObsN = length(yObs)

Z_new = update_z(
    BetaVector,
    ThetaVector,
    gLo_new,
    gHi_new,
    ObsN
)

println("Z update completed")
println(length(Z_new))
println(Z_new[1:10])

# Gaussian prior for beta discrimination parameters.
BetaPrior = 0.0
S2BetaPrior = 1.0

Beta_new, BetaVector_new, BetaMean_new, VarBeta_new =
    update_beta(
        ThetaVector,
        Z_new,
        VoteStartEnd,
        VoteN,
        BetaPrior,
        S2BetaPrior
    )

println("Beta update completed")
println(length(Beta_new))
println(Beta_new[1:10])