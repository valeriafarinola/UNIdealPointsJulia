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