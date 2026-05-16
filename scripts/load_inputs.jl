using DelimitedFiles

const R_OUTPUT_PATH = raw"C:\Users\HP 14-DW1012NL\Desktop\COMPUTATIONAL\United-Nations-General-Assembly-Votes-and-Ideal-Points-master\United-Nations-General-Assembly-Votes-and-Ideal-Points-master\Output"

function load_r_output(filename)
    return readdlm(joinpath(R_OUTPUT_PATH, filename))
end

IObsMat = load_r_output("IObsMat_Important_Apr2020.txt")

IndN = vec(load_r_output("IndN_Important_Apr2020.txt"))
IndN = Int.(IndN)

BetaVector = vec(load_r_output("BetaVectorSaveRW_Important_Apr2020.txt"))

Z = vec(load_r_output("ZSaveRW_Important_Apr2020.txt"))

SmoothVector = vec(load_r_output("SmoothVector_Important_Apr2020.txt"))

CountryList = vec(load_r_output("CountryList_Important_Apr2020.txt"))

SessionList = vec(load_r_output("SessionList_Important_Apr2020.txt"))

GapYear = vec(load_r_output("GapYear_Important_Apr2020.txt"))
GapYear = GapYear .== "TRUE"

Gamma1 = vec(load_r_output("Gamma1RW_Important_Apr2020.txt"))

Gamma2 = vec(load_r_output("Gamma2RW_Important_Apr2020.txt"))

VoteN = vec(load_r_output("VoteN_Important_Apr2020.txt"))
VoteN = Int.(VoteN)

VoteStartEnd = load_r_output("VoteStartEnd_Important_Apr2020.txt")
VoteStartEnd = Int.(VoteStartEnd)

AllData = load_r_output("AllData_Important_Apr2020.txt")
yObs = Int.(AllData[:, 6])
println("Loaded gamma inputs")
println(length(Gamma1))
println(length(Gamma2))
println(length(VoteN))
println(size(VoteStartEnd))
println(length(yObs))