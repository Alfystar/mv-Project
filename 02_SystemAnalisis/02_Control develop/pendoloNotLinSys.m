function [xdot,y] = pendoloNotLinSys(x,u)
%PENDOLONOTLINSYS Summary of this function goes here
% x1:= theta dot    [rad/s]
% x2:= theta        [rad]
% x3:= omegaR       [rad/s]
% u:= Coppia motore [g/s^2 * mm]


% Calcoli notevoli:
Mg = (mCm*g*Lcm/It)*sin(x(2));

xdot=zeros(3,1);
% x1dot:= theta 2 dot
xdot(1) = Mg - (1/It)*u;
xdot(1) = xdot(1) - 1*x(1); %attrito viscoso
% x2dot:= theta dot
xdot(2) = x(1);
% x3dot:= omegaR dot
xdot(3) = -xdot(1) + (1/Ia)*u;



%per ora supponiamo di poter osservare tutto il sistema
y=x;

end

