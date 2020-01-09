clear variables
clc
% Parametri arduino
DeadZone = 25;
timeWanted = 2 / 1000; % time sampling in seconds (-> 10ms)
Ts = floor(16000*1000*timeWanted/1024)*0.064*0.001;

% Calcolo parametri motore
test = importdata('SpeedData/OldMot/speedDatasStepping/testStepping_dt10.dat','\t'); 
Samples = test.data;
t=0:Ts:(length(Samples)-1)*Ts;

% Normalizzazione dati Motore
Samples = dataNorm(Samples,Ts, DeadZone);
    
    
    
%     figure(1)
%     clf
%     plot(t,Samples(:,3),'b')
%     hold on
%     grid on
%     plot(t,Samples(:,1)*1000,'g')


% Ottenimento SISTEMA LINEARE
FrameData = iddata(Samples(:,3), Samples(:,1), Ts);
tfMot_b = tfest(FrameData, 1) % 'Ts',Ts
ka = tfMot_b.Numerator;
rho = tfMot_b.Denominator(2);    % Rho tot (rhoInd + rho_att)
velmax = tfMot_b.Numerator/tfMot_b.Denominator(2);

% figure(2)
% clf
% lsim(tfMot_b,Samples(:,1),t);
% hold on
% grid on
% plot(t,Samples(:,3),'b')
% plot(t,Samples(:,1)*velmax,'g')
% legend()



% Printo valori notevoli
ka
rho 
rho0 = 5000

% vettori di test
v0=0;
setU_Norm = Samples(:,1);
setV_Norm = Samples(:,3);

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