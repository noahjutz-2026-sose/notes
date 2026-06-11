#import "/deps.typ": hi

// Icon
#let i = hi.with(solid: false)

// Bold vector with arrow
#let bva = it => math.bold(math.upright(math.arrow(it)))

// Bold vector
#let bv = it => math.bold(math.upright(it))

// Dot product
#let dp = (..c) => $lr(chevron.l #{ c.pos().join($,$) } chevron.r)$
