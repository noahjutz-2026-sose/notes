#import "/components.typ": *
#import "/deps.typ": codly

= Escape Room

--

= Presentation

Siehe #link("https://github.com/noahjutz-2026-sose/notes/blob/03435341582ceda5cbd873d8f98df0fd855df142/DW/challenge1_cyberrunner/main.typ")[challenge1_cyberrunner].

= Peer-Review

--

= Datenmodellierung

#note(title: [Quellen])[
  - Bundestagswahlen 1949-2021: https://github.com/ZeitOnline/bundestagswahl-historische-wahlkreis-daten
  - Sitzverteilung 1949-2017: https://germanhistorydocs.org/de/ein-neues-deutschland-1990-2023/distribution-of-seats-in-the-bundestag-1949-2017
  - Abstimmungen 2017-2021: https://dataverse.harvard.edu/file.xhtml?fileId=7666482&version=1.0
    - ```py
      df, meta = pyreadstat.read_dta('~/Downloads/EveryBundestagVote_PartyLevel.dta', encoding='latin1')
      df.to_csv("~/Downloads/df.tsv", sep='\t', index=False, encoding='utf-8')
      ```
  - Politbarometer 1977-2024: https://search.gesis.org/research_data/ZA2391
]

== ME/R Diagramm

#context {
  let (width, ..) = measure(include "challenge3_schema/mer_diagram.typ")
  let w = width
  layout(((width, ..)) => {
    scale((width / w) * 100%, reflow: true)[
      #include "challenge3_schema/mer_diagram.typ"
    ]
  })
}

== Measures

#[
  #show table.cell.where(y: 0): strong

  #table(
    columns: 4,
    table.header([Measure], [Data Type], [Range], [Aggregation Type]),
    [wahlbereitschaft], `int`, $1,...,4$, [VPU],
    [skalometer_partei], `int`, $-5,...,5$, [VPU],
    [skalometer_regierung], `int`, $-5,...,5$, [VPU],
    [skalometer_opposition], `int`, $-5,...,5$, [VPU],
    [demokratiezufriedenheit], `int`, $1,...,4$, [VPU],
    [politikinteresse], `int`, $1,...,3$, [VPU],
    [wie_links_rechts], `int`, $1,...,11$, [VPU],
    [wie_links], `int`, $1,...,5$, [VPU],
    [wie_rechts], `int`, $1,...,5$, [VPU],
    [wirtschaft], `int`, $1,...,5$, [VPU],
    [asylrecht], `boolean`, $0, 1$, [STOCK],
    [kernkraft], `boolean`, $0, 1$, [STOCK],
    [kriminalität], `boolean`, $0, 1$, [STOCK],
    [eu_mitgliedschaft], `int`, $1,...,3$, [VPU],
    [milit_bedroht], `boolean`, $0, 1$, [STOCK],
    [jahresrückblick], `boolean`, $0, 1$, [STOCK],
    [jahresausblick], `int`, $1, ..., 3$, [VPU],
    table.hline(stroke: black),
    [sitze], `int`, $1,...,736$, [STOCK],
    table.hline(stroke: black),
    [wahlberechtigte], `int`, $1,...,10^8$, [STOCK],
    [gueltige], `int`, $1,...,10^8$, [FLOW],
    [ungueltige], `int`, $1,...,10^8$, [FLOW\*],
    [waehlende], `int`, $1,...,10^8$, [FLOW\*],
    [stimmen], `int`, $1,...,10^8$, [FLOW\*],
    [anteil], `fraction`, $[0; 1]$, [STOCK],
  )
]

== Star Schema

=== Dimensionen

#codly.codly(header: [Wer? Partei (z.B. SPD)])
```sql
CREATE TABLE Party (
    id INT,
    name VARCHAR(50)
);
```

#codly.codly(header: [Wer? Befragte Person (Politbarometer)])
```sql
CREATE TABLE Questionee (
    id INT,
    age INT,
    is_unionized BOOLEAN,
    sex VARCHAR(50),
    occupation VARCHAR(100),
    marital_status VARCHAR(100),
    is_residing_with_partner BOOLEAN
);
```

#codly.codly(header: [Wo? Wahlkreis])
```sql
CREATE TABLE Voting_District (
    id INT,
    region VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(50)
);
```

=== Fakten

#codly.codly(header: [(Datenquelle: Zeit)])
```sql
CREATE TABLE Bundestagswahl_Ergebnis (
    year INT,
    fraction DECIMAL(10, 9),
    votes INT,
    voting_district_id INT
    party_id INT
);
```

#codly.codly(header: [(Datenquelle: Zeit)])
```sql
CREATE TABLE Bundestagswahl_Erhebung (
    year INT,
    gueltige INT,
    ungueltige INT
    wahlberechtigte INT,
    waehlende INT,
);
```

#codly.codly(header: [(Datenquelle: Germanhistorydocs)])
```sql
CREATE TABLE Sitzverteilung (
    year INT,
    party_id INT,
    seats INT
);
```

#codly.codly(header: [(Datenquelle: Politbarometer)])
```sql
CREATE TABLE Befragung_Wahlumfrage (
    year INT,
    questionee_id INT,
    party_id INT,
    is_aligned_with_party BOOLEAN,
    is_intended_vote BOOLEAN,
    is_last_voted BOOLEAN,
    rating INT
);
```
