#import "/components/admonitions.typ": *

= Bankiersalgorithmus

#further[
  - #link("https://www.geeksforgeeks.org/operating-systems/bankers-algorithm-in-operating-system-2/")[GeeksForGeeks]
  - #link("https://en.wikipedia.org/wiki/Banker's_algorithm")[Wikipedia]
]

Datenstrukturen:

- Max: $m times n$ Matrix \
  Prozess $i$ braucht bis zu $a_(i j)$ Instanzen der Ressource $j$
- Allocation: $m times n$ Matrix \
  Prozess $i$ hält $a_(i j)$ Instanzen der Ressource $j$
- Need: $m times n$ Matrix \
  $="Max" .- "Allocation"$
- Available: $n$ Array \
  Es gibt noch $a_i$ Instanzen der Ressource $i$
- Finish: $m$ Array \
  Prozess $i$ ist Fertig $<==> a_i = "True"$
- Work: $n$ Array \
  Von Ressource $i$ wurden $a_i$ Instanzen zurückgegeben

Algorithmen:

- Safety Algorithm
- Resource Request Algorithm

== Safety Algorithm

```py
# Given
m = 2 # Number of processes
n = 2 # Number of resources
pr_max = [[p1r1, p1r2],
          [p2r1, p2r2]]
pr_allocation = [[p1r1, p1r2],
                 [p2r1, p2r2]]
pr_available = [r1, r2]

# Initialize
need = pr_max - pr_allocation
work = pr_available
finish = [False for p in range(m)]

# Safety Algorithm
for _ in range(m):
    # Find a process that is not finished and doesnt need too much
    p = next((i for i in range(m) if not finish[i] and need[i, :] <= work), None)
    if p is None:
        return False
    # Simulate running this process
    finish[p] = True
    work += pr_allocation[p]
return True
```

== Resource Request Algorithm

```py
# Given
request = [[p1r1, p1r2],
           [p2r1, p2r2]]
p = 0 # Process request to process
pr_max = ...
pr_allocation = ...
pr_available = ...

# Initialize
need = ...

# Resource Request
if request[p] > need[p]:
    return False

if request[p] > pr_available:
    wait()

# Prepare for safety algorithm
pr_available -= request[p]
pr_allocation[p] += request[p]
need[p] -= request[p]

# Run safety algorithm
return safety_algorithm()
```
