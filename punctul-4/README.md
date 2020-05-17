# Cerinta
```
Necromancer-ul si-a mai amintit o vraja: Summon: Zombie Archer care dureaza tot 20 de milisecunde si invoca un Zombie Archer cu 100 cantitate de viata. Arcasul are un singur atac: Shot care dureaza 10 milisecunde si loveste dragonul pentru o valoare aleatoare intre 100 si 200 cantitate de viata.

Cand dragonul nu are niciun Zombie Knight sa atace, va ataca aleator fie pe Necromancer fie pe vreun Zombie Archer.
```
# Rezolvare 1
Rezolvare la fel ca si in cazul punctului 3 (procesul se numeste ZombieArcher).

In plus fata de punctul 3, am mai modificat State-ul Serverului, astfel incat PID-ul Necromancer-ului a fost schimbat cu un array in care sunt atat PID-urile proceselor ZombieArcher, cat si a procesului Necromancer, iar la fiecare lovitura a Dragonului, lovitura este trimisa unui PID aleator a proceselor de tip ZombieKnight, iar daca aceastea nu exista, este trimis aleator unui PID din array-ul format din PID-urile Necromancer-ului si a ZombieArcher-urilor.

[Aici este codul](./main.exs)

# Rezolvare 2
Nu am reusit sa resolv fara utilizarea server-ului.

# Rezolvare 3
Nu am reusit sa resolv fara utilizarea server-ului.
