clear variables
clc

% Calcolo parametri motore
test_10ms = importdata('speedsDatas/test0-255_dt10.dat','\t'); 
Samples_10ms = test_10ms.data;
    % Normalizzazione dati Motore
    timeWanted = 0.01; % time sampling in seconds (-> 10ms)
    Ts = floor(16000*1000*timeWanted/1024)*0.064*0.001;
    step2rad = 11/(2*pi); % STEPs/rad

    Samples_10ms(:,1) = Samples_10ms(:,1)/255; % PWM in percentage
    Samples_10ms(:,3) = Samples_10ms(:,3)/(Ts*step2rad); % rad/s
    Samples_10ms(:,4) = Samples_10ms(:,4)/(Ts*step2rad);


% Frame dati
% freeRelaseSample = 0;
frsStart = 0;
frsEnd = 0;
% brakingFrame = 0;
bfStart = 0;
bfEnd = 0;

% state wait :
% 0 := Attendo 1° Salita (u=0)
% 1 := Salita (u=1)
% 2 := freeRealse (u=0)
% 3 := Attendo Salita (u=-1)
% 4 := Salita (u=-1)
% 5 := freeRealse (u=0)
% 6 := Attendo Salita del SoftBrake (u=1)
% 7 := Salita del SoftBrake(u=1)
% Prendo tutto il resto
state=0;
for k=1:length(Samples_10ms)
    switch (state)
       case 0 % 0 := Attendo 1° Salita (u=0)
          if(Samples_10ms(k,1)~=0)
              state = 1;
          end
       case 1 % 1 := Salita (u=1)
          if(Samples_10ms(k,1)~=1)
              frsStart = k;
              state = 2;
          end
       case 2 % 2 := freeRealse (u=0)
          if(Samples_10ms(k,3) == 0 && Samples_10ms(k-1,3) == 0 && Samples_10ms(k-2,3) == 0)
              frsEnd = k - 3;
              state = 3;
          end
       case 3 % 3 := Attendo Salita (u=-1)
          if(Samples_10ms(k,1)~=0)
              state = 4;
          end
       case 4 % 4 := Salita (u=-1)
          if(Samples_10ms(k,1)~=1)
              state = 5;
          end
       case 5 % 5 := freeRealse (u=0)
          if(Samples_10ms(k,3) == 0 && Samples_10ms(k-1,3) == 0 && Samples_10ms(k-2,3) == 0)
              state = 6;
          end
       case 6 % 6 := Attendo Salita del SoftBrake (u=1)
          if(Samples_10ms(k,1)~=0)
              state = 7;
          end
       case 7 % 7 := Salita del SoftBrake(u=1)
          bfStart = k - 5;
          bfEnd = length(Samples_10ms);
          break % termino la scansione
       otherwise
          error('Non dovresti essere qui!!!');
    end    
end
freeRelaseSample = Samples_10ms(frsStart:frsEnd,3);
brakingFrame = Samples_10ms(bfStart:bfEnd,1:3);

% Ottenimento attDyn e rhoMot
t=0:Ts:(length(freeRelaseSample)-1)*Ts;
[fitresult, gof] = freeRelaseEst(t, freeRelaseSample);
uDym = abs(fitresult.uDym);
rhoMec = abs(fitresult.rhoMec);
velmaxFit = abs(fitresult.vMax);

% Ottenimento rhoInd+(attDyn+rhoMot) da accelerazione e frenata soft
Set_fin_b = Samples_10ms(850:1220,1:3);
Set_fin_b(1150-850:end,1) = 0;
for k=1:length(brakingFrame)
    if(brakingFrame(k,1) ~= 1 && brakingFrame(k,1) ~= -1)
        brakingFrame(k,1) = 0;
    end
end
brakingFrameData = iddata(brakingFrame(:,3), brakingFrame(:,1), Ts);

tfMot_b = tfest(brakingFrameData, 1); % 'Ts',Ts

ka = tfMot_b.Numerator;
rho = tfMot_b.Denominator(2);    % Rho tot (rhoInd + rho_att)
velmax = tfMot_b.Numerator/tfMot_b.Denominator(2);

% Ottenimento rhoMag
rhoInd = rho - rhoMec;

% Printo valori notevoli
ka
rhoInd 
rhoMec
uDym

fprintf("Tra il fitting e la stima ecco le vel max stimate:\n")
fprintf("velmaxFit=%f\tvelmax=%f\tdist=%f\n", velmaxFit, velmax, abs(velmaxFit-velmax));

% Condizioni a contorno
v0 = 0;

% vettori di test
setU_Norm = Samples_10ms(1:bfStart,1);
setV_Norm = Samples_10ms(1:bfStart,3);