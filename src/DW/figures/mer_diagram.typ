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
    dim_district -> dim_municipality -> dim_region -> dim_state
    dim_respondent
        dim_respondent -> dim_state
        dim_respondent -> dim_party
        dim_respondent -> dim_financial_standing
        dim_respondent -> dim_financial_standing_forecast
        dim_respondent -> dim_religion
        dim_respondent -> dim_gender
        dim_respondent -> dim_age
        dim_respondent -> dim_marital_status
        dim_respondent -> dim_education
        dim_respondent -> dim_employment_status
        dim_respondent -> dim_occupation
        dim_respondent -> dim_workers_union
        edge[arrowhead=none arrowtail=none]
        dim_respondent -> measure_respondent_id
        dim_respondent -> measure_p_weight
        dim_respondent -> measure_d_weight

    edge[dir=both arrowhead=none arrowtail=none]

    // Attribute

    // Fakten
    fact_election_result
        fact_election_result -> dim_district
            dim_district -> measure_district_id
            dim_district -> measure_district_name
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
        fact_politbarometer_election_poll -> measure_is_preferred_party
        fact_politbarometer_election_poll -> measure_preference_intensity

    fact_politbarometer_opinion_poll
        fact_politbarometer_opinion_poll -> dim_month
        fact_politbarometer_opinion_poll -> dim_respondent
        fact_politbarometer_opinion_poll -> measure_east_west
        fact_politbarometer_opinion_poll -> measure_turnout
        fact_politbarometer_opinion_poll -> measure_rating_government
        fact_politbarometer_opinion_poll -> measure_rating_opposition
        fact_politbarometer_opinion_poll -> measure_democracy_satisfaction
        fact_politbarometer_opinion_poll -> measure_political_interest
        fact_politbarometer_opinion_poll -> measure_left_right
        fact_politbarometer_opinion_poll -> measure_economy_brd
        fact_politbarometer_opinion_poll -> measure_economy_forecast
        fact_politbarometer_opinion_poll -> measure_reunification
        fact_politbarometer_opinion_poll -> measure_asylum
        fact_politbarometer_opinion_poll -> measure_crime_threat
        fact_politbarometer_opinion_poll -> measure_eu_membership
        fact_politbarometer_opinion_poll -> measure_society
        fact_politbarometer_opinion_poll -> measure_year_review
        fact_politbarometer_opinion_poll -> measure_year_forecast

    fact_election_census
        fact_election_census -> dim_year
        fact_election_census -> measure_eligible_voters
        fact_election_census -> measure_voters
        fact_election_census -> measure_valid
        fact_election_census -> measure_invalid
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
