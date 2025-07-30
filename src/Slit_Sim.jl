module Slit_Sim


# function potential( i, j, L, dx, params )
#   thickness = 0.2 ##厚さ
#   potential_height = 1e3 ##ポテンシャルVの大きさ
#   ##注意：この手法の場合、ポテンシャルが系のパラメーターに対して大きすぎるとうまくいかないことがあります。
#   hall_size, hall_pos, hall_number  = params
#   x = -L + dx*(i-1)
#   y = -L + dx*(j-1)

#   if ( -thickness < y < thickness )
#     if (L<(hall_number-1-2*(i-1))*hall_pos+hall_size)
#       println("error. hall is out of box.")
#       return "error"
#     elseif (typeof(hall_number)==Int64)
#       for i = 1:hall_number
#         if ((hall_number-1-2*(i-1))*hall_pos-hall_size < x < (hall_number-1-2*(i-1))*hall_pos+hall_size)
#             return 0.0
#         end
#       end
#       return potential_height
#     else
#       println("error. hall_number must be integer")
#       return "error"
#     end
#   else
#     return 0.0
#   end
# end

#入力値の型判別器__正しい入力が行われるまで繰り返す
function read_value(type)
  while true
    if type == 1
      print("double型のスリットの半径を入力してください：")
      input = readline()
      try
        num = parse(Float64, input)
        return num
      catch
        println("無効な入力です。もう一度入力してください。")
      end
    elseif type == 2
      print("double型のスリット間の距離を入力してください：")
      input = readline()
      try
        num = parse(Float64, input)
        return num
      catch
        println("無効な入力です。もう一度入力してください。")
      end
    else
      print("Int型のスリット数を入力してください：")
      input = readline()
      try
        num = parse(Int64, input)
        return num
      catch
        println("無効な入力です。もう一度入力してください。")
      end
    end
  end
end


function potential(i, j, L, dx, params) ##ポテンシャル関数__ポテンシャル大でスリットを再現
    thickness = 0.2
    potential_height = 1e3
    hall_size = params.hall_size
    hall_pos = params.hall_pos
    hall_number = params.hall_number

    # 型チェック
    if !isa(hall_number, Integer)
        error("hall_number must be an integer, but got: $(typeof(hall_number))")
    end

    x = -L + dx*(i-1)
    y = -L + dx*(j-1)

    if (-thickness < y < thickness)
        # 穴の配置がボックスをはみ出す場合のチェック
        max_extent = (hall_number - 1) * hall_pos + hall_size
        if L < max_extent
            println("Warning: hole extends beyond simulation box.")
            return potential_height
        end

        # 各スリットの位置にポテンシャルをゼロにする
        for n = 1:hall_number
            cx = (hall_number - 1 - 2*(n-1)) * hall_pos
            if (cx - hall_size < x < cx + hall_size)
                return 0.0
            end
        end

        return potential_height
    else
        return 0.0
    end
end



function initial_condition( N, dx, L )  ##初期の波動関数__同心円状の広がりを持つ
  wave = zeros(ComplexF64, N+1, N+1)
  for i in 1:N+1
    for j in 1:N+1
      x = -L + dx*(i-1)
      y = -L + dx*(j-1)
      if ( x^2 + (y+L/2)^2 < 49)
        wave[j,i] = 2.0*exp(-((x)^2 + (y + L/2)^2)/2)*exp(im * 10 * y)
      end
    end
  end
  return wave
end


function timeprop( N, wave_pre, dt, dx, L, params) ##波動関数の時間発展__差分法
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
            wave_next[j-1, i-1] += -im * potential( i-1, j-1, L, dx, params ) * wave_pre_save[j,i] * dt
        end
    end

    return wave_next
end



end # module Slit_Sim
