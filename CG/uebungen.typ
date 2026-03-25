#import "/components.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/codly:1.3.0"

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
S &= N_triangle dot 3 S_V  \
&= N_triangle dot 3 dot (S_"pos" + S_"rgb") \
&= N_triangle dot 3 dot (3 dot S_"float" + 3 dot S_"float") \
&= 6 dot 3 dot (3 dot 4 + 3 dot 4) \
&= 432 "B"
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
    S &= N_I + N_V \
    &= 3 N_triangle dot S_"short" + 6 N_V dot S_"float" \
    &= 3 dot 6 dot 2 + 6 dot 8 dot 4 = 228 "B"
$

== Signed Distance

$
    triangle_1 &= ((0, 0), (16, 2), (12, 4)) \
    p_1 &= (7,1) \
    p_2 &= (11, 4) \
    p_3 &= (13, 3)
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
        mark: (end: "straight")
    )

    line(A, B, name: "AB")
    line(A, C, name: "AC")
    line(C, cetz.vector.add(C, B))
    line(B, cetz.vector.add(C, B))

    content(
        "AB",
        angle: "AB.end",
        anchor: "north",
        padding: 8pt
    )[$arrow(v_1 v_2)$]
    content(
            "AC",
            angle: "AC.end",
            anchor: "south",
            padding: 8pt
        )[$arrow(v_1 v_3)$]

    set-style(
        fill: red.transparentize(90%),
        stroke: none,
        mark: none
    )

    line(A, B, cetz.vector.add(C, B), C, close: true)

    set-style(
        fill: none,
        stroke: black,
    )

    cetz.angle.angle(A, B, C, radius: 120pt)
})

$
    det(mat(arrow(v_1 v_2),arrow(v_1 v_3)))
    &= det(mat(
        16-0, 12-0;
        2-0, 4-0
    )) \
    &= 16 dot 4 - 2 dot 12 = 40 \
    &> 1 => "CCW"
$

Die Punkte sind bereits CCW.

Als zweites muss für jeden jeden Punkt $p_i$ für jeden Eckpunkt $v_i$ geprüft werden:

$
    arrow(x) &:= arrow(v)_(i+1 mod 3) - arrow(v)_i quad ; quad
    arrow(w) &:= arrow(p) - arrow(x)/2 quad ; quad
    arrow(v)^tack.t &:= vec(-arrow(x)_2, +arrow(x)_1)
$

$
    abs(angle(arrow(w), arrow(v)^tack.t)) < pi/2
$

+ #[
    $p_1$
    + #[
        $ v_1 $
        $
            angle(arrow(w), arrow(v)^tack.t)
            &= arccos(
                (arrow(w) dot arrow(v)^tack.t) /
                (norm(arrow(w)) dot norm(arrow(v)^tack.t))
            ) \
            &= arccos(
                (-vec(-1, 0) dot vec(-2, 16)) /
                (sqrt(1) dot sqrt(260))
            ) \
            &= arccos(
                2/sqrt(260)
            ) \
            &approx 1.45 < pi/2
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
    + $v_3 : angle approx 1.39 < pi/2 $
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
