using CSV
using DataFrames
using DelimitedFiles

R_OUTPUT_PATH =
raw"C:\Users\HP 14-DW1012NL\Desktop\COMPUTATIONAL\United-Nations-General-Assembly-Votes-and-Ideal-Points-master\United-Nations-General-Assembly-Votes-and-Ideal-Points-master\Output"

meta = CSV.read(
    joinpath(R_OUTPUT_PATH, "IdealpointestimatesAll_Apr2020.csv"),
    DataFrame
)

theta = vec(readdlm("../output/ThetaEst_full_all.csv", ','))

meta.JuliaIdealPoint = theta

rows = NamedTuple[]

for g in groupby(meta, :session)
    n = nrow(g)

    for i in 1:(n - 1)
        for j in (i + 1):n
            push!(
                rows,
                (
                    session = g.session[i],
                    ccode1 = g.ccode[i],
                    country1 = g.Countryname[i],
                    ccode2 = g.ccode[j],
                    country2 = g.Countryname[j],
                    theta1 = g.JuliaIdealPoint[i],
                    theta2 = g.JuliaIdealPoint[j],
                    distance = abs(g.JuliaIdealPoint[i] - g.JuliaIdealPoint[j])
                )
            )
        end
    end
end

dyads = DataFrame(rows)

mkpath("../output")

CSV.write("../output/dyadic_distances_full_all.csv", dyads)

println("Saved dyadic distances to output/dyadic_distances_full_all.csv")
println(nrow(dyads))