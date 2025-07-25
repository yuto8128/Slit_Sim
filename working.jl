function potential( i, j, L, dx, params )
  thickness = 0.2 ##厚さ
  potential_height = 10e3 ##ポテンシャルVの大きさ
  hall_number = 2 ##穴の数
  hall_size, hall_pos = params
  x = -L + dx*(i-1)
  y = -L + dx*(j-1)

  if ( -thickness < y < thickness )
    if (L<(hall_number-1-2*(i-1))*hall_pos+hall_size)
      println("error. hall is out of box.")
      return 0
    elseif (typeof(hall_number)==Int64)
      for i = 1:hall_number
        if ((hall_number-1-2*(i-1))*hall_pos-hall_size < x < (hall_number-1-2*(i-1))*hall_pos+hall_size)
            return 0.0
        end
      end
      return potential_height
  else
      println("error. hall_number must be integer")
      return 0
  end
  else
    return 0.0
  end
end
