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

=

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

Als erstes müssen die Eckpunkte des Dreiecks in eine CCW Reihenfolge gebracht werden.

$
    det(mat(arrow(A B);stretch(arrow(A C))))
$
