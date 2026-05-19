using CSV
using DataFrames
using DelimitedFiles

# This script computes pairwise ideological distances between countries
# within each UN General Assembly session.
#
# The distances are computed using the Julia-estimated ideal points from:
#   output/ThetaEst_full_all.csv
#
# Metadata from the original replication output is used to recover:
#   - country names
#   - country codes
#   - UNGA sessions


const DATA_PATH = joinpath(@__DIR__, "..", "data")
const OUTPUT_PATH = joinpath(@__DIR__, "..", "output")

println("Loading metadata from processed replication output")

meta = CSV.read(
    joinpath(DATA_PATH, "IdealpointestimatesAll_Apr2020.csv"),
    DataFrame
)

println("Loading Julia ideal point estimates")

theta_path = joinpath(OUTPUT_PATH, "ThetaEst_full_all.csv")
theta = vec(readdlm(theta_path, ','))

# Attach Julia ideal point estimates to the metadata table.
# Each row corresponds to one country-session observation.
meta.JuliaIdealPoint = theta

# Container for all dyadic comparisons.
rows = NamedTuple[]

println("Computing dyadic ideological distances")

# Group observations by UNGA session.
# Distances are only computed within the same session.
for g in groupby(meta, :session)

    n = nrow(g)

    # Generate all unique country pairs within the session.
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

                    # Absolute ideological distance between the two countries.
                    distance = abs(
                        g.JuliaIdealPoint[i] -
                        g.JuliaIdealPoint[j]
                    )
                )
            )
        end
    end
end

dyads = DataFrame(rows)

mkpath(OUTPUT_PATH)

output_file = joinpath(
    OUTPUT_PATH,
    "dyadic_distances_full_all.csv"
)

CSV.write(output_file, dyads)

println("Saved dyadic distances:")
println(output_file)

println("Number of dyads:")
println(nrow(dyads))