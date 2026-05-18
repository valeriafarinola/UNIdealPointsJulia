using CSV
using DataFrames
using Plots
using DelimitedFiles

println("Loading metadata from R output")

R_OUTPUT_PATH =
raw"C:\Users\HP 14-DW1012NL\Desktop\COMPUTATIONAL\United-Nations-General-Assembly-Votes-and-Ideal-Points-master\United-Nations-General-Assembly-Votes-and-Ideal-Points-master\Output"

meta = CSV.read(
    joinpath(R_OUTPUT_PATH, "IdealpointestimatesImportant_Apr2020.csv"),
    DataFrame
)

println("Loading Julia ideal points")

theta_julia = vec(readdlm("../output/ThetaEst_full.csv", ','))

println(length(theta_julia))
println(nrow(meta))

meta.JuliaIdealPoint = theta_julia

p5_codes = [2, 200, 220, 365, 710]
p5 = filter(row -> row.ccode in p5_codes, meta)

sort!(p5, [:Countryname, :session])

mkpath("../figures")

plt = plot(
    xlabel = "UNGA Session",
    ylabel = "Ideal Point",
    title = "P5 Ideal Points in the UN General Assembly: Important Votes",
    legend = :bottomright,
    size = (1200, 700)
)

for country in unique(p5.Countryname)
    tmp = filter(row -> row.Countryname == country, p5)

    plot!(
        plt,
        tmp.session,
        tmp.JuliaIdealPoint,
        label = country,
        linewidth = 2
    )
end
savefig(plt, "../figures/p5_ideal_points_julia_important.png")
println("Saved figure:")
println("../figures/p5_ideal_points_julia_important.png")