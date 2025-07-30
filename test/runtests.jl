using Test
using Slit_Sim: potential

@testset "potential" begin
    struct SlitConfig
        hall_size::Float64
        hall_pos::Float64
        hall_number::Int
    end
<<<<<<< HEAD
    L = 15
    N = 400 ##格子分割数
    dx = 2*L / N ##格子幅

    @testset "potential1" begin
        hall_size = 0.20    ##穴の半径
        hall_pos  = 2.0    ##2つの穴の中央から穴の中心までの距離
        hall_number = 2
        hall_params = SlitConfig(hall_size, hall_pos, hall_number)
        

        @test potential(1,1,L,dx, hall_params) == 0.0
    end

    @testset "potential2" begin
        hall_size = 0.20    ##穴の半径
        hall_pos  = 1.0    ##2つの穴の中央から穴の中心までの距離
        hall_number = 3
        hall_params = SlitConfig(hall_size, hall_pos, hall_number)
        

        @test potential(1,1,L,dx, hall_params) == 0.0
    end
    
=======
    hall_size = 0.20    ##穴の半径
    hall_pos  = 1.0    ##2つの穴の中央から穴の中心までの距離
    hall_number = 3
    hall_params = SlitConfig(hall_size, hall_pos, hall_number)
    @test potential(1,1,10,0.1, hall_params) == 0.0
>>>>>>> cbd1d4a87b9781c7473a4b7d027a3616949c236f
end

nothing
