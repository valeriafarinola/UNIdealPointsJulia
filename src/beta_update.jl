using Distributions
using Random

function update_z(
    BetaVector,
    ThetaVector,
    gLo,
    gHi,
    ObsN
)

    U = rand(ObsN)

    mu = BetaVector .* ThetaVector

    Z =
        mu .+
        quantile.(
            Normal(),
            cdf.(Normal(), gLo .- mu) .+
            U .* (cdf.(Normal(), gHi .- mu) .- cdf.(Normal(), gLo .- mu))
        )

    Z = clamp.(Z, -9, 9)

    return Z
end

function update_beta(
    ThetaVector,
    Z,
    VoteStartEnd,
    VoteN,
    BetaPrior,
    S2BetaPrior
)

    TT = length(VoteN)

    VarBeta = zeros(Float64, TT)
    BetaMean = zeros(Float64, TT)

    for tt in 1:TT
        lo = VoteStartEnd[tt, 1]
        hi = VoteStartEnd[tt, 2]

        theta_slice = ThetaVector[lo:hi]
        z_slice = Z[lo:hi]

        VarBeta[tt] = 1 / (sum(theta_slice .^ 2) + 1 / S2BetaPrior)

        BetaMean[tt] =
            VarBeta[tt] *
            (sum(theta_slice .* z_slice) + BetaPrior / S2BetaPrior)
    end

    Beta = BetaMean .+ sqrt.(VarBeta) .* randn(TT)

    BetaVector = UNIdealPointsJulia.r_rep(Beta, VoteN)

    return Beta, BetaVector, BetaMean, VarBeta
end