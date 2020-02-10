clc;
clear variables;

% Initial condition
% x1:= q2 dot    [rad/s]
% x2:= q2        [rad]
% x3:= q1 dot    [rad/s]
% x4:= q1        [rad]
% global x0;
% angolo_max := escursione verticale massima del pendolo [gr]
% angolo := angolo di partenza del pendolo [gr]
angolo_max = 60;
angolo = 50;
x0 = zeros(4,1);
x0(1)=0;
x0(2)=0;
x0(3)=0;
x0(4)=deg2rad(angolo);

% xDot1:= q2 acc    [rad/s^2]
% xDot2:= q2 vel    [rad/s]
% xDot3:= q1 acc    [rad/s^2]
% xDot4:= q1 vel    [rad/s]

%###################################################% 
%--System geometry and specification Define (mm,g)--%
%###################################################%

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
q1Max = deg2rad(angolo_max); % Massimo angolo +/-q1 [°]

% System parameter
% Se si inserisce da qua, bisogna tenere conto del sistema tutto montato
Ka = 1.4398e+04;                    % Accelerazione Massima Sperimentale
tauMotMax = Ka * Id;            % Coppia massima del motore
D1 = 0;                         % Attrito viscoso Perno

% Motor parameterization
% rhoInd)*abs(u)+ rhoAtt*1.2 + (attDyn
rhoInd = 26.6195;               % costante Corrente indotta del motore
rhoMec = 0.7235;               % Attrito viscoso meccanico
attDyn = 1.2421e+03;                   % Attrito dinamico meccanico
 

% Calcolo costanti fondamentali (per debug matematico)
M1
Ibcm
Ibtot
M2
Id
tauMotMax
rhoInd
D2 = rhoMec * Id              % Costante di attrito Viscoso meccanico
uDym = attDyn/(M2*g)          % Costante Attrito dinamico meccanico


% Simscape(TM) Multibody(TM) version: 7.0

% This is a model data file derived from a Simscape Multibody Import XML file using the smimport function.
% The data in this file sets the block parameter values in an imported Simscape Multibody model.
% For more information on this file, see the smimport function help page in the Simscape Multibody documentation.
% You can modify numerical values, but avoid any other changes to this file.
% Do not add code to this file. Do not edit the physical units shown in comments.

%%%VariableName:smiData


%============= RigidTransform =============%

%Initialize the RigidTransform structure array by filling in null values.
smiData.RigidTransform(273).translation = [0.0 0.0 0.0];
smiData.RigidTransform(273).angle = 0.0;
smiData.RigidTransform(273).axis = [0.0 0.0 0.0];
smiData.RigidTransform(273).ID = '';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(1).translation = [0 0 8.8817841970012523e-15];  % mm
smiData.RigidTransform(1).angle = 0;  % rad
smiData.RigidTransform(1).axis = [0 0 0];
smiData.RigidTransform(1).ID = 'B[31_Cuscinetto_fittizio:1:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(2).translation = [7.460698725481052e-14 60.000000000000085 -22.999999999999979];  % mm
smiData.RigidTransform(2).angle = 9.2251718552055054e-16;  % rad
smiData.RigidTransform(2).axis = [0.27029661030623442 -0.96277709905094822 -1.2003580809604537e-16];
smiData.RigidTransform(2).ID = 'F[31_Cuscinetto_fittizio:1:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(3).translation = [0 0 0];  % mm
smiData.RigidTransform(3).angle = 0;  % rad
smiData.RigidTransform(3).axis = [0 0 0];
smiData.RigidTransform(3).ID = 'B[31_Cuscinetto_fittizio:2:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(4).translation = [-8.8817841970012523e-14 60.000000000000099 23.000000000000028];  % mm
smiData.RigidTransform(4).angle = 3.1415926535897927;  % rad
smiData.RigidTransform(4).axis = [-1 4.4930904978294048e-32 -2.2204460492503069e-16];
smiData.RigidTransform(4).ID = 'F[31_Cuscinetto_fittizio:2:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(5).translation = [-3.5527136788005009e-14 59.999999999999915 -3.5527136788005009e-14];  % mm
smiData.RigidTransform(5).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(5).axis = [-0.57735026918962562 -0.57735026918962595 -0.57735026918962562];
smiData.RigidTransform(5).ID = 'B[19_Base_Pezzo_Unico:1:-:20_Base_Sopra:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(6).translation = [-5.6843418860808015e-14 30.500000000000085 -1.0000000000001013];  % mm
smiData.RigidTransform(6).angle = 3.357829629637991e-15;  % rad
smiData.RigidTransform(6).axis = [0.64147703407722367 0.7671422389306225 8.2620091117551509e-16];
smiData.RigidTransform(6).ID = 'F[19_Base_Pezzo_Unico:1:-:20_Base_Sopra:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(7).translation = [3.5527136788005009e-14 0 0];  % mm
smiData.RigidTransform(7).angle = 1.2212453270876617e-15;  % rad
smiData.RigidTransform(7).axis = [-0 -1 0];
smiData.RigidTransform(7).ID = 'B[20_Base_Sopra:2:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(8).translation = [1.0658141036401503e-13 61.000000000000036 30.500000000000103];  % mm
smiData.RigidTransform(8).angle = 2.0943951023931962;  % rad
smiData.RigidTransform(8).axis = [-0.57735026918962606 -0.57735026918962673 -0.57735026918962462];
smiData.RigidTransform(8).ID = 'F[20_Base_Sopra:2:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(9).translation = [0 0 -3.5527136788005009e-14];  % mm
smiData.RigidTransform(9).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(9).axis = [-0.57735026918962562 -0.57735026918962595 -0.57735026918962562];
smiData.RigidTransform(9).ID = 'B[19_Base_Pezzo_Unico:1:-:]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(10).translation = [75.655236691455514 -9.3752408878367462e-14 -74.657844101145528];  % mm
smiData.RigidTransform(10).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(10).axis = [-0.57735026918962595 -0.5773502691896254 -0.57735026918962595];
smiData.RigidTransform(10).ID = 'F[19_Base_Pezzo_Unico:1:-:]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(11).translation = [2.9999999999999893 -1.7763568394002505e-14 0];  % mm
smiData.RigidTransform(11).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(11).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(11).ID = 'B[AS 1112 (4) - Metrico M5:1:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(12).translation = [25.000000000000099 43.500000000000078 -30.500000000000245];  % mm
smiData.RigidTransform(12).angle = 2.094395102393197;  % rad
smiData.RigidTransform(12).axis = [-0.57735026918962629 -0.57735026918962584 -0.57735026918962506];
smiData.RigidTransform(12).ID = 'F[AS 1112 (4) - Metrico M5:1:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(13).translation = [2.9999999999999893 8.8817841970012523e-15 0];  % mm
smiData.RigidTransform(13).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(13).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(13).ID = 'B[AS 1112 (4) - Metrico M5:2:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(14).translation = [-25 43.50000000000005 -30.500000000000234];  % mm
smiData.RigidTransform(14).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(14).axis = [-0.57735026918962584 -0.57735026918962673 -0.57735026918962495];
smiData.RigidTransform(14).ID = 'F[AS 1112 (4) - Metrico M5:2:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(15).translation = [2.9999999999999893 -8.8817841970012523e-15 0];  % mm
smiData.RigidTransform(15).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(15).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(15).ID = 'B[AS 1112 (4) - Metrico M5:3:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(16).translation = [-25.000000000000014 43.500000000000043 30.49999999999989];  % mm
smiData.RigidTransform(16).angle = 2.0943951023931966;  % rad
smiData.RigidTransform(16).axis = [-0.57735026918962618 -0.5773502691896264 -0.57735026918962484];
smiData.RigidTransform(16).ID = 'F[AS 1112 (4) - Metrico M5:3:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(17).translation = [2.9999999999999893 0 0];  % mm
smiData.RigidTransform(17).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(17).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(17).ID = 'B[AS 1112 (4) - Metrico M5:4:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(18).translation = [25.00000000000006 43.500000000000057 30.499999999999915];  % mm
smiData.RigidTransform(18).angle = 2.0943951023931966;  % rad
smiData.RigidTransform(18).axis = [-0.57735026918962606 -0.5773502691896264 -0.57735026918962484];
smiData.RigidTransform(18).ID = 'F[AS 1112 (4) - Metrico M5:4:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(19).translation = [5.199999999999994 0 8.8817841970012523e-15];  % mm
smiData.RigidTransform(19).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(19).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(19).ID = 'B[AS 1112 (2) - Metrico M6  Tipo 5:1:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(20).translation = [-49.000000000000107 6.9999999999999787 -7.0000000000001137];  % mm
smiData.RigidTransform(20).angle = 2.0943951023931962;  % rad
smiData.RigidTransform(20).axis = [-0.57735026918962606 -0.57735026918962595 -0.5773502691896254];
smiData.RigidTransform(20).ID = 'F[AS 1112 (2) - Metrico M6  Tipo 5:1:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(21).translation = [5.1999999999999957 8.8817841970012523e-15 -4.4408920985006262e-15];  % mm
smiData.RigidTransform(21).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(21).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(21).ID = 'B[AS 1112 (2) - Metrico M6  Tipo 5:2:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(22).translation = [-49.000000000000099 6.999999999999984 6.9999999999999503];  % mm
smiData.RigidTransform(22).angle = 2.0943951023931962;  % rad
smiData.RigidTransform(22).axis = [-0.57735026918962595 -0.57735026918962573 -0.57735026918962551];
smiData.RigidTransform(22).ID = 'F[AS 1112 (2) - Metrico M6  Tipo 5:2:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(23).translation = [5.1999999999999948 0 0];  % mm
smiData.RigidTransform(23).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(23).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(23).ID = 'B[AS 1112 (2) - Metrico M6  Tipo 5:3:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(24).translation = [49.000000000000199 7.0000000000000107 -6.9999999999999716];  % mm
smiData.RigidTransform(24).angle = 2.0943951023931962;  % rad
smiData.RigidTransform(24).axis = [-0.57735026918962595 -0.57735026918962618 -0.57735026918962518];
smiData.RigidTransform(24).ID = 'F[AS 1112 (2) - Metrico M6  Tipo 5:3:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(25).translation = [5.1999999999999957 0 1.7763568394002505e-14];  % mm
smiData.RigidTransform(25).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(25).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(25).ID = 'B[AS 1112 (2) - Metrico M6  Tipo 5:4:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(26).translation = [49.000000000000156 7.000000000000008 7.0000000000000853];  % mm
smiData.RigidTransform(26).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(26).axis = [-0.57735026918962584 -0.57735026918962606 -0.57735026918962551];
smiData.RigidTransform(26).ID = 'F[AS 1112 (2) - Metrico M6  Tipo 5:4:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(27).translation = [24.999999999999929 59.999999999999915 -30.499999999999989];  % mm
smiData.RigidTransform(27).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(27).axis = [0.57735026918962595 -0.57735026918962551 0.57735026918962573];
smiData.RigidTransform(27).ID = 'B[19_Base_Pezzo_Unico:1:-:IS 2016 A A5.5:7]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(28).translation = [-1.5631940186722204e-13 1.847411112976262e-13 1.2079226507921703e-13];  % mm
smiData.RigidTransform(28).angle = 2.0943951023931962;  % rad
smiData.RigidTransform(28).axis = [-0.57735026918962595 -0.57735026918962606 0.5773502691896254];
smiData.RigidTransform(28).ID = 'F[19_Base_Pezzo_Unico:1:-:IS 2016 A A5.5:7]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(29).translation = [0 -8.8817841970012523e-15 0];  % mm
smiData.RigidTransform(29).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(29).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(29).ID = 'B[IS 2016 A A5.5:9:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(30).translation = [-25.000000000000021 60.000000000000199 -30.500000000000185];  % mm
smiData.RigidTransform(30).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(30).axis = [-0.57735026918962573 -0.57735026918962618 -0.5773502691896254];
smiData.RigidTransform(30).ID = 'F[IS 2016 A A5.5:9:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(31).translation = [0 0 -8.8817841970012523e-15];  % mm
smiData.RigidTransform(31).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(31).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(31).ID = 'B[IS 2016 A A6.6:1:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(32).translation = [-49.000000000000064 60.000000000000064 -7.0000000000001279];  % mm
smiData.RigidTransform(32).angle = 2.0943951023931962;  % rad
smiData.RigidTransform(32).axis = [-0.57735026918962595 -0.57735026918962595 -0.5773502691896254];
smiData.RigidTransform(32).ID = 'F[IS 2016 A A6.6:1:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(33).translation = [0 0 0];  % mm
smiData.RigidTransform(33).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(33).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(33).ID = 'B[IS 2016 A A6.6:2:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(34).translation = [-49.000000000000071 60.000000000000064 6.9999999999999147];  % mm
smiData.RigidTransform(34).angle = 2.0943951023931962;  % rad
smiData.RigidTransform(34).axis = [-0.57735026918962595 -0.57735026918962595 -0.57735026918962529];
smiData.RigidTransform(34).ID = 'F[IS 2016 A A6.6:2:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(35).translation = [0 0 0];  % mm
smiData.RigidTransform(35).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(35).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(35).ID = 'B[IS 2016 A A6.6:3:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(36).translation = [49.000000000000185 60.000000000000135 -7.0000000000000426];  % mm
smiData.RigidTransform(36).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(36).axis = [-0.57735026918962584 -0.5773502691896264 -0.57735026918962506];
smiData.RigidTransform(36).ID = 'F[IS 2016 A A6.6:3:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(37).translation = [8.8817841970012523e-15 0 1.7763568394002505e-14];  % mm
smiData.RigidTransform(37).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(37).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(37).ID = 'B[IS 2016 A A6.6:4:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(38).translation = [49.000000000000149 60.000000000000099 6.9999999999999929];  % mm
smiData.RigidTransform(38).angle = 2.0943951023931962;  % rad
smiData.RigidTransform(38).axis = [-0.57735026918962595 -0.57735026918962595 -0.5773502691896254];
smiData.RigidTransform(38).ID = 'F[IS 2016 A A6.6:4:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(39).translation = [-20.571403593361541 20.000000000000657 14.889919783405912];  % mm
smiData.RigidTransform(39).angle = 3.1415926535897931;  % rad
smiData.RigidTransform(39).axis = [0.99985920187381072 0 -0.016780239219575114];
smiData.RigidTransform(39).ID = 'B[Assieme_Barra:1:-:31_Cuscinetto_fittizio:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(40).translation = [-2.5401902803423582e-13 -2.4526492347109979e-14 8.3500000000008434];  % mm
smiData.RigidTransform(40).angle = 1.9271934959929734e-15;  % rad
smiData.RigidTransform(40).axis = [0.99334039700307442 0.11521655992857463 1.1028293800431189e-16];
smiData.RigidTransform(40).ID = 'F[Assieme_Barra:1:-:31_Cuscinetto_fittizio:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(41).translation = [0 -8.8817841970012523e-15 0];  % mm
smiData.RigidTransform(41).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(41).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(41).ID = 'B[IS 2016 A A5.5:10:-:20_Base_Sopra:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(42).translation = [24.99999999999995 -8.8817841970012523e-14 15.000000000000021];  % mm
smiData.RigidTransform(42).angle = 3.463557771656078e-15;  % rad
smiData.RigidTransform(42).axis = [0.89980837492082866 0.43628532913947204 6.7984996680510396e-16];
smiData.RigidTransform(42).ID = 'F[IS 2016 A A5.5:10:-:20_Base_Sopra:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(43).translation = [0.99999999999999645 -8.8817841970012523e-15 0];  % mm
smiData.RigidTransform(43).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(43).axis = [-0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(43).ID = 'B[IS 2016 A A5.5:10:-:UNI 5739 M5 x 40:5]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(44).translation = [4.2632564145606011e-14 -3.7865323450608567e-29 -5.0487097934144756e-29];  % mm
smiData.RigidTransform(44).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(44).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962562];
smiData.RigidTransform(44).ID = 'F[IS 2016 A A5.5:10:-:UNI 5739 M5 x 40:5]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(45).translation = [-24.999999999999982 59.999999999999915 30.499999999999929];  % mm
smiData.RigidTransform(45).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(45).axis = [0.57735026918962595 -0.57735026918962551 0.57735026918962573];
smiData.RigidTransform(45).ID = 'B[19_Base_Pezzo_Unico:1:-:IS 2016 A A5.5:11]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(46).translation = [-1.2079226507921708e-13 -6.1830739721471888e-14 -1.4694470396280743e-14];  % mm
smiData.RigidTransform(46).angle = 2.0943951023931966;  % rad
smiData.RigidTransform(46).axis = [-0.57735026918962595 -0.57735026918962606 0.57735026918962518];
smiData.RigidTransform(46).ID = 'F[19_Base_Pezzo_Unico:1:-:IS 2016 A A5.5:11]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(47).translation = [0.99999999999998757 4.4408920985006262e-15 1.7763568394002505e-14];  % mm
smiData.RigidTransform(47).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(47).axis = [-0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(47).ID = 'B[IS 2016 A A5.5:11:-:20_Base_Sopra:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(48).translation = [-25.000000000000121 9.5923269327613525e-14 -2.1316282072803006e-14];  % mm
smiData.RigidTransform(48).angle = 3.1415926535897922;  % rad
smiData.RigidTransform(48).axis = [-1 2.685449800280697e-31 -4.5130603050778913e-16];
smiData.RigidTransform(48).ID = 'F[IS 2016 A A5.5:11:-:20_Base_Sopra:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(49).translation = [0 0 -1.7763568394002505e-14];  % mm
smiData.RigidTransform(49).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(49).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(49).ID = 'B[IS 2016 A A5.5:12:-:20_Base_Sopra:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(50).translation = [-24.999999999999986 1.2434497875801753e-13 15.000000000000028];  % mm
smiData.RigidTransform(50).angle = 9.2388968570518403e-16;  % rad
smiData.RigidTransform(50).axis = [0.8471392214882737 -0.53137099978851077 -2.0794226064203222e-16];
smiData.RigidTransform(50).ID = 'F[IS 2016 A A5.5:12:-:20_Base_Sopra:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(51).translation = [0.99999999999999645 8.8817841970012523e-15 -1.7763568394002505e-14];  % mm
smiData.RigidTransform(51).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(51).axis = [-0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(51).ID = 'B[IS 2016 A A5.5:12:-:UNI 5739 M5 x 40:6]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(52).translation = [-1.2621774483536189e-29 9.0372139826605234e-16 1.4182090091763451e-14];  % mm
smiData.RigidTransform(52).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(52).axis = [0.57735026918962584 0.57735026918962562 0.57735026918962584];
smiData.RigidTransform(52).ID = 'F[IS 2016 A A5.5:12:-:UNI 5739 M5 x 40:6]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(53).translation = [0 -1.7763568394002505e-14 0];  % mm
smiData.RigidTransform(53).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(53).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(53).ID = 'B[IS 2016 A A5.5:13:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(54).translation = [25.00000000000006 60.000000000000107 30.499999999999936];  % mm
smiData.RigidTransform(54).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(54).axis = [-0.57735026918962584 -0.57735026918962629 -0.57735026918962518];
smiData.RigidTransform(54).ID = 'F[IS 2016 A A5.5:13:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(55).translation = [0.99999999999999645 -1.7763568394002505e-14 0];  % mm
smiData.RigidTransform(55).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(55).axis = [-0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(55).ID = 'B[IS 2016 A A5.5:13:-:20_Base_Sopra:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(56).translation = [24.999999999999986 1.9895196601282805e-13 7.815970093361102e-14];  % mm
smiData.RigidTransform(56).angle = 3.1415926535897918;  % rad
smiData.RigidTransform(56).axis = [-1 2.7491459633161445e-31 -3.7470335579576442e-16];
smiData.RigidTransform(56).ID = 'F[IS 2016 A A5.5:13:-:20_Base_Sopra:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(57).translation = [0 -1.7763568394002505e-14 8.8817841970012523e-15];  % mm
smiData.RigidTransform(57).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(57).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(57).ID = 'B[IS 2016 A A5.5:14:-:20_Base_Sopra:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(58).translation = [24.999999999999996 6.3948846218409017e-14 15.000000000000071];  % mm
smiData.RigidTransform(58).angle = 1.6690311775283584e-15;  % rad
smiData.RigidTransform(58).axis = [0.98623733672340241 -0.1653357664050043 -1.3607636720256288e-16];
smiData.RigidTransform(58).ID = 'F[IS 2016 A A5.5:14:-:20_Base_Sopra:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(59).translation = [0.99999999999999645 -1.7763568394002505e-14 8.8817841970012523e-15];  % mm
smiData.RigidTransform(59).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(59).axis = [-0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(59).ID = 'B[IS 2016 A A5.5:14:-:UNI 5739 M5 x 40:7]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(60).translation = [1.4210854715202054e-14 -2.8421709430403985e-14 -5.6843418860808015e-14];  % mm
smiData.RigidTransform(60).angle = 2.0943951023931948;  % rad
smiData.RigidTransform(60).axis = [0.57735026918962562 0.57735026918962562 0.57735026918962618];
smiData.RigidTransform(60).ID = 'F[IS 2016 A A5.5:14:-:UNI 5739 M5 x 40:7]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(61).translation = [1.0000000000000053 0 0];  % mm
smiData.RigidTransform(61).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(61).axis = [-0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(61).ID = 'B[IS 2016 A A5.5:7:-:20_Base_Sopra:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(62).translation = [-25.00000000000011 -9.0594198809412774e-14 5.3290705182007514e-14];  % mm
smiData.RigidTransform(62).angle = 3.1415926535897905;  % rad
smiData.RigidTransform(62).axis = [-1 -1.8317015261112307e-30 1.2753141048237606e-15];
smiData.RigidTransform(62).ID = 'F[IS 2016 A A5.5:7:-:20_Base_Sopra:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(63).translation = [0 0 0];  % mm
smiData.RigidTransform(63).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(63).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(63).ID = 'B[IS 2016 A A5.5:8:-:20_Base_Sopra:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(64).translation = [-24.999999999999986 -1.723066134218243e-13 15.000000000000085];  % mm
smiData.RigidTransform(64).angle = 3.326966272203901e-15;  % rad
smiData.RigidTransform(64).axis = [0.86649471982569115 0.49918623830610254 7.1952672139585661e-16];
smiData.RigidTransform(64).ID = 'F[IS 2016 A A5.5:8:-:20_Base_Sopra:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(65).translation = [0.99999999999999645 -8.8817841970012523e-15 0];  % mm
smiData.RigidTransform(65).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(65).axis = [-0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(65).ID = 'B[IS 2016 A A5.5:9:-:20_Base_Sopra:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(66).translation = [25.000000000000018 -1.9539925233402755e-14 6.3948846218409017e-14];  % mm
smiData.RigidTransform(66).angle = 3.1415926535897905;  % rad
smiData.RigidTransform(66).axis = [-1 -1.8317015261112307e-30 1.2753141048237606e-15];
smiData.RigidTransform(66).ID = 'F[IS 2016 A A5.5:9:-:20_Base_Sopra:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(67).translation = [1.6000000000000014 0 -8.8817841970012523e-15];  % mm
smiData.RigidTransform(67).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(67).axis = [-0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(67).ID = 'B[IS 2016 A A6.6:1:-:UNI 5739 M6 x 60:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(68).translation = [2.8421709430404045e-14 -4.3410471231547663e-14 1.576739912517559e-14];  % mm
smiData.RigidTransform(68).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(68).axis = [0.57735026918962606 0.57735026918962584 0.57735026918962529];
smiData.RigidTransform(68).ID = 'F[IS 2016 A A6.6:1:-:UNI 5739 M6 x 60:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(69).translation = [1.6000000000000014 0 0];  % mm
smiData.RigidTransform(69).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(69).axis = [-0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(69).ID = 'B[IS 2016 A A6.6:2:-:UNI 5739 M6 x 60:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(70).translation = [3.5527136788005022e-14 -1.4195565690046127e-14 -6.5901932912737028e-16];  % mm
smiData.RigidTransform(70).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(70).axis = [0.5773502691896254 0.57735026918962595 0.57735026918962595];
smiData.RigidTransform(70).ID = 'F[IS 2016 A A6.6:2:-:UNI 5739 M6 x 60:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(71).translation = [1.6000000000000014 0 0];  % mm
smiData.RigidTransform(71).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(71).axis = [-0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(71).ID = 'B[IS 2016 A A6.6:3:-:UNI 5739 M6 x 60:3]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(72).translation = [7.1054273576010271e-15 -7.1054273576010019e-14 -7.1054273576010031e-14];  % mm
smiData.RigidTransform(72).angle = 2.0943951023931962;  % rad
smiData.RigidTransform(72).axis = [0.57735026918962562 0.57735026918962595 0.57735026918962562];
smiData.RigidTransform(72).ID = 'F[IS 2016 A A6.6:3:-:UNI 5739 M6 x 60:3]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(73).translation = [1.6000000000000103 0 1.7763568394002505e-14];  % mm
smiData.RigidTransform(73).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(73).axis = [-0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(73).ID = 'B[IS 2016 A A6.6:4:-:UNI 5739 M6 x 60:4]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(74).translation = [2.1316282072802996e-14 2.6360773165094622e-15 -5.678226276018462e-14];  % mm
smiData.RigidTransform(74).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(74).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962562];
smiData.RigidTransform(74).ID = 'F[IS 2016 A A6.6:4:-:UNI 5739 M6 x 60:4]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(75).translation = [9.2272727272727515 -4.4408920985006262e-15 -146.77272727272717];  % mm
smiData.RigidTransform(75).angle = 2.0943951023931948;  % rad
smiData.RigidTransform(75).axis = [-0.57735026918962562 -0.57735026918962618 -0.57735026918962562];
smiData.RigidTransform(75).ID = 'B[22_Blocco_Escursione_Braccio:1:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(76).translation = [-64.500000000000071 24.999999999999918 -0.29999999999988347];  % mm
smiData.RigidTransform(76).angle = 2.0943951023931962;  % rad
smiData.RigidTransform(76).axis = [-0.5773502691896254 -0.57735026918962673 -0.57735026918962518];
smiData.RigidTransform(76).ID = 'F[22_Blocco_Escursione_Braccio:1:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(77).translation = [32.727272727272698 4.4408920985006262e-15 -164.27272727272694];  % mm
smiData.RigidTransform(77).angle = 3.1415926535897931;  % rad
smiData.RigidTransform(77).axis = [1 0 8.3266726846886938e-17];
smiData.RigidTransform(77).ID = 'B[22_Blocco_Escursione_Braccio:2:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(78).translation = [41.000000000000412 25.000000000000146 17.799999999999272];  % mm
smiData.RigidTransform(78).angle = 3.1415926535897931;  % rad
smiData.RigidTransform(78).axis = [3.9377063318906429e-32 4.0582153878831258e-17 1];
smiData.RigidTransform(78).ID = 'F[22_Blocco_Escursione_Braccio:2:-:19_Base_Pezzo_Unico:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(79).translation = [0.99999999999999645 0 0];  % mm
smiData.RigidTransform(79).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(79).axis = [-0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(79).ID = 'B[IS 2016 A A5.5:8:-:UNI 5739 M5 x 40:4]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(80).translation = [2.8421709430403992e-14 -1.2621774483536189e-29 -1.4210854715202035e-14];  % mm
smiData.RigidTransform(80).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(80).axis = [0.57735026918962584 0.57735026918962584 0.57735026918962562];
smiData.RigidTransform(80).ID = 'F[IS 2016 A A5.5:8:-:UNI 5739 M5 x 40:4]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(81).translation = [64.69691482827011 231.48283757045363 -137.2317889716054];  % mm
smiData.RigidTransform(81).angle = 3.1415926535897922;  % rad
smiData.RigidTransform(81).axis = [1 -2.0973424124212696e-31 -3.4694469519536152e-16];
smiData.RigidTransform(81).ID = 'B[Assieme_Disco:1:-:Assieme_Barra:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(82).translation = [-22.572741972032929 218.30000000000635 -29.818101249671685];  % mm
smiData.RigidTransform(82).angle = 3.1415926535897905;  % rad
smiData.RigidTransform(82).axis = [0.99985920187381072 -2.5138037017752272e-17 -0.016780239219575454];
smiData.RigidTransform(82).ID = 'F[Assieme_Disco:1:-:Assieme_Barra:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(83).translation = [-21.578076188961681 20.000000000000657 -15.093185630898098];  % mm
smiData.RigidTransform(83).angle = 1.5710779032269133;  % rad
smiData.RigidTransform(83).axis = [0.99971846320321645 0.016777877258443503 -0.016777877258459476];
smiData.RigidTransform(83).ID = 'AssemblyGround[Assieme_Barra:1:1_Asse_cuscinetti:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(84).translation = [-21.074739891161034 44.000000000001556 -0.10163292374572919];  % mm
smiData.RigidTransform(84).angle = 1.571077903226848;  % rad
smiData.RigidTransform(84).axis = [-0.99971846320321633 0.016777877258460007 0.016777877258447541];
smiData.RigidTransform(84).ID = 'AssemblyGround[Assieme_Barra:1:2_Connettore_inf_sup:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(85).translation = [-21.074739891161798 4.4408920985006262e-15 -0.10163292374555155];  % mm
smiData.RigidTransform(85).angle = 1.5710779032269129;  % rad
smiData.RigidTransform(85).axis = [0.99971846320321645 0.01677787725844436 -0.016777877258459403];
smiData.RigidTransform(85).ID = 'AssemblyGround[Assieme_Barra:1:3_Connettore_inf_INF:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(86).translation = [164.27992753016161 59.999999999999673 -30.481788971605262];  % mm
smiData.RigidTransform(86).angle = 1.6378338249998252;  % rad
smiData.RigidTransform(86).axis = [0.93511312653102963 0.25056280708573181 0.25056280708573025];
smiData.RigidTransform(86).ID = 'AssemblyGround[Assieme_Barra:1:10_MPU_6050:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(87).translation = [-21.074739891161123 44.000000000001577 -0.10163292374568478];  % mm
smiData.RigidTransform(87).angle = 1.5710779032269122;  % rad
smiData.RigidTransform(87).axis = [0.99971846320321622 0.016777877258444259 -0.016777877258459695];
smiData.RigidTransform(87).ID = 'AssemblyGround[Assieme_Barra:1:4_barra:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(88).translation = [-21.557680438136355 197.00000000000597 0.41486337641903681];  % mm
smiData.RigidTransform(88).angle = 3.1178612548331981;  % rad
smiData.RigidTransform(88).axis = [-0.011866256286014695 -0.70705699627460383 -0.70705699627462093];
smiData.RigidTransform(88).ID = 'AssemblyGround[Assieme_Barra:1:30_Connettore_sup:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(89).translation = [-22.371407452912777 225.20000000000661 -23.821480166810744];  % mm
smiData.RigidTransform(89).angle = 0.033562053612025723;  % rad
smiData.RigidTransform(89).axis = [-4.2649821022320113e-14 1 -3.7168289124705728e-13];
smiData.RigidTransform(89).ID = 'AssemblyGround[Assieme_Barra:1:29_Motore_6mm:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(90).translation = [-7.3149139639243899 225.20000000000667 -31.330941120571374];  % mm
smiData.RigidTransform(90).angle = 1.5740357574390813;  % rad
smiData.RigidTransform(90).axis = [0.00093338018268393974 -0.99999912880105513 -0.00093338018267764009];
smiData.RigidTransform(90).ID = 'AssemblyGround[Assieme_Barra:1:AS 1110 - Metrico M3 x 12:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(91).translation = [-30.251989605866765 238.45018867790898 -30.560836584937213];  % mm
smiData.RigidTransform(91).angle = 1.5372342936824024;  % rad
smiData.RigidTransform(91).axis = [-0.00014559995027459119 -0.99999997948891906 -0.00014079352254683494];
smiData.RigidTransform(91).ID = 'AssemblyGround[Assieme_Barra:1:AS 1110 - Metrico M3 x 12:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(92).translation = [-14.960605844571671 238.45018867790898 -31.074239608693297];  % mm
smiData.RigidTransform(92).angle = 1.5372342936824042;  % rad
smiData.RigidTransform(92).axis = [-0.00014559995027402792 -0.99999997948891906 -0.00014079352254578123];
smiData.RigidTransform(92).ID = 'AssemblyGround[Assieme_Barra:1:AS 1110 - Metrico M3 x 12:3]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(93).translation = [-37.897681486514621 225.20000000000661 -30.304135073059129];  % mm
smiData.RigidTransform(93).angle = 1.5372342936824042;  % rad
smiData.RigidTransform(93).axis = [-0.00014559995027389657 -0.99999997948891906 -0.00014079352254610858];
smiData.RigidTransform(93).ID = 'AssemblyGround[Assieme_Barra:1:AS 1110 - Metrico M3 x 12:4]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(94).translation = [-42.7939045028237 40.500000000001386 8.6320884235091011];  % mm
smiData.RigidTransform(94).angle = 1.6709637479564556;  % rad
smiData.RigidTransform(94).axis = [0.30151134457776313 -0.30151134457776257 -0.90453403373329144];
smiData.RigidTransform(94).ID = 'AssemblyGround[Assieme_Barra:1:UNI 5739 M5 x 40:8]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(95).translation = [-42.793904502824006 20.000000000000718 8.6320884235090123];  % mm
smiData.RigidTransform(95).angle = 2.094395102393193;  % rad
smiData.RigidTransform(95).axis = [0.57735026918962451 0.57735026918962573 0.57735026918962717];
smiData.RigidTransform(95).ID = 'AssemblyGround[Assieme_Barra:1:IS 2016 A A5.5:15]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(96).translation = [-42.7939045028237 39.500000000001371 8.6320884235089945];  % mm
smiData.RigidTransform(96).angle = 1.7427420369325493;  % rad
smiData.RigidTransform(96).axis = [-0.38223255919517868 -0.38223255919517829 0.84130644915049158];
smiData.RigidTransform(96).ID = 'AssemblyGround[Assieme_Barra:1:IS 2016 A A5.5:16]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(97).translation = [-42.79390450282456 2.0000000000001528 8.6320884235092343];  % mm
smiData.RigidTransform(97).angle = 2.0097471883263984;  % rad
smiData.RigidTransform(97).axis = [-0.54611418199463557 -0.54611418199463646 0.63523113938837972];
smiData.RigidTransform(97).ID = 'AssemblyGround[Assieme_Barra:1:AS 1112 (4) - Metrico M5:5]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(98).translation = [1.1813167714884365 40.500000000001435 7.155635283295334];  % mm
smiData.RigidTransform(98).angle = 1.6709637479564585;  % rad
smiData.RigidTransform(98).axis = [0.30151134457776119 -0.30151134457776285 -0.90453403373329189];
smiData.RigidTransform(98).ID = 'AssemblyGround[Assieme_Barra:1:UNI 5739 M5 x 40:9]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(99).translation = [1.1813167714879391 20.000000000000711 7.1556352832954939];  % mm
smiData.RigidTransform(99).angle = 2.0941108045677015;  % rad
smiData.RigidTransform(99).axis = [0.57725547212920614 0.57725547212919148 0.577539816630673];
smiData.RigidTransform(99).ID = 'AssemblyGround[Assieme_Barra:1:IS 2016 A A5.5:17]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(100).translation = [1.1813167714883654 39.500000000001393 7.1556352832954317];  % mm
smiData.RigidTransform(100).angle = 2.0831507870811645;  % rad
smiData.RigidTransform(100).axis = [0.57355293909033189 0.57355293909031535 0.58487097048981929];
smiData.RigidTransform(100).ID = 'AssemblyGround[Assieme_Barra:1:IS 2016 A A5.5:18]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(101).translation = [1.1813167714879036 2.0000000000001705 7.1556352832956538];  % mm
smiData.RigidTransform(101).angle = 2.7006528144158954;  % rad
smiData.RigidTransform(101).axis = [0.68912024052605392 0.68912024052605236 0.22411289162970832];
smiData.RigidTransform(101).ID = 'AssemblyGround[Assieme_Barra:1:AS 1112 (4) - Metrico M5:6]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(102).translation = [-43.330796553810586 40.500000000001457 -7.358901130786899];  % mm
smiData.RigidTransform(102).angle = 1.6709637479564579;  % rad
smiData.RigidTransform(102).axis = [0.30151134457776124 -0.30151134457776319 -0.90453403373329178];
smiData.RigidTransform(102).ID = 'AssemblyGround[Assieme_Barra:1:UNI 5739 M5 x 40:10]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(103).translation = [-43.33079655381087 20.000000000000682 -7.3589011307868013];  % mm
smiData.RigidTransform(103).angle = 2.0983280556254806;  % rad
smiData.RigidTransform(103).axis = [0.57865532346718762 0.57865532346719217 0.57473127046139028];
smiData.RigidTransform(103).ID = 'AssemblyGround[Assieme_Barra:1:IS 2016 A A5.5:19]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(104).translation = [-43.330796553810586 39.500000000001421 -7.3589011307868457];  % mm
smiData.RigidTransform(104).angle = 2.0993784791274388;  % rad
smiData.RigidTransform(104).axis = [0.57900188398760533 0.57900188398761199 0.5740327836261615];
smiData.RigidTransform(104).ID = 'AssemblyGround[Assieme_Barra:1:IS 2016 A A5.5:20]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(105).translation = [-43.330796553811581 2.000000000000135 -7.3589011307867125];  % mm
smiData.RigidTransform(105).angle = 2.689460951237733;  % rad
smiData.RigidTransform(105).axis = [0.68815013938067793 0.68815013938067471 0.22999732898603742];
smiData.RigidTransform(105).ID = 'AssemblyGround[Assieme_Barra:1:AS 1112 (4) - Metrico M5:7]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(106).translation = [0.64442472050144417 40.500000000001421 -8.8353542710003818];  % mm
smiData.RigidTransform(106).angle = 2.116258401130811;  % rad
smiData.RigidTransform(106).axis = [0.58445801423682986 -0.58445801423682664 -0.5628655782588653];
smiData.RigidTransform(106).ID = 'AssemblyGround[Assieme_Barra:1:UNI 5739 M5 x 40:11]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(107).translation = [0.64442472050107114 20.000000000000718 -8.8353542710003108];  % mm
smiData.RigidTransform(107).angle = 2.0936347016907826;  % rad
smiData.RigidTransform(107).axis = [0.57709657956485216 0.57709657956483995 0.57785731431652798];
smiData.RigidTransform(107).ID = 'AssemblyGround[Assieme_Barra:1:IS 2016 A A5.5:21]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(108).translation = [0.64442472050144417 39.500000000001393 -8.8353542710004085];  % mm
smiData.RigidTransform(108).angle = 2.0824649771800288;  % rad
smiData.RigidTransform(108).axis = [0.57331810902466418 0.57331810902464853 0.58533126665913238];
smiData.RigidTransform(108).ID = 'AssemblyGround[Assieme_Barra:1:IS 2016 A A5.5:22]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(109).translation = [0.64442472050117772 2.0000000000001528 -8.8353542710003286];  % mm
smiData.RigidTransform(109).angle = 2.6925796483763129;  % rad
smiData.RigidTransform(109).axis = [0.6884233801541515 0.68842338015414939 0.22835608009043248];
smiData.RigidTransform(109).ID = 'AssemblyGround[Assieme_Barra:1:AS 1112 (4) - Metrico M5:8]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(110).translation = [-21.121455646709801 184.00000000000551 13.407542389284561];  % mm
smiData.RigidTransform(110).angle = 1.5372342936824048;  % rad
smiData.RigidTransform(110).axis = [-0.00014559995027454102 -0.99999997948891906 -0.00014079352255168381];
smiData.RigidTransform(110).ID = 'AssemblyGround[Assieme_Barra:1:JIS B 1185 Tipo 1 - Metrico M4:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(111).translation = [-22.020749832112845 184.0000000000056 -13.377365114161126];  % mm
smiData.RigidTransform(111).angle = 3.1413902283640032;  % rad
smiData.RigidTransform(111).axis = [0.71887263937585766 -9.7871464364742268e-05 0.69514179760532635];
smiData.RigidTransform(111).ID = 'AssemblyGround[Assieme_Barra:1:ISO 7089 4:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(112).translation = [-20.872965730973032 184.0000000000056 20.808657081882622];  % mm
smiData.RigidTransform(112).angle = 1.5372342936824053;  % rad
smiData.RigidTransform(112).axis = [-0.00014559995027456639 -0.99999997948891906 -0.00014079352255163212];
smiData.RigidTransform(112).ID = 'AssemblyGround[Assieme_Barra:1:DIN 1587 M4:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(113).translation = [-22.020749832112845 184.0000000000056 -13.377365114161153];  % mm
smiData.RigidTransform(113).angle = 1.5708770628212938;  % rad
smiData.RigidTransform(113).axis = [-0.18339513013092282 -0.96691074164089363 -0.17734103852103378];
smiData.RigidTransform(113).ID = 'AssemblyGround[Assieme_Barra:1:ISO 4017 M4 x 40:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(114).translation = [64.696914828270096 231.4828375704536 -149.2317889716054];  % mm
smiData.RigidTransform(114).angle = 2.5403281528138337;  % rad
smiData.RigidTransform(114).axis = [0.3100291349568719 0.67226554852896248 0.67226554852896248];
smiData.RigidTransform(114).ID = 'AssemblyGround[Assieme_Disco:1:9_Flangia:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(115).translation = [64.696914828269854 231.48283757045363 -161.06078897160552];  % mm
smiData.RigidTransform(115).angle = 2.5403281528138328;  % rad
smiData.RigidTransform(115).axis = [-0.3100291349568704 -0.67226554852896248 0.67226554852896314];
smiData.RigidTransform(115).ID = 'AssemblyGround[Assieme_Disco:1:24_Disco:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(116).translation = [64.696914828269911 231.48283757045357 -153.2317889716054];  % mm
smiData.RigidTransform(116).angle = 2.5403281528138328;  % rad
smiData.RigidTransform(116).axis = [0.31002913495687234 0.6722655485289627 0.67226554852896203];
smiData.RigidTransform(116).ID = 'AssemblyGround[Assieme_Disco:1:24_Disco:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(117).translation = [-49.439913417913658 194.43173181230929 -170.23178897160534];  % mm
smiData.RigidTransform(117).angle = 2.7304621298275515;  % rad
smiData.RigidTransform(117).axis = [0.69156465201756634 0.20851058524603516 -0.69156465201756678];
smiData.RigidTransform(117).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(118).translation = [-49.439913417913729 194.43173181230947 -154.83178897160536];  % mm
smiData.RigidTransform(118).angle = 1.9165618016574142;  % rad
smiData.RigidTransform(118).axis = [-0.5031179635415699 0.70266964465783455 0.50311796354156968];
smiData.RigidTransform(118).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(119).translation = [-49.439913417913814 194.43173181230949 -147.63178897160535];  % mm
smiData.RigidTransform(119).angle = 1.5974579065261156;  % rad
smiData.RigidTransform(119).axis = [-0.97368762631779371 0.16114032139042853 -0.16114032139042711];
smiData.RigidTransform(119).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(120).translation = [-49.439913417913729 194.43173181230941 -147.63178897160546];  % mm
smiData.RigidTransform(120).angle = 1.74203760702316;  % rad
smiData.RigidTransform(120).axis = [0.38156957790800927 0.84190813894997252 -0.38156957790801038];
smiData.RigidTransform(120).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(121).translation = [-49.439913417913758 194.43173181230947 -153.23178897160537];  % mm
smiData.RigidTransform(121).angle = 2.0414311181010851;  % rad
smiData.RigidTransform(121).axis = [-0.61321634696974814 -0.55855425511273171 0.55855425511273193];
smiData.RigidTransform(121).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(122).translation = [-49.439913417913708 194.43173181230941 -159.83178897160536];  % mm
smiData.RigidTransform(122).angle = 1.7674303798787434;  % rad
smiData.RigidTransform(122).axis = [-0.82044075105944114 0.4042752614253205 -0.40427526142531772];
smiData.RigidTransform(122).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:3]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(123).translation = [-49.439913417913729 194.43173181230941 -168.6317889716054];  % mm
smiData.RigidTransform(123).angle = 1.7963222748271632;  % rad
smiData.RigidTransform(123).axis = [-0.79655236813139041 0.42749521916875011 -0.42749521916874827];
smiData.RigidTransform(123).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:4]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(124).translation = [-49.439913417913729 194.43173181230947 -165.43178897160533];  % mm
smiData.RigidTransform(124).angle = 1.7931831984671762;  % rad
smiData.RigidTransform(124).axis = [-0.79912098494228412 0.4250915498012609 -0.42509154980125857];
smiData.RigidTransform(124).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:5]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(125).translation = [-49.439913417913658 194.43173181230944 -167.03178897160535];  % mm
smiData.RigidTransform(125).angle = 1.7960179883519805;  % rad
smiData.RigidTransform(125).axis = [-0.79680107573804948 0.42726341155234032 -0.42726341155233805];
smiData.RigidTransform(125).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:6]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(126).translation = [-26.572920369686607 153.57380611107857 -170.23178897160548];  % mm
smiData.RigidTransform(126).angle = 2.7304621298275502;  % rad
smiData.RigidTransform(126).axis = [0.69156465201756645 0.20851058524603597 -0.69156465201756645];
smiData.RigidTransform(126).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(127).translation = [-26.572920369686628 153.57380611107871 -154.83178897160545];  % mm
smiData.RigidTransform(127).angle = 1.9165618016574144;  % rad
smiData.RigidTransform(127).axis = [-0.50311796354156979 0.70266964465783399 0.50311796354157023];
smiData.RigidTransform(127).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(128).translation = [-26.572920369686699 153.57380611107874 -147.63178897160546];  % mm
smiData.RigidTransform(128).angle = 1.5834059830489631;  % rad
smiData.RigidTransform(128).axis = [-0.98746918236008874 0.11158990520897957 -0.11158990520897845];
smiData.RigidTransform(128).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:7]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(129).translation = [-26.572920369686717 153.57380611107868 -147.6317889716054];  % mm
smiData.RigidTransform(129).angle = 1.7420376070231589;  % rad
smiData.RigidTransform(129).axis = [0.38156957790800855 0.84190813894997329 -0.38156957790800988];
smiData.RigidTransform(129).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(130).translation = [-26.572920369686699 153.57380611107868 -153.23178897160548];  % mm
smiData.RigidTransform(130).angle = 1.5974579065261103;  % rad
smiData.RigidTransform(130).axis = [-0.97368762631779837 0.16114032139041368 -0.16114032139041232];
smiData.RigidTransform(130).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:8]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(131).translation = [-26.572920369686628 153.57380611107854 -159.83178897160548];  % mm
smiData.RigidTransform(131).angle = 1.7382164019991644;  % rad
smiData.RigidTransform(131).axis = [-0.84517825845436512 0.37793763469390557 -0.37793763469390335];
smiData.RigidTransform(131).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:9]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(132).translation = [-26.57292036968661 153.57380611107857 -168.63178897160554];  % mm
smiData.RigidTransform(132).angle = 1.782144281422916;  % rad
smiData.RigidTransform(132).axis = [-0.80820529905519789 0.41641577454456469 -0.41641577454456308];
smiData.RigidTransform(132).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:10]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(133).translation = [-26.572920369686642 153.57380611107854 -165.43178897160547];  % mm
smiData.RigidTransform(133).angle = 1.7772978711639409;  % rad
smiData.RigidTransform(133).axis = [-0.81221920048149954 0.41249240621446304 -0.41249240621446115];
smiData.RigidTransform(133).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:11]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(134).translation = [-26.57292036968661 153.5738061110786 -167.03178897160555];  % mm
smiData.RigidTransform(134).angle = 1.7816737629008479;  % rad
smiData.RigidTransform(134).axis = [-0.80859430265018295 0.41603801131727491 -0.41603801131727308];
smiData.RigidTransform(134).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:12]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(135).translation = [55.249399902616183 111.85531372359958 -170.23178897160528];  % mm
smiData.RigidTransform(135).angle = 2.7304621298275622;  % rad
smiData.RigidTransform(135).axis = [0.69156465201756701 0.20851058524602983 -0.69156465201756778];
smiData.RigidTransform(135).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:3]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(136).translation = [55.249399902616254 111.85531372359959 -154.83178897160536];  % mm
smiData.RigidTransform(136).angle = 1.6542234703188545;  % rad
smiData.RigidTransform(136).axis = [-0.27734559293365812 0.91986892770685325 0.27734559293365696];
smiData.RigidTransform(136).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:3]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(137).translation = [55.249399902616204 111.85531372359964 -147.63178897160537];  % mm
smiData.RigidTransform(137).angle = 1.7963222748272087;  % rad
smiData.RigidTransform(137).axis = [-0.79655236813135222 0.42749521916878491 -0.42749521916878486];
smiData.RigidTransform(137).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:13]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(138).translation = [55.249399902616283 111.85531372359961 -147.63178897160537];  % mm
smiData.RigidTransform(138).angle = 2.0586183593682139;  % rad
smiData.RigidTransform(138).axis = [0.56491343222192447 0.6014529309850345 -0.56491343222192592];
smiData.RigidTransform(138).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:3]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(139).translation = [55.249399902616226 111.85531372359955 -153.23178897160534];  % mm
smiData.RigidTransform(139).angle = 1.7963222748272034;  % rad
smiData.RigidTransform(139).axis = [-0.79655236813135766 0.42749521916878064 -0.4274952191687787];
smiData.RigidTransform(139).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:14]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(140).translation = [55.249399902616254 111.85531372359955 -159.83178897160533];  % mm
smiData.RigidTransform(140).angle = 1.7963222748271845;  % rad
smiData.RigidTransform(140).axis = [-0.79655236813137331 0.42749521916876621 -0.42749521916876421];
smiData.RigidTransform(140).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:15]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(141).translation = [55.249399902616204 111.85531372359958 -168.63178897160535];  % mm
smiData.RigidTransform(141).angle = 1.7963222748271663;  % rad
smiData.RigidTransform(141).axis = [-0.79655236813138786 0.42749521916875283 -0.42749521916875066];
smiData.RigidTransform(141).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:16]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(142).translation = [55.249399902616204 111.85531372359958 -165.43178897160527];  % mm
smiData.RigidTransform(142).angle = 1.7963222748271781;  % rad
smiData.RigidTransform(142).axis = [-0.79655236813137786 0.42749521916876149 -0.42749521916876043];
smiData.RigidTransform(142).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:17]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(143).translation = [55.249399902616176 111.85531372359961 -167.03178897160535];  % mm
smiData.RigidTransform(143).angle = 1.7963222748271737;  % rad
smiData.RigidTransform(143).axis = [-0.79655236813138308 0.42749521916875705 -0.4274952191687551];
smiData.RigidTransform(143).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:18]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(144).translation = [-42.209098539774686 285.9906746744108 -170.23178897160534];  % mm
smiData.RigidTransform(144).angle = 2.730462129827552;  % rad
smiData.RigidTransform(144).axis = [0.69156465201756656 0.20851058524603472 -0.69156465201756656];
smiData.RigidTransform(144).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:4]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(145).translation = [-42.209098539774637 285.99067467441085 -154.83178897160542];  % mm
smiData.RigidTransform(145).angle = 1.6542234703188579;  % rad
smiData.RigidTransform(145).axis = [-0.2773455929336629 0.91986892770685003 0.2773455929336624];
smiData.RigidTransform(145).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:4]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(146).translation = [-42.209098539774516 285.9906746744108 -147.63178897160546];  % mm
smiData.RigidTransform(146).angle = 1.7963222748272047;  % rad
smiData.RigidTransform(146).axis = [-0.79655236813135566 0.42749521916878219 -0.42749521916878097];
smiData.RigidTransform(146).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:19]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(147).translation = [-42.209098539774516 285.99067467441074 -147.63178897160546];  % mm
smiData.RigidTransform(147).angle = 2.0586183593682024;  % rad
smiData.RigidTransform(147).axis = [0.56491343222191992 0.60145293098504271 -0.56491343222192159];
smiData.RigidTransform(147).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:4]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(148).translation = [-42.209098539774672 285.9906746744108 -153.23178897160543];  % mm
smiData.RigidTransform(148).angle = 1.7963222748271943;  % rad
smiData.RigidTransform(148).axis = [-0.79655236813136554 0.42749521916877337 -0.42749521916877165];
smiData.RigidTransform(148).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:20]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(149).translation = [-42.209098539774587 285.9906746744108 -159.83178897160542];  % mm
smiData.RigidTransform(149).angle = 1.7963222748271797;  % rad
smiData.RigidTransform(149).axis = [-0.79655236813137698 0.42749521916876215 -0.42749521916876132];
smiData.RigidTransform(149).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:21]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(150).translation = [-42.209098539774615 285.9906746744108 -168.63178897160537];  % mm
smiData.RigidTransform(150).angle = 1.7963222748271643;  % rad
smiData.RigidTransform(150).axis = [-0.79655236813138997 0.42749521916875066 -0.42749521916874866];
smiData.RigidTransform(150).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:22]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(151).translation = [-42.209098539774601 285.99067467441074 -165.43178897160533];  % mm
smiData.RigidTransform(151).angle = 1.7963222748271737;  % rad
smiData.RigidTransform(151).axis = [-0.79655236813138153 0.42749521916875838 -0.42749521916875671];
smiData.RigidTransform(151).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:23]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(152).translation = [-42.209098539774658 285.9906746744108 -167.03178897160535];  % mm
smiData.RigidTransform(152).angle = 1.7963222748271686;  % rad
smiData.RigidTransform(152).axis = [-0.79655236813138686 0.4274952191687536 -0.42749521916875149];
smiData.RigidTransform(152).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:24]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(153).translation = [101.74802058641411 117.34600932426959 -170.23178897160523];  % mm
smiData.RigidTransform(153).angle = 2.7304621298275609;  % rad
smiData.RigidTransform(153).axis = [0.69156465201756723 0.20851058524603019 -0.69156465201756734];
smiData.RigidTransform(153).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:5]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(154).translation = [101.74802058641411 117.34600932426969 -154.83178897160536];  % mm
smiData.RigidTransform(154).angle = 1.6542234703188543;  % rad
smiData.RigidTransform(154).axis = [-0.27734559293365818 0.91986892770685291 0.27734559293365768];
smiData.RigidTransform(154).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:5]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(155).translation = [101.74802058641404 117.3460093242696 -147.63178897160532];  % mm
smiData.RigidTransform(155).angle = 1.7963222748272092;  % rad
smiData.RigidTransform(155).axis = [-0.79655236813135255 0.42749521916878497 -0.42749521916878408];
smiData.RigidTransform(155).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:25]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(156).translation = [101.74802058641407 117.34600932426964 -147.63178897160537];  % mm
smiData.RigidTransform(156).angle = 2.0586183593682135;  % rad
smiData.RigidTransform(156).axis = [0.56491343222192403 0.60145293098503527 -0.56491343222192536];
smiData.RigidTransform(156).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:5]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(157).translation = [101.74802058641413 117.34600932426964 -153.23178897160537];  % mm
smiData.RigidTransform(157).angle = 1.7963222748272025;  % rad
smiData.RigidTransform(157).axis = [-0.79655236813135832 0.42749521916878014 -0.42749521916877808];
smiData.RigidTransform(157).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:26]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(158).translation = [101.74802058641416 117.34600932426963 -159.83178897160531];  % mm
smiData.RigidTransform(158).angle = 1.7963222748271837;  % rad
smiData.RigidTransform(158).axis = [-0.79655236813137364 0.42749521916876548 -0.42749521916876426];
smiData.RigidTransform(158).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:27]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(159).translation = [101.74802058641411 117.34600932426959 -168.63178897160526];  % mm
smiData.RigidTransform(159).angle = 1.7963222748271659;  % rad
smiData.RigidTransform(159).axis = [-0.79655236813138819 0.42749521916875266 -0.42749521916875005];
smiData.RigidTransform(159).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:28]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(160).translation = [101.74802058641411 117.34600932426959 -165.43178897160527];  % mm
smiData.RigidTransform(160).angle = 1.796322274827179;  % rad
smiData.RigidTransform(160).axis = [-0.79655236813137831 0.42749521916876132 -0.42749521916875954];
smiData.RigidTransform(160).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:29]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(161).translation = [101.74802058641417 117.34600932426959 -167.03178897160527];  % mm
smiData.RigidTransform(161).angle = 1.7963222748271728;  % rad
smiData.RigidTransform(161).axis = [-0.79655236813138364 0.42749521916875699 -0.42749521916875433];
smiData.RigidTransform(161).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:30]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(162).translation = [10.189077724312895 124.57682420240889 -170.23178897160537];  % mm
smiData.RigidTransform(162).angle = 2.730462129827564;  % rad
smiData.RigidTransform(162).axis = [0.69156465201756712 0.20851058524602958 -0.69156465201756778];
smiData.RigidTransform(162).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:6]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(163).translation = [10.189077724312888 124.57682420240893 -154.83178897160536];  % mm
smiData.RigidTransform(163).angle = 1.6542234703188541;  % rad
smiData.RigidTransform(163).axis = [-0.27734559293365713 0.91986892770685358 0.27734559293365646];
smiData.RigidTransform(163).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:6]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(164).translation = [10.189077724312806 124.57682420240903 -147.63178897160532];  % mm
smiData.RigidTransform(164).angle = 1.796322274827209;  % rad
smiData.RigidTransform(164).axis = [-0.79655236813135188 0.4274952191687853 -0.4274952191687848];
smiData.RigidTransform(164).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:31]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(165).translation = [10.189077724312874 124.57682420240903 -147.63178897160537];  % mm
smiData.RigidTransform(165).angle = 2.0586183593682157;  % rad
smiData.RigidTransform(165).axis = [0.56491343222192458 0.6014529309850335 -0.56491343222192658];
smiData.RigidTransform(165).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:6]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(166).translation = [10.189077724312856 124.576824202409 -153.2317889716054];  % mm
smiData.RigidTransform(166).angle = 1.7963222748272045;  % rad
smiData.RigidTransform(166).axis = [-0.7965523681313571 0.42749521916878153 -0.42749521916877897];
smiData.RigidTransform(166).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:32]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(167).translation = [10.189077724312817 124.57682420240894 -159.83178897160536];  % mm
smiData.RigidTransform(167).angle = 1.7963222748271852;  % rad
smiData.RigidTransform(167).axis = [-0.79655236813137298 0.42749521916876659 -0.42749521916876443];
smiData.RigidTransform(167).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:33]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(168).translation = [10.18907772431287 124.57682420240891 -168.6317889716054];  % mm
smiData.RigidTransform(168).angle = 1.7963222748271677;  % rad
smiData.RigidTransform(168).axis = [-0.79655236813138774 0.42749521916875327 -0.42749521916875005];
smiData.RigidTransform(168).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:34]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(169).translation = [10.189077724312838 124.57682420240887 -165.43178897160547];  % mm
smiData.RigidTransform(169).angle = 1.7963222748271799;  % rad
smiData.RigidTransform(169).axis = [-0.79655236813137797 0.42749521916876126 -0.4274952191687601];
smiData.RigidTransform(169).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:35]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(170).translation = [10.189077724312838 124.57682420240891 -167.03178897160541];  % mm
smiData.RigidTransform(170).angle = 1.7963222748271737;  % rad
smiData.RigidTransform(170).axis = [-0.79655236813138275 0.42749521916875788 -0.42749521916875488];
smiData.RigidTransform(170).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:36]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(171).translation = [171.60292819631451 176.97500046649637 -170.23178897160537];  % mm
smiData.RigidTransform(171).angle = 2.7304621298275586;  % rad
smiData.RigidTransform(171).axis = [0.69156465201756701 0.20851058524603108 -0.69156465201756745];
smiData.RigidTransform(171).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:7]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(172).translation = [171.60292819631448 176.97500046649637 -154.83178897160539];  % mm
smiData.RigidTransform(172).angle = 1.6542234703188545;  % rad
smiData.RigidTransform(172).axis = [-0.27734559293365907 0.91986892770685247 0.27734559293365835];
smiData.RigidTransform(172).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:7]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(173).translation = [171.60292819631437 176.97500046649628 -147.6317889716054];  % mm
smiData.RigidTransform(173).angle = 1.7963222748272072;  % rad
smiData.RigidTransform(173).axis = [-0.79655236813135299 0.42749521916878419 -0.42749521916878397];
smiData.RigidTransform(173).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:37]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(174).translation = [171.60292819631445 176.9750004664964 -147.6317889716054];  % mm
smiData.RigidTransform(174).angle = 2.0586183593682108;  % rad
smiData.RigidTransform(174).axis = [0.56491343222192336 0.60145293098503705 -0.56491343222192414];
smiData.RigidTransform(174).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:7]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(175).translation = [171.60292819631437 176.97500046649645 -153.2317889716054];  % mm
smiData.RigidTransform(175).angle = 1.7963222748272007;  % rad
smiData.RigidTransform(175).axis = [-0.79655236813135977 0.42749521916877842 -0.42749521916877703];
smiData.RigidTransform(175).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:38]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(176).translation = [171.60292819631437 176.97500046649645 -159.83178897160542];  % mm
smiData.RigidTransform(176).angle = 1.796322274827183;  % rad
smiData.RigidTransform(176).axis = [-0.79655236813137464 0.42749521916876482 -0.42749521916876299];
smiData.RigidTransform(176).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:39]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(177).translation = [171.60292819631448 176.97500046649651 -168.63178897160535];  % mm
smiData.RigidTransform(177).angle = 1.796322274827165;  % rad
smiData.RigidTransform(177).axis = [-0.7965523681313883 0.42749521916875244 -0.42749521916874983];
smiData.RigidTransform(177).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:40]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(178).translation = [171.60292819631437 176.97500046649645 -165.43178897160539];  % mm
smiData.RigidTransform(178).angle = 1.7963222748271783;  % rad
smiData.RigidTransform(178).axis = [-0.79655236813137897 0.42749521916876071 -0.42749521916875899];
smiData.RigidTransform(178).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:41]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(179).translation = [171.60292819631439 176.97500046649645 -167.03178897160541];  % mm
smiData.RigidTransform(179).angle = 1.7963222748271714;  % rad
smiData.RigidTransform(179).axis = [-0.79655236813138408 0.42749521916875621 -0.42749521916875416];
smiData.RigidTransform(179).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:42]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(180).translation = [-13.212116631105085 322.75267276841026 -170.23178897160531];  % mm
smiData.RigidTransform(180).angle = 2.7304621298275533;  % rad
smiData.RigidTransform(180).axis = [0.69156465201756601 0.2085105852460343 -0.69156465201756723];
smiData.RigidTransform(180).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:8]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(181).translation = [-13.212116631105104 322.75267276841043 -154.83178897160545];  % mm
smiData.RigidTransform(181).angle = 1.6542234703188572;  % rad
smiData.RigidTransform(181).axis = [-0.27734559293366245 0.91986892770685036 0.27734559293366212];
smiData.RigidTransform(181).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:8]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(182).translation = [-13.212116631104873 322.75267276841032 -147.63178897160546];  % mm
smiData.RigidTransform(182).angle = 1.796322274827205;  % rad
smiData.RigidTransform(182).axis = [-0.79655236813135577 0.42749521916878197 -0.42749521916878114];
smiData.RigidTransform(182).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:43]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(183).translation = [-13.212116631104973 322.75267276841032 -147.63178897160549];  % mm
smiData.RigidTransform(183).angle = 2.0586183593682033;  % rad
smiData.RigidTransform(183).axis = [0.56491343222192025 0.60145293098504216 -0.56491343222192203];
smiData.RigidTransform(183).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:8]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(184).translation = [-13.212116631104953 322.75267276841032 -153.23178897160551];  % mm
smiData.RigidTransform(184).angle = 1.7963222748271956;  % rad
smiData.RigidTransform(184).axis = [-0.79655236813136443 0.42749521916877414 -0.42749521916877248];
smiData.RigidTransform(184).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:44]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(185).translation = [-13.212116631105035 322.75267276841021 -159.83178897160545];  % mm
smiData.RigidTransform(185).angle = 1.796322274827181;  % rad
smiData.RigidTransform(185).axis = [-0.79655236813137664 0.42749521916876276 -0.42749521916876143];
smiData.RigidTransform(185).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:45]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(186).translation = [-13.212116631104964 322.75267276841026 -168.63178897160549];  % mm
smiData.RigidTransform(186).angle = 1.7963222748271639;  % rad
smiData.RigidTransform(186).axis = [-0.79655236813138974 0.42749521916875094 -0.42749521916874894];
smiData.RigidTransform(186).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:46]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(187).translation = [-13.212116631105006 322.75267276841026 -165.43178897160544];  % mm
smiData.RigidTransform(187).angle = 1.7963222748271757;  % rad
smiData.RigidTransform(187).axis = [-0.79655236813138108 0.42749521916875888 -0.42749521916875682];
smiData.RigidTransform(187).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:47]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(188).translation = [-13.212116631104964 322.75267276841026 -167.03178897160541];  % mm
smiData.RigidTransform(188).angle = 1.7963222748271692;  % rad
smiData.RigidTransform(188).axis = [-0.79655236813138619 0.42749521916875455 -0.42749521916875194];
smiData.RigidTransform(188).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:48]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(189).translation = [27.645809070125562 345.61966581663734 -170.23178897160537];  % mm
smiData.RigidTransform(189).angle = 2.7304621298275542;  % rad
smiData.RigidTransform(189).axis = [0.69156465201756634 0.20851058524603425 -0.69156465201756712];
smiData.RigidTransform(189).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:9]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(190).translation = [27.64580907012574 345.61966581663739 -154.83178897160545];  % mm
smiData.RigidTransform(190).angle = 1.6542234703188561;  % rad
smiData.RigidTransform(190).axis = [-0.27734559293366218 0.91986892770685058 0.27734559293366129];
smiData.RigidTransform(190).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:9]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(191).translation = [27.645809070125651 345.61966581663739 -147.63178897160546];  % mm
smiData.RigidTransform(191).angle = 1.7963222748272059;  % rad
smiData.RigidTransform(191).axis = [-0.7965523681313551 0.4274952191687823 -0.4274952191687818];
smiData.RigidTransform(191).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:49]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(192).translation = [27.645809070125694 345.61966581663751 -147.63178897160543];  % mm
smiData.RigidTransform(192).angle = 2.058618359368205;  % rad
smiData.RigidTransform(192).axis = [0.56491343222192103 0.60145293098504082 -0.56491343222192247];
smiData.RigidTransform(192).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:9]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(193).translation = [27.645809070125669 345.61966581663739 -153.23178897160551];  % mm
smiData.RigidTransform(193).angle = 1.7963222748271961;  % rad
smiData.RigidTransform(193).axis = [-0.79655236813136399 0.42749521916877442 -0.42749521916877326];
smiData.RigidTransform(193).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:50]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(194).translation = [27.645809070125622 345.61966581663734 -159.83178897160536];  % mm
smiData.RigidTransform(194).angle = 1.7963222748271808;  % rad
smiData.RigidTransform(194).axis = [-0.79655236813137631 0.42749521916876315 -0.42749521916876176];
smiData.RigidTransform(194).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:51]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(195).translation = [27.645809070125587 345.61966581663734 -168.63178897160537];  % mm
smiData.RigidTransform(195).angle = 1.7963222748271646;  % rad
smiData.RigidTransform(195).axis = [-0.79655236813138963 0.42749521916875111 -0.42749521916874861];
smiData.RigidTransform(195).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:52]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(196).translation = [27.645809070125491 345.61966581663734 -165.43178897160539];  % mm
smiData.RigidTransform(196).angle = 1.7963222748271752;  % rad
smiData.RigidTransform(196).axis = [-0.79655236813138075 0.42749521916875904 -0.42749521916875749];
smiData.RigidTransform(196).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:53]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(197).translation = [27.645809070125651 345.61966581663734 -167.03178897160538];  % mm
smiData.RigidTransform(197).angle = 1.7963222748271699;  % rad
smiData.RigidTransform(197).axis = [-0.79655236813138608 0.42749521916875455 -0.42749521916875199];
smiData.RigidTransform(197).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:54]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(198).translation = [74.144429753923603 351.1103614173075 -170.23178897160534];  % mm
smiData.RigidTransform(198).angle = 2.7304621298275547;  % rad
smiData.RigidTransform(198).axis = [0.69156465201756645 0.20851058524603361 -0.69156465201756723];
smiData.RigidTransform(198).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:10]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(199).translation = [74.144429753923646 351.11036141730744 -154.83178897160542];  % mm
smiData.RigidTransform(199).angle = 1.6542234703188565;  % rad
smiData.RigidTransform(199).axis = [-0.27734559293366096 0.91986892770685125 0.27734559293366084];
smiData.RigidTransform(199).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:10]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(200).translation = [74.144429753923703 351.11036141730744 -147.63178897160543];  % mm
smiData.RigidTransform(200).angle = 1.7963222748272065;  % rad
smiData.RigidTransform(200).axis = [-0.79655236813135466 0.42749521916878314 -0.42749521916878186];
smiData.RigidTransform(200).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:55]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(201).translation = [74.144429753923745 351.11036141730733 -147.6317889716054];  % mm
smiData.RigidTransform(201).angle = 2.0586183593682055;  % rad
smiData.RigidTransform(201).axis = [0.56491343222192136 0.60145293098504082 -0.56491343222192236];
smiData.RigidTransform(201).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:10]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(202).translation = [74.144429753923788 351.11036141730733 -153.23178897160548];  % mm
smiData.RigidTransform(202).angle = 1.7963222748271968;  % rad
smiData.RigidTransform(202).axis = [-0.79655236813136299 0.4274952191687757 -0.42749521916877387];
smiData.RigidTransform(202).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:56]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(203).translation = [74.144429753923674 351.11036141730733 -159.83178897160533];  % mm
smiData.RigidTransform(203).angle = 1.7963222748271817;  % rad
smiData.RigidTransform(203).axis = [-0.79655236813137631 0.42749521916876326 -0.42749521916876138];
smiData.RigidTransform(203).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:57]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(204).translation = [74.144429753923632 351.11036141730744 -168.63178897160535];  % mm
smiData.RigidTransform(204).angle = 1.7963222748271652;  % rad
smiData.RigidTransform(204).axis = [-0.79655236813138952 0.42749521916875133 -0.42749521916874883];
smiData.RigidTransform(204).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:58]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(205).translation = [74.144429753923617 351.11036141730744 -165.43178897160541];  % mm
smiData.RigidTransform(205).angle = 1.7963222748271763;  % rad
smiData.RigidTransform(205).axis = [-0.79655236813138053 0.42749521916875893 -0.42749521916875777];
smiData.RigidTransform(205).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:59]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(206).translation = [74.144429753923731 351.11036141730744 -167.03178897160535];  % mm
smiData.RigidTransform(206).angle = 1.7963222748271703;  % rad
smiData.RigidTransform(206).axis = [-0.79655236813138575 0.42749521916875494 -0.42749521916875227];
smiData.RigidTransform(206).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:60]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(207).translation = [142.60594628764491 140.21300237249662 -170.2317889716052];  % mm
smiData.RigidTransform(207).angle = 2.73046212982756;  % rad
smiData.RigidTransform(207).axis = [0.69156465201756712 0.20851058524603053 -0.69156465201756734];
smiData.RigidTransform(207).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:11]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(208).translation = [142.60594628764491 140.21300237249676 -154.83178897160536];  % mm
smiData.RigidTransform(208).angle = 1.6542234703188534;  % rad
smiData.RigidTransform(208).axis = [-0.27734559293365857 0.91986892770685258 0.27734559293365835];
smiData.RigidTransform(208).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:11]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(209).translation = [142.60594628764483 140.21300237249665 -147.63178897160532];  % mm
smiData.RigidTransform(209).angle = 1.7963222748272083;  % rad
smiData.RigidTransform(209).axis = [-0.79655236813135277 0.42749521916878508 -0.42749521916878391];
smiData.RigidTransform(209).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:61]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(210).translation = [142.60594628764488 140.2130023724967 -147.6317889716054];  % mm
smiData.RigidTransform(210).angle = 2.0586183593682117;  % rad
smiData.RigidTransform(210).axis = [0.56491343222192403 0.60145293098503527 -0.56491343222192558];
smiData.RigidTransform(210).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:11]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(211).translation = [142.60594628764483 140.21300237249673 -153.23178897160531];  % mm
smiData.RigidTransform(211).angle = 1.7963222748272023;  % rad
smiData.RigidTransform(211).axis = [-0.79655236813135877 0.42749521916877936 -0.42749521916877808];
smiData.RigidTransform(211).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:62]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(212).translation = [142.60594628764491 140.21300237249673 -159.83178897160539];  % mm
smiData.RigidTransform(212).angle = 1.7963222748271834;  % rad
smiData.RigidTransform(212).axis = [-0.79655236813137398 0.42749521916876526 -0.42749521916876371];
smiData.RigidTransform(212).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:63]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(213).translation = [142.605946287645 140.2130023724967 -168.63178897160532];  % mm
smiData.RigidTransform(213).angle = 1.7963222748271663;  % rad
smiData.RigidTransform(213).axis = [-0.79655236813138819 0.42749521916875222 -0.4274952191687505];
smiData.RigidTransform(213).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:64]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(214).translation = [142.60594628764491 140.21300237249676 -165.4317889716053];  % mm
smiData.RigidTransform(214).angle = 1.7963222748271779;  % rad
smiData.RigidTransform(214).axis = [-0.79655236813137853 0.42749521916876076 -0.42749521916875999];
smiData.RigidTransform(214).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:65]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(215).translation = [142.60594628764488 140.21300237249676 -167.03178897160529];  % mm
smiData.RigidTransform(215).angle = 1.7963222748271721;  % rad
smiData.RigidTransform(215).axis = [-0.79655236813138386 0.42749521916875655 -0.42749521916875427];
smiData.RigidTransform(215).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:66]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(216).translation = [119.20475193222678 338.38885093849819 -170.23178897160531];  % mm
smiData.RigidTransform(216).angle = 2.730462129827556;  % rad
smiData.RigidTransform(216).axis = [0.69156465201756656 0.20851058524603316 -0.69156465201756712];
smiData.RigidTransform(216).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:12]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(217).translation = [119.20475193222686 338.38885093849842 -154.83178897160548];  % mm
smiData.RigidTransform(217).angle = 1.6542234703188567;  % rad
smiData.RigidTransform(217).axis = [-0.27734559293366096 0.91986892770685103 0.27734559293366084];
smiData.RigidTransform(217).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:12]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(218).translation = [119.20475193222686 338.38885093849819 -147.63178897160552];  % mm
smiData.RigidTransform(218).angle = 1.7963222748272067;  % rad
smiData.RigidTransform(218).axis = [-0.79655236813135433 0.42749521916878341 -0.42749521916878219];
smiData.RigidTransform(218).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:67]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(219).translation = [119.20475193222687 338.38885093849808 -147.63178897160557];  % mm
smiData.RigidTransform(219).angle = 2.0586183593682064;  % rad
smiData.RigidTransform(219).axis = [0.56491343222192159 0.60145293098503949 -0.56491343222192347];
smiData.RigidTransform(219).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:12]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(220).translation = [119.20475193222683 338.38885093849819 -153.23178897160551];  % mm
smiData.RigidTransform(220).angle = 1.7963222748271972;  % rad
smiData.RigidTransform(220).axis = [-0.79655236813136276 0.42749521916877603 -0.42749521916877414];
smiData.RigidTransform(220).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:68]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(221).translation = [119.20475193222684 338.38885093849825 -159.83178897160542];  % mm
smiData.RigidTransform(221).angle = 1.7963222748271817;  % rad
smiData.RigidTransform(221).axis = [-0.79655236813137609 0.42749521916876387 -0.42749521916876132];
smiData.RigidTransform(221).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:69]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(222).translation = [119.20475193222686 338.38885093849819 -168.63178897160537];  % mm
smiData.RigidTransform(222).angle = 1.7963222748271652;  % rad
smiData.RigidTransform(222).axis = [-0.7965523681313893 0.42749521916875133 -0.42749521916874933];
smiData.RigidTransform(222).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:70]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(223).translation = [119.20475193222694 338.38885093849825 -165.43178897160539];  % mm
smiData.RigidTransform(223).angle = 1.7963222748271761;  % rad
smiData.RigidTransform(223).axis = [-0.79655236813138031 0.42749521916875943 -0.42749521916875793];
smiData.RigidTransform(223).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:71]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(224).translation = [119.20475193222686 338.38885093849825 -167.03178897160535];  % mm
smiData.RigidTransform(224).angle = 1.7963222748271697;  % rad
smiData.RigidTransform(224).axis = [-0.79655236813138552 0.42749521916875505 -0.42749521916875266];
smiData.RigidTransform(224).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:72]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(225).translation = [184.32443867512359 222.03532264479952 -170.23178897160531];  % mm
smiData.RigidTransform(225).angle = 2.7304621298275582;  % rad
smiData.RigidTransform(225).axis = [0.69156465201756678 0.20851058524603167 -0.69156465201756734];
smiData.RigidTransform(225).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:13]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(226).translation = [184.3244386751237 222.03532264479958 -154.83178897160536];  % mm
smiData.RigidTransform(226).angle = 1.6542234703188554;  % rad
smiData.RigidTransform(226).axis = [-0.27734559293365979 0.91986892770685202 0.27734559293365857];
smiData.RigidTransform(226).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:13]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(227).translation = [184.32443867512376 222.03532264479969 -147.63178897160532];  % mm
smiData.RigidTransform(227).angle = 1.7963222748272081;  % rad
smiData.RigidTransform(227).axis = [-0.79655236813135333 0.42749521916878436 -0.42749521916878341];
smiData.RigidTransform(227).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:73]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(228).translation = [184.32443867512359 222.03532264479952 -147.63178897160546];  % mm
smiData.RigidTransform(228).angle = 2.0586183593682099;  % rad
smiData.RigidTransform(228).axis = [0.56491343222192303 0.60145293098503749 -0.56491343222192425];
smiData.RigidTransform(228).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:13]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(229).translation = [184.3244386751237 222.03532264479958 -153.2317889716054];  % mm
smiData.RigidTransform(229).angle = 1.7963222748272001;  % rad
smiData.RigidTransform(229).axis = [-0.79655236813136088 0.42749521916877758 -0.42749521916877614];
smiData.RigidTransform(229).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:74]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(230).translation = [184.3244386751235 222.03532264479963 -159.83178897160531];  % mm
smiData.RigidTransform(230).angle = 1.7963222748271819;  % rad
smiData.RigidTransform(230).axis = [-0.79655236813137531 0.42749521916876415 -0.42749521916876271];
smiData.RigidTransform(230).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:75]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(231).translation = [184.32443867512347 222.03532264479949 -168.63178897160537];  % mm
smiData.RigidTransform(231).angle = 1.7963222748271657;  % rad
smiData.RigidTransform(231).axis = [-0.79655236813138874 0.42749521916875205 -0.4274952191687495];
smiData.RigidTransform(231).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:76]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(232).translation = [184.32443867512353 222.03532264479952 -165.43178897160522];  % mm
smiData.RigidTransform(232).angle = 1.7963222748271772;  % rad
smiData.RigidTransform(232).axis = [-0.7965523681313792 0.42749521916876038 -0.42749521916875888];
smiData.RigidTransform(232).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:77]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(233).translation = [184.32443867512362 222.03532264479949 -167.03178897160538];  % mm
smiData.RigidTransform(233).angle = 1.7963222748271721;  % rad
smiData.RigidTransform(233).axis = [-0.7965523681313843 0.42749521916875621 -0.42749521916875366];
smiData.RigidTransform(233).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:78]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(234).translation = [155.96675002622663 309.39186902982851 -170.23178897160534];  % mm
smiData.RigidTransform(234).angle = 2.7304621298275573;  % rad
smiData.RigidTransform(234).axis = [0.69156465201756689 0.20851058524603214 -0.69156465201756701];
smiData.RigidTransform(234).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:14]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(235).translation = [155.96675002622669 309.39186902982846 -154.83178897160533];  % mm
smiData.RigidTransform(235).angle = 1.6542234703188556;  % rad
smiData.RigidTransform(235).axis = [-0.27734559293366029 0.91986892770685158 0.27734559293366001];
smiData.RigidTransform(235).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:14]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(236).translation = [155.96675002622649 309.3918690298284 -147.63178897160543];  % mm
smiData.RigidTransform(236).angle = 1.7963222748272076;  % rad
smiData.RigidTransform(236).axis = [-0.79655236813135399 0.42749521916878397 -0.42749521916878247];
smiData.RigidTransform(236).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:79]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(237).translation = [155.96675002622658 309.39186902982851 -147.6317889716054];  % mm
smiData.RigidTransform(237).angle = 2.0586183593682073;  % rad
smiData.RigidTransform(237).axis = [0.56491343222192192 0.60145293098503927 -0.56491343222192336];
smiData.RigidTransform(237).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:14]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(238).translation = [155.96675002622663 309.3918690298284 -153.23178897160548];  % mm
smiData.RigidTransform(238).angle = 1.7963222748271983;  % rad
smiData.RigidTransform(238).axis = [-0.79655236813136199 0.42749521916877659 -0.42749521916877475];
smiData.RigidTransform(238).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:80]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(239).translation = [155.96675002622678 309.39186902982846 -159.83178897160542];  % mm
smiData.RigidTransform(239).angle = 1.7963222748271819;  % rad
smiData.RigidTransform(239).axis = [-0.79655236813137575 0.42749521916876376 -0.42749521916876215];
smiData.RigidTransform(239).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:81]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(240).translation = [155.96675002622661 309.39186902982851 -168.6317889716054];  % mm
smiData.RigidTransform(240).angle = 1.7963222748271648;  % rad
smiData.RigidTransform(240).axis = [-0.79655236813138908 0.42749521916875138 -0.42749521916874961];
smiData.RigidTransform(240).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:82]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(241).translation = [155.96675002622663 309.39186902982851 -165.43178897160541];  % mm
smiData.RigidTransform(241).angle = 1.7963222748271763;  % rad
smiData.RigidTransform(241).axis = [-0.7965523681313802 0.42749521916875949 -0.42749521916875821];
smiData.RigidTransform(241).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:83]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(242).translation = [155.96675002622669 309.39186902982846 -167.03178897160541];  % mm
smiData.RigidTransform(242).angle = 1.7963222748271703;  % rad
smiData.RigidTransform(242).axis = [-0.79655236813138519 0.42749521916875499 -0.42749521916875322];
smiData.RigidTransform(242).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:84]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(243).translation = [178.83374307445359 268.53394332859756 -170.23178897160511];  % mm
smiData.RigidTransform(243).angle = 2.7304621298275569;  % rad
smiData.RigidTransform(243).axis = [0.69156465201756678 0.208510585246032 -0.69156465201756723];
smiData.RigidTransform(243).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:15]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(244).translation = [178.83374307445368 268.53394332859773 -154.83178897160536];  % mm
smiData.RigidTransform(244).angle = 1.6542234703188554;  % rad
smiData.RigidTransform(244).axis = [-0.27734559293365979 0.91986892770685191 0.27734559293365929];
smiData.RigidTransform(244).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:15]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(245).translation = [178.83374307445371 268.53394332859773 -147.6317889716054];  % mm
smiData.RigidTransform(245).angle = 1.7963222748272076;  % rad
smiData.RigidTransform(245).axis = [-0.79655236813135355 0.42749521916878414 -0.42749521916878308];
smiData.RigidTransform(245).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:85]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(246).translation = [178.83374307445368 268.53394332859762 -147.63178897160537];  % mm
smiData.RigidTransform(246).angle = 2.0586183593682081;  % rad
smiData.RigidTransform(246).axis = [0.56491343222192236 0.60145293098503816 -0.56491343222192414];
smiData.RigidTransform(246).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:15]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(247).translation = [178.83374307445359 268.53394332859773 -153.2317889716054];  % mm
smiData.RigidTransform(247).angle = 1.7963222748271994;  % rad
smiData.RigidTransform(247).axis = [-0.79655236813136132 0.42749521916877714 -0.42749521916877559];
smiData.RigidTransform(247).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:86]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(248).translation = [178.83374307445376 268.53394332859767 -159.83178897160536];  % mm
smiData.RigidTransform(248).angle = 1.7963222748271819;  % rad
smiData.RigidTransform(248).axis = [-0.79655236813137542 0.42749521916876387 -0.4274952191687626];
smiData.RigidTransform(248).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:87]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(249).translation = [178.83374307445368 268.53394332859756 -168.63178897160523];  % mm
smiData.RigidTransform(249).angle = 1.7963222748271652;  % rad
smiData.RigidTransform(249).axis = [-0.79655236813138852 0.42749521916875194 -0.42749521916874983];
smiData.RigidTransform(249).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:88]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(250).translation = [178.83374307445379 268.53394332859762 -165.43178897160516];  % mm
smiData.RigidTransform(250).angle = 1.7963222748271772;  % rad
smiData.RigidTransform(250).axis = [-0.79655236813137997 0.4274952191687601 -0.42749521916875804];
smiData.RigidTransform(250).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:89]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(251).translation = [178.83374307445371 268.53394332859762 -167.03178897160524];  % mm
smiData.RigidTransform(251).angle = 1.796322274827171;  % rad
smiData.RigidTransform(251).axis = [-0.79655236813138475 0.42749521916875566 -0.42749521916875338];
smiData.RigidTransform(251).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:90]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(252).translation = [-54.930609018583837 240.93035249610736 -170.2317889716052];  % mm
smiData.RigidTransform(252).angle = 2.7304621298276412;  % rad
smiData.RigidTransform(252).axis = [0.69156465201757356 0.20851058524598795 -0.69156465201757389];
smiData.RigidTransform(252).ID = 'AssemblyGround[Assieme_Disco:1:DIN 1587 M6:16]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(253).translation = [-54.930609018583866 240.93035249610745 -154.83178897160536];  % mm
smiData.RigidTransform(253).angle = 1.654223470318841;  % rad
smiData.RigidTransform(253).axis = [-0.27734559293363709 0.91986892770686546 0.27734559293363709];
smiData.RigidTransform(253).ID = 'AssemblyGround[Assieme_Disco:1:DIN 934 - sostituito da DIN EN 24032/28673/28674 M6:16]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(254).translation = [-54.930609018583937 240.9303524961075 -147.63178897160543];  % mm
smiData.RigidTransform(254).angle = 1.7963222748272096;  % rad
smiData.RigidTransform(254).axis = [-0.79655236813135222 0.42749521916878519 -0.42749521916878452];
smiData.RigidTransform(254).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:91]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(255).translation = [-54.930609018583866 240.93035249610745 -147.63178897160543];  % mm
smiData.RigidTransform(255).angle = 2.0586183593682166;  % rad
smiData.RigidTransform(255).axis = [0.56491343222192503 0.60145293098503327 -0.56491343222192658];
smiData.RigidTransform(255).ID = 'AssemblyGround[Assieme_Disco:1:DIN 933 - sostituito da DIN EN 24017 M6  x 30:16]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(256).translation = [-54.930609018583866 240.9303524961075 -153.23178897160543];  % mm
smiData.RigidTransform(256).angle = 1.7963222748272092;  % rad
smiData.RigidTransform(256).axis = [-0.79655236813135222 0.42749521916878513 -0.42749521916878458];
smiData.RigidTransform(256).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:92]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(257).translation = [-54.930609018583937 240.93035249610753 -159.83178897160539];  % mm
smiData.RigidTransform(257).angle = 1.7963222748272103;  % rad
smiData.RigidTransform(257).axis = [-0.79655236813135211 0.42749521916878569 -0.42749521916878436];
smiData.RigidTransform(257).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:93]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(258).translation = [-54.930609018583851 240.93035249610736 -168.63178897160526];  % mm
smiData.RigidTransform(258).angle = 1.7963222748272096;  % rad
smiData.RigidTransform(258).axis = [-0.79655236813135188 0.42749521916878547 -0.42749521916878491];
smiData.RigidTransform(258).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:94]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(259).translation = [-54.930609018583866 240.93035249610739 -165.4317889716053];  % mm
smiData.RigidTransform(259).angle = 1.7963222748272107;  % rad
smiData.RigidTransform(259).axis = [-0.79655236813135222 0.42749521916878536 -0.42749521916878419];
smiData.RigidTransform(259).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:95]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(260).translation = [-54.930609018583908 240.93035249610747 -167.03178897160527];  % mm
smiData.RigidTransform(260).angle = 1.7963222748272101;  % rad
smiData.RigidTransform(260).axis = [-0.79655236813135188 0.42749521916878569 -0.42749521916878475];
smiData.RigidTransform(260).ID = 'AssemblyGround[Assieme_Disco:1:28_Rondella_M6:96]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(261).translation = [64.696914828270025 231.48283757045348 -157.14618547681528];  % mm
smiData.RigidTransform(261).angle = 1.6345252519627982;  % rad
smiData.RigidTransform(261).axis = [0.93821878878293297 0.24468909290637197 0.24468909290637197];
smiData.RigidTransform(261).ID = 'AssemblyGround[Assieme_Disco:1:26_Collana_di_Sfere:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(262).translation = [59.502979397644886 237.56749325031734 -165.06078897160549];  % mm
smiData.RigidTransform(262).angle = 1.654223470318881;  % rad
smiData.RigidTransform(262).axis = [0.27734559293369271 -0.91986892770683004 0.27734559293369898];
smiData.RigidTransform(262).ID = 'AssemblyGround[Assieme_Disco:1:AS 1237 (2.1) 3:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(263).translation = [59.502979397644822 237.5674932503174 -165.0607889716054];  % mm
smiData.RigidTransform(263).angle = 2.8141342041319675;  % rad
smiData.RigidTransform(263).axis = [-0.69739023300217706 -0.16520812881435371 -0.69739023300217584];
smiData.RigidTransform(263).ID = 'AssemblyGround[Assieme_Disco:1:AS 1110 - Metrico M3 x 25:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(264).translation = [59.502979397645021 237.5674932503174 -147.23178897160545];  % mm
smiData.RigidTransform(264).angle = 1.6542234703188816;  % rad
smiData.RigidTransform(264).axis = [0.27734559293369265 -0.91986892770683015 0.27734559293369893];
smiData.RigidTransform(264).ID = 'AssemblyGround[Assieme_Disco:1:AS 1112 (2) - Metrico M3  Tipo 5:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(265).translation = [69.890850258894886 225.39818189058985 -165.56078897160549];  % mm
smiData.RigidTransform(265).angle = 2.8141342041319679;  % rad
smiData.RigidTransform(265).axis = [-0.69739023300217606 -0.16520812881435193 -0.6973902330021774];
smiData.RigidTransform(265).ID = 'AssemblyGround[Assieme_Disco:1:AS 1110 - Metrico M3 x 25:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(266).translation = [69.890850258894943 225.39818189058985 -165.56078897160543];  % mm
smiData.RigidTransform(266).angle = 1.6542234703188792;  % rad
smiData.RigidTransform(266).axis = [0.27734559293369543 -0.91986892770682971 0.27734559293369726];
smiData.RigidTransform(266).ID = 'AssemblyGround[Assieme_Disco:1:AS 1237 (2.1) 3:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(267).translation = [69.890850258894972 225.39818189058977 -147.23178897160528];  % mm
smiData.RigidTransform(267).angle = 1.6542234703188794;  % rad
smiData.RigidTransform(267).axis = [0.27734559293369487 -0.91986892770682982 0.27734559293369765];
smiData.RigidTransform(267).ID = 'AssemblyGround[Assieme_Disco:1:AS 1112 (2) - Metrico M3  Tipo 5:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(268).translation = [58.612259148406181 226.28890213982868 -165.56078897160549];  % mm
smiData.RigidTransform(268).angle = 2.8141342041319679;  % rad
smiData.RigidTransform(268).axis = [-0.69739023300217606 -0.16520812881435193 -0.6973902330021774];
smiData.RigidTransform(268).ID = 'AssemblyGround[Assieme_Disco:1:AS 1110 - Metrico M3 x 25:3]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(269).translation = [58.612259148406245 226.28890213982871 -165.56078897160543];  % mm
smiData.RigidTransform(269).angle = 1.6542234703188792;  % rad
smiData.RigidTransform(269).axis = [0.27734559293369543 -0.91986892770682971 0.27734559293369726];
smiData.RigidTransform(269).ID = 'AssemblyGround[Assieme_Disco:1:AS 1237 (2.1) 3:3]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(270).translation = [58.612259148406054 226.28890213982862 -144.83178897160536];  % mm
smiData.RigidTransform(270).angle = 1.654223470318881;  % rad
smiData.RigidTransform(270).axis = [-0.27734559293369815 0.91986892770682938 0.27734559293369632];
smiData.RigidTransform(270).ID = 'AssemblyGround[Assieme_Disco:1:AS 1112 (2) - Metrico M3  Tipo 5:3]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(271).translation = [70.781570508133655 236.67677300107866 -165.56078897160543];  % mm
smiData.RigidTransform(271).angle = 2.8141342041319626;  % rad
smiData.RigidTransform(271).axis = [-0.69739023300217773 -0.16520812881435115 -0.69739023300217584];
smiData.RigidTransform(271).ID = 'AssemblyGround[Assieme_Disco:1:AS 1110 - Metrico M3 x 25:4]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(272).translation = [70.781570508133683 236.67677300107857 -165.56078897160543];  % mm
smiData.RigidTransform(272).angle = 1.6542234703188792;  % rad
smiData.RigidTransform(272).axis = [0.27734559293369554 -0.91986892770682971 0.27734559293369732];
smiData.RigidTransform(272).ID = 'AssemblyGround[Assieme_Disco:1:AS 1237 (2.1) 3:4]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(273).translation = [70.781570508133242 236.67677300107874 -144.83178897160542];  % mm
smiData.RigidTransform(273).angle = 1.571759379923817;  % rad
smiData.RigidTransform(273).axis = [-0.031018162443223762 0.99903741030918947 0.03101816244322261];
smiData.RigidTransform(273).ID = 'AssemblyGround[Assieme_Disco:1:AS 1112 (2) - Metrico M3  Tipo 5:4]';


%============= Solid =============%
%Center of Mass (CoM) %Moments of Inertia (MoI) %Product of Inertia (PoI)

%Initialize the Solid structure array by filling in null values.
smiData.Solid(32).mass = 0.0;
smiData.Solid(32).CoM = [0.0 0.0 0.0];
smiData.Solid(32).MoI = [0.0 0.0 0.0];
smiData.Solid(32).PoI = [0.0 0.0 0.0];
smiData.Solid(32).color = [0.0 0.0 0.0];
smiData.Solid(32).opacity = 0.0;
smiData.Solid(32).ID = '';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(1).mass = 0.28427862228457251;  % kg
smiData.Solid(1).CoM = [-1.5454142451139869e-11 27.208684343667247 -3.616817023001641e-14];  % mm
smiData.Solid(1).MoI = [320.90674042007851 598.48824220032657 463.19784288862576];  % kg*mm^2
smiData.Solid(1).PoI = [0 -8.8130036601637876e-14 8.5293461399366973e-11];  % kg*mm^2
smiData.Solid(1).color = [0.96078431372549022 0.96078431372549022 0.96078431372549022];
smiData.Solid(1).opacity = 1;
smiData.Solid(1).ID = '19_Base_Pezzo_Unico.ipt_{7C038A44-4F5D-277D-6D95-8287DBE6EBAD}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(2).mass = 0.026202550579053192;  % kg
smiData.Solid(2).CoM = [6.24333802728591e-12 -0.13015218853521049 8.8954936066189951];  % mm
smiData.Solid(2).MoI = [2.1253251823410624 20.797068485686818 21.419071299521782];  % kg*mm^2
smiData.Solid(2).PoI = [-0.016841623237927171 2.3242182097061469e-13 0];  % kg*mm^2
smiData.Solid(2).color = [0.96862745098039216 0.96862745098039216 0.90196078431372551];
smiData.Solid(2).opacity = 1;
smiData.Solid(2).ID = '20_Base_Sopra.ipt_{9E5FE860-495D-1D67-91B9-10BE8ADB3001}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(3).mass = 0.019485863004900128;  % kg
smiData.Solid(3).CoM = [8.885274444292893 8.8780239826666758 -146.77272727272731];  % mm
smiData.Solid(3).MoI = [2.7096600868653695 5.342994071933572 4.0319638853946511];  % kg*mm^2
smiData.Solid(3).PoI = [0 0 0.015369275496005839];  % kg*mm^2
smiData.Solid(3).color = [0.74901960784313726 0.74901960784313726 0.74901960784313726];
smiData.Solid(3).opacity = 1;
smiData.Solid(3).ID = '22_Blocco_Escursione_Braccio.ipt_{7915D2DB-4D85-5D45-94BE-DA90F04D09E8}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(4).mass = 0.015905278340676787;  % kg
smiData.Solid(4).CoM = [24.682580939766879 5.3808183582914927e-10 0];  % mm
smiData.Solid(4).MoI = [0.094920869670491709 6.2597437201962025 6.259743712173627];  % kg*mm^2
smiData.Solid(4).PoI = [0 0 -3.7997135818491156e-11];  % kg*mm^2
smiData.Solid(4).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(4).opacity = 1;
smiData.Solid(4).ID = 'UNI 5739 M6 x 60_{A372AD11-815C-A684-A6DB-14AD41B3ECC9}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(5).mass = 0.0027209470214407372;  % kg
smiData.Solid(5).CoM = [2.5999999999999983 0 -1.3303668096371805e-10];  % mm
smiData.Solid(5).MoI = [0.046110011026971369 0.029030697876146205 0.029030698546691373];  % kg*mm^2
smiData.Solid(5).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(5).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(5).opacity = 1;
smiData.Solid(5).ID = 'AS 1112 (2) - Metrico M6  Tipo 5_{9BCF4747-0768-EEBD-BDB4-BAC10216F668}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(6).mass = 0.0011116418790576784;  % kg
smiData.Solid(6).CoM = [0.80000000000000004 1.5455825914449699e-09 0];  % mm
smiData.Solid(6).MoI = [0.027764643688948765 0.01411947390487224 0.014119470319141136];  % kg*mm^2
smiData.Solid(6).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(6).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(6).opacity = 1;
smiData.Solid(6).ID = 'IS 2016 A A6.6_{D40BF110-1D68-FF06-0068-177DD8842A18}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(7).mass = 0.0075983522566636609;  % kg
smiData.Solid(7).CoM = [15.808998698942975 4.3671498476563979e-10 0];  % mm
smiData.Solid(7).MoI = [0.031575841368629697 1.3891121055943176 1.3891121030043951];  % kg*mm^2
smiData.Solid(7).PoI = [0 0 -1.1578257355640726e-11];  % kg*mm^2
smiData.Solid(7).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(7).opacity = 1;
smiData.Solid(7).ID = 'UNI 5739 M5 x 40_{08205C30-6148-93A5-1589-42B6ACEAB930}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(8).mass = 0.00043003494689121196;  % kg
smiData.Solid(8).CoM = [0.49999999999999994 1.2497546927119201e-09 0];  % mm
smiData.Solid(8).MoI = [0.0070015060269594505 0.0035365897111670824 0.0035365888069409032];  % kg*mm^2
smiData.Solid(8).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(8).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(8).opacity = 1;
smiData.Solid(8).ID = 'IS 2016 A A5.5_{DBEE1004-8090-21BD-A1DF-749F6B10A68F}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(9).mass = 0.00096864241068575984;  % kg
smiData.Solid(9).CoM = [1.5 0 -1.2479488393496865e-10];  % mm
smiData.Solid(9).MoI = [0.01070785749385297 0.0060545264983599941 0.0060545266849830739];  % kg*mm^2
smiData.Solid(9).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(9).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(9).opacity = 1;
smiData.Solid(9).ID = 'AS 1112 (4) - Metrico M5_{148CA801-2ED7-8EEF-2ABF-CC5500D55229}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(10).mass = 0.0012762720155209118;  % kg
smiData.Solid(10).CoM = [-1.0686872504588327e-09 0 2.5];  % mm
smiData.Solid(10).MoI = [0.034326393282783585 0.034326401462336044 0.063334994680449161];  % kg*mm^2
smiData.Solid(10).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(10).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(10).opacity = 1;
smiData.Solid(10).ID = '31_Cuscinetto_fittizio.ipt_{876B1DB3-471D-7169-5B22-0CBFCA751E26}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(11).mass = 0.12898349621567878;  % kg
smiData.Solid(11).CoM = [-1.0087309168406074e-11 17.209800918836194 0];  % mm
smiData.Solid(11).MoI = [30.053538756126237 12.520164280694923 30.053538759680258];  % kg*mm^2
smiData.Solid(11).PoI = [0 0 6.2541308210179463e-11];  % kg*mm^2
smiData.Solid(11).color = [0.27058823529411763 0.27058823529411763 0.27058823529411763];
smiData.Solid(11).opacity = 1;
smiData.Solid(11).ID = '1_Asse_cuscinetti.ipt_{8399E34B-43EF-0CAF-E0AA-A6A711B719B9}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(12).mass = 0.03003318475977481;  % kg
smiData.Solid(12).CoM = [0.0074520173006813392 -0.0074515441512245555 2.5093420098397976];  % mm
smiData.Solid(12).MoI = [11.474188559510361 16.050274561834037 8.5100004162424572];  % kg*mm^2
smiData.Solid(12).PoI = [0.0038717125649921033 -0.0038716144977916328 0.0018117054136672181];  % kg*mm^2
smiData.Solid(12).color = [0.96078431372549022 0.96078431372549022 0.96078431372549022];
smiData.Solid(12).opacity = 1;
smiData.Solid(12).ID = '2_Connettore_inf_sup.ipt_{C2195D89-4C8B-347C-BF50-73BA5CA51328}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(13).mass = 0.017975398554038131;  % kg
smiData.Solid(13).CoM = [-1.0392944368376689e-11 5.1070979697182742e-15 -7.0404750921731836];  % mm
smiData.Solid(13).MoI = [2.1366747737243048 6.7984442943012953 7.3813545960968101];  % kg*mm^2
smiData.Solid(13).PoI = [0 -1.0164912167565223e-12 0];  % kg*mm^2
smiData.Solid(13).color = [0.96078431372549022 0.96078431372549022 0.96078431372549022];
smiData.Solid(13).opacity = 1;
smiData.Solid(13).ID = '3_Connettore_inf_INF.ipt_{785A06B7-49A8-E4E4-230C-F7A8604E65AF}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(14).mass = 0.0006219223916933774;  % kg
smiData.Solid(14).CoM = [-1.5573624291702767e-11 1.30711131264562 1.8163630394632289];  % mm
smiData.Solid(14).MoI = [0.015671743215102143 0.036123999394451982 0.022723514554357276];  % kg*mm^2
smiData.Solid(14).PoI = [-0.0017094065340867862 -7.0861040542299592e-14 0];  % kg*mm^2
smiData.Solid(14).color = [1 1 1];
smiData.Solid(14).opacity = 1;
smiData.Solid(14).ID = '10_MPU_6050.ipt_{E2057A6E-4575-693F-FA8D-F18B6A807785}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(15).mass = 0.025784978041973199;  % kg
smiData.Solid(15).CoM = [5.6191522740621152e-11 -2.6467980565530455e-14 -76.500000000003055];  % mm
smiData.Solid(15).MoI = [51.223726703400352 51.223726703400352 3.1253057606913659];  % kg*mm^2
smiData.Solid(15).PoI = [0 -7.4516375292876894e-13 0];  % kg*mm^2
smiData.Solid(15).color = [0.99607843137254903 0.99607843137254903 1];
smiData.Solid(15).opacity = 1;
smiData.Solid(15).ID = '4_barra.ipt_{70E42CB2-4E15-7EFF-0042-8DACF3A154F5}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(16).mass = 0.10065415222380616;  % kg
smiData.Solid(16).CoM = [-1.2052001893845568e-12 -2.2347798102722409 11.361608804563375];  % mm
smiData.Solid(16).MoI = [77.54516578383587 69.370295125818188 49.595469411435772];  % kg*mm^2
smiData.Solid(16).PoI = [4.7415177960691075 -2.9957040008891123e-12 1.540342901620635e-12];  % kg*mm^2
smiData.Solid(16).color = [0.96078431372549022 0.96078431372549022 0.96078431372549022];
smiData.Solid(16).opacity = 1;
smiData.Solid(16).ID = '30_Connettore_sup.ipt_{0CFB390E-4EA8-A4AA-47A6-47950BFFF8A2}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(17).mass = 0.075015224649266132;  % kg
smiData.Solid(17).CoM = [-1.9098732910833673e-09 -0.10067188300168456 34.003236268996048];  % mm
smiData.Solid(17).MoI = [37.462758677985427 37.411251785615271 12.699421381582281];  % kg*mm^2
smiData.Solid(17).PoI = [-0.30949236547369352 8.1530130655417165e-11 1.6402789851470106e-11];  % kg*mm^2
smiData.Solid(17).color = [0.95686274509803926 0.95686274509803926 0.95686274509803926];
smiData.Solid(17).opacity = 1;
smiData.Solid(17).ID = '29_Motore_6mm.ipt_{E205AE32-4F83-E610-5241-B2BFB32A5644}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(18).mass = 0.0010648561188752392;  % kg
smiData.Solid(18).CoM = [3.3333319015416318 2.1497402895615881e-10 0];  % mm
smiData.Solid(18).MoI = [0.0023948961785386241 0.021410662426451028 0.021410662312312818];  % kg*mm^2
smiData.Solid(18).PoI = [0 0 -4.7112590265557954e-13];  % kg*mm^2
smiData.Solid(18).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(18).opacity = 1;
smiData.Solid(18).ID = 'AS 1110 - Metrico M3 x 12_{1F1E2368-1702-3548-C348-2F8F1888837D}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(19).mass = 0.0027948453234549818;  % kg
smiData.Solid(19).CoM = [4.6447639341317846 -2.4213834466561542e-12 0];  % mm
smiData.Solid(19).MoI = [0.090836717942251621 0.024144626708781914 0.10671998516615247];  % kg*mm^2
smiData.Solid(19).PoI = [0 0 -1.0923834023967977e-13];  % kg*mm^2
smiData.Solid(19).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(19).opacity = 1;
smiData.Solid(19).ID = 'JIS B 1185 Tipo 1 - Metrico M4_{821578D8-83C6-B0A8-EE5D-F22048B4BA4F}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(20).mass = 0.00031420953084142325;  % kg
smiData.Solid(20).CoM = [0.40000000000000008 1.0864856398923737e-09 0];  % mm
smiData.Solid(20).MoI = [0.0039075880255992623 0.0019705521067718908 0.0019705516021171227];  % kg*mm^2
smiData.Solid(20).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(20).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(20).opacity = 1;
smiData.Solid(20).ID = 'ISO 7089 4_{3EB9AE38-5E50-4FC3-26E0-406B9D9CA5CA}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(21).mass = 0.001632677773427668;  % kg
smiData.Solid(21).CoM = [3.4420057109009812 0 7.9603796407651029e-11];  % mm
smiData.Solid(21).MoI = [0.010914863124009635 0.012674205103719834 0.012674205264233287];  % kg*mm^2
smiData.Solid(21).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(21).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(21).opacity = 1;
smiData.Solid(21).ID = 'DIN 1587 M4_{0FEC2F55-73ED-9EA8-63A2-F5D0A6A1A8EC}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(22).mass = 0.0047578468777037539;  % kg
smiData.Solid(22).CoM = [16.038188243371273 3.5232763897894949e-10 0];  % mm
smiData.Solid(22).MoI = [0.013456823398770922 0.84967669465725004 0.84967669360779297];  % kg*mm^2
smiData.Solid(22).PoI = [0 0 -5.4985835174165142e-12];  % kg*mm^2
smiData.Solid(22).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(22).opacity = 1;
smiData.Solid(22).ID = 'ISO 4017 M4 x 40_{106ECA69-99AA-D31A-75D7-8255D4C1C2DD}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(23).mass = 0.008874650922809842;  % kg
smiData.Solid(23).CoM = [-2.1727842146472226e-09 3.5569010073337011 3.7974651281991244e-10];  % mm
smiData.Solid(23).MoI = [0.3092136309234127 0.39477082826733167 0.3098727569232646];  % kg*mm^2
smiData.Solid(23).PoI = [-9.486243968155465e-12 -0.0011299912197713258 -2.7332628580620153e-11];  % kg*mm^2
smiData.Solid(23).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(23).opacity = 1;
smiData.Solid(23).ID = '9_Flangia.ipt_{47AA717B-4515-9B6A-A2A6-D9A29629A323}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(24).mass = 0.035241872990924628;  % kg
smiData.Solid(24).CoM = [0.0057923329442101596 1.997238503249346 -0.00015188219270773781];  % mm
smiData.Solid(24).MoI = [185.70614934280385 371.26335244500672 185.65105113225556];  % kg*mm^2
smiData.Solid(24).PoI = [8.8311102334425715e-06 -0.00061285088728834996 -0.00030769002925016094];  % kg*mm^2
smiData.Solid(24).color = [1 1 1];
smiData.Solid(24).opacity = 1;
smiData.Solid(24).ID = '24_Disco.ipt_{589156E5-4EA3-F9BE-FA25-68BB06AC74F5}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(25).mass = 0.0051014642372110243;  % kg
smiData.Solid(25).CoM = [5.2609289727488502 0 1.2667494729872923e-10];  % mm
smiData.Solid(25).MoI = [0.071963159463769674 0.08754286724125207 0.087542868438382632];  % kg*mm^2
smiData.Solid(25).PoI = [0 4.0003763979487047e-13 0];  % kg*mm^2
smiData.Solid(25).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(25).opacity = 1;
smiData.Solid(25).ID = 'DIN 1587 M6_{10C73804-9F76-B88F-F9A1-2AD85E2B709D}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(26).mass = 0.0025217350523128131;  % kg
smiData.Solid(26).CoM = [2.5000000000000009 8.7111896998868867e-10 -1.402500988713261e-10];  % mm
smiData.Solid(26).MoI = [0.041972712823053392 0.02579932862910439 0.025799326289468284];  % kg*mm^2
smiData.Solid(26).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(26).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(26).opacity = 1;
smiData.Solid(26).ID = 'DIN 934 - sostituito da DIN EN 24032/28673/28674 M6_{9F4BC115-209C-E4B0-5136-B5F05713EBEC}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(27).mass = 0.0010164484800612588;  % kg
smiData.Solid(27).CoM = [-1.4875935790430706e-09 0.80000000000000004 0];  % mm
smiData.Solid(27).MoI = [0.011966987530671372 0.023500287341515998 0.011966984495670763];  % kg*mm^2
smiData.Solid(27).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(27).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(27).opacity = 1;
smiData.Solid(27).ID = '28_Rondella_M6.ipt_{A33BED69-44F4-0189-AF8B-96BE74B3C164}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(28).mass = 0.0091337448727666481;  % kg
smiData.Solid(28).CoM = [10.246309708605875 4.6796020655614706e-10 0];  % mm
smiData.Solid(28).MoI = [0.063917080591511105 1.0616984363841646 1.0616984323656447];  % kg*mm^2
smiData.Solid(28).PoI = [0 0 -1.8011042495097325e-11];  % kg*mm^2
smiData.Solid(28).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(28).opacity = 1;
smiData.Solid(28).ID = 'DIN 933 - sostituito da DIN EN 24017 M6  x 30_{A086C25C-6A33-B165-EA7C-DD8C6BD5BD3D}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(29).mass = 0.14399369921403274;  % kg
smiData.Solid(29).CoM = [4.3476015511247203e-14 -3.5812550802533824e-14 2.0643033250676053e-10];  % mm
smiData.Solid(29).MoI = [1039.0771087593389 2075.8317429836297 1039.0771085989138];  % kg*mm^2
smiData.Solid(29).PoI = [-6.8946651921032425e-11 7.6315700425895652e-13 6.4093264029452053e-14];  % kg*mm^2
smiData.Solid(29).color = [0.35294117647058826 0.3843137254901961 0.40000000000000002];
smiData.Solid(29).opacity = 1;
smiData.Solid(29).ID = '26_Collana_di_Sfere.ipt_{9F3901FC-4AAD-40E9-97A8-1FB18D4B7BFF}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(30).mass = 7.9410037504785803e-05;  % kg
smiData.Solid(30).CoM = [0.25000000000000006 7.4379625363291759e-10 0];  % mm
smiData.Solid(30).MoI = [0.00045898998713898392 0.00023114939898951934 0.00023114933971216388];  % kg*mm^2
smiData.Solid(30).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(30).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(30).opacity = 1;
smiData.Solid(30).ID = 'AS 1237 (2.1) 3_{83133A67-E39B-9402-85BF-16DD7A1D38CF}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(31).mass = 0.0017862050620475942;  % kg
smiData.Solid(31).CoM = [9.4346957357204566 2.5484546609215899e-10 0];  % mm
smiData.Solid(31).MoI = [0.0032064136872048416 0.13014086592701449 0.13014086570807093];  % kg*mm^2
smiData.Solid(31).PoI = [0 0 -1.1072739754719906e-12];  % kg*mm^2
smiData.Solid(31).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(31).opacity = 1;
smiData.Solid(31).ID = 'AS 1110 - Metrico M3 x 25_{013A5C08-140D-4027-E896-5F16028F99A7}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(32).mass = 0.00039849638268521162;  % kg
smiData.Solid(32).CoM = [1.2000000000000002 0 -5.243140253858104e-11];  % mm
smiData.Solid(32).MoI = [0.0019764099957795631 0.0011748296661996459 0.0011748296855551951];  % kg*mm^2
smiData.Solid(32).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(32).color = [0.74509803921568629 0.73725490196078436 0.72941176470588232];
smiData.Solid(32).opacity = 1;
smiData.Solid(32).ID = 'AS 1112 (2) - Metrico M3  Tipo 5_{B4624124-4293-12B8-8BC2-30CEBC61882D}';


%============= Joint =============%
%X Revolute Primitive (Rx) %Y Revolute Primitive (Ry) %Z Revolute Primitive (Rz)
%X Prismatic Primitive (Px) %Y Prismatic Primitive (Py) %Z Prismatic Primitive (Pz) %Spherical Primitive (S)
%Constant Velocity Primitive (CV) %Lead Screw Primitive (LS)
%Position Target (Pos)

%Initialize the PlanarJoint structure array by filling in null values.
smiData.PlanarJoint(3).Rz.Pos = 0.0;
smiData.PlanarJoint(3).Px.Pos = 0.0;
smiData.PlanarJoint(3).Py.Pos = 0.0;
smiData.PlanarJoint(3).ID = '';

%This joint has been chosen as a cut joint. Simscape Multibody treats cut joints as algebraic constraints to solve closed kinematic loops. The imported model does not use the state target data for this joint.
smiData.PlanarJoint(1).Rz.Pos = -90.000000000000156;  % deg
smiData.PlanarJoint(1).Px.Pos = 0;  % mm
smiData.PlanarJoint(1).Py.Pos = 0;  % mm
smiData.PlanarJoint(1).ID = '[19_Base_Pezzo_Unico:1:-:20_Base_Sopra:1]';

%This joint has been chosen as a cut joint. Simscape Multibody treats cut joints as algebraic constraints to solve closed kinematic loops. The imported model does not use the state target data for this joint.
smiData.PlanarJoint(2).Rz.Pos = -89.999999999999929;  % deg
smiData.PlanarJoint(2).Px.Pos = 0;  % mm
smiData.PlanarJoint(2).Py.Pos = 0;  % mm
smiData.PlanarJoint(2).ID = '[20_Base_Sopra:2:-:19_Base_Pezzo_Unico:1]';

smiData.PlanarJoint(3).Rz.Pos = -81.527554466326634;  % deg
smiData.PlanarJoint(3).Px.Pos = 0;  % mm
smiData.PlanarJoint(3).Py.Pos = 0;  % mm
smiData.PlanarJoint(3).ID = '[19_Base_Pezzo_Unico:1:-:]';


%Initialize the RevoluteJoint structure array by filling in null values.
smiData.RevoluteJoint(36).Rz.Pos = 0.0;
smiData.RevoluteJoint(36).ID = '';

smiData.RevoluteJoint(1).Rz.Pos = -4.0301789005601669e-13;  % deg
smiData.RevoluteJoint(1).ID = '[31_Cuscinetto_fittizio:1:-:19_Base_Pezzo_Unico:1]';

smiData.RevoluteJoint(2).Rz.Pos = 3.4675468643923416e-13;  % deg
smiData.RevoluteJoint(2).ID = '[31_Cuscinetto_fittizio:2:-:19_Base_Pezzo_Unico:1]';

smiData.RevoluteJoint(3).Rz.Pos = 85.291535361907108;  % deg
smiData.RevoluteJoint(3).ID = '[AS 1112 (4) - Metrico M5:1:-:19_Base_Pezzo_Unico:1]';

smiData.RevoluteJoint(4).Rz.Pos = 80.200437686475055;  % deg
smiData.RevoluteJoint(4).ID = '[AS 1112 (4) - Metrico M5:2:-:19_Base_Pezzo_Unico:1]';

smiData.RevoluteJoint(5).Rz.Pos = 95.944178752355043;  % deg
smiData.RevoluteJoint(5).ID = '[AS 1112 (4) - Metrico M5:3:-:19_Base_Pezzo_Unico:1]';

smiData.RevoluteJoint(6).Rz.Pos = 96.118458525249494;  % deg
smiData.RevoluteJoint(6).ID = '[AS 1112 (4) - Metrico M5:4:-:19_Base_Pezzo_Unico:1]';

smiData.RevoluteJoint(7).Rz.Pos = -172.93990359787884;  % deg
smiData.RevoluteJoint(7).ID = '[AS 1112 (2) - Metrico M6  Tipo 5:1:-:19_Base_Pezzo_Unico:1]';

smiData.RevoluteJoint(8).Rz.Pos = -176.98215263676596;  % deg
smiData.RevoluteJoint(8).ID = '[AS 1112 (2) - Metrico M6  Tipo 5:2:-:19_Base_Pezzo_Unico:1]';

smiData.RevoluteJoint(9).Rz.Pos = -176.98215263676596;  % deg
smiData.RevoluteJoint(9).ID = '[AS 1112 (2) - Metrico M6  Tipo 5:3:-:19_Base_Pezzo_Unico:1]';

smiData.RevoluteJoint(10).Rz.Pos = 166.42436833564588;  % deg
smiData.RevoluteJoint(10).ID = '[AS 1112 (2) - Metrico M6  Tipo 5:4:-:19_Base_Pezzo_Unico:1]';

smiData.RevoluteJoint(11).Rz.Pos = 81.527554466326606;  % deg
smiData.RevoluteJoint(11).ID = '[19_Base_Pezzo_Unico:1:-:IS 2016 A A5.5:7]';

smiData.RevoluteJoint(12).Rz.Pos = 81.527554466326606;  % deg
smiData.RevoluteJoint(12).ID = '[IS 2016 A A5.5:9:-:19_Base_Pezzo_Unico:1]';

smiData.RevoluteJoint(13).Rz.Pos = 6.9769175257214435;  % deg
smiData.RevoluteJoint(13).ID = '[IS 2016 A A6.6:1:-:19_Base_Pezzo_Unico:1]';

smiData.RevoluteJoint(14).Rz.Pos = 5.5871671222396264;  % deg
smiData.RevoluteJoint(14).ID = '[IS 2016 A A6.6:2:-:19_Base_Pezzo_Unico:1]';

smiData.RevoluteJoint(15).Rz.Pos = -8.4724455336733921;  % deg
smiData.RevoluteJoint(15).ID = '[IS 2016 A A6.6:3:-:19_Base_Pezzo_Unico:1]';

smiData.RevoluteJoint(16).Rz.Pos = -6.4595117988720636;  % deg
smiData.RevoluteJoint(16).ID = '[IS 2016 A A6.6:4:-:19_Base_Pezzo_Unico:1]';

smiData.RevoluteJoint(17).Rz.Pos = -1.4174440301310297e-13;  % deg
smiData.RevoluteJoint(17).ID = '[Assieme_Barra:1:-:31_Cuscinetto_fittizio:2]';

smiData.RevoluteJoint(18).Rz.Pos = -8.4724455336734827;  % deg
smiData.RevoluteJoint(18).ID = '[IS 2016 A A5.5:10:-:20_Base_Sopra:1]';

smiData.RevoluteJoint(19).Rz.Pos = -2.8447745895630462e-14;  % deg
smiData.RevoluteJoint(19).ID = '[IS 2016 A A5.5:10:-:UNI 5739 M5 x 40:5]';

smiData.RevoluteJoint(20).Rz.Pos = 68.331203484931123;  % deg
smiData.RevoluteJoint(20).ID = '[19_Base_Pezzo_Unico:1:-:IS 2016 A A5.5:11]';

smiData.RevoluteJoint(21).Rz.Pos = -158.33120348493105;  % deg
smiData.RevoluteJoint(21).ID = '[IS 2016 A A5.5:11:-:20_Base_Sopra:2]';

smiData.RevoluteJoint(22).Rz.Pos = 178.72581673903883;  % deg
smiData.RevoluteJoint(22).ID = '[IS 2016 A A5.5:12:-:20_Base_Sopra:2]';

smiData.RevoluteJoint(23).Rz.Pos = -3.5521489722421049;  % deg
smiData.RevoluteJoint(23).ID = '[IS 2016 A A5.5:12:-:UNI 5739 M5 x 40:6]';

smiData.RevoluteJoint(24).Rz.Pos = 78.869545921083215;  % deg
smiData.RevoluteJoint(24).ID = '[IS 2016 A A5.5:13:-:19_Base_Pezzo_Unico:1]';

%This joint has been chosen as a cut joint. Simscape Multibody treats cut joints as algebraic constraints to solve closed kinematic loops. The imported model does not use the state target data for this joint.
smiData.RevoluteJoint(25).Rz.Pos = -168.86954592108313;  % deg
smiData.RevoluteJoint(25).ID = '[IS 2016 A A5.5:13:-:20_Base_Sopra:2]';

smiData.RevoluteJoint(26).Rz.Pos = -168.59466892658392;  % deg
smiData.RevoluteJoint(26).ID = '[IS 2016 A A5.5:14:-:20_Base_Sopra:2]';

smiData.RevoluteJoint(27).Rz.Pos = -19.877776607089544;  % deg
smiData.RevoluteJoint(27).ID = '[IS 2016 A A5.5:14:-:UNI 5739 M5 x 40:7]';

smiData.RevoluteJoint(28).Rz.Pos = 8.4724455336735236;  % deg
smiData.RevoluteJoint(28).ID = '[IS 2016 A A5.5:7:-:20_Base_Sopra:1]';

smiData.RevoluteJoint(29).Rz.Pos = -8.4724455336735129;  % deg
smiData.RevoluteJoint(29).ID = '[IS 2016 A A5.5:8:-:20_Base_Sopra:1]';

%This joint has been chosen as a cut joint. Simscape Multibody treats cut joints as algebraic constraints to solve closed kinematic loops. The imported model does not use the state target data for this joint.
smiData.RevoluteJoint(30).Rz.Pos = 8.4724455336735236;  % deg
smiData.RevoluteJoint(30).ID = '[IS 2016 A A5.5:9:-:20_Base_Sopra:1]';

smiData.RevoluteJoint(31).Rz.Pos = -18.107371604638097;  % deg
smiData.RevoluteJoint(31).ID = '[IS 2016 A A6.6:1:-:UNI 5739 M6 x 60:1]';

smiData.RevoluteJoint(32).Rz.Pos = -16.717621201156291;  % deg
smiData.RevoluteJoint(32).ID = '[IS 2016 A A6.6:2:-:UNI 5739 M6 x 60:2]';

smiData.RevoluteJoint(33).Rz.Pos = 2.4840926170103824e-14;  % deg
smiData.RevoluteJoint(33).ID = '[IS 2016 A A6.6:3:-:UNI 5739 M6 x 60:3]';

smiData.RevoluteJoint(34).Rz.Pos = -4.6709422800446054;  % deg
smiData.RevoluteJoint(34).ID = '[IS 2016 A A6.6:4:-:UNI 5739 M6 x 60:4]';

smiData.RevoluteJoint(35).Rz.Pos = -5.0087425211137726e-14;  % deg
smiData.RevoluteJoint(35).ID = '[IS 2016 A A5.5:8:-:UNI 5739 M5 x 40:4]';

smiData.RevoluteJoint(36).Rz.Pos = -1.7516268603820017e-13;  % deg
smiData.RevoluteJoint(36).ID = '[Assieme_Disco:1:-:Assieme_Barra:1]';


% %%
% % Simscape(TM) Multibody(TM) version: 7.0
% 
% % This is a model data file derived from a Simscape Multibody Import XML file using the smimport function.
% % The data in this file sets the block parameter values in an imported Simscape Multibody model.
% % For more information on this file, see the smimport function help page in the Simscape Multibody documentation.
% % You can modify numerical values, but avoid any other changes to this file.
% % Do not add code to this file. Do not edit the physical units shown in comments.
% 
% %%%VariableName:smiData
% 
% 
% %============= RigidTransform =============%
% 
% %Initialize the RigidTransform structure array by filling in null values.
% smiData.RigidTransform(11).translation = [0.0 0.0 0.0];
% smiData.RigidTransform(11).angle = 0.0;
% smiData.RigidTransform(11).axis = [0.0 0.0 0.0];
% smiData.RigidTransform(11).ID = '';
% 
% %Translation Method - Cartesian
% %Rotation Method - Arbitrary Axis
% smiData.RigidTransform(1).translation = [1.7763568394002505e-14 0 0];  % mm
% smiData.RigidTransform(1).angle = 0;  % rad
% smiData.RigidTransform(1).axis = [0 0 0];
% smiData.RigidTransform(1).ID = 'B[Base:1:-:]';
% 
% %Translation Method - Cartesian
% %Rotation Method - Arbitrary Axis
% smiData.RigidTransform(2).translation = [-17.295596894265962 -0.91194967194548215 0];  % mm
% smiData.RigidTransform(2).angle = 0;  % rad
% smiData.RigidTransform(2).axis = [0 0 0];
% smiData.RigidTransform(2).ID = 'F[Base:1:-:]';
% 
% %Translation Method - Cartesian
% %Rotation Method - Arbitrary Axis
% smiData.RigidTransform(3).translation = [89 0 -2.2204460492503131e-14];  % mm
% smiData.RigidTransform(3).angle = 2.0943951023931953;  % rad
% smiData.RigidTransform(3).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
% smiData.RigidTransform(3).ID = 'B[Pendolo:1:-:Base:1]';
% 
% %Translation Method - Cartesian
% %Rotation Method - Arbitrary Axis
% smiData.RigidTransform(4).translation = [1.0658141036401503e-14 -9.9999999999999822 34.999999999999964];  % mm
% smiData.RigidTransform(4).angle = 2.0943951023931953;  % rad
% smiData.RigidTransform(4).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
% smiData.RigidTransform(4).ID = 'F[Pendolo:1:-:Base:1]';
% 
% %Translation Method - Cartesian
% %Rotation Method - Arbitrary Axis
% smiData.RigidTransform(5).translation = [0 4.4408920985006262e-15 -4.4408920985006262e-15];  % mm
% smiData.RigidTransform(5).angle = 2.0943951023931953;  % rad
% smiData.RigidTransform(5).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
% smiData.RigidTransform(5).ID = 'B[Perno:1:-:Base:1]';
% 
% %Translation Method - Cartesian
% %Rotation Method - Arbitrary Axis
% smiData.RigidTransform(6).translation = [1.0658141036401503e-14 -24.999999999999986 34.999999999999986];  % mm
% smiData.RigidTransform(6).angle = 2.0943951023931953;  % rad
% smiData.RigidTransform(6).axis = [-0.57735026918962562 -0.57735026918962584 -0.57735026918962584];
% smiData.RigidTransform(6).ID = 'F[Perno:1:-:Base:1]';
% 
% %Translation Method - Cartesian
% %Rotation Method - Arbitrary Axis
% smiData.RigidTransform(7).translation = [0 -2.2204460492503131e-15 0];  % mm
% smiData.RigidTransform(7).angle = 2.0943951023931953;  % rad
% smiData.RigidTransform(7).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
% smiData.RigidTransform(7).ID = 'B[Perno:2:-:Pendolo:1]';
% 
% %Translation Method - Cartesian
% %Rotation Method - Arbitrary Axis
% smiData.RigidTransform(8).translation = [-89.000000000000028 -1.7763568394002414e-15 -1.3650170512753636e-14];  % mm
% smiData.RigidTransform(8).angle = 2.0943951023931953;  % rad
% smiData.RigidTransform(8).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
% smiData.RigidTransform(8).ID = 'F[Perno:2:-:Pendolo:1]';
% 
% %Translation Method - Cartesian
% %Rotation Method - Arbitrary Axis
% smiData.RigidTransform(9).translation = [7.1054273576010019e-14 5.0000000000000133 -8.8817841970012523e-15];  % mm
% smiData.RigidTransform(9).angle = 2.0943951023931948;  % rad
% smiData.RigidTransform(9).axis = [0.57735026918962562 -0.57735026918962618 0.57735026918962562];
% smiData.RigidTransform(9).ID = 'B[Anello:1:-:Perno:2]';
% 
% %Translation Method - Cartesian
% %Rotation Method - Arbitrary Axis
% smiData.RigidTransform(10).translation = [2.8768654125599312e-14 49.999999999999957 -2.6644680322434643e-14];  % mm
% smiData.RigidTransform(10).angle = 2.0943951023931953;  % rad
% smiData.RigidTransform(10).axis = [0.57735026918962551 -0.57735026918962618 0.57735026918962551];
% smiData.RigidTransform(10).ID = 'F[Anello:1:-:Perno:2]';
% 
% %Translation Method - Cartesian
% %Rotation Method - Arbitrary Axis
% smiData.RigidTransform(11).translation = [-17.29559689426598 -0.91194967194548215 0];  % mm
% smiData.RigidTransform(11).angle = 0;  % rad
% smiData.RigidTransform(11).axis = [0 0 0];
% smiData.RigidTransform(11).ID = 'RootGround[Base:1]';
% 
% 
% %============= Solid =============%
% %Center of Mass (CoM) %Moments of Inertia (MoI) %Product of Inertia (PoI)
% 
% %Initialize the Solid structure array by filling in null values.
% smiData.Solid(4).mass = 0.0;
% smiData.Solid(4).CoM = [0.0 0.0 0.0];
% smiData.Solid(4).MoI = [0.0 0.0 0.0];
% smiData.Solid(4).PoI = [0.0 0.0 0.0];
% smiData.Solid(4).color = [0.0 0.0 0.0];
% smiData.Solid(4).opacity = 0.0;
% smiData.Solid(4).ID = '';
% 
% %Inertia Type - Custom
% %Visual Properties - Simple
% smiData.Solid(1).mass = 0.22996814210510785;  % kg
% smiData.Solid(1).CoM = [2.1989091600115006e-11 0 8.1267124940488227];  % mm
% smiData.Solid(1).MoI = [197.59955299816477 690.46339710638222 845.6764698098707];  % kg*mm^2
% smiData.Solid(1).PoI = [0 -1.3552878820800156e-10 -1.0713847586885094e-10];  % kg*mm^2
% smiData.Solid(1).color = [0.74901960784313726 0.74901960784313726 0.74901960784313726];
% smiData.Solid(1).opacity = 1;
% smiData.Solid(1).ID = 'Base.ipt_{1F461F11-416F-F494-7EAD-E8826F507B9F}';
% 
% %Inertia Type - Custom
% %Visual Properties - Simple
% smiData.Solid(2).mass = 0.010053096491487768;  % kg
% smiData.Solid(2).CoM = [8.3654419139402923e-10 25.000000000000004 0];  % mm
% smiData.Solid(2).MoI = [2.2552446149625722 0.32169906681974519 2.255244656643741];  % kg*mm^2
% smiData.Solid(2).PoI = [0 0 0];  % kg*mm^2
% smiData.Solid(2).color = [0.74901960784313726 0.74901960784313726 0.74901960784313726];
% smiData.Solid(2).opacity = 1;
% smiData.Solid(2).ID = 'Perno.ipt_{40D9D788-4D0A-DB73-A037-5985C77F8DED}';
% 
% %Inertia Type - Custom
% %Visual Properties - Simple
% smiData.Solid(3).mass = 0.07995752280681051;  % kg
% smiData.Solid(3).CoM = [1.6823215836391396e-10 10 0];  % mm
% smiData.Solid(3).MoI = [6.085904450160001 232.92084556584896 232.16544263614298];  % kg*mm^2
% smiData.Solid(3).PoI = [0 6.8212102632993534e-14 0];  % kg*mm^2
% smiData.Solid(3).color = [0.74901960784313726 0.74901960784313726 0.74901960784313726];
% smiData.Solid(3).opacity = 1;
% smiData.Solid(3).ID = 'Pendolo.ipt_{19A0FA3E-4BC2-D7BB-397F-B991B68041EF}';
% 
% %Inertia Type - Custom
% %Visual Properties - Simple
% smiData.Solid(4).mass = 1.144373780654278;  % kg
% smiData.Solid(4).CoM = [-3.5736231983156973e-08 2.5000000000000004 -6.2090092220905189e-15];  % mm
% smiData.Solid(4).MoI = [989.90063115511282 1975.03240468894 989.89999761988679];  % kg*mm^2
% smiData.Solid(4).PoI = [0 -2.8421709427864801e-12 0];  % kg*mm^2
% smiData.Solid(4).color = [0.74901960784313726 0.74901960784313726 0.74901960784313726];
% smiData.Solid(4).opacity = 1;
% smiData.Solid(4).ID = 'Anello.ipt_{05ED31FA-4D50-3296-E90C-F484BB382E20}';
% 
% 
% %============= Joint =============%
% %X Revolute Primitive (Rx) %Y Revolute Primitive (Ry) %Z Revolute Primitive (Rz)
% %X Prismatic Primitive (Px) %Y Prismatic Primitive (Py) %Z Prismatic Primitive (Pz) %Spherical Primitive (S)
% %Constant Velocity Primitive (CV) %Lead Screw Primitive (LS)
% %Position Target (Pos)
% 
% %Initialize the PlanarJoint structure array by filling in null values.
% smiData.PlanarJoint(1).Rz.Pos = 0.0;
% smiData.PlanarJoint(1).Px.Pos = 0.0;
% smiData.PlanarJoint(1).Py.Pos = 0.0;
% smiData.PlanarJoint(1).ID = '';
% 
% smiData.PlanarJoint(1).Rz.Pos = 0;  % deg
% smiData.PlanarJoint(1).Px.Pos = 0;  % mm
% smiData.PlanarJoint(1).Py.Pos = 0;  % mm
% smiData.PlanarJoint(1).ID = '[Base:1:-:]';
% 
% 
% %Initialize the RevoluteJoint structure array by filling in null values.
% smiData.RevoluteJoint(4).Rz.Pos = 0.0;
% smiData.RevoluteJoint(4).ID = '';
% 
% smiData.RevoluteJoint(1).Rz.Pos = 1.6563332079562368e-13;  % deg
% smiData.RevoluteJoint(1).ID = '[Pendolo:1:-:Base:1]';
% 
% smiData.RevoluteJoint(2).Rz.Pos = angolo;  % deg
% smiData.RevoluteJoint(2).ID = '[Perno:1:-:Base:1]';
% 
% smiData.RevoluteJoint(3).Rz.Pos = -6.7394745408815011e-14;  % deg
% smiData.RevoluteJoint(3).ID = '[Perno:2:-:Pendolo:1]';
% 
% smiData.RevoluteJoint(4).Rz.Pos = 2.3305024752416401e-13;  % deg
% smiData.RevoluteJoint(4).ID = '[Anello:1:-:Perno:2]';
