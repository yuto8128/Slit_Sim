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


hall_size = 0.20    ##穴の半径
hall_pos  = 1.0    ##2つの穴の中央から穴の中心までの距離
hall_params = [hall_size, hall_pos]

function potential( i, j, L, dx, params )
  thickness = 0.2 ##厚さ
  potential_height = 1e3 ##ポテンシャルVの大きさ
  ##注意：この手法の場合、ポテンシャルが系のパラメーターに対して大きすぎるとうまくいかないことがあります。
  hall_number = 3 ##穴の数
  hall_size, hall_pos = params
  x = -L + dx*(i-1)
  y = -L + dx*(j-1)

  if ( -thickness < y < thickness )
    if (L<(hall_number-1-2*(i-1))*hall_pos+hall_size)
      println("error. hall is out of box.")
      return "error"
    elseif (typeof(hall_number)==Int64)
      for i = 1:hall_number
        if ((hall_number-1-2*(i-1))*hall_pos-hall_size < x < (hall_number-1-2*(i-1))*hall_pos+hall_size)
            return 0.0
        end
      end
      return potential_height
    else
      println("error. hall_number must be integer")
      return "error"
    end
  else
    return 0.0
  end
end



function initial_condition( N, dx, L )
  wave = zeros(ComplexF64, N+1, N+1)
  for i in 1:N+1
    for j in 1:N+1
      x = -L + dx*(i-1)
      y = -L + dx*(j-1)
      if ( x^2 + (y+L/2)^2 < 49)
        wave[j,i] = exp(-((x)^2 + (y + L/2)^2)/2)*exp(im * 10 * y)
      end
    end
  end
  return wave
end

function timeprop(N,wave_pre,dt,dx)
     wave_next = zeros(ComplexF64, N+1, N+1)
    wave_pre_save = zeros(ComplexF64,N+3,N+3)  # waveのコピーを保存するための配列:行列を1周り大きくして、i-1,i+1のエラーに備える。
    # 時間発展の計算
    for i in 1:N+1
        for j in 1:N+1
            wave_pre_save[j+1, i+1] = wave_pre[j, i] 
        end
    end
    for i in 2:N+2
        for j in 2:N+2
            wave_next[j-1, i-1] = im*(wave_pre_save[j-1, i] + wave_pre_save[j+1, i] + wave_pre_save[j, i-1] + wave_pre_save[j, i+1] -4 * wave_pre_save[j, i])/dx^2 * dt + wave_pre_save[j, i]
            wave_next[j-1, i-1] += -im * potential( i-1, j-1, L, dx, hall_params ) * wave_pre_save[j,i] * dt
        end
    end

    return wave_next
end

function main()
  anim = Animation()
  x = range(-L, L, length=N+1)
  y = range(-L, L, length=N+1)
  wave0 = initial_condition(N, dx, L)
  wave_pre = copy(wave0)
  for i in 1:80000
    wave_next = timeprop( N, wave_pre, dt, dx )
    if i % 500 == 0
      p = heatmap(x, y, real.(wave_next), clims = (-1, 1), aspect_ratio=:equal, title="t = $(round(i*dt, digits=3))")
      # p = heatmap(x, y, abs.(wave_next),clims = (0, 2), aspect_ratio=:equal, color=:grays, title="t = $(round(i*dt, digits=3))")
      frame(anim,p)
      println(i)
    end
    wave_pre = copy(wave_next)
  end

  gif(anim, "sample_real.gif", fps=10)

end 

main()
