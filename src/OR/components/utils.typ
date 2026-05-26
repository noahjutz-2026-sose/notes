#import "/deps.typ": cetz
#let s = i => (
  style: (
    stroke: (
      paint: cetz.palette.tango(i, stroke: true).stroke.paint,
      thickness: 8pt,
    ),
  ),
)
