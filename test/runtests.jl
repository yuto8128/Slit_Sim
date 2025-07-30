using Test
using Slit_Sim: potential, SlitConfig

@testset "potential" begin
    struct SlitConfig
        hall_size::Float64
        hall_pos::Float64
        hall_number::Int
    end
    hall_size = 0.20    ##穴の半径
    hall_pos  = 1.0    ##2つの穴の中央から穴の中心までの距離
    hall_number = 3
    hall_params = SlitConfig(hall_size, hall_pos, hall_number)
    @test potential(1,1,10,0.1, hall_params) == 0.0
end

nothing
