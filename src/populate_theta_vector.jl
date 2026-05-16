function populate_theta_vector(IObsMat, Theta, IndN, len)

    out = zeros(Float64, len)

    for i in 1:size(IObsMat, 1)
        for j in 1:IndN[i]
            out[Int(IObsMat[i, j])] = Theta[i]
        end
    end

    return out
end