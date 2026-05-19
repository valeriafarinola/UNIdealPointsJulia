using CSV
using DataFrames
using Plots
using DelimitedFiles

# This script reproduces the P5 ideal point figure for the Important-votes dataset.
# It combines:
#   1. metadata from the original replication output;
#   2. Julia-estimated ideal points from output/ThetaEst_full.csv.
#
# Paths are built relative to the location of this script, so the script can be
# run from the repository root or from inside the scripts/ folder.

const DATA_PATH = joinpath(@__DIR__, "..", "data")
const OUTPUT_PATH = joinpath(@__DIR__, "..", "output")
const FIGURES_PATH = joinpath(@__DIR__, "..", "figures")

println("Loading metadata from processed replication output")

meta = CSV.read(
    joinpath(DATA_PATH, "IdealpointestimatesImportant_Apr2020.csv"),
    DataFrame
)

println("Loading Julia ideal point estimates")

theta_path = joinpath(OUTPUT_PATH, "ThetaEst_full.csv")
theta_julia = vec(readdlm(theta_path, ','))

println(length(theta_julia))
println(nrow(meta))

# Attach Julia ideal point estimates to the metadata table.
# The matching is by row order: each row is one country-session observation.
meta.JuliaIdealPoint = theta_julia

# Country codes for the five permanent members of the UN Security Council:
# USA, UK, China, USSR/Russia, France.
p5_codes = [2, 200, 220, 365, 710]
p5 = filter(row -> row.ccode in p5_codes, meta)

sort!(p5, [:Countryname, :session])

mkpath(FIGURES_PATH)

plt = plot(
    xlabel = "UNGA Session",
    ylabel = "Ideal Point",
    title = "P5 Ideal Points: Important Votes",
    legend = :bottomright,
    size = (900, 600)
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

figure_path = joinpath(FIGURES_PATH, "p5_ideal_points_julia_important.png")
savefig(plt, figure_path)

println("Saved figure:")
println(figure_path)