clear variables
clc

% Condizioni a contorno
v0 =0;


% Calcolo parametri motore
% Normalizzazione dati Motore
test_10ms = importdata('speedsDatas/test0-255_dt10.dat','\t'); 
Samples_10ms = test_10ms.data;
timeWanted = 0.01; % time sampling in seconds (-> 10ms)
Ts = floor(16000*1000*timeWanted/1024)*0.064*0.001;
step2rad = 11/(2*pi); % STEPs/rad

Samples_10ms(:,1) = Samples_10ms(:,1)/255; % PWM in percentage
Samples_10ms(:,3) = Samples_10ms(:,3)/(Ts*step2rad); % rad/s
Samples_10ms(:,4) = Samples_10ms(:,4)/(Ts*step2rad);

% Ottenimento rho_mag+(rho_attDyn+rho_attMot) da accelerazione e frenata soft
Set_fin_b = Samples_10ms(850:1220,1:3);
Set_fin_b(1150-850:end,1) = 0;
data_set_fin_b = iddata(Set_fin_b(:,3), Set_fin_b(:,1), Ts);

tfMot_b = tfest(data_set_fin_b, 1); % 'Ts',Ts

ka = tfMot_b.Numerator
rho = tfMot_b.Denominator(2)    % Rho tot (rho_mag + rho_att)
velmax = tfMot_b.Numerator/tfMot_b.Denominator(2)


% Ottenimento rho_attDyn e rho_attMot
% free release (from 255 to 0)
Set_f1 = Samples_10ms(170:365,1:3);
Set_f2 = Samples_10ms(675:865,1:3);

rhoAttDyn1 = (Set_f1(176,3)-Set_f1(30,3))/((176-30)*Ts);
rhoAttDyn2 = (Set_f1(167,3)-Set_f1(23,3))/((167-23)*Ts);
rhoAttDyn = (rhoAttDyn1+rhoAttDyn2)/2;
rhoAttDyn = abs(rhoAttDyn)

% Cerco di capire l'attrito vischioso meccanico del motore
onlyDecrease = Samples_10ms(170+30:170+176,1:3);
d=onlyDecrease(:,3);
% for k=1:length(onlyDecrease)
%   onlyDecrease(k,3) = onlyDecrease(k,3) - rhoAttDyn + rhoAttDyn*k*Ts ;
% end
% figure(1)
% clf
% t=0:Ts:(length(onlyDecrease)-1)*Ts;
% plot(t(:),onlyDecrease(:,3));
% yl = ylim; % Get current limits.
% ylim([0, yl(2)]); 
t=0:Ts:(length(onlyDecrease)-1)*Ts;
var=fit(t(:),d,'exp2')


data_f1V = iddata(Set_f1(:,3), Set_f1(:,1), Ts);
data_f2V = iddata(Set_f2(:,3), Set_f2(:,1), Ts);
datas_fV = merge(data_f1V, data_f2V);

Sys_fVC = tfest(datas_fV, 1);%, 'Ts', Ts) %% this is ok, maybe?

rhoAtt = Sys_fVC.Denominator(2) 


% Ottenimento rhoMag
rhoMag = rho - rhoAtt



% vettori di test
setU_Norm = Samples_10ms(1:850,1);
setV_Norm = Samples_10ms(1:850,3);