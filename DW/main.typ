#import "/template.typ": template

#import "/deps.typ": gentle-clues, codly, cetz
#import gentle-clues: *
#import codly: codly

#show: template

#title[Data Warehousing]

#outline()

#align(end)[2026-03-16 VL01]

= Organisatorisches

- Prüfung
  #table(columns: 5,
      [], [Challenge], [Punkte], [Deadline], [Informationen],
      [0], [Escape Room], [5], [2026-03-31], [
          - Laptop + DBeaver + Fortinet VPN
          - 90min
          - Slot wählen in KW13
      ],
      [1], [Szenario], [], [], [],
      [2], [Peer-Review], [], [], [],
      [3], [], [], [], [Workbook],
      [4], [], [], [], [
          - Workbook
          - Power BI Dashboard
      ]
  )
- Übungen
  - 7 Blätter

= Einführung in Data Warehousing

== OLTP vs OLAP

- OLTP: Online Transaction Processing
  - Viele schnelle queries
- OLAP: Online Analytical Processing
  - Dauert länger
  - Läuft nicht auf der gleichen DB, weil:
    - Stört OLTP queries
    - DW-Schema optimiert für OLAP queries (häufige reads, seltene writes)
    - DW enthält quellübergreifende + historische Daten
    - Spaltenbasiert statt Zeilenbasiert

== Fakten und Dimensionen

- _Faktentabelle_:
- _Dimensionstabelle_: W-Fragen
- _ETL_: #strong[E]xtract, #strong[T]ransform, #strong[L]oad

#align(end)[2026-03-23 VL02]
== Eigenschaften von Data Warehouses

- _subject-oriented_: Kunden, Produkte, Aktivitäten
- _integrated_: Aus mehreren Quellen
- _non-volatile_: Daten sind statisch
- _time-variant_: Mehrere Snapshots mit Timestamps


== Architektur
- _Data Mart_: View oder Kopie eines Data Warehouses

= Exasol

== Quickstart

```sh
sudo podman run -p 127.0.0.1:8563:8563 -d --privileged docker.io/exasol/docker-db
```

#align(end)[2026-03-30 VL03]

#clue(title: [DBeaver Connection])[
    - Host: `127.0.0.1`
    - Port: `8563`
    - User: `sys`
    - Password: `exasol`
]

- Cluster: 1 Reserve Node $=>$ 1 darf ausfallen

== Queries

#codly(header: [Schema])
```sql
CREATE SCHEMA noah;
SELECT CURRENT_SCHEMA;
CLOSE SCHEMA;
OPEN SCHEMA noah;
DROP SCHEMA noah;
```

#codly(header: [Tables])
```sql
CREATE TABLE t(i int);
CREATE TABLE "t"(i int);
```

#codly(header: [Strings])
```sql
SELECT 'Hello ' || 'World';
```

#codly(header: [Date/Time])
```sql
SELECT add_hours(CURRENT_TIMESTAMP, -24);
SELECT to_char(add_days(CURRENT_TIMESTAMP, -2), 'DD');
SELECT hours_between('2025-03-03', CURRENT_DATE);
SELECT trunc(CURRENT_TIMESTAMP, 'IW');
```
