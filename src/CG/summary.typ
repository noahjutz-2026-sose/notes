#import "/components/admonitions.typ": *
#import "components/figure_grid.typ": figure_grid
#import "components/up_down_box.typ": up_down_box
#import "components/top_bottom_box.typ": top_bottom_box

// #figure_grid(
//   $
//     mat(
//       1, s_y, s_z, 0;
//       0, 1, 0, 0;
//       0, 0, 1, 0;
//       0, 0, 0, 1
//     )
//   $,
//   [Shear x],
//   $
//     mat(
//       1, 0, 0, 0;
//       s_x, 1, s_z, 0;
//       0, 0, 1, 0;
//       0, 0, 0, 1
//     )
//   $,
//   [Shear y],
//   $
//     mat(
//       1, 0, 0, 0;
//       0, 1, 0, 0;
//       s_x, s_y, 1, 0;
//       0, 0, 0, 1
//     )
//   $,
//   [Shear z],
// )

= Rendering Pipeline

#top_bottom_box(title: [Local Space])[
]

#up_down_box[
  #figure_grid(
    columns: 3,
    $
      M_T = mat(
        1, 0, 0, d_x;
        0, 1, 0, d_y;
        0, 0, 1, d_z;
        0, 0, 0, 1
      )
    $,
    [Translate],
    $
      M_S = mat(
        s_x, 0, 0, 0;
        0, s_y, 0, 0;
        0, 0, s_z, 0;
        0, 0, 0, 1
      )
    $,
    [Scale],

    $
      M_R_x = mat(
        1, 0, 0;
        0, cos Phi, -sin Phi;
        0, sin Phi, cos Phi
      )
    $,
    [Euler Rotate x],
    $
      M_R_y = mat(
        cos Phi, 0, sin Phi;
        0, 1, 0;
        -sin Phi, 0, cos Phi
      )
    $,
    [Euler Rotate y],
    $
      M_R_z = mat(
        cos Phi, -sin Phi, 0;
        sin Phi, cos Phi, 0;
        0, 0, 1
      )
    $,
    [Euler Rotate z],
  )

  $
    p_"local" |-> M_T M_S M_R p_"local"
  $
]


#top_bottom_box(title: [World Space])[]

#up_down_box[

]

#top_bottom_box(title: [Eye Space])[]
