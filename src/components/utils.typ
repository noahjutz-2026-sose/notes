#import "/deps.typ": hi, mannot
#import "/style.typ": colors

// Icon
#let i = hi.with(solid: false)

// Bold vector with arrow
#let bva = it => math.bold(math.upright(math.arrow(it)))

// Bold vector
#let bv = it => math.bold(math.upright(it))

// Dot product
#let dp = (..c) => $lr(chevron.l #{ c.pos().join($,$) } chevron.r)$

// Highlight anything
#let hl = (body, fill: colors.primary.lighter) => box(
  fill: fill,
  outset: 2pt,
  radius: 2pt,
  body,
)

#let markhl = mannot.markhl.with(radius: 2pt)
