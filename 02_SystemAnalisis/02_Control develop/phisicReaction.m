function [xSat,reset]  = phisicReaction(x)
%PHISICREACTION Summary of this function goes here
% Funzione che letto lo stato, in caso di urto con la base cambia
% in maniera realistica lo stato introducendo una saturazione.
% x1:= theta dot    [rad/s]
% x2:= theta        [rad]
% x3:= omegaR       [rad/s]

% integrator_handle= get_param('invertedPendolum/not-lin Integratroe','state');
% System Saturation
xSat=x;
if((abs(x(2))>thetaMax))
%     x(2)=sign(x(2))*thetaMax;     %riposizionamento
    xSat(1)=-x(1);
    xSat(2)=sign(x(2))*thetaMax*0.1;
    
    x0=xSat; %to reset integrator state
    reset=1;
else
    reset=0;
end


end

