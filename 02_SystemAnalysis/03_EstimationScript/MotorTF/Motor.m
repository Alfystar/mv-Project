% ####################################################################
% Analisi funzione di trasferimento motore progetto
% 
% La stima attuale è fatta con il motore a vuoto, si dovrà aggiungere
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

test_2ms = importdata('speedsDatas/test0-255_dt2.dat','\t'); 
test_4ms = importdata('speedsDatas/test0-255_dt4.dat','\t'); 
test_6ms = importdata('speedsDatas/test0-255_dt6.dat','\t'); 
test_8ms = importdata('speedsDatas/test0-255_dt8.dat','\t'); 
test_10ms = importdata('speedsDatas/test0-255_dt10.dat','\t'); 
test_12ms = importdata('speedsDatas/test0-255_dt12.dat','\t'); 
test_14ms = importdata('speedsDatas/test0-255_dt14.dat','\t'); 
test_15ms = importdata('speedsDatas/test0-255_dt15.dat','\t'); 

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
plot(times_xs, maxSpeeds_xMs, 'r-.', 'Marker', '*','MarkerEdgeColor','b')
xlabel('Sample time (s)'); ylabel('Not normalized speed')
legend('Speed_{max}')

% reading the graph, we can easily notice how we have to estimate our model
% only with a 8+ ms sampling.


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



%% Fourier analysis of a step
% facciamo questa prova per verificare la bontà dei dati raccolti; essendo
% uno step, dovrei avere componente percentuale = 1 a 0Hz. 
% Dall'analisi risulta un 4% d'errore nella raccolta dati

fft_Test = Samples_10ms(10:190,3)/(maxSpeeds_xMs(5)/(step2rad));

len = length(fft_Test);

fft_Test_f = fft(fft_Test);
P2 = abs(fft_Test_f/len);
P1 = P2(1:len/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(len/2))/len;

figure(2)
plot(f,P1,'b')
legend('P1')
title('Single-Sided Amplitude Spectrum of Set_1(t)')
xlabel('f(Hz)')
ylabel('|P1(f)|')

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

% c'è nella simulazione del continuo, un polo vicino allo zero ma NON zero,
% per cui otteniamo un sistema del secondo ordine ma convergente, se lo
% sottoponiamo ad uno step; se pongo Sys.Denominator = 0 in maniera
% brutale, allora tolgo il problema e metto il polo ESATTAMENTE in zero,
% visto che è più un errore numerico ed un fastidio che altro.
% Da notare come nel discreto (ed è visibile in rlocus) non si verifica
% tale problematica, e si può continuare normalmente la trattazione

getpar(Sys_c10) 
%getpar(Sys_c10,'value') % to obtain a vector with gain and pole (ka & rho)

%% RLocus Analysis

figure(3)
rlocus(Sys_d10)
figure(4)
rlocus(Sys_c10)



%% Simulation
tMax = 10; % we stop simulation after 10 seconds
figure(2)
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
% considerazioni: il polo molto piccolo può essere cancellato come nel caso
% sopra del sistema generale -> lo pongo uguale a zero; il polo rimanente
% (ottenuto tramite getpar) è il rho del sistema; senza il polo piccolo, il
% gain per s=0 non è altro che il ka desiderato (o si pone s = 0, o si
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

Sys_fVC = tfest(datas_fV, 1, 0)%, 'Ts', Ts) %% this is ok, maybe?
Sys_sVC = tfest(data_sV, 1, 0)%, 'Ts', Ts) %% this is ok, maybe?
Sys_hVC = tfest(data_hV, 1, 0)%, 'Ts', Ts) %% this is ok, maybe?

% comparing with accelerating system
data_sysV1 = iddata(Set_1(:,3), Set_1(:,1), Ts);
data_sysV2 = iddata(Set_2(:,3), Set_2(:,1), Ts);
data_sysV3 = iddata(Set_3(:,3), Set_3(:,1), Ts);
data_sysV4 = iddata(Set_4(:,3), Set_4(:,1), Ts);

datas_sysV = merge(data_sysV1, data_sysV2, data_sysV3, data_sysV4);

Sys_sysVC = tfest(datas_sysV, 1, 0)%, 'Ts', Ts) %% this is ok, maybe?

% con questo metodo evitiamo di far stimare anche il polo che sappiamo
% essere in zero (e che tfest potrà trovare solo con un numero enorme di
% campioni), così riusciamo ad estrapolare solo il polo d'interesse (rho)
% e la costante ka del sistema

%%
figure(50)
h = bodeplot(Sys_sysVC);
showConfidence(h,3)
%%

sys_sim = ssest(data_sV, 1, 'Ts', Ts)
tempo = 0:Ts:length(Set_s(106:end,1))*Ts';
figure(51)
Simul = lsim(sys_sim, zeros(1,length(tempo)), tempo, Set_s(106,3))/sys_sim.C;
% hold on
% plot(tempo, Set_s(105:end,3),'r')







