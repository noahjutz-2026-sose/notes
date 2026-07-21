#import "/components/sets.typ": *

#let math_set = math_set.with(shape: rect.with(inset: 20pt, radius: 10pt))

#set grid(align: center + horizon)

#math_set(title: [Transformationen])[
  #math_set(title: [Affine])[
    #grid(columns: 1, gutter: 12pt)[

    ][
      #math_set(title: [Lineare])[
        #grid(columns: 2, gutter: 12pt)[
          - Scherung
          - Skalierung
        ][
          #math_set(title: [Rigide])[
            #box(width: 120pt)[
              - Rotation
            ]
          ]
        ]
      ]
    ][
      #math_set(title: [Rigide])[
        #box(width: 120pt)[
          - Translation
        ]
      ]
    ]
  ]
]
