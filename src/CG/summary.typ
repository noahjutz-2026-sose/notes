#import "/components/admonitions.typ": *
#import "/components/utils.typ": *
#import "components/figure_grid.typ": figure_grid
#import "components/up_down_box.typ": up_down_box
#import "components/top_bottom_box.typ": top_bottom_box
#import "/deps.typ": cetz
#import "/style.typ": colors

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

#up_down_box(title: [Model Matrix $M$])[
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

  #hl[
    $
      p_"local" |-> M_T M_S M_R p_"local"
    $
  ]
]


#top_bottom_box(title: [World Space])[]

#up_down_box(title: [View-Matrix $V$])[
  Gegeben einer Kamera mit den Vektoren in $RR^3$
  $
    g & "Gaze" \
    t & "Up-Vektor" \
    o & "Offset"
  $

  Kann man drei orthogonale Basisvektoren berechnen, die die Rotation der Kamera haben.

  $
    w & = -g/norm(g)                  && "Negative Gaze" \
    u & = (t times w)/norm(t times w) && "Right" \
    v & = w times u                   && "Up"
  $

  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    let g = (1.75, .9, .75)
    let t = (0.9, 1, -.25)
    set-style(mark: (end: "straight"))
    line((0, 0, 0), g, name: "g")
    content("g.end", anchor: "north", padding: 8pt)[$g$]
    line((0, 0, 0), t, name: "t")
    content("t.end", anchor: "south", padding: 8pt)[$t$]

    let w = cetz.vector.norm(cetz.vector.scale(g, -1))
    line((0, 0, 0), w, stroke: colors.primary.normal, name: "w")
    content("w.end", anchor: "north", padding: 8pt)[$w$]

    let u = cetz.vector.norm(cetz.vector.cross(t, w))
    line((0, 0, 0), u, stroke: colors.secondary.normal, name: "u")
    content("u.end", anchor: "south", padding: 8pt)[$u$]

    let v = cetz.vector.cross(w, u)
    line((0, 0, 0), v, stroke: colors.tertiary.normal, name: "v")
    content("v.end", anchor: "south", padding: 8pt)[$v$]
  })

  $
    M_R = mat(u, v, w) quad ; quad
    M_T = mat(
      1, 0, 0, o_x;
      0, 1, 0, o_y;
      0, 0, 1, o_z;
      0, 0, 0, 1
    )
  $

  #hl[
    $
      p_"world" & |-> (M_R M_T)^(-1) p_"world" \
                & = M_(-T) M_R^T p_"world"
    $
  ]
]

#top_bottom_box(title: [Eye Space])[]
