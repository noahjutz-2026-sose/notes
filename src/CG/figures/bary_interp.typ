#import "/deps.typ": cetz
#import "/style.typ": *

#cetz.canvas(length: .5cm, {
    import cetz.draw: *
    import cetz.vector as vec

    let A = (3, 14)
    let B = (16, 2)
    let C = (12, 12)

    let alpha = 1/3
    let beta = 1/3
    let gamma = 1/3

    let pA = vec.scale(A, alpha)
    let pB = vec.scale(B, beta)
    let pC = vec.scale(C, gamma)

    let p = vec.add(pA, vec.add(pB, pC))

    circle(
        p,
        radius: 2pt,
        fill: black
    )

    line(
        A, B, C,
        close: true,
        stroke: colors.on_surface.lighter
    )

    let p1 = pA
    let p2 = vec.add(p1, pB)
    let p3 = vec.add(p2, pC)

    set-style(mark: (end: "straight", stroke: (dash: "solid")))
    set-style(stroke: (paint: colors.on_surface.light, dash: "dashed"))
    line((0, 0), A)
    line((0, 0), B)
    line((0, 0), C)

    set-style(stroke: (paint: red, dash: "solid"))
    line((0, 0), p1, name: "alpha")
    line(p1, p2, name: "beta")
    line(p2, p3, name: "gamma")

    content("alpha")[$ #math.alpha = 1/3 $]
    content("beta")[$ #math.beta = 1/3 $]
    content("gamma")[$ #math.gamma = 1/3 $]
    content((0, 0))[$ (0, 0) $]
})
