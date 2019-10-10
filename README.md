# mv-Project: Reverse Pendulum
Progetto di meccanica delle Vibrazioni 2019 Tor-Vergata
A cura di:
- Alfano Emanuele
- Badalamenti Filippo
- Soccio Leonardo
[foto del team =D]
## Abstract
Il progetto è un pendolo inverso che si mantiene in equilibrio controllando un anello posto all'estremita del braccio e che lavorando sulla velocità angolare applica un momento al braccio e permette di mantenere l'equilibrio.

[FOTO del progetto]


### Studio Teorico
Lo studio teorico del sistema è servito per dimensionare il progetto da sviluppare e sviluppare un algoritmo di controllo del sistema non lineare in esame.

[FOTO/Screen dello schema del sistema]

### Modello di Controllo
Simulazione e sviluppo del modello sviluppato con Matlab 2019a Student Edition
[FOTO/screen del modello su simulink]

### Meccanica
La meccanica è un mix di Componenti pre-fabricati e pezzi progettati e successivamente stampati in 3D.
Il progetto è stato ottenuto usando Autocad Meccanical 2019 Student Edition, Inventor Professional 2019 Student Edition

[Foto dei vari componenti smontati e ordinati]

### Elettronica
L'elettronica si occupa di connettere un motore e un sensore all'arduino alimentando il tutto in sicurezza.
Lo schema è stato disegnato usando Eagle 2019 Student Edition

[Screen dello schema e in caso presente della board]

### Firmware
Il firmware è stato sviluppato per un arduino nano, ovvero un atmega328p-au.


[Se presente un diagramma UML del firmware]

#### Ide di svilippo
L'ide utilizzato è SLOEBER, per accedere alle caratteristiche avanzate di un ide non presente nell'ide di default di un arduino.

##### Windows user
Se siete su windows oltre la come e poche altri dettagli siete ready to go.

##### Linux user
Su linux prima di caricare il codice dovete andare in :
    /dev/

Trovare la ttyAMC* che ha montato ora il vostro arduino, quindi cambiare i diritti di accesso aggiungendo oltre il root, anche la possibilità di leggere, scrivere ed eseguire agli altri utenti. 
!!Attenzione che l'operazione andrà ripetuta ogni volta che si collega l'arduino!!

I comandi da eseguire che funzionano sempre sono:

    cd /dev/
    ls -l ttyAMC*
    sudo chmod o+rwx ttyAMC* 


Con questi comandi sarete in grado di sapre su quale tty siete e metterla ad accesso libero. Fatto ciò sloebel certamente funzionerà


In alternativa si può aggiungere il proprio user al gruppo "dialout"

    sudo usermod -a -G dialout <UserName>
dove "UserName" lo si può scoprire digitando:

    whoiam
or

    id
A questo punto riavviare la macchina e sloeber non dovrebbe avere più problemi a individuare la periferica

Sull'ide arduino questo codice non è stato provato, ma anche funzionasse non conviene usarlo essendo molto meno potente