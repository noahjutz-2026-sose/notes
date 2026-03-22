#import "@preview/gentle-clues:1.3.1": *
#import "@preview/cetz:0.4.2"

#set heading(numbering: "1.1")
#set page(numbering: "1")

#title[Computergrafik]

#outline()

#align(end)[2026-03-16]

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

#cetz.canvas({
  import cetz.draw: *
  line((0, 1), (0, 2))
})

In 3D: Vertexe definieren polygon nicht eindeutig, aber Dreiecke schon

- Bezier, B-Spline, ...
- Subdivision Surfaces