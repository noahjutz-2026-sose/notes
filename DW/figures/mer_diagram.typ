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

    // Dimensionen
    edge[dir=both arrowhead=normal arrowtail=crow]
    dim_month -> dim_year
    dim_wahlkreis -> dim_stadt -> dim_region -> dim_bundesland
    dim_respondent -> dim_bundesland
    dim_respondent -> dim_party
    dim_respondent -> dim_age
    dim_respondent -> dim_sex
    dim_respondent -> dim_occupation
    dim_respondent -> dim_financial_situation
    dim_respondent -> dim_marital_status
    dim_respondent -> dim_employment_status
    dim_respondent -> dim_is_unionized

    edge[dir=both arrowhead=none arrowtail=none]

    // Attribute

    // Fakten
    fact_election_result
        fact_election_result -> dim_wahlkreis
            dim_wahlkreis -> measure_wahlkreisnr
            dim_wahlkreis -> measure_wahlkreisname
            // dim_wahlkreis -> dim_keys_hist [arrowhead=normal]
            //     dim_keys_hist -> measure_fractions
        fact_election_result -> dim_party
        fact_election_result -> dim_year
        fact_election_result -> measure_votes
        fact_election_result -> measure_percentage

    fact_seat_distribution
      fact_seat_distribution -> dim_party
      fact_seat_distribution -> dim_year
      fact_seat_distribution -> measure_seats

    fact_politbarometer_election_poll
        fact_politbarometer_election_poll -> dim_party
        fact_politbarometer_election_poll -> dim_month
        fact_politbarometer_election_poll -> dim_respondent
        fact_politbarometer_election_poll -> measure_rating
        fact_politbarometer_election_poll -> measure_is_intended_vote
        fact_politbarometer_election_poll -> measure_is_last_vote
        fact_politbarometer_election_poll -> measure_is_aligned_party

    fact_politbarometer_opinion_poll
        fact_politbarometer_opinion_poll -> dim_month
        fact_politbarometer_opinion_poll -> dim_respondent
        fact_politbarometer_opinion_poll -> measure_wie_links_rechts
        fact_politbarometer_opinion_poll -> measure_wie_links
        fact_politbarometer_opinion_poll -> measure_wie_rechts
        fact_politbarometer_opinion_poll -> measure_demokratiezufriedenheit
        fact_politbarometer_opinion_poll -> measure_politikinteresse
        fact_politbarometer_opinion_poll -> measure_wirtschaft
        fact_politbarometer_opinion_poll -> measure_asylrecht
        fact_politbarometer_opinion_poll -> measure_kernkraft
        fact_politbarometer_opinion_poll -> measure_kriminalität
        fact_politbarometer_opinion_poll -> measure_milit_bedroht
        fact_politbarometer_opinion_poll -> measure_jahresrückblick
        fact_politbarometer_opinion_poll -> measure_jahresausblick

    fact_election_census
        fact_election_census -> dim_year
        fact_election_census -> measure_wahlberechtigte
        fact_election_census -> measure_waehlende
        fact_election_census -> measure_gueltige
        fact_election_census -> measure_ungueltige
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
