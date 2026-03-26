#import "@preview/codly:1.3.0": codly

#align(end)[2026-03-19]

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

#codly(header: [Writer])
#raw(
    block: true,
    lang: "c",
    read("assets/writer.c")
)

#codly(header: [Reader])
#raw(
    block: true,
    lang: "c",
    read("assets/reader.c")
)

```sh
$ ./writer
$ ./reader
0 2 4 6 8 10 12 14 16 18
```

#align(end)[2026-03-26 VL10 (2025-11-04)]

= IPC Mit Pipes

#codly(header: [Pipes])
#raw(
    block: true,
    lang: "c",
    read("assets/pipe.c")
)

```sh
$ ./pipe
Child received: pong

Parent received: ping
```

= Exec und Fork

= Cron Daemon
