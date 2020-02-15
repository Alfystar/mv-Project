clear variables
clc
% Parametri arduino
DeadZone = 27;
step2rad = (2*pi)/621; % STEPs/rad

% Calcolo parametri motore
test = importTest('SpeedData/testBench/testAll_10ms.dat'); 
Ts = test.Time(2);
   
% Normalizzazione dati Motore
test = dataNorm(test,Ts, step2rad, DeadZone);

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
% 8 := Fine frenata SoftBrake (break=1, vel = 0
state=0;
for k=1:height(test)
    switch (state)
        case 0 % 0 := Attendo 1° Salita (u=0)
            if(test.PWM(k)~=0)
              state = 1;
            end
        case 1 % 1 := Salita (u=1)
            if(test.PWM(k)~=1)
              frsStart = k;
              state = 2;
            end
        case 2 % 2 := freeRealse (u=0)
            if(test.mVel(k) == 0 && test.mVel(k-1) == 0 && test.mVel(k-2) == 0)
              frsEnd = k - 3;
              state = 3;
            end
         case 3 % 3 := Attendo Salita (u=-1)
            if(test.PWM(k)~=0)
              state = 4;
            end
         case 4 % 4 := Salita (u=-1)
            if(test.PWM(k)~=1)
              state = 5;
            end
        case 5 % 5 := freeRealse (u=0)
            if(test.mVel(k) == 0 && test.mVel(k-1) == 0 && test.mVel(k-2) == 0)
                state = 6;
            end
        case 6 % 6 := Attendo Salita del SoftBrake (u=1)
            if(test.PWM(k)~=0)
              state = 7;
            end
        case 7 % 7 := Salita del SoftBrake(u=1)
            bfStart = k - 5;
            state = 8;
        case 8 % 8 := Fine frenata SoftBrake (break=1, vel = 0)
            if (test.Breaking(k) == 1 && test.Breaking(k-1) == 1 && test.Breaking(k-2) == 1 &&...
                test.mVel(k) == 0 && test.mVel(k-1) == 0 && test.mVel(k-2) == 0)
                    bfEnd = k;
                break
            end    
        otherwise
            error('Non dovresti essere qui!!!');
    end    
end
freeRelaseSample = [test.mVel(frsStart:frsEnd), test.Time(frsStart:frsEnd)-test.Time(frsStart)];
brakingFrame = [test.PWM(bfStart:bfEnd), test.mVel(bfStart:bfEnd), test.Time(bfStart:bfEnd)-test.Time(bfStart)];

% Ottenimento attDyn e rhoMot
% t=0:Ts:(length(freeRelaseSample)-1)*Ts;
[fitresult, gof] = freeRelaseEst(freeRelaseSample(:,2), freeRelaseSample(:,1));
uDym = abs(fitresult.uDym);
rhoMec = abs(fitresult.rhoMec);
velmaxFit = abs(fitresult.vMax);

% Ottenimento rhoInd+(attDyn+rhoMot) da accelerazione e frenata soft
for k=1:length(brakingFrame)
    if(brakingFrame(k,1) ~= 1 && brakingFrame(k,1) ~= -1)
        brakingFrame(k,1) = 0;
    end
end

brakingFrameData = iddata(brakingFrame(:,2), brakingFrame(:,1), Ts);
tfMot_b = tfest(brakingFrameData, 1) % 'Ts',Ts

ka = tfMot_b.Numerator;
rho = tfMot_b.Denominator(2);    % Rho tot (rhoInd + rho_att)
velmax = tfMot_b.Numerator/tfMot_b.Denominator(2);

% Ottenimento rhoMag
rhoInd = rho - rhoMec;

% Printo valori notevoli
ka
rho
rhoInd 
rhoMec
uDym

fprintf("Tra il fitting e la stima ecco le vel max stimate:\n")
fprintf("velmaxFit=%f\tvelmax=%f\tdist=%f\n", velmaxFit, velmax, abs(velmaxFit-velmax));

% Condizioni a contorno
v0 = 0;

% vettori di test
SamplesStepping = test;
setU_Norm = SamplesStepping.PWM;
setBrake = SamplesStepping.Breaking;
setV_Norm = SamplesStepping.mVel;
SampleTime = Ts * height(SamplesStepping)

function dataOut = dataNorm (dataIn, Ts, step2rad, DeadZone)
    Breaking = zeros(height(dataIn),1);
    breaking = table(Breaking);
    
    % colonna = 4 brake on/off (1/0) 
        for k=1:height(dataIn)
            [u,b]=pwm2duty(dataIn.PWM(k),DeadZone);
            dataIn.PWM(k) = u;
            breaking.Breaking(k) = b; 
        end
    dataIn.mStep = dataIn.mStep * step2rad; % rad/s
    dataIn.mVel = dataIn.mVel * step2rad / Ts; % rad/s
    dataIn.mAcc = dataIn.mAcc * step2rad / Ts; % rad/s^2
    dataOut = [dataIn breaking];
end

function [u,b] = pwm2duty(pwm, dead)
    b=0;
    if(abs(pwm)>255)
        u=0;
        b=1;
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