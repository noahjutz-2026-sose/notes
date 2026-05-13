#import "/deps.typ": cetz, diagraph, fletcher
#import "/style.typ": colors

#let fact(body) = {
  cetz.canvas({
    import cetz.draw: *
    content((), body, name: "body", padding: (4pt, 8pt))

    let (width, height) = measure(body)
    let displacement = width / 4
    set-style(stroke: colors.on_surface.lighter)
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
        stroke: colors.on_surface.lighter,
      )
      line(
        (rel: (0, displacement), to: "body.south"),
        (rel: (0, displacement), to: "body.north"),
        stroke: colors.on_surface.lighter,
      )
    })
  })
}

#let relation(body) = context {
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
      stroke: colors.on_surface.lighter,
    )
  })
}

#diagraph.raw-render(
  ```
    digraph {
    rankdir=LR
    overlap=scalexy
    node[shape=none, width=0, height=0, margin=0]
    edge[arrowhead=none]
    fact_bundestagswahl
      fact_bundestagswahl -> dim_wahlkreis
          dim_wahlkreis -> measure_nr
          dim_wahlkreis -> measure_name
          dim_wahlkreis -> dim_keys_hist [arrowhead=normal]
              dim_keys_hist -> measure_fractions
          dim_wahlkreis -> dim_cities [arrowhead=normal]
              dim_cities -> dim_states [arrowhead=normal]
      fact_bundestagswahl -> dim_partei
      fact_bundestagswahl -> dim_year
      fact_bundestagswahl -> measure_stimmen
      fact_bundestagswahl -> measure_anteil
      fact_bundestagswahl -> measure_wahlberechtigte
      fact_bundestagswahl -> measure_waehlende
      fact_bundestagswahl -> measure_gueltige
      fact_bundestagswahl -> measure_ungueltige
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
        fact_politbarometer -> dim_month
        fact_politbarometer -> dim_respid
            dim_respid -> rel_wahlumfrage
                rel_wahlumfrage -> dim_partei
                rel_wahlumfrage -> measure_wahlabsicht
                rel_wahlumfrage -> measure_skalometer_partei
            dim_respid -> rel_demographie
                rel_demographie -> measure_alter
                rel_demographie -> measure_geschlecht
                rel_demographie -> measure_berufsgruppe
            dim_respid -> rel_beurteilungen
                rel_beurteilungen -> measure_links_rechts
                rel_beurteilungen -> measure_links
                rel_beurteilungen -> measure_rechts
    }
  ```,
  labels: it => {
    let text = str(it)
    let type = text.split("_").at(0)
    let body = text.split("_").slice(1).join("_")
    let fn = (
      "fact": fact,
      "dim": rect.with(stroke: colors.on_surface.lighter),
      "rel": relation,
      "measure": ellipse.with(stroke: colors.on_surface.lighter),
    ).at(type, default: box)

    fn(body)
  },
)
