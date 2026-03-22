#import "@preview/codly:1.3.0": codly, codly-init
#import "@preview/codly-languages:0.1.10"

#set heading(numbering: "1.1")
#set page(numbering: "1")

#show raw: set text(font: "JetBrainsMono NF")
#show: codly-init

#codly(
  number-format: none,
  languages: codly-languages.codly-languages,
  header-transform: strong
)

#title[Betriebssysteme]

#outline()

= Organisatorisches

Siehe `2025_sose/notizen.xopp` für
- Historischer Abriss
- Kernel
- Interrupts und Traps
- Bash
- Build & Debug Tools
- IPC Mit Shared Memory
- IPC Mit Pipes

// #counter(heading).update(9)

#align(end)[2026-03-19 VL9 (2025-11-03)]

= IPC mit Shared Memory

#codly(header: [\u{f4a5} writer.c])
```c
todo
```

#codly(header: [\u{f4a5} reader.c])
```c
todo
```

```sh
todo
```

== Prozess Scheduling Queues

== Exec

= IPC Mit Pipes

#codly(header: [\u{f4a5} pipes.c])
```c

```