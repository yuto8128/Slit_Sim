import Slit_Sim

using Plots


## 定数
h = 1.0 ##プランク定数
m = 1.0 ##電子の質量
L = 15 ##一辺の長さ/2
N = 400 ##格子分割数
dx = 2*L / N ##格子幅



t_ini = 0.0 ##開始時間
t_fin = 1.0 ##終了時間
step_t = 100000 ##時間分割数
dt = (t_fin - t_ini)/step_t ##時間幅

struct SlitConfig
    hall_size::Float64
    hall_pos::Float64
    hall_number::Int
end

hall_size = 0.20    ##穴の半径
hall_pos  = 1.0    ##2つの穴の中央から穴の中心までの距離
hall_number = 3
hall_params = SlitConfig(hall_size, hall_pos, hall_number)

function main()
  anim = Animation()
  x = range(-L, L, length=N+1)
  y = range(-L, L, length=N+1)
  wave0 = Slit_Sim.initial_condition(N, dx, L)
  wave_pre = copy(wave0)
  for i in 1:80000
    wave_next = Slit_Sim.timeprop( N, wave_pre, dt, dx ,L, hall_params)
    if i % 500 == 0
      # p = heatmap(x, y, real.(wave_next), clims = (-1, 1), aspect_ratio=:equal, color=:grays, title="t = $(round(i*dt, digits=3))")
      p = heatmap(x, y, abs.(wave_next),clims = (0, 2), aspect_ratio=:equal, color=:grays, title="t = $(round(i*dt, digits=3))")
      frame(anim,p)
      println(i)
    end
    wave_pre = copy(wave_next)
  end

  gif(anim, "sample_main.gif", fps=10)
end

main()