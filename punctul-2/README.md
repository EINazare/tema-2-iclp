# Cerinta
```
Realitate e ca orice atac dureaza putin pentru a se intampla. Anti zombie bolt dureaza 12 milisecunde, iar Whiptail 5 milisecunde.

Observati concluzia in situatia actuala (spoiler alert: inca castiga dragonul).
```
# Rezolvare 1
Pentru punctul acesta am adaugat in cele doua functii care trimit mesaje catre Server din fiecare din cele doua procese cate un timer pentru a simula intervalul de timp al fiecarei lovituri.

Astfel in cazul Necromancer-ului am pus: ``:timer.sleep(12)``

Iar in cazul Dragonului am pus: ``:timer.sleep(5)``

[Aici este codul](./main.exs)

# Rezolvare 2
Nu am reusit sa resolv fara utilizarea server-ului, dintr-o cauza sau alta, daca pun sleep in procesele pentru atac, se blocheaza cu totul, si nu mai functioneaza nimic.


[Incercare de rezolvare fara Server](./main-without-server.exs)

# Rezolvare 3
Nu am reusit sa resolv fara utilizarea server-ului, dintr-o cauza sau alta, daca pun sleep in procesele pentru atac, se blocheaza cu totul, si nu mai functioneaza nimic.


[Incercare de rezolvare fara Server cu procese pentru strategii](./main-without-server-and-stragey-processes.exs)
