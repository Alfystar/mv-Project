%Questo Memorizza l'inerzia della ruota utilizzata per mantenere in
%equilibrio il pendolo inverso. Consta dei valori dell'inerzia delle varie
%parti(trascurate le viti per fissare il disco alla flangia) 
%e calcola l'inerzia totale in funzione dei pezzi usati.
%Le inerzie sono state calcolate in kg*mm^3 e 
%rispetto l'asse principale di inerzia del singolo componente 

%Numero delle sfere usate  {Sempre in num. pari}
NS=16;
%Numero di rondelle utilizzate nel CB {Min. 2}
NR=6;
%Numero di CB nell'anello esterno {Min 4 sempre in num. pari}
N_cb=16;
%Numero di CB nell'anello esterno {Sempre in num. pari}
N_cbe=0;

%Inerzia disco in legno:
I_dl=371.394569782;
%Inerzia del complesso bullone (CB):
%Inerzia e massa vite a testa esagonale
I_v=0.064;
M_v=0.009;
%Inerzia e massa dado
I_da=0.042;
M_da=0.003;
%Inerzia e massa rondella
I_r=0.024;
M_r=0.001;
%Inerzia e massa dado cieco
I_dc=0.072;
M_dc=0.005;
%Inerzia e massa sfere 
I_s=0.145161;
M_s=0.009;
%Inerzia flangia 
I_fl=0;

%Inerzia e massa CB
I_cb=I_v+I_dc+I_da+NR*I_r;
M_cb=M_v+M_dc+M_da+NR*M_r;
%Inerzia totale
I_tot=2*I_dl+I_fl+NS*(I_s+M_s*(120^2))+N_cb*(I_cb+M_cb*(120^2))+N_cbe*(I_cb+M_cb*(64^2))