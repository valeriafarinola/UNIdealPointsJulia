using Test

include("../src/UNIdealPointsJulia.jl")
using .UNIdealPointsJulia

@testset "UNIdealPointsJulia tests" begin

    x = UNIdealPointsJulia.r_rep([1.0, 2.0], [2, 3])

    @test x == [1.0, 1.0, 2.0, 2.0, 2.0]

    theta = [1.0, 2.0, 3.0]

    dist = abs(theta[1] - theta[3])

    @test dist == 2.0

    println("All tests passed.")

end