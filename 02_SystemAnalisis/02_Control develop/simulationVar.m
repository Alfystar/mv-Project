clc;

% Initial condition
% x1:= theta dot    [rad/s]
% x2:= theta        [rad]
% x3:= omegaR       [rad/s]
% global x0;
x0 = zeros(3,1);
x0(1)=0;
x0(2)=deg2rad(-5);
x0(3)=5;



% System geometry and specification Define (mm,g)
% global g;
g = 9.81*1000; %mm/s^2
% global Lcm;
Lcm= 40;   % Distanza centro di massa [mm] ( perno --> cm)
% global Ld;
Ld = 200;   % Distanza braccio [mm] (perno --> motore) 
% global Ra;
Ra = 100;    % Raggio anello [mm]

% global ma;
ma = 300;       % Massa Anello [g]
% global mb;
mb = 200;       % Massa Barra [g]
% global mCm;
mCm = ma+mb;    % Massa al centro di massa [g]

% global Ia;
Ia = ma*Ra^2;         % Inerzia Anello risp D [g*mm^2]
% global Ib;
Ib = 1/3*mb*Ld^2;     % Inerzia Barra risp O [g*mm^2]
% global It;
It = Ib+ma*Ld^2+Ia;   % Inerzia Totale risp 0 [g*mm^2]



% Saturation
% global thetaMax;
thetaMax = deg2rad(60); % Massimo angolo +/-tetha [°]
