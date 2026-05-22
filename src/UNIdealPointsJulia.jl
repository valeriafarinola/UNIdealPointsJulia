__precompile__(false)
module UNIdealPointsJulia
# Load package source files.
include("populate_theta_vector.jl")
include("theta_update.jl")
include("lag_prior.jl")
include("gamma_update.jl")
include("beta_update.jl")
include("replication.jl")

# Export core estimation and replication functions.
export populate_theta_vector
export compute_theta_mean_var
export build_lag_prior
export update_gamma
export update_z
export update_beta
export run
export run_replication



# Package entry point displaying replication workflow information.
function run()

    println("UNIdealPointsJulia")
    println("------------------")
    println("Replication package for:")
    println("Bailey, Strezhnev, and Voeten (2017)")
    println()

    println("Main replication function:")
    println(" - run_replication(dataset = :all, test = true)")
    println()

    println("Examples:")
    println(" - run_replication()")
    println(" - run_replication(test = false)")
    println(" - run_replication(dataset = :important)")
    println(" - run_replication(dataset = :important, test = false)")
    println()

    println("Post-processing scripts:")
    println(" - scripts/plot_p5.jl")
    println(" - scripts/plot_p5_important.jl")
    println(" - scripts/compute_dyadic_distances.jl")
    println()

    println("Online report:")
    println("https://valeriafarinola.github.io/UNIdealPointsJulia/")

end

end