import "base"

let edgy [h][w] (frame: [h][w]pixel) (distortion: f32): [h][w]pixel =
  map (\x: [w]pixel ->
         map (\y ->
                if x >= w - 10
                then RGB.black
                else let (x1, x2) = (frame[x, y], frame[x + 10, y])
                     let r_grad   = i32.abs (get_r(x1) - get_r(x2))
                     let g_grad   = i32.abs (get_g(x1) - get_g(x2))
                     let b_grad   = i32.abs (get_b(x1) - get_b(x2))
                     let total_edge = 1.0 - r32 (r_grad + g_grad + b_grad) / (3.0f32 * 255.0f32)
                     let total_edge' = if total_edge > (distortion / 10.0) then 1.0 else 0.0
                     in set_rgb (t32 (total_edge' * 255.0))
                                (t32 (total_edge' * 255.0))
                                (t32 (total_edge' * 255.0))
           ) (iota w)) (iota h)
