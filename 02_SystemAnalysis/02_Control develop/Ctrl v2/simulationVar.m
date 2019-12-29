clc;
clear variables;

% Initial condition
% x1:= q2 dot    [rad/s]
% x2:= q2        [rad]
% x3:= q1 dot    [rad/s]
% x4:= q1        [rad]
% global x0;
x0 = zeros(4,1);
x0(1)=0;
x0(2)=0;
x0(3)=0;
x0(4)=deg2rad(50);

% xDot1:= q2 acc    [rad/s^2]
% xDot2:= q2 vel    [rad/s]
% xDot3:= q1 acc    [rad/s^2]
% xDot4:= q1 vel    [rad/s]

% System geometry and specification Define (mm,g)

%Geometria Link1 (braccio)
L1 = 200;               % Lunghezza braccio [mm] (risp R0)
Lbc = -L1/2;            % Coordinate centro di massa braccio [mm] (risp R1)
M1 = 20;                % Peso braccio (senza disco)[g]
Ibcm = 1/12*M1*L1^2;    % Inerzia Braccio rispetto Rotazione nel SUO cm [g*mm^2] (risp R1cm)

%Geomeria Link2 (disco)
M2 = 550;               % Massa Anello [g]
% per ora approssimato a corona circolare di 28 mm diametro
Id = M2*28^2;           % Inerzia Anello risp D [g*mm^2]

%Costanti Notevoli
Ibtot = Ibcm+Id+M1*(Lbc+L1)^2+M2*L1^2;  % Inerzia Braccio + Carico risp 0 [g*mm^2]
g = 9.81*1000;                          % Gravità [mm/s^2]
Kmgl = g*(M1*(Lbc+L1)+M2*L1);           % Valore della Forza di Gravità sul Sistema


% Saturation
% global thetaMax;
q1Max = deg2rad(60); % Massimo angolo +/-q1 [°]

% Motor parameterization
Ka = 100000;                      % Accelerazione Massima Sperimentale
rho = 36;                       % Attrito viscoso sperimentale

D1 = 0;                         % Attrito viscoso Perno
tauMotMax = Ka * Id;               % Coppia massima del motore
D2 = rho * (1/Ibtot+1/Id)^-1;   % Costante di Attrito viscoso del motore
