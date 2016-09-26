include futcamlib.base
default (f32)

-- fun desaturateE (p: pixel): pixel =
--   let v = u32 (intensity p)
--   in set_rgb(v,v,v)

-- fun rotationE ((x,y): (int,int)): f32 =
--   let r = sqrt32 (f32 (x*x + y*y))
--   let x' = f32 x / r
--   let y' = f32 y / r
--   in atan2_32 y' x'

  
entry edgy(frame: [h][w]pixel, distortion: i32): [h][w]pixel =
    zipWith (fn x: [w]pixel =>
               map (fn y =>
                      if (x >= w - 10)
                      then RGB.black
                      else
                        let two_pixels = (unsafe frame[x,y], unsafe frame[x + 10,y])
                        let edgy_pixel =
                             let (x1, x2) = two_pixels
                             let r_grad   = abs (get_r(x1) - get_r(x2)) 
                             let g_grad   = abs (get_g(x1) - get_g(x2))
                             let b_grad   = abs (get_b(x1) - get_b(x2)) 
                             let total_edge = 1.0 - f32 (r_grad + g_grad + b_grad) / (3.0f32 * 255.0f32)
                             let total_edge' = if total_edge > (f32 distortion / 10.0) then 1.0 else 0.0
                             in set_rgb(u32 (total_edge' * 255.0), u32 (total_edge' * 255.0), u32 (total_edge' * 255.0))
                          --                    in if rotation (x-h/2, y-w/2) < distortion+3.147
                          --                       then desaturate p
                          --                       else p)
                        in edgy_pixel
                   )
             (iota w))
             (iota h)