#import "/components.typ": *
#import "/deps.typ": cetz, codly, mannot
#import "/style.typ": *
#import mannot: *

#align(end)[2026-03-20 TT01]

= Farben

#note(title: [Wiederholung Mathematik])[
  Orthogonale Matrix:
  - Jede Zeile und Spalte steht zu jeder anderen senkrecht
  - Jede Zeile und Spalte ist ein Einheitsvektor (Länge 1)
  - Spannt ein Koordinatensystem auf
  - Es gilt: $M^(-1) = M^T$
]

+ #[
    - Retina: Teil des Auges, das Licht aufnimmt und als Signale ans Gehirn schickt.
    - Fovea: Stelle in der Retina mit vielen Zapfen
  ]
+ Tristimulus: RGB
+ RGB ist additiv, CMY ist subtraktiv
+ 8 Bit $=>$ 0-255. Größere Ranges existieren auch
+ #[
    - Faul: $(1/3, 1/4, 1/5, 0)$

    - Effizient: $(2/15, 1/15, 0, 1/5)$
  ]

#align(end)[2026-03-27 TT02]

= Vertexe und Dreiecke

- _Signed Distance Raster Verfahren:_ Prüft, ob ein Punkt in einem konvexen Polygon ist. Für alle Kanten $arrow(v)$ im Uhrzeigersinn Winkel $phi$ zwischen Rechtsnormale und Punkt prüfen.
  $
    abs(phi) > pi/2 => "Punkt nicht im Polygon"
  $
- _Vertex:_ Punkt im 3D-Raum. $(arrow(v), arrow(N), arrow(t))$
- _Konkaves Polygon:_ #cetz.canvas({
    import cetz.draw: *
    line((0, 0), (1, 1), (2, 0), (1, 0.5), close: true)
  })
- Bei konvexen Polygonen schränkt jede Kante den Bereich weiter ein, in dem der Punkt sein darf, weil: Zwei Kanten haben immer einen Innenwinkel $<180degree$, und deshalb wird der Normalenvektor einer Kante immer "in die Mitte zeigen". Bei konkaven Polygonen können zwei Kanten einen Innenwinkel $>180 degree$ haben, und deshalb können die Normalenvektoren bei jeder Kante beliebig sein.

== Dreiecksnetz

$
  N_V = 8 quad
  N_triangle = 6
$

=== Sequentielle Liste Dreiecke

$
  S & = N_triangle dot 3 S_V \
    & = N_triangle dot 3 dot (S_"pos" + S_"rgb") \
    & = N_triangle dot 3 dot (3 dot S_"float" + 3 dot S_"float") \
    & = 6 dot 3 dot (3 dot 4 + 3 dot 4) \
    & = 432 "B"
$

=== Indexed Face Set

$
  V = (#range(1, 9).map(i => $v_#i$).join(","))
$

$
  I = (
    1, 3, 2,
    1, 4, 3,
    1, 5, 4,
    1, 8, 5,
    7, 5, 8,
    7, 6, 5
  )
$

#codly.local(header: [Pseudocode], lang-format: none)[
  ```c
  struct V {
      float x; float y; float z;
      float r; float g; float b;
  }
  struct V vectors[] = {
      { 0.0f, 0.0f, 0.0f,   1.0f, 0.0f, 0.0f },
      ...
  }
  int indices[] = {
      1, 3, 2, ...
  }
  ```
]

=== Größe Indexed Face Set

$
  S & = N_I + N_V \
    & = 3 N_triangle dot S_"short" + 6 N_V dot S_"float" \
    & = 3 dot 6 dot 2 + 6 dot 8 dot 4 = 228 "B"
$

== Signed Distance

$
  triangle_1 & = ((0, 0), (16, 2), (12, 4)) \
         p_1 & = (7,1) \
         p_2 & = (11, 4) \
         p_3 & = (13, 3)
$

Als erstes müssen die Eckpunkte $v_1, v_2, v_3$ des Dreiecks in eine CCW Reihenfolge gebracht werden.

#cetz.canvas(length: .5cm, {
  import cetz.draw: *
  let A = (0, 0)
  let B = (16, 2)
  let C = (12, 4)
  set-style(fill: gray, stroke: none, radius: 2pt)
  for (p, m) in (A, B, C).zip(($v_1$, $v_2$, $v_3$)) {
    circle(p)
    content(p, anchor: "north", padding: 4pt)[#m]
  }

  let p1 = (7, 1)
  let p2 = (11, 4)
  let p3 = (13, 3)
  for (p, m) in (p1, p2, p3).zip(($p_1$, $p_2$, $p_3$)) {
    circle(p)
    content(p, anchor: "north", padding: 4pt)[
      #set text(gray)
      #m
    ]
  }

  set-style(
    fill: none,
    stroke: (thickness: 1pt, paint: red, dash: "solid"),
    mark: (end: "straight"),
  )

  line(A, B, name: "AB")
  line(A, C, name: "AC")
  line(C, cetz.vector.add(C, B))
  line(B, cetz.vector.add(C, B))

  content(
    "AB",
    angle: "AB.end",
    anchor: "north",
    padding: 8pt,
  )[$arrow(v_1 v_2)$]
  content(
    "AC",
    angle: "AC.end",
    anchor: "south",
    padding: 8pt,
  )[$arrow(v_1 v_3)$]

  set-style(
    fill: red.transparentize(90%),
    stroke: none,
    mark: none,
  )

  line(A, B, cetz.vector.add(C, B), C, close: true)

  set-style(
    fill: none,
    stroke: black,
  )

  cetz.angle.angle(A, B, C, radius: 120pt)
})

$
  det(mat(arrow(v_1 v_2), arrow(v_1 v_3))) & = det(
                                               mat(
                                                 16-0, 12-0;
                                                 2-0, 4-0
                                               )
                                             ) \
                                           & = 16 dot 4 - 2 dot 12 = 40 \
                                           & > 1 => "CCW"
$

Die Punkte sind bereits CCW.

Als zweites muss für jeden jeden Punkt $p_i$ für jeden Eckpunkt $v_i$ geprüft werden:

$
  arrow(x) & := arrow(v)_(i+1 mod 3) - arrow(v)_i quad ; quad
             arrow(w) & := arrow(p) - arrow(x)/2 quad ; quad
                        arrow(v)^tack.t & := vec(-arrow(x)_2, +arrow(x)_1)
$

$
  abs(angle(arrow(w), arrow(v)^tack.t)) < pi/2
$

+ #[
    $p_1$
    + #[
        $ v_1 $
        $
          angle(arrow(w), arrow(v)^tack.t) & = arccos(
                                               (arrow(w) dot arrow(v)^tack.t) /
                                               (norm(arrow(w)) dot norm(arrow(v)^tack.t))
                                             ) \
                                           & = arccos(
                                               (-vec(-1, 0) dot vec(-2, 16)) /
                                               (sqrt(1) dot sqrt(260))
                                             ) \
                                           & = arccos(2/sqrt(260)) \
                                           & approx 1.45 < pi/2
        $
      ]
    + $ v_2 : angle approx 0.83 < pi/2 $
    + $ v_3 : angle approx 0.46 < pi /2 $
  ]
+ #[
    $p_2$
    + $ v_1 : angle approx 0.9 < pi/2 $
    + $ v_2 : angle approx 1.42 < pi/2 $
    + $ v_3 : angle approx 1.63 > pi/2 arrow.zigzag $
  ]
+ #[
    $p_3$
    + $ v_1 : angle approx 1.31 < pi/2 $
    + $ v_2 : angle approx 1.1 < pi/2 $
    + $v_3 : angle approx 1.39 < pi/2$
  ]

#code(title: [Winkelberechnung])[
  ```py
  """
  Args:
      vi: Index of the starting corner point
      p: x,y coordinate of point outside/inside triangle
  """
  def angle(vi, p):
      vectors = [v1, v2, v3]
      v = vectors[vi]
      v_next = vectors[(vi+1)%3]
      x = v_next - v
      w = p - (v+x/2)
      x_norm = np.array([-x[1], x[0]])
      angle = np.arccos(
          (w @ x_norm) / (np.linalg.norm(w) * np.linalg.norm(x_norm))
      )
      return angle
  ```
]

== Asymptote

=== raster_signed_distance

Siehe #link("https://github.com/noahjutz-2026-sose/cg-ue01/blob/d7813c99a6d1761914f2125729ae45782330770e/raster-sd1.asy#L74-L96")[cg-ue01/raster-sd1.asy]

=== Konservative Rasterisierung

Man muss nicht nur den Mittelpunkt, sondern auch die Größe des Pixels wissen.

Implementierung: Siehe #link("https://github.com/noahjutz-2026-sose/cg-ue01/blob/85191ac5da4ec5e00f3fa287b4c7fe89afecc639/raster-sd1.asy#L78-L111")[cg-ue01/raster-sd01.asy]

=== Bounding Box Optimierung

Implementierung: Siehe #link("https://github.com/noahjutz-2026-sose/cg-ue01/blob/0728bcc23bec8cabe69011dcd4ce3b2dad5145f8/raster-sd1.asy#L76-L81")[cg-ue01/raster-sd01.asy]

Zeitmessung (500x500):

```sh
$ time asy -f pdf raster-sd1.asy # without optimization

________________________________________________________
Executed in    7.82 secs    fish           external
   usr time   13.13 secs    0.00 millis   13.13 secs
   sys time    0.51 secs    1.44 millis    0.51 secs

$ time asy -f pdf raster-sd1.asy # with optimization

________________________________________________________
Executed in    6.03 secs    fish           external
   usr time   10.40 secs    0.48 millis   10.40 secs
   sys time    0.50 secs    1.10 millis    0.49 secs
```

#align(end)[2026-04-10 TT03]

= Interpolation und Transformationen

- _Lineare Interpolation:_ Mittelwerte zwischen zwei diskreten Werten ermitteln, z.B. Pfad zwischen zwei Punkten.
- Bei einer _Scherung_ verschieben sich Punkte immer mehr um den fixen Faktor,
  - x: desto größer der y- oder z-Wert ist
  - y: desto größer der x- oder z-Wert ist
  - z: desto größer der x- oder y-Wert ist.

== Bayzentrische Koordinaten

Die Bayzentrischen Koordinaten sind gegeben durch

$
           p & = alpha A + beta B + gamma C \
  vec(13, 3) & = alpha vec(0, 0) + beta vec(16, 2) + gamma vec(12, 4)
$

Das lineare Gleichungssystem ist

$
  & mat(
      augment: #{ -1 },
      0, 16, 12, 13;
      0, 2, 4, 3
    )
    -> & mat(
           augment: #{ -1 },
           0, 1, 3/4, 13/16;
           0, 2, 4, 3
         )
         -> & mat(
                augment: #{ -1 },
                0, 1, 3/4, 13/16;
                0, 0, 2 1/2, 1 3/8
              )
              -> & mat(
                     augment: #{ -1 },
                     0, 1, 3/4, 13/16;
                     0, 0, 1, 11/20
                   )
                   -> & mat(
                          augment: #{ -1 },
                          0, 1, 0, 2/5;
                          0, 0, 1, 11/20
                        )
$

Das heißt

$
  beta = 2/5 quad ; quad
  gamma = 11/20 quad ; quad
  alpha = 1 - (beta + gamma) = 1/20
$

Die Baryzentrischen Koordinaten von $p$ sind also

$
  p = "bary"(1/20, 2/5, 11/20)
$

Der interpolierte Wert ist

$
  vec(alpha, beta, gamma) dot vec(m_1, m_2, m_3) & = 1/20 dot 1/2 + 2/5 dot 1/3 + 11/20 dot 1/4 & = 71/240
$

== Lineare Interpolation

Ich benenne Variablen um:
$
  p_1 =: p quad ; quad
  p_2 =: q quad ; quad
  (5, 3)^T =: r
$

Kartesische Koordinaten von $p$ und $q$:

#grid(columns: (1fr,) * 2)[
  $
    p & = a + lambda_p arrow(a c) \
      & = a + abs((a_2-r_2)/(a_2-c_2)) arrow(a c) \
      & = vec(1, 1) + 1/2 vec(5-1, 5-1) \
      & = vec(3, 3)
  $
][
  $
    q & = b + lambda_q arrow(b c) \
      & = b + abs((b_2-r_2)/(b_2-c_2)) arrow(b c) \
      & = vec(7, -1) + 2/3 vec(5-7, 5+1) \
      & = vec(5 2/3, 3)
  $
]

Linear Interpolierte Werte von $p$ und $q$:

#grid(columns: (1fr,) * 2)[
  $
    alpha(p) & = alpha(a) + lambda_p (alpha(c) - alpha(a)) \
             & = 4 + 1/2 (12-4) \
             & = 8
  $
][
  $
    alpha(q) & = alpha(b) + lambda_q (alpha(c) - alpha(b)) \
             & = 9 + 2/3 (12-9) \
             & = 11
  $
]

Linear interpolierter Wert von $r$:

#grid(columns: (1fr,) * 2)[
  $
    lambda_r & = abs((p_1-r_1)/(p_1 - q_1)) \
             & = 2/(2 2/3) \
             & = 3/4
  $
][
  $
    alpha(r) & = alpha(p) + lambda_r (alpha(q) - alpha(p)) \
             & = 8 + 3/4 (11-8) \
             & = markhl(10 1/4, color: #green)
  $
]

#alternative(title: [Interpolation zwischen a und b])[
  Sei $s$ der Punkt auf $arrow(a b)$ mit $x=5$.

  $
    s & = a + lambda_s arrow(a b) \
      & = a + abs((a_1-r_1)/(a_1-b_1)) arrow(a b) \
      & = vec(1, 1) + 2/3 vec(7-1, -1-1) \
      & = vec(5, -1/3)
  $

  Das Attribut in $s$ ist demnach

  $
    alpha(s) & = alpha(a) + lambda_s (alpha_b-alpha(a)) \
             & = 4 + 2/3 (9-4) \
             & = 7 1/3
  $

  Somit

  $
    alpha(r) & = alpha(s) + lambda_r (alpha(c) - alpha(s)) \
             & = alpha(s) + abs((s_2-r_2)/(s_2-c_2)) (alpha(c) - alpha(s)) \
             & = 7 1/3 + 5/8 (12 - 7 1/3) \
             & = markhl(10 1/4, color: #green)
  $
]

== Transformationen

#cetz.canvas(length: .5cm, {
  import cetz.draw: *

  let unitsquare = line.with(
    (0, 0),
    (1, 0),
    (1, 1),
    (0, 1),
    close: true,
  )

  let dimens = (
    (-1, -1),
    (20, 10),
  )

  grid(
    (dimens.at(0).at(0), dimens.at(0).at(1)),
    (dimens.at(1).at(0), dimens.at(1).at(1)),
    stroke: colors.on_surface.lighter,
  )

  set-style(
    stroke: colors.on_surface.light,
    mark: (end: "straight"),
  )

  line((dimens.at(0).at(0), 0), (dimens.at(1).at(0), 0))
  line((0, dimens.at(0).at(1)), (0, dimens.at(1).at(1)))

  set-style(stroke: black, mark: none)

  group({
    let stroke = red
    for (i, op) in (
      scale.with(5),
      translate.with((3, 0)),
      rotate.with(35deg),
    ).enumerate() {
      op()
      unitsquare(stroke: stroke.transparentize(100% * i / 3))
    }
  })

  group({
    let stroke = green
    for (i, op) in (
      translate.with((3, 0)),
      rotate.with(35deg),
      scale.with(5),
    ).enumerate() {
      op()
      unitsquare(stroke: stroke.transparentize(100% * i / 3))
    }
  })

  group({
    let stroke = blue
    for (i, op) in (
      rotate.with(35deg),
      translate.with((3, 0)),
      scale.with(5),
    ).enumerate() {
      op()
      unitsquare(stroke: stroke.transparentize(100% * i / 3))
    }
  })

  unitsquare()
})

Weil der Raum des blauen Quadrats zuerst rotiert wurde, geschah die Translation (Verschiebung) um eine rotierte x-Achse. Dadurch landet das Quadrat weiter oben und links.

#align(end)[2026-04-14]

= Transformationsmatrizen

+ Ja
+ Nein
+ $I$
+ 0: Unendlich weit weg, 1: Liegt auf der Projektionsebene
+ #[
    $
      mat(
        A, t;
        0^T, 1
      )
    $

    In 5D: $A=(a_(i j))_(0 <= i <= 5\ 0 <= j <= 5)$
  ]

== Konkatenation

=== Nicht-Homogen

#clue[
  $
       A_1A_2 & = mat(1, 1/2; 0, 1) mat(1, 0; 0, 1)
                = mat(1, 1/2; 0, 1) \
    A_1A_2A_3 & = mat(1, 1/2; 0, 1) mat(4, 0; 0, 4)
                = mat(4, 2; 0, 4)
  $
]

$
  T_1(T_2(T_3(x))) & = (T_1 compose T_2 compose T_3)(x) \
                   & = A_1 (A_2 (A_3x + t_3) + t_2) + t_1 \
                   & = A_1A_2A_3x + A_1A_2t_3 + A_1t_2 + t_1 \
                   & = mat(4, 2; 0, 4)x + mat(1, 1/2; 0, 1) vec(0, 0) + mat(1, 1/2; 0, 1) vec(2, 2) + vec(0, 0) \
                   & = mat(4, 2; 0, 4)x + vec(3, 2)
$

=== Homogen

$
  A_1 = mat(
    1, 1/2, 0;
    0, 1, 0;
    0, 0, 1
  ) quad
  A_2 = mat(
    1, 0, 2;
    0, 1, 2;
    0, 0, 1
  ) quad
  A_3 = mat(
    4, 0, 0;
    0, 4, 0;
    0, 0, 1
  )
$

#clue[
  $
    A_1A_2A_3 & = mat(
                  1, 1/2, 0;
                  0, 1, 0;
                  0, 0, 1
                ) mat(
                  1, 0, 2;
                  0, 1, 2;
                  0, 0, 1
                ) mat(
                  4, 0, 0;
                  0, 4, 0;
                  0, 0, 1
                ) \
              & = mat(
                  1, 1/2, 0;
                  0, 1, 0;
                  0, 0, 1
                ) mat(
                  4, 0, 2;
                  0, 4, 2;
                  0, 0, 1
                ) \
              & = mat(
                  4, 2, 3;
                  0, 4, 2;
                  0, 0, 1
                )
  $
]

$
  T_1(T_2(T_3(x))) & = A_1A_2A_3x \
$

$
  vec(0, 0, 1) -> vec(3, 2, 1) quad quad
  vec(1, 0, 1) -> vec(7, 2, 1) quad quad
  vec(1, 1, 1) -> vec(9, 6, 1) quad quad
  vec(0, 1, 1) -> vec(5, 6, 1)
$

=== Andere Reihenfolge

#clue[
  $
    A_2A_1A_3 & = mat(
                  1, 0, 2;
                  0, 1, 2;
                  0, 0, 1
                ) mat(
                  1, 1/2, 0;
                  0, 1, 0;
                  0, 0, 1
                ) mat(
                  4, 0, 0;
                  0, 4, 0;
                  0, 0, 1
                ) \
              & = mat(
                  1, 1/2, 2;
                  0, 1, 2;
                  0, 0, 1
                ) mat(
                  4, 0, 0;
                  0, 4, 0;
                  0, 0, 1
                ) \
              & = mat(
                  4, 2, 2;
                  0, 4, 2;
                  0, 0, 1
                )
  $
]

$
  vec(0, 0, 1) -> vec(2, 2, 1) quad quad
  vec(1, 0, 1) -> vec(6, 2, 1) quad quad
  vec(1, 1, 1) -> vec(8, 6, 1) quad quad
  vec(0, 1, 1) -> vec(4, 6, 1)
$

== Rotationsmatrix

Um um den Ursprung $o$ zu rotieren, müssen wir zu $o$ verschieben, rotieren, und um $-o$ zurückverschieben.

#cetz.canvas(length: .25cm, {
  import cetz.draw: *

  let dim = 5

  let bggrid = grid.with(
    (-dim, -dim),
    (dim, dim),
    stroke: colors.on_surface.lighter,
  )

  bggrid()

  let point = circle.with(stroke: none, fill: black, radius: 2pt)

  point((2, 4))

  let axes = () => {
    set-style(mark: (end: ">", stroke: (dash: "solid")))
    line((-dim, 0), (dim, 0))
    line((0, -dim), (0, dim))
  }
  axes()

  group({
    set-style(stroke: colors.on_surface.light)
    line((0, 0), (2, 4))
    set-style(stroke: (dash: "dashed"))
    translate((2, 4))
    axes()
  })

  content((0, -dim - 1), anchor: "north")[1]

  translate((2 * dim + 4, 0))

  bggrid()
  axes()
  point((0, 0))

  group({
    set-style(stroke: colors.on_surface.light)
    arc((0, 0), start: 0deg, stop: 45deg, radius: 20pt, anchor: "origin")
    rotate(45deg)
    set-style(stroke: (dash: "dashed"))
    axes()
  })

  content((0, -dim - 1), anchor: "north")[2]

  translate((2 * dim + 4, 0))

  bggrid()
  axes()
  point((0, 0))

  group({
    set-style(stroke: colors.on_surface.light)
    line((0, 0), (-2, -4))
    set-style(stroke: (dash: "dashed"))
    translate((-2, -4))
    axes()
  })

  content((0, -dim - 1), anchor: "north")[3]
})

Die homogenen Transformationsmatrizen der drei Schritte sind:

#table(
  columns: 3,
  table.header($A_1$, $A_2$, $A_3$),
  $
    mat(
      1, 0, o_1;
      0, 1, o_2;
      0, 0, 1;
    ) & = mat(
          1, 0, 1;
          0, 1, 1;
          0, 0, 1
        )
  $,
  $
    mat(
      cos Phi, -sin Phi, 0;
      sin Phi, cos Phi, 0;
      0, 0, 1
    ) & = mat(
          sqrt(2)/2, -sqrt(2)/2, 0;
          sqrt(2)/2, sqrt(2)/2, 0;
          0, 0, 1
        )
  $,
  $
    mat(
      1, 0, -o_1;
      0, 1, -o_2;
      0, 0, 1;
    ) & = mat(
          1, 0, -1;
          0, 1, -1;
          0, 0, 1
        )
  $,
)

Konkateniert lautet die Transformation

$
  A_1A_2A_3 & = mat(
                1, 0, 1;
                0, 1, 1;
                0, 0, 1
              ) dot mat(
                sqrt(2)/2, -sqrt(2)/2, 0;
                sqrt(2)/2, sqrt(2)/2, 0;
                0, 0, 1
              ) dot mat(
                1, 0, -1;
                0, 1, -1;
                0, 0, 1
              ) \
            & = mat(
                sqrt(2)/2, sqrt(2)/2, 1;
                sqrt(2)/2, sqrt(2)/2, 1;
                0, 0, 1
              ) dot mat(
                1, 0, -1;
                0, 1, -1;
                0, 0, 1
              ) \
            & = mat(
                sqrt(2)/2, sqrt(2)/2, -sqrt(2)+1;
                sqrt(2)/2, sqrt(2)/2, -sqrt(2)+1;
                0, 0, 1
              )
$

Der Punkt $p = vec(2, 4)$ ist also transformiert

$
  mat(
    sqrt(2)/2, sqrt(2)/2, -sqrt(2)+1;
    sqrt(2)/2, sqrt(2)/2, -sqrt(2)+1;
    0, 0, 1
  ) dot vec(2, 4, 1) & = vec(
                         2 sqrt(2) + 1,
                         2 sqrt(2) + 1,
                         1
                       )
$

Visualisierung:

#cetz.canvas(length: 0.25cm, {
  import cetz.draw: *

  let bounds = 5

  grid(
    (-bounds, -bounds),
    (bounds, bounds),
    stroke: colors.on_surface.lighter,
  )

  let o = (1, 1)
  let p = (2, 4)

  set-style(stroke: none, fill: black)
  circle(o, radius: 2pt)
  content((), anchor: "north", padding: 8pt)[$o$]
  circle(p, radius: 2pt, fill: gray)
  content((), anchor: "north", padding: 8pt)[$p$]

  let s2 = calc.sqrt(2)

  set-transform((
    (s2 / 2, s2 / 2, 0, -s2 + 1),
    (s2 / 2, -s2 / 2, 0, -s2 + 1),
    (0, 0, 1, 0),
    (0, 0, 0, 1),
  ))

  circle(p, radius: 2pt, fill: colors.primary.normal)
  content((), anchor: "north", padding: 8pt)[$p'$]
})

== Komposition 3D-Rotationsmatrix

#note(title: [Einheitskreis])[
  $
    (x, y) = (cos theta, sin theta)
  $
  #include "figures/unit_circle.typ"
]

#further(title: [arcsin und arccos], width: 50%)[
  #link("https://www.desmos.com/calculator/sxjpz2cb63")[Desmos]
]

#[
  #show sym.alpha: text.with(red)
  #show sym.beta: text.with(green)
  #show sym.gamma: text.with(blue)
  #show "cos": math.bold
  #show "sin": math.italic

  $
    R & = R_X (alpha) R_Z (beta) R_X (gamma) \
      & = mat(
          1, 0, 0;
          0, cos alpha, -sin alpha;
          0, sin alpha, cos alpha
        ) dot mat(
          cos beta, -sin beta, 0;
          sin beta, cos beta, 0;
          0, 0, 1
        ) dot mat(
          1, 0, 0;
          0, cos gamma, -sin gamma;
          0, sin gamma, cos gamma
        ) \
      & = mat(
          cos beta, -sin beta, 0;
          cos alpha sin beta, cos alpha cos beta, -sin alpha;
          sin alpha sin beta, sin alpha cos beta, cos alpha
        ) dot mat(
          1, 0, 0;
          0, cos gamma, -sin gamma;
          0, sin gamma, cos gamma
        ) \
      & = mat(
          cos beta, -sin beta cos gamma, (-sin beta) (-sin gamma);
          cos alpha sin beta, cos alpha cos beta cos gamma + (-sin alpha) sin gamma, cos alpha cos beta (-sin gamma) + (-sin alpha) cos gamma;
          sin alpha sin beta, sin alpha cos beta cos gamma + cos alpha sin gamma, sin alpha cos beta (-sin gamma) + cos alpha cos gamma
        )
  $
]

$beta$ berechnen:

$
   R_(1 1) & = M_(1 1) \
  cos beta & = 0 \
      beta & = arccos 0 \
           & = plus.minus pi/2
$

Wähle $beta = +pi/2 in [0, pi]$. $alpha$ berechnen, indem wir $beta$ einsetzen:

$
  M_(2 1) & = R_(2 1) \
     -0.5 & = cos alpha sin beta \
     -0.5 & = cos alpha sin pi/2 \
     -0.5 & = cos alpha \
    alpha & = arccos -0.5 \
          & = (2pi)/3
$

$gamma$ berechnen, indem wir $beta$ einsetzen:

$
  M_(1 2) & = R_(1 2) \
        0 & = -sin beta cos gamma \
        0 & = -sin pi/2 cos gamma \
        0 & = -cos gamma \
        0 & = cos gamma \
    gamma & = arccos 0 \
    gamma & = pi/2
$

#box(fill: green.transparentize(50%), inset: 4pt)[
  $
    alpha = (2pi)/3 quad quad
    beta = pi/2 quad quad
    gamma = pi/2
  $
]

== Gimbal Lock

Der Raum hat sich um $90degree$ um die x-Achse rotiert. Die y- und z-Achse "tauschen" ihre Rolle.

== Winkel kodieren

Ein Winkel ist ein $alpha in [0, 360]$ bzw. $alpha in [0, 2pi]$, allgemeiner ein Faktor $alpha in [0, 1]$ einer gesamten Rotation (Annahme: Anzahl Rotationen ist uns egal).

Um einen Winkel so fein granular in einer Zahl $x$ mit $n$ bits zu speichern, bilde ich den Wertebereich ${0, 1, ..., 2^n-1}$ linear auf eine Kreisrotation $alpha in [0, 360]$ bzw. $alpha in [0, 2pi]$ ab.

$
  alpha_deg = x/(2^n-1) dot 360degree quad quad "bzw." quad quad
  alpha_"rad" = x/(2^n-1) dot 2pi
$

Konkrete implementierung mit 32 bit:

#codly.codly(header: [degrees_datastructure])
```c
uint32_t angles;

uint32_t push_angle(uint32_t angles, double deg) {
    double frac = (double) (1 << 10) / 360;
    int enc = round(frac * deg);
    enc &= (1 << 10) - 1;

    angles <<= 11;
    angles |= enc;
    return angles;
}
```

== Asymptote Rotation

Siehe #link("https://github.com/noahjutz-2026-sose/practice/blob/da4a3d6907dcc10ddb0939c9616c458a9cbbea52/CG/ue04/solar.asy")[practive/CG/ue04].

#align(end)[2026-04-28]

= Projektion

- Nlerp stellt die länge wieder her, wodurch das Objekt unter Rotation rigide bleibt. Dabei ist die Interpolationsgeschwindigkeit nicht linear.
- Slerp rotiert um einen Ursprung, ist also zeitlich linear.
- $
    mat(
      a_(1 1), a_(1 2), a_(1 3), a_(1 4), t_1;
      a_(2 1), a_(2 2), a_(2 3), a_(2 4), t_2;
      a_(3 1), a_(3 2), a_(3 3), a_(3 4), t_3;
      a_(4 1), a_(4 2), a_(4 3), a_(4 4), t_4;
      0, 0, 0, 0, 1
    )
  $
- Viewing Direction $g$ und Up Vector $t$
- Viewing Direction Vector hat einen Rotationsfreiheitsgrad. Durch $t$ eingeschränkt.
- nearest und farthest.
- Orthographisch: Entfernte Objekte werden nicht kleiner. Perspektivisch: Distanz zur Kamera wird berücksichtigt
- Orth.: Diagonale Matrix. Perspektivisch: Translation.
- #[
    $
      h = t = -b = n tan theta/2 quad ; quad
      w = r = -l = a n tan theta/2
    $
  ]
- #[
    Extrinsische Parameter: View-Matrix

    Intrinsische Parameter: Projektionsmatrix
  ]

== Slerp

Siehe #link("https://github.com/noahjutz-2026-sose/practice/blob/ccbd5dfd868dbedbff902eb86b182561998c6cfe/CG/ue05/slerp.asy#L48-L54")[CG/ue05].

== Eyespace

Nichts zu tun

== Projektionsmatrix und Viewport-Matrix

$
  P = mat(
    0.1, 0, 0, 0;
    0, 0.2, 0, 0;
    0, 0, -0.02, -1.02;
    0, 0, 0, 1;
  ) quad quad
  W = mat(
    960, 0, 0, 960;
    0, 540, 0, 540;
    0, 0, 50, 51;
    0, 0, 0, 1
  )
$

Siehe #link("https://github.com/noahjutz-2026-sose/practice/blob/ef6b3849b03f76d58514e82117a5f8ad2c0993c9/CG/ue05/projection.m")[CG/ue05/projection.m].

== Frustumsgrenze

#figure[
  #image("assets/frustum.png", width: 50%)
]

#cetz.canvas(length: .5cm, {
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

  set-style(stroke: colors.primary.normal)
  line((-2, -2), (2, -2))
  line((-6, -6), (6, -6))

  set-style(stroke: (paint: black, dash: "dashed"))
  line((0, 0), (0, -6))
})

$
  z' & = (n+f)/(n-f) z + (2f n)/(n-f) \
   z & = (z' - (2f n)/(n - f))/((n+f)/(n-f)) \
     & = z' (n-f)/(n+f) - (2f n)/(n+f) \
$

$
  x_max (z') & = r/n dot z \
$

TODO fertig machen

== C++ Rendering Pipeline

=== NDC

=== Perspectiv-Projektion

=== Camera Space

== Depth Buffer

#align(end)[2026-05-14]

= OpenGL

+ Binding Points sind Schnittstellen an GPU, um Daten von RAM in GPU buffer zu laden.
+ Weil batch-übertragen großer Buffers die Latenz zwischen CPU, PCIe und GPU nur einmal verursacht
+ _Vertex Buffer Object:_ Enthält für jeden Vertex 3 Floats. _Index Buffer Object:_ Enthält für jedes Dreieck drei Indexe auf VBO.
+ _Vertex Shader:_ Vertextransformation (Funktion für jeden Vertex). _Fragment Shader:_ Funktion Für jeden Pixel im Raster
+ Vertex Shader: `in vec3 local_vertex -> gl_Position`. Fragment Shader: `in vec3 color -> out vec4 out_color`
