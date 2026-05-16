#import "/deps.typ": diagraph
#import "/style.typ": *

#set table(
  fill: (x, y) => if y == 0 { colors.primary.light },
)

#let fact_header(body) = table.header(
  table.cell(fill: colors.secondary.light, body),
)

#let ico = text.with(font: "JetBrainsMono NF", fill: colors.primary.dark)

#let type_str = ico[\u{f100d}#sym.space]
#let type_num = ico[\u{f03a0}#sym.space]
#let type_float = ico[\u{f10a1}#sym.space]
#let type_bool = ico[\u{f0521}#sym.space]
#let type_date = ico[\u{f00ed}#sym.space]

#diagraph.raw-render(
  ```
  digraph {
    overlap=scalexy
    sep="+10"
    start=7
    node[width=0,height=0,margin=0,shape=none,padding=0]
    edge[dir=both arrowhead=none arrowtail=none]
    dim_party
    dim_questionee
    dim_voting_district
        dim_voting_district -> dim_city [arrowtail=odot arrowhead=odiamond]
            dim_city -> dim_region [arrowtail=odot arrowhead=odiamond]
                dim_region -> dim_state [arrowtail=odot arrowhead=odiamond]

    fact_bundestagswahl_result
        fact_bundestagswahl_result -> dim_party [arrowtail=odot]
        fact_bundestagswahl_result -> dim_voting_district [arrowtail=odot]
    fact_bundestagswahl_statistic
        fact_bundestagswahl_statistic -> dim_questionee [arrowtail=odot]
    fact_sitzverteilung
        fact_sitzverteilung -> dim_party [arrowtail=odot]
    fact_politbarometer_wahlumfrage
        fact_politbarometer_wahlumfrage -> dim_questionee [arrowtail=odot]
        fact_politbarometer_wahlumfrage -> dim_party [arrowtail=odot]
    fact_politbarometer_beurteilung
        fact_politbarometer_beurteilung -> dim_questionee [arrowtail=odot]
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
    "fact_politbarometer_wahlumfrage": table(
      fact_header[Politbarometer_Wahlumfrage],
      [],
      [
        #type_date date \
        #type_bool is_aligned_with_party \
        #type_bool is_intended_vote \
        #type_bool is_last_voted \
        #type_num rating
      ],
    ),
    "fact_politbarometer_beurteilung": table(
      fact_header[Politbarometer_Beurteilung],
      [],
      [
        #type_date date \
        #type_num wahlbereitschaft \
        #type_num demokratiezufriedenheit \
        #type_num politikinteresse \
        #type_num wie_links_rechts \
        #type_num wie_links \
        #type_num wie_rechts \
        #type_num wirtschaft \
        #type_bool asylrecht \
        #type_bool kernkraft \
        #type_bool kriminalität \
        #type_num eu_mitgliedschaft \
        #type_num jahresausblick \
        #type_bool jahresrückblick \
      ],
    ),
    "dim_party": table(
      [Partei],
      [#type_str *name*],
      [],
    ),
    "dim_voting_district": table(
      [Wahlkreis],
      [#type_num *nr*],
      [#type_str name],
    ),
    "dim_city": table(
      [Ort],
      [#type_str *name*],
      [#type_num einwohner _TODO_],
    ),
    "dim_region": table(
      [Region],
      [#type_str *name*],
      [],
    ),
    "dim_state": table(
      [Bundesland],
      [#type_str *name*],
      [],
    ),
    "dim_questionee": table(
      [Person],
      [#type_num *respid*],
      [
        #type_num age \
        #type_bool is_unionized \
        #type_str sex \
        #type_str occupation \
        #type_str marital_status \
        #type_bool is_residing_with_partner \
      ],
    ),
  ),
)
