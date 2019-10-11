function [xdot,y] = pendoloNotLinSys(x,u)
%PENDOLONOTLINSYS Summary of this function goes here
% x1:= theta dot    [rad/s]
% x2:= theta        [rad]
% x3:= omegaR       [rad/s]
% u:= Coppia motore [g/s^2 * mm]

% System geometry and specification Define (mm,g)
g = 9.81*1000; %mm/s^2
Lcm = 50;   % Distanza centro di massa [mm] ( perno --> cm)
Ld = 100;   % Distanza braccio [mm] (perno --> motore) 
Ra = 20;    % Raggio anello [mm]

ma = 250;       % Massa Anello [g]
mb = 500;       % Massa Barra [g]
mCm = ma+mb;    % Massa al centro di massa [g]

Ia=ma*Ra^2;         % Inerzia Anello risp D [g*mm^2]
Ib=1/3*mb*Ld^2;     % Inerzia Barra risp O [g*mm^2]
It=Ib+ma*Ld^2+Ia;   % Inerzia Totale risp 0 [g*mm^2]

% Calcoli notevoli:
Mg = (mCm*g*Lcm/It)*sin(x(2));

xdot=zeros(3,1);
% x1dot:= theta 2 dot
xdot(1) = Mg - 1/It*u;
% x2dot:= theta dot
xdot(2) = x(1);
% x3dot:= omegaR dot
xdot(3) = -Mg + (1/It+1/Ia)*u;

%per ora supponiamo di poter osservare tutto il sistema
y=x;

end

