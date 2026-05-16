using LinearAlgebra

function compute_theta_mean_var(
    IObsMat,
    IndN,
    BetaVector,
    Z,
    LagThetaPrior,
    SmoothVector,
    Smooth
)

    NN = length(IndN)

    ThetaMean = zeros(Float64, NN)
    VarTheta = zeros(Float64, NN)

    for ii in 1:NN
        indexValue = Int.(IObsMat[ii, 1:Int(IndN[ii])])

        BstarPrior = vcat(
            BetaVector[indexValue],
            1 / (SmoothVector[ii] * Smooth)
        )

        Bstar = vcat(
            BetaVector[indexValue],
            1.0
        )

        Zstar = vcat(
            Z[indexValue],
            LagThetaPrior[ii]
        )

        VarTheta[ii] = 1 / dot(BstarPrior, Bstar)
        ThetaMean[ii] = VarTheta[ii] * dot(BstarPrior, Zstar)
    end

    return ThetaMean, VarTheta
end