using Plots


## 定数
h = 1.0
m = 1.0
k = 1.0
L = 15
N = 400
dx = 2*L / N



t_ini = 0.0
t_fin = 0.1
step_t = 10000
dt = (t_fin - t_ini)/step_t


hall_size = 0.20    ##穴の半径
hall_pos  = 1.0    ##穴の位置
hall_params = [hall_size, hall_pos]
function potential( i, j, L, dx, params )
  hall_size , hall_pos = params
  x = -L + dx*(i-1)
  y = -L + dx*(j-1)
  if ( -0.2 < y < 0.2 )
    if (-L < x < -hall_pos-hall_size)
      return 1e3
      # return 0
    elseif (-hall_pos+hall_size < x < hall_pos-hall_size)
      return 1e3
      # return 0
    elseif (hall_pos+hall_size< x < L)
      return 1e3
      # return 0
    else
      return 0.0
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

function next_wave( N, wave_pre, dt, dx )
  wave_next = zeros(ComplexF64, N+1, N+1)

  for i in 1:N+1
    for j in 1:N+1
      if ( i==1 )
        if ( j==1 )
          wave_next[j,i] = wave_pre[j,i] + im*(wave_pre[j,i+1] + wave_pre[j+1,i]                                     - 4.0*wave_pre[j,i])*dt/dx^2
        elseif ( j==N+1 )
          wave_next[j,i] = wave_pre[j,i] + im*(wave_pre[j,i+1]                                     + wave_pre[j-1,i] - 4.0*wave_pre[j,i])*dt/dx^2
        else
          wave_next[j,i] = wave_pre[j,i] + im*(wave_pre[j,i+1] + wave_pre[j+1,i] +                 + wave_pre[j-1,i] - 4.0*wave_pre[j,i])*dt/dx^2 
        end
      elseif ( i==N+1 )
        if ( j==1 )
          wave_next[j,i] = wave_pre[j,i] + im*(                  wave_pre[j+1,i] + wave_pre[j,i-1] +                 - 4.0*wave_pre[j,i])*dt/dx^2
        elseif ( j==N+1 )
          wave_next[j,i] = wave_pre[j,i] + im*(                                  + wave_pre[j,i-1] + wave_pre[j-1,i] - 4.0*wave_pre[j,i])*dt/dx^2
        else
          wave_next[j,i] = wave_pre[j,i] + im*(                  wave_pre[j+1,i] + wave_pre[j,i-1] + wave_pre[j-1,i] - 4.0*wave_pre[j,i])*dt/dx^2
        end
      else
        if ( j==1 )
          wave_next[j,i] = wave_pre[j,i] + im*(wave_pre[j,i+1] + wave_pre[j+1,i] + wave_pre[j,i-1] +                 - 4.0*wave_pre[j,i])*dt/dx^2
        elseif ( j==N+1 )
          wave_next[j,i] = wave_pre[j,i] + im*(wave_pre[j,i+1]                   + wave_pre[j,i-1] + wave_pre[j-1,i] - 4.0*wave_pre[j,i])*dt/dx^2
        else
          wave_next[j,i] = wave_pre[j,i] + im*(wave_pre[j,i+1] + wave_pre[j+1,i] + wave_pre[j,i-1] + wave_pre[j-1,i] - 4.0*wave_pre[j,i])*dt/dx^2
        end
      end
      wave_next[j,i] += -im * potential( i, j, L, dx, hall_params ) * wave_pre[j,i] * dt
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
    wave_next = next_wave( N, wave_pre, dt, dx )
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