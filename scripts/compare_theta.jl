include("../src/UNIdealPointsJulia.jl")

using Statistics
using DelimitedFiles

println("Loading Julia theta estimates")

ThetaJulia =
    vec(readdlm("../output/ThetaEst_smoke_test.csv", ','))

println(length(ThetaJulia))

println("Loading R theta estimates")

R_OUTPUT_PATH =
raw"C:\Users\HP 14-DW1012NL\Desktop\COMPUTATIONAL\United-Nations-General-Assembly-Votes-and-Ideal-Points-master\United-Nations-General-Assembly-Votes-and-Ideal-Points-master\Output"

ThetaR =
    vec(readdlm(joinpath(R_OUTPUT_PATH,
    "ThetaSaveRW_Important_Apr2020.txt")))

println(length(ThetaR))

corr_value = cor(ThetaJulia, ThetaR)

println("Correlation Julia vs R:")
println(corr_value)

println("First 10 Julia estimates:")
println(ThetaJulia[1:10])

println("First 10 R estimates:")
println(ThetaR[1:10])