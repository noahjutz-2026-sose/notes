#import "/deps.typ": diagraph
#import "/components/utils.typ": i
#import "/style.typ": *

#show regex("v\d+\w?_"): none

#set table(
  fill: (x, y) => if y == 0 { colors.primary.light },
)

#let fact_header(body) = table.header(
  table.cell(fill: colors.secondary.light, body),
)

#let ico = text.with(font: "JetBrainsMono NF", fill: colors.primary.dark)

#let type_str = i("bars-3-bottom-left")
#let type_num = i("hashtag")
#let type_num_range = i("adjustments-horizontal")
#let type_num_trit = i("cube")
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
      fact_header[*Bundestagswahl_Ergebnis*],
      [],
      [
        #type_date date \
        #type_num stimmen \
        #type_float anteil
      ],
    ),
    "fact_sitzverteilung": table(
      fact_header[*Sitzverteilung*],
      [],
      [
        #type_date date \
        #type_num sitze
      ],
    ),
    "fact_bundestagswahl_statistic": table(
      fact_header[*Bundestagswahl_Erhebung*],
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
      fact_header[*Politbarometer_Election_Poll*],
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
      fact_header[*Politbarometer_Opinion_Poll*],
      [],
      [
        #type_date date \
        #type_float p_weight \
        #type_float d_weight \
        #type_bool v5_is_willing_to_vote \
        #type_num_range v15_rating_government \
        #type_num_range v16_rating_opposition \
        #type_num_range v18_democracy_satisfaction \
        // TODO delete v20, not enough years
        #type_num_trit v21_political_interest \
        #type_num_range v22_left_right \
        // TODO delete v23 and v24, not enough years
        #type_num_range v25_economy_brd \
        #type_num_range v26_economy_forecast \
        #type_num_trit v29_reunification \
        #type_bool v30_asylum \
        // TODO delete v31 and v32, not enough years
        // TODO delete v39, not enough years
        #type_bool v41_crime_threat \
        #type_num_trit v42_eu_membership \
        // TODO delete v43, not enough years
        #type_num_range v44_society \
        // TODO delete v48 and v49, not enough years
        #type_bool v50_year_review \
        #type_num_trit v51_year_forecast \
      ],
    ),
    "dim_party": table(
      [*Party*],
      [#type_str *shortname*],
      [
        #type_str full_name \
        #type_num id
      ],
    ),
    "dim_questionee": table(
      [*Questionee*],
      [
        #type_num *id*
      ],
      [
        #type_num_range v27_financial_standing \
        #type_num_range v28_financial_standing_forecast \
        #type_str v52_religion \
        #type_bool v54_is_male \
        #type_num v55_age \
        // TODO remove v56 redundant
        #type_str v57_marital_status \
        #type_num_range v60_education_level \
        #type_str v60_education_name \
        #type_bool v64_is_employed \
        #type_str v65_occupation \
        #type_bool v74_is_unionized \
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
        #type_str state \
        #type_bool v4a_is_west_germany
      ],
    ),
  ),
)
