#import "/deps.typ": cetz, diagraph, fletcher
#import "/style.typ": colors

#let fact(body, s: gray + 1pt) = {
  cetz.canvas({
    import cetz.draw: *
    content((), body, name: "body", padding: (4pt, 8pt))

    let (width, height) = measure(body)
    let displacement = width / 4
    set-style(stroke: s)
    set-style(stroke: (dash: "dashed"))
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
    dim_month -> dim_year [arrowhead=normal]

    fact_bundestagswahl_ergebnis
      fact_bundestagswahl_ergebnis -> dim_wahlkreis
          dim_wahlkreis -> measure_nr
          dim_wahlkreis -> measure_name
          dim_wahlkreis -> dim_keys_hist [arrowhead=normal]
              dim_keys_hist -> measure_fractions
          dim_wahlkreis -> dim_stadt [arrowhead=normal]
              dim_stadt -> dim_region [arrowhead=normal]
              dim_region -> dim_bundesland [arrowhead=normal]
      fact_bundestagswahl_ergebnis -> dim_partei
      fact_bundestagswahl_ergebnis -> dim_year
      fact_bundestagswahl_ergebnis -> measure_stimmen
      fact_bundestagswahl_ergebnis -> measure_anteil

    fact_sitzverteilung
      fact_sitzverteilung -> dim_partei
      fact_sitzverteilung -> dim_year
      fact_sitzverteilung -> measure_sitze
    // fact_abstimmung
    //   fact_abstimmung -> dim_date
    //       dim_date -> dim_day [arrowhead=normal]
    //           dim_day -> dim_month [arrowhead=normal]
    //           dim_month -> dim_year [arrowhead=normal]
    //     fact_abstimmung -> rel_sponsor
    //         rel_sponsor -> dim_partei
    //     fact_abstimmung -> rel_voting_behavior
    //         rel_voting_behavior -> dim_partei
    //     fact_abstimmung -> measure_result
    //     fact_abstimmung -> dim_abstimmungstyp
    fact_politbarometer
        fact_politbarometer -> dim_befragter
            dim_befragter -> measure_alter
            dim_befragter -> measure_geschlecht
            dim_befragter -> measure_berufsgruppe
            dim_befragter -> rel_wahlumfrage
                rel_wahlumfrage -> dim_partei
                rel_wahlumfrage -> measure_wahlabsicht
                rel_wahlumfrage -> measure_skalometer_partei
                rel_wahlumfrage -> dim_month
            dim_befragter -> rel_beurteilt
                rel_beurteilt -> dim_month
                rel_beurteilt -> measure_links_rechts
                rel_beurteilt -> measure_links
                rel_beurteilt -> measure_rechts
    fact_bundestagswahl_erhebung
        fact_bundestagswahl_erhebung -> dim_year
        fact_bundestagswahl_erhebung -> measure_wahlberechtigte
        fact_bundestagswahl_erhebung -> measure_waehlende
        fact_bundestagswahl_erhebung -> measure_gueltige
        fact_bundestagswahl_erhebung -> measure_ungueltige
    }
  ```,
  labels: it => {
    let text = str(it)
    let type = text.split("_").at(0)
    let body = text.split("_").slice(1).join("_")
    let fn = (
      "fact": it => fact(strong(it)),
      "dim": rect.with(stroke: colors.secondary.normal + 2pt),
      "rel": relation.with(s: colors.on_surface.light + 2pt),
      "measure": ellipse.with(stroke: colors.primary.normal + 2pt),
    ).at(type, default: box)

    fn(body)
  },
  engine: "neato",
)
