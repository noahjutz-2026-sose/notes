#import "/deps.typ": diagraph
#import "/components/utils.typ": i
#import "/style.typ": *

#set table(
  fill: (x, y) => if y == 0 { colors.primary.light },
)

#let fact_header(body) = table.header(
  table.cell(fill: colors.secondary.light, body),
)

#let ico = text.with(font: "JetBrainsMono NF", fill: colors.primary.dark)

#let type_str = i("bars-3-bottom-left")
#let type_num = i("hashtag")
#let type_float = i("divide")
#let type_bool = i("power")
#let type_date = i("calendar")

#diagraph.raw-render(
  ```
  digraph {
    overlap=scalexy
    sep="+10"
    start=6
    node[width=0,height=0,margin=0,shape=none,padding=0]
    edge[dir=both arrowhead=odiamond arrowtail=odot]
    dim_party
    dim_questionee
        dim_questionee -> dim_location

    edge[arrowhead=none arrowtail=odot]

    fact_bundestagswahl_result
        fact_bundestagswahl_result -> dim_party
        fact_bundestagswahl_result -> dim_location
    fact_bundestagswahl_statistic
    fact_sitzverteilung
        fact_sitzverteilung -> dim_party
    fact_politbarometer_election_poll
        fact_politbarometer_election_poll -> dim_questionee
        fact_politbarometer_election_poll -> dim_party
    fact_politbarometer_opinion_poll
        fact_politbarometer_opinion_poll -> dim_questionee
  }
  ```,
  engine: "neato",
  labels: (
    "fact_bundestagswahl_result": table(
      fact_header[Bundestagswahl_Ergebnis],
      [],
      [
        #type_date date \
        #type_num stimmen \
        #type_float anteil
      ],
    ),
    "fact_sitzverteilung": table(
      fact_header[Sitzverteilung],
      [],
      [
        #type_date date \
        #type_num sitze
      ],
    ),
    "fact_bundestagswahl_statistic": table(
      fact_header[Bundestagswahl_Erhebung],
      [],
      [
        #type_date date \
        #type_num wahlberechtigte  \
        #type_num waehlende \
        #type_num gueltige \
        #type_num ungueltige \
      ],
    ),
    "fact_politbarometer_election_poll": table(
      fact_header[Politbarometer_Election_Poll],
      [],
      [
        #type_date date \
        #type_bool v6_intended_vote \
        #type_bool v7_last_vote \
        #type_bool v72_preferred_party \
        #type_num v73_preference_intensity \
        #type_num v8_rating
      ],
    ),
    "fact_politbarometer_opinion_poll": table(
      fact_header[Politbarometer_Opinion_Poll],
      [],
      [
        #type_date date \
        #type_num p_weight \
        #type_num d_weight \
        #type_num v4a_east_west \
        #type_num v5_turnout \
        #type_num v15_rating_government \
        #type_num v16_rating_opposition \
        #type_num v18_democracy_satisfaction \
        #type_num v20_political_interest \
        #type_num v21_political_interest_intensity \
        #type_num v22_left_right \
        #type_num v23_left \
        #type_num v24_right \
        #type_num v25_economy_brd \
        #type_num v26_economy_forecast \
        #type_num v29_reunification \
        #type_num v30_asylum \
        #type_num v31_foreigners \
        #type_num v32_abortion \
        #type_num v39_nuclear_energy \
        #type_num v41_crime_threat \
        #type_num v42_eu_membership \
        #type_num v43_responsibility_foreign_policy \
        #type_num v44_society \
        #type_num v48_military_threat \
        #type_num v49_security \
        #type_num v50_year_review \
        #type_num v51_year_forecast \
      ],
    ),
    "dim_party": table(
      [Party],
      [#type_str *shortname*],
      [
        #type_str full_name \
        #type_num id
      ],
    ),
    "dim_questionee": table(
      [Person],
      [
        #type_num *id*
      ],
      [
        #type_num v27_financial_standing \
        #type_num v28_financial_standing_forecast \
        #type_num v52_religion \
        #type_num v54_gender \
        #type_num v55_age \
        #type_num v56_age_group \
        #type_num v57_marital_status \
        #type_num v60_education \
        #type_num v64_employment_status \
        #type_num v65_occupation \
        #type_num v74_workers_union \
      ],
    ),
    "dim_location": table(
      [*Location*],
      [
      ],
      [
        #type_str voting_district_name \
        #type_num voting_district_id \
        #type_str municipality \
        #type_str region \
        #type_str state
      ],
    ),
  ),
)
