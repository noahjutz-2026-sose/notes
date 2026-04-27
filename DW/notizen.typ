#import "/deps.typ": cetz, codly, gentle-clues
#import gentle-clues: *
#import codly: codly

#align(end)[2026-03-16 VL01]

= Organisatorisches

- Prüfung
  #table(
    columns: 5,
    [], [Challenge], [Punkte], [Deadline], [Informationen],
    [0],
    [Escape Room],
    [5/5],
    [2026-03-31],
    [
      - Laptop + DBeaver + Fortinet VPN
      - 90min
      - Slot wählen in KW13
    ],

    [1], [Idee Präsentation], [\_/15], [2026-04-26], [],
    [2], [Peer-Review], [\_/5], [], [],
    [3], [], [\_/25], [], [Workbook],
    [4],
    [],
    [\_/25],
    [],
    [
      - Workbook
      - Power BI Dashboard
    ],

    [5], [], [\_/25],
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
CREATE TABLE t(i INT, name VARCHAR(100));
CREATE TABLE "t"(i INT);
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

== JSON

```sql
SELECT json is json FROM table;
SELECT json_value(json, '$.id') from table;
SELECT json_extract(json, '$.id', '$.hobbies#')
    EMITS (id INT, hobby VARCHAR(5000)) FROM people;
```

#align(end)[2026-04-13 VL04]

== Row ID

```sql
SELECT rownum, rowid, * FROM users;
DELETE FROM users WHERE rowid = 36893488147419103232;
```

== Transactions

Neue TA kann begonnen werden mit:

- commit
- rollback
- kill session

_Read Lock:_ Eine Transaktion sieht für immer nur den Snapshot des Schemas zum Zeitpunkt des ersten Reads. Es muss eine neue Transaktion mit commit / rollback gestartet werden, um den neuen Zustand zu lesen.

_Enforced Rollback:_ Bei zwei konkurrenten Transaktionen, die nicht serialisierbar sind.

== Rechtemanagement

Roles & Users

- SYS user
- DBA role
- PUBLIC role

Permissions

#block(breakable: false)[
  #let transpose = (n, ..a) => {
    let a = a.pos()
    let m = calc.floor(a.len() / n)
    let r = ()
    for i in range(n) {
      for j in range(m) {
        r.push(a.at(i + j * n))
      }
    }
    return r
  }

  #let cells = transpose(
    4,
    [GRANT],
    [REVOKE],
    [],
    [],
    [CREATE SESSION],
    [CREATE TABLE],
    [CREATE ANY TABLE],
    [SELECT ANY DICTIONARY],
    [TO],
    [FROM],
    [],
    [],
    [PUBLIC],
    [\<ROLE\>],
    [\<USER\>],
    [],
    [ON],
    [],
    [],
    [],
    [\<TABLE\>],
    [\<SCHEMA\>],
    [],
    [],
  )
  #set text(font: "JetBrainsMono NF")
  #table(
    columns: 6,
    column-gutter: 12pt,
    ..cells
  )
]

```sql
SELECT * FROM sys.EXA_ALL_OBJ_PRIVS;
SELECT * FROM sys.EXA_ALL_TABLES;
```

#align(end)[2026-04-20 VL05]

== Systemtabelle

```sql
SELECT * FROM EXA_SQL_
```

#{
  set text(font: "JetBrainsMono NF")
  let syntax = (
    (
      [EXA],
    ),
    (
      [\_],
    ),
    (
      [USER],
      [ALL],
      [DBA],
    ),
    (
      [\_],
    ),
    (
      [TABLES],
      [COLUMNS],
      [SESSIONS],
      [SCRIPTS],
    ),
  )

  grid(
    columns: syntax.len(),
    column-gutter: 8pt,
    align: horizon,
    ..syntax.map(it => table(..it))
  )
}

```sql
OPEN SCHEMA EXA_STATISTICS;
```

```sql
COMMENT ON TABLE MY_TABLE IS 'hallo';
DESC FULL MY_TABLE;
```

= Fakten und Dimensionen

- _Fact / Measure:_ Es ist etwas passiert, z.B. Kaufpreis
- _Dimension:_ Referenz auf andere Tabelle oder Kontext, z.B. Date

== Multidimensional Data Cube

- Product: z.B. Produktnummer
- Position vom Punkt: Dimensionenabh.
- Wert vom Punkt: Fakt

_Slice Operation:_ Eine Dimension eingrenzen

_Dice Operation:_ Mehrere Dimensionen eingrenzen

== Dimensionshierarchie

- Wann? \
  Tag $->$ Monat $->$ Quartal $->$ Jahr $->$ Top
- Wo? \
  Stadt $->$ Kreis $->$ Region $->$ Bundesland $->$ Land $->$ Top

== Measure

#align(end)[2026-04-27 VL06]

== Aggregation Type

- _Flow:_ Immer addierbar
  - z.B. Units sold
- _Stock:_ Über Zeit nicht addierbar
  - z.B. Lagerbestand
- _Value Per Unit (VPU):_ allgemein nicht addierbar

= Conceptual Modeling

== M/ER-Diagramm

== ROLAP

_Snowflake Schema:_ Fakt $->$ Dimension $->$ Feinere Dimension

- Attribute einer Tabelle sind Measures

_Star Schema:_
