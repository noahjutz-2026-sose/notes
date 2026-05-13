= Presentation

Siehe #link("https://github.com/noahjutz-2026-sose/notes/blob/03435341582ceda5cbd873d8f98df0fd855df142/DW/challenge1_cyberrunner/main.typ")[challenge1_cyberrunner].

= Peer-Review

--

= Datenmodellierung

== Quellen

- Bundestagswahlen 1949-2021: https://github.com/ZeitOnline/bundestagswahl-historische-wahlkreis-daten
- Sitzverteilung 1949-2017: https://germanhistorydocs.org/de/ein-neues-deutschland-1990-2023/distribution-of-seats-in-the-bundestag-1949-2017
- Abstimmungen 2017-2021: https://dataverse.harvard.edu/file.xhtml?fileId=7666482&version=1.0
  - ```py
    df, meta = pyreadstat.read_dta('~/Downloads/EveryBundestagVote_PartyLevel.dta', encoding='latin1')
    df.to_csv("~/Downloads/df.tsv", sep='\t', index=False, encoding='utf-8')
    ```
- Politbarometer 1977-2024: https://search.gesis.org/research_data/ZA2391

== ME/R Diagramm

#scale(20%, reflow: true)[
  #include "challenge3_schema/mer_diagram.typ"
]
