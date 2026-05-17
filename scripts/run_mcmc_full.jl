include("../src/UNIdealPointsJulia.jl")
using .UNIdealPointsJulia

include("load_inputs.jl")

using Random
using Statistics
using LinearAlgebra
using DelimitedFiles

println("Starting MCMC smoke test")

Random.seed!(123)

Smooth = 0.5
sigmaMH = 0.1

BetaPrior = 0.0
S2BetaPrior = 1.0

Theta = zeros(length(IndN))

Burn = 4000
Thin = 50
K = 20000

SavedDraws = Int((K - Burn) / Thin)

ThetaStore = zeros(SavedDraws, length(Theta))

save_index = 0

for iter in 1:K

    global Theta
    global Gamma1
    global Gamma2
    global Z
    global BetaVector

    println("Iteration: ", iter)

    ThetaVector = populate_theta_vector(
        IObsMat,
        Theta,
        IndN,
        length(BetaVector)
    )

    LagThetaPrior = build_lag_prior(
        Theta,
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

    Theta =
        ThetaMean .+
        sqrt.(VarTheta) .* randn(length(ThetaMean))

    Theta = clamp.(Theta, -5, 5)

    Theta =
        (Theta .- mean(Theta)) ./ std(Theta)

    ThetaVector = populate_theta_vector(
        IObsMat,
        Theta,
        IndN,
        length(BetaVector)
    )

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

    Z = update_z(
        BetaVector,
        ThetaVector,
        gLo,
        gHi,
        length(yObs)
    )

    Beta, BetaVector, BetaMean, VarBeta =
        update_beta(
            ThetaVector,
            Z,
            VoteStartEnd,
            VoteN,
            BetaPrior,
            S2BetaPrior
        )

    println("Theta mean: ", mean(Theta))
    println("Beta mean: ", mean(Beta))
    println("Gamma acceptance: ", mean(AcceptTemp))
        if iter > Burn && ((iter - Burn) % Thin == 0)

        global save_index += 1

        ThetaStore[save_index, :] = Theta

        println("Saved draw: ", save_index)
    end
end
ThetaEst = vec(mean(ThetaStore, dims = 1))

println("Theta estimates computed")
println(length(ThetaEst))
println(ThetaEst[1:10])
mkpath("../output")

writedlm("../output/ThetaEst_full.csv", ThetaEst, ",")

println("Theta estimates saved to output/ThetaEst_full.csv")
println("Smoke test completed")