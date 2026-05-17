include("../src/UNIdealPointsJulia.jl")
using .UNIdealPointsJulia

include("load_inputs.jl")

using Random
using Statistics

println("Loaded R output data")

Smooth = 0.5
Random.seed!(123)

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

LagThetaPrior = build_lag_prior(
    ThetaMean0,
    CountryList,
    SessionList,
    GapYear
)

ThetaMean, VarTheta = compute_theta_mean_var(
    IObsMat,
    IndN,
    BetaVector,
    Z,
    LagThetaPrior,
    SmoothVector,
    Smooth
)

Theta = ThetaMean .+ sqrt.(VarTheta) .* randn(length(ThetaMean))
Theta = clamp.(Theta, -5, 5)
Theta = (Theta .- mean(Theta)) ./ std(Theta)

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
Gamma1Vector = UNIdealPointsJulia.r_rep(Gamma1, VoteN)
Gamma2Vector = UNIdealPointsJulia.r_rep(Gamma2, VoteN)

gLo =
    -99 .* (yObs .== 1) .+
    Gamma1Vector .* (yObs .== 2) .+
    Gamma2Vector .* (yObs .== 3)

gHi =
    Gamma1Vector .* (yObs .== 1) .+
    Gamma2Vector .* (yObs .== 2) .+
    99 .* (yObs .== 3)
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