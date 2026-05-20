#import "/deps.typ": cetz
#import "/style.typ": *
#cetz.canvas(length: .4cm, {
    import cetz.draw: *

    let d = 10

    let shape = line.with(
        (1, 1),
        (2, 3),
        (3, 1),
        close: true,
    )

    let shape2 = line.with(
        (-7, 1),
        (-8, 3),
        (-9, 1),
        close: true,
    )

    let shape3 = line.with(
        (5, -7),
        (6, -5),
        (7, -7),
        close: true
    )

    ortho({
        on-layer(-1, {
            grid((-d, -d), (d, d), stroke: colors.on_surface.lighter)
        })
        set-style(mark: (end: "straight"), stroke: colors.on_surface.light)
        line((-d, 0), (d, 0))
        line((0, -d), (0, d))

        set-style(mark: none)

        let n = 1
        let lambda = 5
        for i in range(-(n * lambda), (n+1) * lambda) {
            i = i/lambda
            let kx = i
            let ky = i
            let kz = i

            let shear-z = cetz.matrix.ident(4)
            shear-z.at(2).at(0) = kx
            shear-z.at(2).at(1) = ky

            let shear-x = cetz.matrix.ident(4)
            shear-x.at(0).at(1) = ky
            shear-x.at(0).at(2) = kz

            let shear-y = cetz.matrix.ident(4)
            shear-y.at(1).at(0) = kx
            shear-y.at(1).at(2) = kz

            group({
                set-ctx(ctx => {
                    ctx.transform = cetz.matrix.mul-mat(ctx.transform, shear-z)
                    return ctx
                })

                shape(
                    stroke: red.transparentize(
                        100% - calc.pow(.3, calc.abs(i)) * 100%
                    )
                )
            })

            group({
                set-ctx(ctx => {
                    ctx.transform = cetz.matrix.mul-mat(ctx.transform, shear-x)
                    return ctx
                })

                shape3(
                    stroke: blue.transparentize(
                        100% - calc.pow(.3, calc.abs(i)) * 100%
                    )
                )
            })

            group({
                set-ctx(ctx => {
                    ctx.transform = cetz.matrix.mul-mat(ctx.transform, shear-y)
                    return ctx
                })

                shape2(
                    stroke: green.transparentize(
                        100% - calc.pow(.3, calc.abs(i)) * 100%
                    )
                )
            })
        }
        set-style(stroke: black)
        shape()
        shape2()
        shape3()
    })
})
