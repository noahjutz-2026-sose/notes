#import "/deps.typ": hi

#let i = hi.with(solid: false)

#let bv = it => math.bold(math.upright(math.arrow(it)))

#let dp = (..c) => $lr(chevron.l #{ c.pos().join($,$) } chevron.r)$
