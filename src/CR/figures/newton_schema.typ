#import "/deps.typ": cetz, fletcher

#let n = 3
#let i = range(n+1)

#let I = i.map(i => $#i$)
#let X = i.map(i => $x_#i$)
#let Y = i.map(i => $y_#i$)

#let coeff(irange) = $[#{irange.map(i => $x_#i$).join($,$)}]f$

#let divdiff(i, j) = {
    if i == j {
        return Y.at(i)
    }

    let minuend = coeff(range(i+1, j+1))
    let subtrahend = coeff(range(i, j - 1 + 1))

    return $(#minuend - #subtrahend) / (x_#j - x_#i)$
}

#cetz.canvas({
    import cetz.draw: *
})

#let diag(body,
    template: it => it,
    nodes: arguments(),
    edges: arguments()
) = {
    import fletcher: node, edge
    body(
        node.with(..nodes.named()),
        edge.with(..edges.named()),
        template
    )
}

#let diag_generic(nodes: arguments(), edges: arguments()) = {
    return diag.with(nodes: nodes, edges: edges)
}

#let common_args = (
    spacing: (1pt, 8pt)
)

#let diag = diag_generic.with(
    edges: arguments(
        marks: (none, ">")
    ),
)

#let diffdiagram(new, ..old) = fletcher.diagram(
    ..old.pos().map(old =>
        diag(
            edges: arguments(
                stroke: none,
            )
        )(old, template: text.with(gray)),
    ),
    diag(
        edges: arguments(
            stroke: black,
            marks: (none, ">")
        )
    )(new),
    ..common_args
)

#let iter0(node, edge, c) = {
    node((-3, -1), c[$i$])
    node((-2, -1), c[$x$])
    node((-1, -1), c[$y$])

    for i in range(4) {
        node((i, -1), width: 3.5cm, c[#coeff(range(0, i+1))])
    }

    for i in range(n+1) {
        node((-3, i), name: "i" + str(i), c[#I.at(i)])
    }
    for i in range(n+1) {
        node((-2, i), name: "x" + str(i), c[#X.at(i)])
    }
    for i in range(n+1) {
        node((-1, i), name: "y" + str(i), c[#Y.at(i)])
    }

}

#let iter1(node, edge, c) = {
    for i in range(n+1) {
        edge(label("y" + str(i)), auto)
        node((0, i), name: "f0_" + str(i), c[#Y.at(i)])
    }
}

#let iter_i(node, edge, c, i, j) = {
    let x_pos = j
    let y_offset = 0.5 * j

    let i_offset = i
    let j_offset = j

    for i in range(n+1 - j_offset) {
        let j = i + j_offset
        edge(label("f" + str(j_offset - 1) + "_" + str(i)), auto)
        // edge(label("x" + str(i)), auto)
        edge(label("f" + str(j_offset - 1) + "_" + str(i+1)), auto)
        // edge(label("x" + str(j)), auto)
        node(
            (x_pos, i + y_offset),
            name: "f" + str(j_offset) + "_" + str(i),
            c[#divdiff(i, j)])
    }
}

#let iter2(node, edge, c) = {
    iter_i(node, edge, c, 0, 1)
}

#let iter3(node, edge, c) = {
    iter_i(node, edge, c, 0, 2)
}
#let iter4(node, edge, c) = {
    iter_i(node, edge, c, 0, 3)
}

// #table(
//     diffdiagram(iter1, iter0),
//     diffdiagram(iter2, iter1, iter0),
//     diffdiagram(iter3, iter2, iter1, iter0),
//     diffdiagram(iter4, iter3, iter2, iter1, iter0)
// )

#fletcher.diagram(
    ..(iter4, iter3, iter2, iter1, iter0).map(it => diag()(it)), ..common_args
)
