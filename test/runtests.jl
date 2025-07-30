using Test
using Slit_Sim: potential

@testset "potential" begin
    struct SlitConfig
        hall_size::Float64
        hall_pos::Float64
        hall_number::Int
    end
    L = 15
    N = 400 ##格子分割数
    dx = 2*L / N ##格子幅

    @testset "potential1" begin
        hall_size = 0.20    ##穴の半径
        hall_pos  = 2.0    ##2つの穴の中央から穴の中心までの距離
        hall_number = 2
        hall_params = SlitConfig(hall_size, hall_pos, hall_number)
        

        @test potential(1  ,200,L,dx,hall_params) == 1e3   ## ポテンシャルの左端
        @test potential(173,200,L,dx,hall_params) == 0.0   ## ポテンシャルの左穴の中心
        @test potential(200,200,L,dx,hall_params) == 1e3   ## ポテンシャルの中心
        @test potential(226,200,L,dx,hall_params) == 0.0   ## ポテンシャルの右穴の中心
        @test potential(400,200,L,dx,hall_params) == 1e3   ## ポテンシャルの右端
    end

    @testset "potential2" begin
        hall_size = 0.20    ##穴の半径
        hall_pos  = 1.0    ##2つの穴の中央から穴の中心までの距離
        hall_number = 3
        hall_params = SlitConfig(hall_size, hall_pos, hall_number)
        

        @test potential(1,1,L,dx, hall_params) == 0.0
    end

    @testset "potential3" begin
        hall_size = 0.20    ##穴の半径
        hall_pos  = 1.0    ##2つの穴の中央から穴の中心までの距離
        hall_number = 3
        hall_params = SlitConfig(hall_size, hall_pos, hall_number)


        @test potential(20,200,15,3/40,hall_params) == 1e3
    end
end

nothing
