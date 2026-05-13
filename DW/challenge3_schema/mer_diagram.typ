#import "/deps.typ": cetz, diagraph, fletcher
#import "/style.typ": colors

#let fact(body, s: gray + 1pt) = {
  cetz.canvas({
    import cetz.draw: *
    content((), body, name: "body", padding: (4pt, 8pt))

    let (width, height) = measure(body)
    let displacement = 20pt // width / 4
    set-style(stroke: s)
    line(
      "body.north-east",
      (rel: (0, displacement), to: "body.north"),
      "body.north-west",
      "body.south-west",
      (rel: (0, -displacement), to: "body.south"),
      "body.south-east",
      close: true,
    )
    on-layer(-10, {
      line(
        "body.south-west",
        (rel: (0, displacement), to: "body.south"),
        "body.south-east",
      )
      line(
        (rel: (0, displacement), to: "body.south"),
        (rel: (0, displacement), to: "body.north"),
      )
    })
  })
}

#let relation(body, s: gray) = context {
  cetz.canvas({
    import cetz.draw: *
    content((), body, padding: (4pt, 8pt), name: "body")
    let (width, height) = measure(body)
    let displacement = 12pt // width / 4
    line(
      (rel: (0, -displacement), to: "body.south"),
      "body.east",
      (rel: (0, displacement), to: "body.north"),
      "body.west",
      close: true,
      stroke: s,
    )
  })
}

#diagraph.raw-render(
  ```
    digraph {
    rankdir=LR
    overlap=scalexy
    splines=curved
    node[shape=none, width=0, height=0, margin=0]
    edge[arrowhead=none]

    // Dimensionen
    dim_month -> dim_year [arrowhead=normal]
    dim_wahlkreis -> dim_stadt -> dim_region -> dim_bundesland [arrowhead=normal]

    // Fakten
    fact_bundestagswahl_ergebnis
        fact_bundestagswahl_ergebnis -> dim_wahlkreis
            dim_wahlkreis -> measure_nr
            dim_wahlkreis -> measure_name
            dim_wahlkreis -> dim_keys_hist [arrowhead=normal]
                dim_keys_hist -> measure_fractions
        fact_bundestagswahl_ergebnis -> dim_partei
        fact_bundestagswahl_ergebnis -> dim_year
        fact_bundestagswahl_ergebnis -> measure_stimmen
        fact_bundestagswahl_ergebnis -> measure_anteil

    fact_sitzverteilung
      fact_sitzverteilung -> dim_partei
      fact_sitzverteilung -> dim_year
      fact_sitzverteilung -> measure_sitze

    fact_politbarometer
        fact_politbarometer -> dim_befragter
            dim_befragter -> measure_alter
            dim_befragter -> measure_geschlecht
            dim_befragter -> measure_berufsgruppe
            dim_befragter -> measure_wirtschaftl_lage
            dim_befragter -> rel_wahlumfrage
                rel_wahlumfrage -> dim_partei
                rel_wahlumfrage -> measure_wahlabsicht
                rel_wahlumfrage -> measure_skalometer_partei
                rel_wahlumfrage -> measure_wahlrückerinnerung
                rel_wahlumfrage -> dim_month
            dim_befragter -> rel_beurteilung
                rel_beurteilung -> dim_month
                rel_beurteilung -> measure_wie_links_rechts
                rel_beurteilung -> measure_wie_links
                rel_beurteilung -> measure_wie_rechts
                rel_beurteilung -> measure_demokratiezufriedenheit
                rel_beurteilung -> measure_politikinteresse
                rel_beurteilung -> measure_wirtschaft
                rel_beurteilung -> measure_asylrecht
                rel_beurteilung -> measure_kernkraft
            // dim_befragter -> rel_kompetenzzuschreibung
            //     rel_kompetenzzuschreibung -> dim_thema
            //     rel_kompetenzzuschreibung -> dim_partei
            //     rel_kompetenzzuschreibung -> dim_month

    fact_bundestagswahl_erhebung
        fact_bundestagswahl_erhebung -> dim_year
        fact_bundestagswahl_erhebung -> measure_wahlberechtigte
        fact_bundestagswahl_erhebung -> measure_waehlende
        fact_bundestagswahl_erhebung -> measure_gueltige
        fact_bundestagswahl_erhebung -> measure_ungueltige
    }
  ```,
  labels: it => {
    let txt = str(it)
    let type = txt.split("_").at(0)
    let body = txt.split("_").slice(1).join("_")
    let dfn = (
      "fact": it => {
        set text(weight: "bold", size: 20pt)
        fact(it, s: colors.on_surface.transparenter + 4pt)
      },
      "dim": rect.with(stroke: colors.secondary.normal + 2pt),
      "rel": relation.with(s: colors.on_surface.light + 2pt),
      "measure": ellipse.with(stroke: colors.primary.normal + 2pt),
    ).at(type, default: box)

    dfn(body)
  },
  engine: "neato",
)
