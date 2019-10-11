function [x] = phisicReaction(x)
%PHISICREACTION Summary of this function goes here
% Funzione che letto lo stato, in caso di urto con la base cambia
% in maniera realistica lo stato introducendo una saturazione.
% x1:= theta dot    [rad/s]
% x2:= theta        [rad]
% x3:= omegaR       [rad/s]

% System Saturation
thetaMax = deg2rad(60); % Massimo angolo +/-tetha [°]

if(abs(x(2))>thetaMax)
    x(1)=-x(1);                 %rimbalzo
    x(2)=sign(x2)*thetaMax;     %riposizionamento
end

end

