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

figure(10)
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

figure(1)
plot(f,P1,'b')
legend('P1')
title('Single-Sided Amplitude Spectrum of Set_1(t)')
xlabel('f(Hz)')
ylabel('|P1(f)|')

%% Preparing sets
% We have a Nx2 matrix 
Set_1 = Samples_10ms(10:190,1:2); 
Set_2 = Samples_10ms(365:695,1:2);
Set_3 = Samples_10ms(870:1140,1:2); 
Set_4 = Samples_10ms(1230:1480,1:2);
Set_4(1:4,1) = 0; %% prendiamo dei dati da una frenata forzata

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

%% Hard-braking transfer function

Set_h1 = Samples_10ms(1045:1180,1:2);
Set_h1(106:end,1) = 0;
Set_h2 = Samples_10ms(1385:1520,1:2);
Set_h2(106:end,1) = 0;

data_h1 = iddata(Set_h1(:,2), Set_h1(:,1), Ts);
data_h2 = iddata(Set_h2(:,2), Set_h2(:,1), Ts);
datas_h = merge(data_h1, data_h2);

Sys_hC = tfest(datas_h, 2, 0) % ?? why is not working??
Sys_hD = tfest(datas_h, 2, 0, 'Ts', Ts); %% this is ok, maybe?

%%
figure(5)
rlocus(Sys_hD)
figure(6)
rlocus(Sys_hC)

%% Comparing with soft-braking

Set_s1 = Samples_10ms(175:365,1:2);
Set_s2 = Samples_10ms(675:865,1:2);

data_s1 = iddata(Set_s1(:,2), Set_s1(:,1), Ts);
data_s2 = iddata(Set_s2(:,2), Set_s2(:,1), Ts);
datas_s = merge(data_s1, data_s2);

Sys_sC = tfest(datas_s, 2, 0) % ?? why is not working??
Sys_sD = tfest(datas_s, 2, 0, 'Ts', Ts); %% this is ok, maybe?



%%
figure(7)
rlocus(Sys_sD)
figure(8)
rlocus(Sys_sC)

figure(17)
rlocus(d2c(Sys_sD))
figure(18)
rlocus(d2c(Sys_hD))

%% New Analysis
clc
clear variables


%% Dati con campionamento 2ms

filename = 'test0_255.dat'; delimiterIn = '\t';
Samples = importdata(filename,delimiterIn);
% matrice Nx4, con N misure effettuate

%% Normalization

timeWanted = 0.002; % time sampling in seconds (-> 2ms)

Ts = floor(16000*1000*timeWanted/1024)*0.064*0.001;
Fs = 1/Ts;
step2rad = 11/(2*pi); % STEPs/rad

Samples.data(:,1) = Samples.data(:,1)/255; % PWM in percentage
Samples.data(:,3) = Samples.data(:,3)/(Ts*step2rad); % rad/s

maxSpeed_2 = mean(Samples.data(190:1190,3)); 





%% Analizzo diversi 0-255

Set_1 = Samples.data(5:255,2);
input_1 = Samples.data(5:255,1);

Set_2 = Samples.data(2075:3075,2);
input_2 = Samples.data(2075:3075,1);

Set_3 = Samples.data(4080:5080,2);
input_3 = Samples.data(4080:5080,1);

Set_4 = Samples.data(5394:5894,2);
input_4 = Samples.data(5394:5894,1);
input_4(1:5) = 0; %% prendiamo dei dati da una frenata forzata


%%
data_1 = iddata(Set_1, input_1, Ts);
data_2 = iddata(Set_2, input_2, Ts);
data_3 = iddata(Set_3, input_3, Ts);
data_4 = iddata(Set_4, input_4, Ts);


datas_2ms = merge(data_1, data_2, data_3, data_4);
Sys_c = tfest(datas_2ms, 2, 0)
Sys_c.Denominator(3) = 0;
Sys_d = tfest(datas_2ms, 2, 0, 'Ts', Ts);

%%
tMax = 10; % we stop simulation after 10 seconds
figure(2)
step(Sys_d,'b', Sys_c, 'r', tMax);
legend('Sys_{disc}','Sys_{cont}') 
ylabel('Steps')
% c'è nella simulazione del continuo, un polo vicino allo zero ma NON zero,
% per cui otteniamo un sistema del secondo ordine ma convergente, se lo
% sottoponiamo ad uno step; se pongo Sys.Denominator = 0 in maniera
% brutale, allora tolgo il problema e metto il polo ESATTAMENTE in zero,
% visto che è più un errore numerico ed un fastidio che altro.
% Da notare come nel discreto (ed è visibile in rlocus) non si verifica
% tale problematica, e si può continuare normalmente la trattazione
%%
figure(3)
rlocus(Sys_d)
figure(4)
rlocus(Sys_c)

% analisi fatta con la simulazione dello step; ho preso a 5 e 6 secondi i
% valori del sys_c e del sys_d, fatta la differenza degli estremi e
% confrontata con il numero di step che dovrebbe fare in un sec (6820 ca).
% Per sys_c a regime se ne hanno 7300ca, per sys_d 7100ca, con un errore a
% regime percentuale rispettivamente del 6.58% e 3.94%
% TODO: capire come tirare fuori i parametri dal discreto.

%% Spazio di stato

[Ad, Bd, Cd, Dd, ts] = ssdata(Sys_d);




