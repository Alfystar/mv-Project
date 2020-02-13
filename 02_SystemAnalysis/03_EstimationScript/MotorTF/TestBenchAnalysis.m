% ####################################################################
% Analisi funzione di trasferimento motore progetto, con disco inerziale
% 
% Il seguente script è fatto per stimare, nel caso del nostro motore,
% l'inerzia di un eventuale disco attaccato.
% Inoltre, si vedrà il rapporto segnale rumore (SNR) dell'encoder
% 
% Filippo Badalamenti
% ####################################################################

%%
clc 
clear variables
format shortEng

%%

data_noBolts = importdata('SpeedData/OldMot/19_12_29/speedsDatas0-255/test0-255_dt10.dat','\t'); 
data_4Bolts = importdata('SpeedData/OldMot/19_12_29/speedsDatas0-255/test0-255_dt10.dat','\t'); 
data_8Bolts = importdata('SpeedData/OldMot/19_12_29/speedsDatas0-255/test0-255_dt10.dat','\t'); 
data_16Bolts = importdata('SpeedData/OldMot/19_12_29/speedsDatas0-255/test0-255_dt10.dat','\t'); 

data_b_tot = struct('NoBolts',data_noBolts,'4Bolts',data_4Bolts,...
                    '8Bolts',data_8Bolts,'16Bolts',data_16Bolts);



%% 10ms sampling & Normalization

timeWanted = 0.01; % time sampling in seconds (-> 10ms)
ocr4a = 0; % value from arduino
Ts = ocr4a*0.064*0.001; % Arduino normalization
Fs = 1/Ts;
step2rad = 64/(2*pi); % STEPs/rad

data_noBolts(:,3) = data_noBolts(:,3)/(Ts*step2rad); % rad/s
data_noBolts(:,1) = data_noBolts(:,1)/255; % PWM in percentage
data_noBolts(:,4) = data_noBolts(:,4)/(Ts*step2rad);

%% picking first acceleration

a = eye(3);
b = magic(4);

s = struct('a',a,'b',b);

s.a()








