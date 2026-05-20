#import "/deps.typ": cetz

// AI Generated function
#let squircle(body, n: 6) = context {
  let size = measure(body)

  let k = calc.pow(2, 1 / n)
  let a = size.width * k / 2
  let b = size.height * k / 2

  let sign(v) = if v < 0 { -1 } else { 1 }

  let pts = range(0, 360, step: 2).map(deg => {
    let theta = deg * 1deg
    let c = calc.cos(theta)
    let s = calc.sin(theta)

    let cx = calc.pow(calc.abs(c), 2 / n)
    let cy = calc.pow(calc.abs(s), 2 / n)

    let x = a * cx * sign(c)
    let y = b * cy * sign(s)

    (x, y)
  })

  cetz.canvas({
    import cetz.draw: *
    line(..pts, close: true)
    content((0, 0), body)
  })
}

#let math_set(body, title: none, shape: squircle) = box(context {
  set block(spacing: 4pt)
  set par(spacing: 4pt)
  stack(
    if title != none {
      let (width, height) = measure(title)
      box(height: height / 2)
    },
    shape(body),
  )
  if title != none {
    place(top + center, box(fill: white, title))
  }
})
