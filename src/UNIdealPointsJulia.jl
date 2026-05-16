module UNIdealPointsJulia

export populate_theta_vector
export compute_theta_mean_var
export build_lag_prior

include("populate_theta_vector.jl")
include("theta_update.jl")
include("lag_prior.jl")

end