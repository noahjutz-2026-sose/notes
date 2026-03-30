#import "@preview/codly:1.3.0": codly
#import "/components.typ": *

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

= IPC mit Pipes

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

= Scheduling

- Ready Queue: FIFO
- _Daemon Process_
- _Zombie Process:_ Beendeter Prozess, der noch in der Prozesstabelle ist.
    - Lösung: Elternprozess terminieren
- _Niceness:_ Priorität
    - $(20-(-20))/(20-0)=2 =>$ Prozess mit niceness -20 erhält doppelt so viel CPU-Zeit.
- _Starvation:_ Prozess kommt nie zum Zug

#align(end)[2026-03-30 VL11 (2025-11-10)]

== Preemtives Scheduling

$
    "Turnaround Time" = "Waiting Time" + "Burst Time"
$

- _Waiting Time:_
    - Ziel: minimieren
    - Lösung: _Shortest Job First (SJF)_
    - _Exponentielle Glättung:_ Schätzung von Bursts anhand Vergangenheit
        $
            tau_(n+1) = alpha t_n + (1 - alpha) tau_n
        $
    - _Round Robin:_ Jeder Prozess darf maximal $q$ Schritte rechnen

= PThread

= Software Patterns

- Compute Farm
- Workcrew

#align(end)[2026-04-02 VL12 (2025-11-11)]
