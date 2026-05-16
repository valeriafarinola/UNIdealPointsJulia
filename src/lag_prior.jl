function build_lag_prior(
    ThetaMean,
    CountryList,
    SessionList,
    GapYear
)

    NN = length(ThetaMean)
    LagThetaPrior = zeros(Float64, NN)

    unique_countries = unique(CountryList)

    for i in 1:NN
        current_country = CountryList[i]
        current_session = SessionList[i]

        previous_index = findfirst(
            (CountryList .== current_country) .&
            (SessionList .== current_session - 1)
        )

        if previous_index !== nothing
            LagThetaPrior[i] = ThetaMean[previous_index]
        else
            LagThetaPrior[i] = 0.0
        end
    end

    for country in unique_countries
        rows = findall(CountryList .== country)
        country_sessions = SessionList[rows]

        first_row = rows[argmin(country_sessions)]
        second_rows = rows[country_sessions .> minimum(country_sessions)]

        if !isempty(second_rows)
            second_row = second_rows[argmin(SessionList[second_rows])]
            LagThetaPrior[first_row] = ThetaMean[second_row]
        end
    end

    for i in 1:NN
        if GapYear[i]
            previous_rows = findall(
                (CountryList .== CountryList[i]) .&
                (SessionList .< SessionList[i])
            )

            if !isempty(previous_rows)
                last_previous_row = previous_rows[argmax(SessionList[previous_rows])]
                LagThetaPrior[i] = ThetaMean[last_previous_row]
            end
        end
    end

    return LagThetaPrior
end