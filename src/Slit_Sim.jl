module Slit_Sim

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



end # module Slit_Sim
