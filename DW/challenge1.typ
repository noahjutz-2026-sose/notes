#import "/template.typ": template_presentation
#import "/deps.typ": diagraph, touying
#import "/style.typ": *
#import touying: *

#show: template_presentation

// Ideas
// - CyberRunner params: Observation, Loss, Fps over time
// - GymRoutines, Orgzly over time
// - RVV/DB: Verspätungen Ursachen, Verbesserungen im Netz
// - Welche Autostraßen lohnen sich nicht aufrechtzuerhalten?
//
// Idea report: https://www.perplexity.ai/apps/21dccc17-f748-43d9-bb07-3bc24db7a125
// Datasets Palestine: https://www.perplexity.ai/apps/dc39b110-548b-46e3-ba80-76d3dc594608
// Clean datasets palestine: https://www.perplexity.ai/search/give-me-a-list-of-high-quality-r_tQkPkBQROegRvqSPw2_g

#slide[
  #align(horizon)[
    #title[Humanitäre Auswirkungen des Völkermords in Gaza]
  ]
  #align(bottom)[
    Noah Jutz \
    2026-04-28 \
    Data Warehousing #sym.dot OTH Regensburg
  ]
]

= Kurzbeschreibung

Welche Korrelationen gibt es zwischen

- Angriffen auf Infrastruktur und Zivilisten
- Güterpreise
- Sterblichkeit

= Relevanz

"Mit welcher Seite sympathisieren Sie im israelisch-palästinensischen Konflikt mehr?"

#image("assets/israel_sympathie.png", height: 1fr)

#align(
  end + bottom,
)[
  #set text(size: 10pt)
  https://www.stern.de/politik/ausland/-israel--umfrage-zeigt--wie-der-rueckhalt-in-europa-broeckelt-35784476.html
]

= Datenquellen

// #diagraph.raw-render(
//   ```
//   digraph {
//     node[shape=none,padding=0,width=0,height=0,margin=0]
//     rankdir=BT
//     "Government Media Office" -> "TechForPalestine" -> "infrastructure-damaged.json"
//     "Ministry Of Health" -> "TechForPalestine" -> "casualties-daily.json"
//   }
//   ```,
//   labels: rect.with(stroke: 2pt, inset: 6pt),
// )

== Hauptquellen

#table(
  columns: 4,
  table.header([], [*Format*], [*Dimensionen*], [*Measures*]),
  [TechForPalestine \ Daily Casualties], [JSON], [date, source], [killed, injured],
  [TechForPalestine \ Infrastructure Damaged], [JSON], [date, type], [destroyed],
  [UNOSAT Damage Assessment], [GDB], [date, location], [destroyed],
)

== Weitere Quellen

#table(
  columns: 2,
  table.header([*Quelle*], [*Warum*]),
  [PCBS Consumer Price Index], [Auswirkungen auf die Wirtschaft],
  [PCBS Prices of Basic Commodities], [Auswirkungen auf die Wirtschaft],
)

#pagebreak()

#[
  #set text(size: 7pt)
  #table(
    columns: 12,
    inset: 2pt,
    ..csv("assets/sources.tsv", delimiter: "\t")
      .flatten()
      .map(it => if it.len() < 20 { it } else { it.slice(0, 20) + "..." })
  )
]

\~ 1MB ohne Geo-/Bilddaten

= Schema

#diagraph.raw-render(
  ```
  digraph {
  node[shape=none,width=0,height=0,margin=0]
  edge[arrowhead=none]
  graph[overlap=none]
    casualties -> infrastructure_damages
    casualties -> commodity_price
    casualties -> damage_assessment

    infrastructure_damages -> commodity_price
    infrastructure_damages -> damage_assessment

    commodity_price -> damage_assessment
  }
  ```,
  engine: "neato",
  labels: it => {
    let c = (
      "casualties": (
        [CasualtiesDaily],
        [
          DATE date \
          INT amount
        ],
      ),
      "infrastructure_damages": (
        [InfrastructureDamages],
        [
          DATE date \
          INT academic \
          INT residential \
          INT worship
        ],
      ),
      "commodity_price": (
        [CommodityPrice],
        [
          DATE date \
          VARCHAR commodity \
          DOUBLE price
        ],
      ),
      "damage_assessment": (
        [DamageAssessment],
        [
          DATE date \
          POINT location \
          VARCHAR severity
        ],
      ),
    ).at(it, default: ())
    set text(font: "JetBrainsMono NF", size: 18pt)
    table(..c)
  },
)

= Queries

- Wie verändern sich bestimmte Produktpreise an Tagen mit hohen Opferzahlen?
- Werden Güter teurer, wenige Tage nachdem viele Gebäude zerstört wurden?
- An welchen Orten führen Angriffe zu hohen Personenschäden?

= Headline

"Forscher der OTH Regensburg findet heraus, dass die Zerstörung ziviler Infrastruktur in Gaza sofortige Preisexplosionen bei lebenswichtigen Gütern auslöst."
