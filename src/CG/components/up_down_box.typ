#import "/deps.typ": tiptoe
#import tiptoe: *
#let up_down_box(content) = {
  let inner = 16pt
  let outer = 32pt
  block(
    inset: (x: outer),
    block(
      stroke: (left: black, right: black),
      width: 100%,
      inset: (x: inner),
    )[
      #place(bottom + left, dx: -inner, dy: 4pt)[
        #line(tip: tiptoe.stealth, angle: 90deg, length: 1pt)
      ]
      #place(bottom + right, dx: inner, dy: 4pt)[
        #line(tip: tiptoe.stealth, angle: 90deg, length: 1pt)
      ]

      #content
    ],
  )
}
