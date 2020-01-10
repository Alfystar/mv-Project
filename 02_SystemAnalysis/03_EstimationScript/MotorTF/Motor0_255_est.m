clear variables
clc
% Parametri arduino
DeadZone = 25;
timeWanted = 10 / 1000; % time sampling in seconds (-> 10ms)
Ts = floor(16000*1000*timeWanted/1024)*0.064*0.001;

% Calcolo parametri motore
test = importdata('SpeedData/OldMot/19_12_29/speedsDatas0-255/test0-255_dt10.dat','\t'); 
Samples = test.data;

% Normalizzazione dati Motore
Samples = dataNorm(Samples,Ts, DeadZone);

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
for k=1:length(Samples)
    switch (state)
       case 0 % 0 := Attendo 1° Salita (u=0)
          if(Samples(k,1)~=0)
              state = 1;
          end
       case 1 % 1 := Salita (u=1)
          if(Samples(k,1)~=1)
              frsStart = k;
              state = 2;
          end
       case 2 % 2 := freeRealse (u=0)
          if(Samples(k,3) == 0 && Samples(k-1,3) == 0 && Samples(k-2,3) == 0)
              frsEnd = k - 3;
              state = 3;
          end
       case 3 % 3 := Attendo Salita (u=-1)
          if(Samples(k,1)~=0)
              state = 4;
          end
       case 4 % 4 := Salita (u=-1)
          if(Samples(k,1)~=1)
              state = 5;
          end
       case 5 % 5 := freeRealse (u=0)
          if(Samples(k,3) == 0 && Samples(k-1,3) == 0 && Samples(k-2,3) == 0)
              state = 6;
          end
       case 6 % 6 := Attendo Salita del SoftBrake (u=1)
          if(Samples(k,1)~=0)
              state = 7;
          end
       case 7 % 7 := Salita del SoftBrake(u=1)
          bfStart = k - 5;
          bfEnd = length(Samples);
          break % termino la scansione
       otherwise
          error('Non dovresti essere qui!!!');
    end    
end
freeRelaseSample = Samples(frsStart:frsEnd,3);
brakingFrame = Samples(bfStart:bfEnd,1:3);

% Ottenimento attDyn e rhoMot
t=0:Ts:(length(freeRelaseSample)-1)*Ts;
[fitresult, gof] = freeRelaseEst(t, freeRelaseSample);
uDym = abs(fitresult.uDym);
rhoMec = abs(fitresult.rhoMec);
velmaxFit = abs(fitresult.vMax);

% Ottenimento rhoInd+(attDyn+rhoMot) da accelerazione e frenata soft
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
setU_Norm = Samples(1:bfStart,1);
setV_Norm = Samples(1:bfStart,3);

function dataOut = dataNorm (dataIn, Ts, DeadZone)
dataOut = dataIn;
step2rad = 11/(2*pi); % STEPs/rad
    for k=1:length(dataOut)
        dataOut(k,1) = pwm2duty(dataOut(k,1),DeadZone);
    end
dataOut(:,3) = dataOut(:,3)/(Ts*step2rad); % rad/s
dataOut(:,4) = dataOut(:,4)/(Ts*step2rad); % rad/s^2
end

function u = pwm2duty(pwm, dead)
if(abs(pwm)>255)
    u=1;
    return
end
if(abs(pwm)<=dead)
    u = 0;
    return
end
if(pwm>0)
    u = map(pwm,dead,255,0,1);
    return
else
    u = -map(-pwm,dead,255,0,1);
    return
end
end

function u = map (var, varMin, varMax,outMin , outMax)

u = ((var-varMin)/(varMax-varMin));
u = (u * outMax) + ((1-u)*outMin);

end