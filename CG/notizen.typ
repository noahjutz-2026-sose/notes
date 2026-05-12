#import "/components.typ": *
#import "/style.typ": *
#import "/deps.typ": cetz, cetz-plot, codly, gentle-clues, suiji

#align(end)[2026-03-16 VL01]

= Dreiecke und Pixel

Rendering turns triangles to pixels.

$
  { triangle } -> [[ square ]]
$

== Farben

- RGB
- CMY(K)

== Netze

Triangulieren von Polygonen

- Konvex trivial
- Konkav möglich

In 3D: Vertexe definieren polygon nicht eindeutig, aber Dreiecke schon

- Bezier, B-Spline, ...
- Subdivision Surfaces

#align(end)[2026-03-23 VL02]

=== Effizientes Speichern von Dreiecken

#let index_list = (4, 5, 2, 4, 6, 5)

#cetz.canvas({
  import cetz.draw: *
  let rng = suiji.gen-rng-f(40)
  let (rng, v) = suiji.uniform-f(rng, low: 0, high: 10, size: 2 * 10)
  let positions = v.chunks(2)
  for (i, pos) in positions.enumerate() {
    circle(pos, radius: 2pt, stroke: none, fill: black)
    content(pos, anchor: "north", padding: 2pt)[$v_#i$]
  }

  for (v1, v2, v3) in index_list.chunks(3) {
    line(positions.at(v1), positions.at(v2), positions.at(v3), close: true)
  }
})

- Statt Vertexe nur indizes speichern $(1+S_I/S_V)$

Ein Vertex besteht aus
- Position $RR^3$
- Normale $RR^3$
- Texturkoordinate $RR^2$

= Rasterisieren

$
  {triangle} -> "magic" -> {triangle_"2D"} stretch(->)^"Wir sind hier" [[square]]
$

Ist ein Punkt in einem konvexen Polygon?

Kanten entlang laufen, wenn der Punkt immer auf der Seite nach innen liegt, ist er innen.

#grid(
  columns: 2,
  align: horizon,
  column-gutter: 32pt,
  cetz.canvas({
    import cetz.draw: *
    let mid = (x1, x2) => ((x1.at(0) + x2.at(0)) / 2, (x1.at(1) + x2.at(1)) / 2)
    let a = (3, 0)
    let b = (5, 5)
    let c = (0, 6)
    let p = (3, 2)

    circle(p, radius: 3pt, stroke: none, fill: red)
    set-style(mark: (end: "straight"))
    line(a, b)
    line(b, c)
    line(c, a)

    for (v, w) in ((a, b), (b, c), (c, a)) {
      line(
        mid(v, w),
        p,
        stroke: gray,
        name: "real",
      )
      line(
        mid(v, w),
        cetz.vector.add(
          cetz.util.line-normal(v, w),
          mid(v, w),
        ),
        name: "norm",
      )
      cetz.angle.angle(
        "real.start",
        "norm.end",
        "real.end",
        mark: none,
        direction: "near",
      )
    }
  }),
  cetz.canvas({
    import cetz-plot: *

    plot.plot(
      size: (5, 3),
      axis-style: "school-book",
      x-tick-step: calc.pi,
      y-tick-step: 1,
      {
        plot.add(
          domain: (-calc.pi, calc.pi),
          calc.cos,
        )
        plot.add-fill-between(
          domain: (-calc.pi / 2, calc.pi / 2),
          calc.cos,
          it => 0,
          style: (stroke: none),
        )
      },
    )
  }),
)

#align(end)[2026-03-30 VL03]

== Lineare Interpolation

_Lerp:_

$
  "lerp"(a, b, t) = (1-t) dot h(a) + t dot h(b) quad quad t in [0;1]
$

#alternative[
  $
    "lerp"(a, b)(t) \
    "lerp"(t)(a, b)
  $
]

== Baryzentrische Interpolation

#figure(
  include "figures/bary_interp.typ",
  caption: [Baryzentrischer Mittelpunkt],
)

Wenn die längste Kante weniger als ein Pixel ist, muss man nur einen Pixel prüfen.

== Clipping

Bounding Box auf View begrenzen

#align(end)[2026-04-13 VL04]

= Transformationen

_Affine Transformation:_ Translation, (Nicht-)Uniforme Skalierung, Rotation, Scherung

#figure(
  include "figures/shear.typ",
  caption: [
    Shear in #text(blue)[x], #text(green)[y] und #text(red)[z].
  ],
)

#align(end)[2026-04-13 VL05]

== Konkatenation

#clue[
  Es ist einfacher, jedes mal ein Matrixvektorprodukt zu berechnen, statt die Transformationsmatrizen zu multiplizieren.

  $
    A_1 A_2 A_3 x = A_1 A_2 x' = A_1 x'' = x'''
  $
]


== Homogene koordinaten

Man kann die Translation in die Transformationsmatrix einbinden.

$
  A x + t = mat(
    A, t;
    0^T, 1
  ) x
$

In 1D:

$
  x in RR -> vec(x, 1) in RR^2
$

#cetz.canvas({
  import cetz-plot: *
  import cetz.draw: *

  plot.plot(
    size: (10, 5),
    axis-style: "school-book",
    x-min: 0,
    x-max: 10,
    y-min: 0,
    y-max: 5,
    {
      plot.add(((0, 0), (0, 0)), style: (stroke: none))
      plot.add-hline(1)
      plot.annotate({
        import cetz.draw: *
        set-style(mark: (end: "straight"))
        line((0, 0), (3, 2))
        content((), anchor: "north", padding: 6pt)[$ vec(3, 2) $]

        set-style(stroke: none, fill: black)
        circle((1.5, 1), radius: 2pt)
        content((), anchor: "north", padding: 6pt)[$ vec(3/2, 2/2) $]
      })
    },
  )
})

== Normalenvektor unter Transformation

$
  n^T t = n^T I t = n^T A^(-1) A t = n^T A^(-1) t'
$

$=>$ Man kann den durch $A$ transformierten Vektor $t'$ mit $A^(-1)$ transformieren, um seine Normale zu finden

== Rotation

#clue[
  Figur auf Folie 15:

  + Rotiere um $z$ um $alpha$
  + Um $N$ um $beta$
  + Um $y$ um $gamma$
]

#align(end)[2026-04-20 VL06]

= Komplexe Zahlen

Eine komplexe Zahl in $CC$ hat einen reellen und einen imaginären Teil.

$
  a + i b
$

== Multiplikation

$
  (a + i b) (c + i d) & = a c + a i d + i b c + i^2 b d \
                      & = a c - b d + i (a d + b c)
$

== Polare Koordinaten

$
  R = r (cos phi + i sin phi)
$

#example(title: [Rotation mit komplexen Zahlen])[
  Sei $A = 0 + 3i$ und $R = cos pi/4 + i sin pi/4$. Dann ist $A R$ der CCW rotierte Punkt um $pi/4$.
  $
    A R & = (0 + 3 i) dot (cos pi/4 + i sin pi/4) \
        & = 3 i cos pi/4 - 3 sin pi/4 \
        & = - (3 sqrt(2))/2 + (3 sqrt(2))/2 i
  $
]

= Quaternionen

$
  bold(upright(hat(q))) = (
    bold(upright(q))_v, q_w
  ) quad quad
  bold(upright(q))_v = vec(q_x, q_y, q_z) = q_x i + q_y j + q_z k quad quad
  i^2 = j^2 = k^2 = -1
$

#note(title: [Konjugat])[
  $
    bold(upright(hat(q)))^* = (-bold(upright(q))_v, q_w)
  $
]

= Slerp

Rotationsinterpolation

#align(end)[2026-04-27 VL07]

= Camera Space

// #cetz.canvas({
//   import cetz.draw: *
//
//   line((0, 0, 0), (0, 0, 1))
//   line((0, 0, 0), (1, 0, 0))
//   line((0, 0, 0), (0, 1, 0))
// })

Die Kamera schaut in die negative Z-Achse (Right-Hand Rule).

== Viewing Transform

#[
  #show "w": set text(red)
  #show "u": set text(blue)
  #show "v": set text(green)
  $
    w = (-g)/norm(g) \
    u = (t times w) / norm(t times w) \
    v = w times u
  $

  $
    M_(C->W) & = T_(C->W) dot R_(C->W) \
             & =mat(
                 1, 0, 0, o_x;
                 0, 1, 0, o_y;
                 0, 0, 1, o_z;
                 0, 0, 0, 1
               ) dot mat(
                 u_x, v_x, w_x, 0;
                 u_y, v_y, w_y, 0;
                 u_z, v_z, w_z, 0;
                 0, 0, 0, 1
               )
  $

  $
    M_(W->C) & = M_(C->W)^(-1) \
             & = R_(C->W)^(-1) T_(C->W)^(-1) \
             & =
               mat(
                 u_x, u_y, u_z, 0;
                 v_x, v_y, v_z, 0;
                 w_x, w_y, w_z, 0;
                 0, 0, 0, 1
               ) dot mat(
                 1, 0, 0, -o_x;
                 0, 1, 0, -o_y;
                 0, 0, 1, -o_z;
                 0, 0, 0, 1
               )
  $

]

== Orthographische Projektion

- _Normalized Device Coordinates (NDC):_ Projektionswürfel (in 3D), Quadrat (in 2D)

Orthographische Projektionsmatrix:

$
  P = mat(
    2/(x_max-x_min), 0, 0, -(x_max+x_min)/(x_max-x_min);
    0, 2/(y_max-y_min), 0, -(y_max+y_min)/(y_max-y_min);
    0, 0, 2/(n-f), -(f+n)/(f-n);
    0, 0, 0, 1
  )
$

== Perspektive Projektion

Top-Down view vom Viewing Frustum in 3D:

#grid(
  columns: 2,
  column-gutter: 12pt,
  cetz.canvas(length: 0.4cm, {
    import cetz.draw: *

    let bounds = 10

    grid(
      (-bounds, -1),
      (bounds, bounds),
      stroke: colors.on_surface.lighter,
    )

    set-transform(cetz.matrix.ident(4))

    line((0, 0), (-bounds, -bounds))
    line((0, 0), (bounds, -bounds))

    group({
      let n = 3
      let f = 6
      set-style(stroke: (dash: "dashed", thickness: 2pt))
      line((-n, -n), (n, -n), stroke: colors.primary.normal)
      line((-f, -f), (f, -f), stroke: colors.secondary.normal)
    })

    group({
      set-style(stroke: colors.on_surface.light, mark: (end: "straight"))
      line((-bounds, 0), (bounds, 0), name: "x")
      content("x.end", anchor: "north-east", padding: 4pt)[$x$]

      line((0, 1), (0, -bounds), name: "z")
      content("z.end", anchor: "north-west", padding: 4pt)[$-z$]
    })

    set-style(stroke: 2pt)
    line((0, 0), (0, -3), stroke: blue, name: "n")
    content("n", anchor: "west", padding: 2pt)[$n$]
    line((0, -3), (3, -3), stroke: green, name: "r")
    content("r", anchor: "south", padding: 2pt)[$r$]

    circle((3, -3), radius: 2pt, fill: black, stroke: none)
    content((), anchor: "north-west", padding: 2pt)[$v$]
  }),
  table(
    columns: 3,
    [], $triangle_"eye"$, $triangle_"NDC"$,
    $n$, $3$, $-1$,
    $f$, $6$, $1$,
    $r$, $3$, $1$,
    $l$, $-3$, $-1$,
  ),
)

#grid(
  columns: (1fr,) * 2,
  $
    P & = mat(
          (2n)/(r-l), 0, (l+r)/(r-l), 0;
          0, (2n)/(t-b), (b+t)/(t-b), 0;
          0, 0, (n+f)/(n-f), (2f n)/(n-f);
          0, 0, -1, 0
        ) \
      & = mat(
          (n)/(w), 0, 0, 0;
          0, (n)/(h), 0, 0;
          0, 0, (n+f)/(n-f), (2f n)/(n-f);
          0, 0, -1, 0
        )
  $,
  $
    r = -l = w \
    t = -b = h
  $,
)

#align(end)[2026-05-04 VL08]

_Dehomogenisierte Koordinaten:_

$
  H(vec(x_1, x_2, x_3)) = vec(x_1 slash x_3, x_2 slash x_3)
$

#example(title: [Perspektivische Projektion in 2D])[
  #cetz.canvas(length: .5cm, {
    import cetz.draw: *
    line((0, 0), (5, 5))
    line((0, 0), (5, -5))

    line((2, 2), (2, -2), stroke: orange)

    circle((2, 2), radius: 2pt, fill: purple, stroke: none)
    circle((4, 0), radius: 2pt, fill: purple, stroke: none)

    translate((10, 0))

    grid(
      (0, -5),
      (10, 5),
      stroke: colors.on_surface.lighter,
    )
    line((0, -5), (0, 5), stroke: orange)
  })
]

=== Nichtlineares Z

- x-Achse: Eingabe-Z (nach rechts negativ)
- y-Achse: NDC-Z
  - near-Distanz: $f(1)$
  - far-Distanz: $f(-1)$

== Clipping

$
  "Local Space " ->^M
  "World Space" ->^V
  "Eye Space" ->^P
  bold("ClipSpace") ->^H(dot)
  "NDC" ->^W
  "Window Coordinates"
$

#align(end)[2026-05-12 VL09]

= OpenGL

== Streams

- _vbo:_ Vertex Buffer Object
- _ibo:_ Index Buffer Object

#codly.codly(header: [Daten einschleusen])

```c
glGenBuffers(...); // Create buffers
glBindBuffer(...); // Bind buffer
glBufferData(...); // Copy Data
glBindBuffer(...); // Unbind buffer
```

#codly.codly(header: [Buffer an SM binden])
```c
glEnableVertexAttribArray(...); // Shader input an machen
glVertexAttribPointer(...); // Buffer an stream binden
```

Diese Aufrufe sind langsam, weil CPU mit GPU synchronisiert kommuniziert. Schneller: _Vertex Array Objects_

#codly.codly(header: [Vertex Array Object (VAO)])
```c
glGenVertexArrays(...); // Create
glBindVertexArray(vao); // Bind
glBindVertexArray(0); // Unbind
```

#note[
  Zuerst VAO unbinden, dann Element Buffer
]

== State

```c
glEnable(...);
glDisable(...);
```

== Shader

- _Vertex Shader:_ Transformationen wie View, Projektion, Clip, NDC, Screen
- _Fragment Shader:_ Raster-Werte
- _Shader Program:_ Mehrere Shader

#codly.codly(header: [Shader erstellen])
```c
glCreateShader();
glShaderSource(); // Source code string
glCompileShader();
glGetShaderiv(); // iv: Int Vector (status codes)
```

#codly.codly(header: [Shader-Programm erstellen])
```c
glCreateProgram();
glAttachShader(program, shader);
glLinkProgram(program);
glGetProgramiv(...);
```

#codly.codly(header: [Destructor])

```c
glDeleteProgram();
glDeleteShader();
```

#codly.codly(header: [Programm nutzen])
```c
glUseProgram(program);
```

== OpenGL Shading Language GLSlang

#codly.codly(header: [Vertex Shader])
```glsl
#version 130

in vec3 local_vertex;

void main() {
    gl_Position = local_vertex; // ohne Verarbeitung weitergeben
}
```

#codly.codly(header: [Fragment Shader])
```glsl
#version 130

uniform vec3 col;
out vec4 out_color;

void main() {
    out_color = vec4(col, 1); // immer gleiche Farbe
}
```

=== Datenmanagement

#codly.codly(header: [Uniform])
```c
glUniform1f(location, value);
glUniformMatrix4fv(location, amount, transpose, ptr);
```

== Error Handling

#codly.codly(header: [Debugging])
```c
glDebugMessageCallback
```
