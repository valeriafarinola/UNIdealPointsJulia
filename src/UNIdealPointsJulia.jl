
module UNIdealPointsJulia


export populate_theta_vector
export compute_theta_mean_var
export build_lag_prior
export update_gamma
export update_z
export update_beta

include("populate_theta_vector.jl")
include("theta_update.jl")
include("lag_prior.jl")
include("gamma_update.jl")
include("beta_update.jl")

end

