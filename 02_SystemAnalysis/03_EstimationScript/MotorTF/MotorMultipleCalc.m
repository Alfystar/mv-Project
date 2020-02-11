% ####################################################################
% Analisi funzione di trasferimento motore progetto
% 
% La stima attuale � fatta con il motore a vuoto, si dovr� aggiungere
% successivamente la massa e il disco con inerzia
% 
% Filippo Badalamenti
% ####################################################################

%%
clc 
clear variables
format shortEng

%% Speed Analysis
% This portion is written in order to find which is the highest refresh 
% rate we can push the encoder, before it starts to lose steps.

test_2ms = importdata('SpeedData/OldMot/19_12_29/speedsDatas0-255/test0-255_dt2.dat','\t'); 
test_4ms = importdata('SpeedData/OldMot/19_12_29/speedsDatas0-255/test0-255_dt4.dat','\t'); 
test_6ms = importdata('SpeedData/OldMot/19_12_29/speedsDatas0-255/test0-255_dt6.dat','\t'); 
test_8ms = importdata('SpeedData/OldMot/19_12_29/speedsDatas0-255/test0-255_dt8.dat','\t'); 
test_10ms = importdata('SpeedData/OldMot/19_12_29/speedsDatas0-255/test0-255_dt10.dat','\t'); 
test_12ms = importdata('SpeedData/OldMot/19_12_29/speedsDatas0-255/test0-255_dt12.dat','\t'); 
test_14ms = importdata('SpeedData/OldMot/19_12_29/speedsDatas0-255/test0-255_dt14.dat','\t'); 
test_15ms = importdata('SpeedData/OldMot/19_12_29/speedsDatas0-255/test0-255_dt15.dat','\t'); 

% to slim down the first part of the code, we won't scale speeds other than
% the required time sampling normalization; moreover, it's useless flooring
% sample time, since there are the same multiplicative terms for everyone

maxSpeeds_xMs = zeros(1,8);
times_xs = [0.002 0.004 0.006 0.008 0.01 0.012 0.014 0.015];


maxSpeeds_xMs(1) = mean(test_2ms.data(300:1000,3))/ times_xs(1);
maxSpeeds_xMs(2) = mean(test_4ms.data(150:500,3))/ times_xs(2);
maxSpeeds_xMs(3) = mean(test_6ms.data(70:360,3))/ times_xs(3);
maxSpeeds_xMs(4) = mean(test_8ms.data(70:360,3))/ times_xs(4);
maxSpeeds_xMs(5) = mean(test_10ms.data(40:190,3))/ times_xs(5);
maxSpeeds_xMs(6) = mean(test_12ms.data(35:230,3))/ times_xs(6);
maxSpeeds_xMs(7) = mean(test_14ms.data(30:160,3))/ times_xs(7);
maxSpeeds_xMs(8) = mean(test_15ms.data(30:150,3))/ times_xs(8);

figure(1)
plot(times_xs, maxSpeeds_xMs, 'r', 'Marker', '*','MarkerEdgeColor','b')
grid on
xlabel('Sample time (s)'); ylabel('Not normalized speed')
legend('Speed_{max}')
%%
figure(2)
t = [0:times_xs(1):(length(test_2ms.data(:,3))-1)*times_xs(1)];

plot(t, test_2ms.data(:,3), 'r')
hold on
grid on

t = [0:times_xs(2):(length(test_4ms.data(:,3))-1)*times_xs(2)];
plot(t, test_4ms.data(:,3), 'g')

t = [0:times_xs(3):(length(test_6ms.data(:,3))-1)*times_xs(3)];
plot(t, test_6ms.data(:,3), 'b')

t = [0:times_xs(4):(length(test_8ms.data(:,3))-1)*times_xs(4)];
plot(t, test_8ms.data(:,3), 'k')

t = [0:times_xs(5):(length(test_10ms.data(:,3))-1)*times_xs(5)];
plot(t, test_10ms.data(:,3), 'c')

t = [0:times_xs(6):(length(test_12ms.data(:,3))-1)*times_xs(6)];
plot(t, test_12ms.data(:,3), 'm')

t = [0:times_xs(7):(length(test_14ms.data(:,3))-1)*times_xs(7)];
plot(t, test_14ms.data(:,3), 'y')

t = [0:times_xs(8):(length(test_15ms.data(:,3))-1)*times_xs(8)];
plot(t, test_15ms.data(:,3), 'r')


xlabel('Sample time (s)'); ylabel('Not normalized speed')
legend('Test_{2ms}','Test_{4ms}','Test_{6ms}','Test_{8ms}',...
    'Test_{10ms}','Test_{12ms}','Test_{14ms}','Test_{15ms}')

% reading the graph, we can easily notice how we have to estimate our model
% only with a 8+ ms sampling.
%%

figure(193)
t = [0:times_xs(1):(length(test_2ms.data(:,3))-1)*times_xs(1)];

plot(t, test_2ms.data(:,3)/2, 'r')
hold on
grid on

t = [0:times_xs(2):(length(test_4ms.data(:,3))-1)*times_xs(2)];
plot(t, test_4ms.data(:,3)/4, 'g')

t = [0:times_xs(3):(length(test_6ms.data(:,3))-1)*times_xs(3)];
plot(t, test_6ms.data(:,3)/6, 'b')

t = [0:times_xs(4):(length(test_8ms.data(:,3))-1)*times_xs(4)];
plot(t, test_8ms.data(:,3)/8, 'k')

t = [0:times_xs(5):(length(test_10ms.data(:,3))-1)*times_xs(5)];
plot(t, test_10ms.data(:,3)/10, 'c')

t = [0:times_xs(6):(length(test_12ms.data(:,3))-1)*times_xs(6)];
plot(t, test_12ms.data(:,3)/12, 'm')

t = [0:times_xs(7):(length(test_14ms.data(:,3))-1)*times_xs(7)];
plot(t, test_14ms.data(:,3)/14, 'y')

t = [0:times_xs(8):(length(test_15ms.data(:,3))-1)*times_xs(8)];
plot(t, test_15ms.data(:,3)/15, 'r')


xlabel('Sample time (s)'); ylabel('Not normalized speed')
legend('Test_{2ms}','Test_{4ms}','Test_{6ms}','Test_{8ms}',...
    'Test_{10ms}','Test_{12ms}','Test_{14ms}','Test_{15ms}')


%% Dati con campionamento >= 10ms
% we take all the data with a sample rate greater than 10ms

Samples_10ms = test_10ms.data;
Samples_12ms = test_12ms.data;
Samples_14ms = test_14ms.data;
Samples_15ms = test_15ms.data;

% matrice Nx4, con N misure effettuate

%% 10ms sampling & Normalization

timeWanted = 0.01; % time sampling in seconds (-> 10ms)

Ts = floor(16000*1000*timeWanted/1024)*0.064*0.001;
Fs = 1/Ts;
step2rad = 11/(2*pi); % STEPs/rad

Samples_10ms(:,3) = Samples_10ms(:,3)/(Ts*step2rad); % rad/s
Samples_10ms(:,1) = Samples_10ms(:,1)/255; % PWM in percentage
Samples_10ms(:,4) = Samples_10ms(:,4)/(Ts*step2rad);


%% Fourier analysis of a step
% facciamo questa prova per verificare la bont� dei dati raccolti; essendo
% uno step, dovrei avere componente percentuale = 1 a 0Hz. 
% Dall'analisi risulta un 4% d'errore nella raccolta dati

fft_Test = Samples_10ms(10:190,3)/(maxSpeeds_xMs(5)/(step2rad));

len = length(fft_Test);

fft_Test_f = fft(fft_Test);
P2 = abs(fft_Test_f/len);
P1 = P2(1:len/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(len/2))/len;

figure(200)
plot(f,P1,'b')
legend('V(f)')
title('Single-Sided Amplitude Spectrum of limited-step(t)')
xlabel('f(Hz)')
ylabel('|V(f)|')

%% Preparing sets
% We have a Nx2 matrix 
Set_1 = Samples_10ms(10:190,1:3); 
Set_2 = Samples_10ms(365:695,1:3);
Set_3 = Samples_10ms(870:1140,1:3); 
Set_4 = Samples_10ms(1200:1480,1:3);
Set_4(1:34,1) = 0; %% prendiamo dei dati da una frenata forzata

%% Merging datas

data_1 = iddata(Set_1(:,2), Set_1(:,1), Ts);
data_2 = iddata(Set_2(:,2), Set_2(:,1), Ts);
data_3 = iddata(Set_3(:,2), Set_3(:,1), Ts);
data_4 = iddata(Set_4(:,2), Set_4(:,1), Ts);

datas_10 = merge(data_1, data_2, data_3, data_4);

%% Estimation

Sys_c10 = tfest(datas_10, 2, 0)
%Sys_c10.Denominator(3) = 0;
Sys_d10 = tfest(datas_10, 2, 0, 'Ts', Ts);

% c'� nella simulazione del continuo, un polo vicino allo zero ma NON zero,
% per cui otteniamo un sistema del secondo ordine ma convergente, se lo
% sottoponiamo ad uno step; se pongo Sys.Denominator = 0 in maniera
% brutale, allora tolgo il problema e metto il polo ESATTAMENTE in zero,
% visto che � pi� un errore numerico ed un fastidio che altro.
% Da notare come nel discreto (ed � visibile in rlocus) non si verifica
% tale problematica, e si pu� continuare normalmente la trattazione

getpar(Sys_c10) 
%getpar(Sys_c10,'value') % to obtain a vector with gain and pole (ka & rho)

%% RLocus Analysis

figure(3)
rlocus(Sys_d10)
figure(4)
rlocus(Sys_c10)



%% Simulation
tMax = 10; % we stop simulation after 10 seconds
figure(20)
step(Sys_d10,'b', Sys_c10, 'r', tMax);
legend('Sys_{disc}','Sys_{cont}') 
ylabel('Steps')

% otteniamo una stima con un errore dello 0.11%
% analisi fatta con la simulazione dello step; ho preso a 5 e 6 secondi i
% valori del sys_c e del sys_d, fatta la differenza degli estremi e
% confrontata con il numero di step che dovrebbe fare in un secondo.
% Per sys_c a regime se ne hanno tot ca, per sys_d tot ca, con un errore a
% regime percentuale rispettivamente del 0.11% per entrambi
% TODO: capire come tirare fuori i parametri dal discreto.

%% Soft-braking transfer function

Set_s = Samples_10ms(1045:1180,1:3);
Set_s(106:end,1) = 0;

data_s = iddata(Set_s(:,2), Set_s(:,1), Ts);

Sys_sC = tfest(data_s, 2, 0); % ?? why is not working??
Sys_sD = tfest(data_s, 2, 0, 'Ts', Ts) %% this is ok, maybe?

%%
figure(5)
rlocus(Sys_sC)
figure(6)
rlocus(Sys_sD)


%% Hard-braking transfer function

Set_h = Samples_10ms(1385:1520,1:3);
Set_h(106:end,1) = 0;

data_h = iddata(Set_h(:,2), Set_h(:,1), Ts);

Sys_hC = tfest(data_h, 2, 0); % ?? why is not working??
Sys_hD = tfest(data_h, 2, 0, 'Ts', Ts) %% this is ok, maybe?

%%
figure(7)
rlocus(Sys_hC)
figure(8)
rlocus(Sys_hD)

%% Comparing with free-releasing

Set_f1 = Samples_10ms(170:365,1:3);
Set_f2 = Samples_10ms(675:865,1:3);

data_f1 = iddata(Set_f1(:,2), Set_f1(:,1), Ts);
data_f2 = iddata(Set_f2(:,2), Set_f2(:,1), Ts);
datas_f = merge(data_f1, data_f2);

Sys_fC = tfest(datas_f, 2, 0); % ?? why is not working??
Sys_fD = tfest(datas_f, 2, 0, 'Ts', Ts) %% this is ok, maybe?

%%
figure(9)
rlocus(Sys_fD)
figure(10)
rlocus(Sys_fC)

%% rlocus and parameters with d2c
% considerazioni: il polo molto piccolo pu� essere cancellato come nel caso
% sopra del sistema generale -> lo pongo uguale a zero; il polo rimanente
% (ottenuto tramite getpar) � il rho del sistema; senza il polo piccolo, il
% gain per s=0 non � altro che il ka desiderato (o si pone s = 0, o si
% vede il valore sempre in getpar).

Sys_sD_d2c = d2c(Sys_sD)
getpar(Sys_sD_d2c) 

Sys_hD_d2c = d2c(Sys_hD)
getpar(Sys_hD_d2c) 

Sys_fD_d2c = d2c(Sys_fD)
getpar(Sys_fD_d2c) 


figure(17)
rlocus(Sys_sD_d2c)
figure(18)
rlocus(Sys_hD_d2c)
figure(19)
rlocus(Sys_fD_d2c)

%% New braking analysis 
% We have three different situations:
% 1) free release (from 255 to 0)
% 2) soft braking (from 255 to 999)
% 3) hard braking (from -255 to -999)
% Now we are going to find the rho parameter, using only speed (not steps)

data_f1V = iddata(Set_f1(:,3), Set_f1(:,1), Ts);
data_f2V = iddata(Set_f2(:,3), Set_f2(:,1), Ts);

datas_fV = merge(data_f1V, data_f2V);

data_sV = iddata(Set_s(:,3), Set_s(:,1), Ts);
data_hV = iddata(Set_h(:,3), Set_h(:,1), Ts);

Sys_fVC = ssest(datas_fV, 1)%, 'Ts', Ts) %% this is ok, maybe?
Sys_sVC = ssest(data_sV, 1)%, 'Ts', Ts) %% this is ok, maybe?
Sys_hVC = ssest(data_hV, 1)%, 'Ts', Ts) %% this is ok, maybe?

% comparing with accelerating system
data_sysV1 = iddata(Set_1(:,3), Set_1(:,1), Ts);
data_sysV2 = iddata(Set_2(:,3), Set_2(:,1), Ts);
data_sysV3 = iddata(Set_3(:,3), Set_3(:,1), Ts);
data_sysV4 = iddata(Set_4(:,3), Set_4(:,1), Ts);

datas_sysV = merge(data_sysV1, data_sysV2, data_sysV3, data_sysV4);

Sys_sysVC = tfest(datas_sysV, 1)%, 'Ts', Ts) %% this is ok, maybe?

% con questo metodo evitiamo di far stimare anche il polo che sappiamo
% essere in zero (e che tfest potr� trovare solo con un numero enorme di
% campioni), cos� riusciamo ad estrapolare solo il polo d'interesse (rho)
% e la costante ka del sistema

%%
figure(50)
h = bodeplot(Sys_sysVC);
showConfidence(h,3)

%%
figure(1007)
rlocus(Sys_sysVC)

%%

sys_sim = ssest(data_sV, 1, 'Ts', Ts)
tempo = 0:Ts:(length(Set_s(106:end,1))-1)*Ts';
figure(51)
clf
lsim(sys_sim, zeros(1,length(tempo)), tempo, Set_s(105,3))
hold on
stairs(tempo, Set_s(106:end,3)*sys_sim.C,'r')


%%

figure(52)
clf
tempo_2 = 0:Ts:(length(Set_1(4:end,1))-1)*Ts';
Sys_sysVC = ssest(datas_sysV, 1)%, 'Ts', Ts) %% this is ok, maybe?
Sys_sysVC.B = Sys_sysVC.B*Sys_sysVC.C
Sys_sysVC.C = Sys_sysVC.C/Sys_sysVC.C

valmax = Sys_sysVC.B*Sys_sysVC.C/Sys_sysVC.A

step(Sys_sysVC)
hold on
plot(tempo_2, Set_1(4:end,3),'r')
legend('Sys_{sim}','Sys_{real}') 




%%

figure(53)
clf
tempo_3 = 0:Ts:(length(Set_f1(31:end,1))-1)*Ts';
Sys_fVC = ssest(datas_fV, 1)

Sys_fVC.B = Sys_fVC.B*Sys_fVC.C
Sys_fVC.C = Sys_fVC.C/Sys_fVC.C

valmax_2 = Sys_fVC.B*Sys_fVC.C/Sys_fVC.A

lsim(Sys_fVC, zeros(1,length(tempo)), tempo, Set_f1(30,3))
hold on
plot(tempo_3, Set_f1(31:end,3),'r')


%%
figure(54)
tempo_tot = 0:Ts:(length(Samples_10ms(:,1))-1)*Ts';
plot(tempo_tot, Samples_10ms(:,3),'r')


%%

Set_fin = Samples_10ms(1:354,1:3);
data_set_fin = iddata(Set_fin(:,3), Set_fin(:,1), Ts);

Sys_final = ssest(data_set_fin, 2, 'Ts',Ts)
tfMot=tfest(data_set_fin, 4) % 'Ts',Ts
% Sys_final.B = Sys_final.B*Sys_final.C
% Sys_final.C = Sys_final.C/Sys_final.C
% 
% valmax_3 = Sys_final.B*Sys_final.C/Sys_final.A
tempo_4 = 0:Ts:(length(Set_fin(:,1))-1)*Ts';

figure(55)
clf
plot(tempo_4, Set_fin(:,3),'r')
hold on
plot(tempo_4, Set_fin(:,1)*4000,'k')
lsim(tfMot, Set_fin(:,1) , tempo_4)
grid on
legend()
%%

Set_fin_2 = Samples_10ms(850:1220,1:3);
Set_fin_2(1150-850:end,1) = 0;
data_set_fin_2 = iddata(Set_fin_2(:,3), Set_fin_2(:,1), Ts);

tfMot_2 = tfest(data_set_fin_2, 1) % 'Ts',Ts
% Sys_final.B = Sys_final.B*Sys_final.C
% Sys_final.C = Sys_final.C/Sys_final.C
% 
% valmax_3 = Sys_final.B*Sys_final.C/Sys_final.A
tempo_4 = 0:Ts:(length(Set_fin_2(:,1))-1)*Ts';

figure(55)
clf
plot(tempo_4, Set_fin_2(:,3),'r')
hold on
plot(tempo_4, Set_fin_2(:,1)*4000,'k')
lsim(tfMot_2, Set_fin_2(:,1) , tempo_4)
grid on
legend()

valmax_4 = tfMot_2.Numerator/tfMot_2.Denominator(2)

%%







