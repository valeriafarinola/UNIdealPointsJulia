
module UNIdealPointsJulia


export populate_theta_vector
export compute_theta_mean_var
export build_lag_prior
export update_gamma
export update_z
export update_beta
export run

include("populate_theta_vector.jl")
include("theta_update.jl")
include("lag_prior.jl")
include("gamma_update.jl")
include("beta_update.jl")

function run()

    println("UNIdealPointsJulia")
    println("------------------")
    println("Replication package for:")
    println("Bailey, Strezhnev, and Voeten (2017)")
    println()

    println("Main scripts:")
    println(" - scripts/run_mcmc_full_all.jl")
    println(" - scripts/plot_p5.jl")
    println(" - scripts/plot_p5_important.jl")
    println(" - scripts/compute_dyadic_distances.jl")
    println()

    println("Diagnostic scripts:")
    println(" - scripts/run_mcmc_smoke_test.jl")
    
    println("Online report:")
    println("https://valeriafarinola.github.io/UNIdealPointsJulia/")

end

end

