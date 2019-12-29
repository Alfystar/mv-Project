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
times_xMs = [2 4 6 8 10 12 14 15];


maxSpeeds_xMs(1) = mean(test_2ms.data(300:1000,3))/ 2;
maxSpeeds_xMs(2) = mean(test_4ms.data(150:500,3))/ 4;
maxSpeeds_xMs(3) = mean(test_6ms.data(70:360,3))/ 6;
maxSpeeds_xMs(4) = mean(test_8ms.data(70:360,3))/ 8;
maxSpeeds_xMs(5) = mean(test_10ms.data(40:190,3))/ 10;
maxSpeeds_xMs(6) = mean(test_12ms.data(35:230,3))/ 12;
maxSpeeds_xMs(7) = mean(test_14ms.data(30:160,3))/ 14;
maxSpeeds_xMs(8) = mean(test_15ms.data(30:150,3))/ 15;

figure(10)
plot(times_xMs, maxSpeeds_xMs, 'r-.', 'Marker', '*','MarkerEdgeColor','blue')
xlabel('Sample time (ms)'); ylabel('Not normalized speed')
legend('Speed_{max}')

% reading the graph, we can easily notice how we have to estimate our model
% only with a 8+ ms sampling.


%% Dati con campionamento 10ms
filename = 'test1.dat'; delimiterIn = '\t';
Samples = importdata(filename,delimiterIn); 
% matrice Nx4, con N misure effettuate

%% 10ms sampling & Normalization

timeWanted = 0.01; % time sampling in seconds (-> 10ms)

Ts = floor(16000*1000*timeWanted/1024)*0.064*0.001;
Fs = 1/Ts;
step2rad = 11/(2*pi); % STEPs/rad

Samples.data(:,3) = Samples.data(:,3)/(Ts*step2rad); % rad/s
Samples.data(:,1) = Samples.data(:,1)/255; % PWM in percentage

maxSpeed_10 = mean(Samples.data(5676:5926,3));




%% Analizzo un 0-255

Set_1 = Samples.data(5650:5920,3);

len = length(Set_1);

Set1_f = fft(Set_1);
P2 = abs(Set1_f/len);
P1 = P2(1:len/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(len/2))/len;

figure(1)
plot(f,P1,'b')
legend('P1')
title('Single-Sided Amplitude Spectrum of Set_1(t)')
xlabel('f(Hz)')
ylabel('|P1(f)|')
%xlim([1 30]) % per centrare la vista su un intervallo delle frequenze

%% Preparazione vettori input e output

Set2_1 = Set_1(1:100);
input_1 = maxSpeed*ones(length(Set2_1), 1);
input_1(1:4) = 0;

%%
datas = iddata(Set2_1, input_1, Ts);

Sys_c = tfest(datas, 1)

Sys_d = tfest(datas, 1, 'Ts', Ts)

Sys_c1 = d2c(Sys_d);
Sys_c2 = d2c(Sys_d,'tustin');


%%
figure(2)
step(Sys_c, 'k', Sys_c1,'r', Sys_c2,'b');
legend('Sys_direct','Sys_{zoh}','Sys_{tustin}')





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


datas = merge(data_1, data_2, data_3, data_4);
Sys_c = tfest(datas, 2, 0)
Sys_c.Denominator(3) = 0;
Sys_d = tfest(datas, 2, 0, 'Ts', Ts);

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


%%




