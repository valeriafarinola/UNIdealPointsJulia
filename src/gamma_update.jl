using Distributions

function r_rep(values, counts)
    out = Float64[]

    for i in eachindex(values)
        append!(out, fill(values[i], counts[i]))
    end

    return out
end
function update_gamma(
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

    TT = length(Gamma1)

    U1 = rand(TT)
    U = rand(TT)

    CANDGamma1 = Gamma1 .+ sigmaMH .* quantile.(
        Normal(),
        U1 .* cdf.(Normal(), (Gamma2 .- Gamma1) ./ sigmaMH) .+
        cdf.(Normal(), (-7 .- Gamma1) ./ sigmaMH) .* (1 .- U1)
    )

    CANDGamma2 = Gamma2 .+ sigmaMH .* quantile.(
        Normal(),
        U .* cdf.(Normal(), (7 .- Gamma2) ./ sigmaMH) .+
        cdf.(Normal(), (CANDGamma1 .- Gamma2) ./ sigmaMH) .* (1 .- U)
    )

    CANDGamma1Vector = r_rep(CANDGamma1, VoteN)
    CANDGamma2Vector = r_rep(CANDGamma2, VoteN)

    CANDgLo =
        -99 .* (yObs .== 1) .+
        CANDGamma1Vector .* (yObs .== 2) .+
        CANDGamma2Vector .* (yObs .== 3)

    CANDgHi =
        CANDGamma1Vector .* (yObs .== 1) .+
        CANDGamma2Vector .* (yObs .== 2) .+
        99 .* (yObs .== 3)

    num = cdf.(Normal(), CANDgHi .- BetaVector .* ThetaVector) .-
          cdf.(Normal(), CANDgLo .- BetaVector .* ThetaVector)

    den = cdf.(Normal(), gHi .- BetaVector .* ThetaVector) .-
          cdf.(Normal(), gLo .- BetaVector .* ThetaVector)

    LikelihoodVector = num ./ den
    LikelihoodVector[isnan.(LikelihoodVector)] .= 1.0

    R = ones(Float64, TT)

    for tt in 1:TT
        lo = VoteStartEnd[tt, 1]
        hi = VoteStartEnd[tt, 2]

        R[tt] =
            prod(LikelihoodVector[lo:hi]) *
            (1 - cdf(Normal(), (CANDGamma1[tt] - Gamma2[tt]) / sigmaMH)) /
            (1 - cdf(Normal(), (Gamma1[tt] - CANDGamma2[tt]) / sigmaMH))

        if isnan(R[tt])
            R[tt] = 1.0
        end
    end

    AcceptTemp = rand(TT) .< R

    Gamma1_new = AcceptTemp .* CANDGamma1 .+ (1 .- AcceptTemp) .* Gamma1
    Gamma2_new = AcceptTemp .* CANDGamma2 .+ (1 .- AcceptTemp) .* Gamma2

    Gamma1Vector = r_rep(Gamma1_new, VoteN)
    Gamma2Vector = r_rep(Gamma2_new, VoteN)

    gLo_new =
        -99 .* (yObs .== 1) .+
        Gamma1Vector .* (yObs .== 2) .+
        Gamma2Vector .* (yObs .== 3)

    gHi_new =
        Gamma1Vector .* (yObs .== 1) .+
        Gamma2Vector .* (yObs .== 2) .+
        99 .* (yObs .== 3)

    return Gamma1_new, Gamma2_new, gLo_new, gHi_new, AcceptTemp
end