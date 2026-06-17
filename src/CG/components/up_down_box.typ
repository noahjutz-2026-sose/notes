#import "/deps.typ": tiptoe
#import tiptoe: *
#let up_down_box(content, title: none) = {
  let inner = 16pt
  let outer = 32pt
  block(
    inset: (x: outer, bottom: 4pt),
    stack(
      if title != none {
        rect(width: 100%)[
          #set align(center)
          #show: strong
          #title
        ]
      },
      block(
        stroke: (left: black, right: black),
        width: 100%,
        inset: (x: inner, top: if title != none { 8pt } else { 0pt }),
      )[
        #content
        #place(bottom + left, dx: -inner, dy: 4pt)[
          #line(tip: tiptoe.stealth, angle: 90deg, length: 1pt)
        ]
        #place(bottom + right, dx: inner, dy: 4pt)[
          #line(tip: tiptoe.stealth, angle: 90deg, length: 1pt)
        ]

      ],
    ),
  )
}
