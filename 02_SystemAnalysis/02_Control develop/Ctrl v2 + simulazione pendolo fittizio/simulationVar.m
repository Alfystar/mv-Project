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


%%
% Simscape(TM) Multibody(TM) version: 7.0

% This is a model data file derived from a Simscape Multibody Import XML file using the smimport function.
% The data in this file sets the block parameter values in an imported Simscape Multibody model.
% For more information on this file, see the smimport function help page in the Simscape Multibody documentation.
% You can modify numerical values, but avoid any other changes to this file.
% Do not add code to this file. Do not edit the physical units shown in comments.

%%%VariableName:smiData


%============= RigidTransform =============%

%Initialize the RigidTransform structure array by filling in null values.
smiData.RigidTransform(11).translation = [0.0 0.0 0.0];
smiData.RigidTransform(11).angle = 0.0;
smiData.RigidTransform(11).axis = [0.0 0.0 0.0];
smiData.RigidTransform(11).ID = '';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(1).translation = [1.7763568394002505e-14 0 0];  % mm
smiData.RigidTransform(1).angle = 0;  % rad
smiData.RigidTransform(1).axis = [0 0 0];
smiData.RigidTransform(1).ID = 'B[Base:1:-:]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(2).translation = [-17.295596894265962 -0.91194967194548215 0];  % mm
smiData.RigidTransform(2).angle = 0;  % rad
smiData.RigidTransform(2).axis = [0 0 0];
smiData.RigidTransform(2).ID = 'F[Base:1:-:]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(3).translation = [89 0 -2.2204460492503131e-14];  % mm
smiData.RigidTransform(3).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(3).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
smiData.RigidTransform(3).ID = 'B[Pendolo:1:-:Base:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(4).translation = [1.0658141036401503e-14 -9.9999999999999822 34.999999999999964];  % mm
smiData.RigidTransform(4).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(4).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
smiData.RigidTransform(4).ID = 'F[Pendolo:1:-:Base:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(5).translation = [0 4.4408920985006262e-15 -4.4408920985006262e-15];  % mm
smiData.RigidTransform(5).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(5).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
smiData.RigidTransform(5).ID = 'B[Perno:1:-:Base:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(6).translation = [1.0658141036401503e-14 -24.999999999999986 34.999999999999986];  % mm
smiData.RigidTransform(6).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(6).axis = [-0.57735026918962562 -0.57735026918962584 -0.57735026918962584];
smiData.RigidTransform(6).ID = 'F[Perno:1:-:Base:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(7).translation = [0 -2.2204460492503131e-15 0];  % mm
smiData.RigidTransform(7).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(7).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
smiData.RigidTransform(7).ID = 'B[Perno:2:-:Pendolo:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(8).translation = [-89.000000000000028 -1.7763568394002414e-15 -1.3650170512753636e-14];  % mm
smiData.RigidTransform(8).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(8).axis = [-0.57735026918962584 -0.57735026918962584 -0.57735026918962584];
smiData.RigidTransform(8).ID = 'F[Perno:2:-:Pendolo:1]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(9).translation = [7.1054273576010019e-14 5.0000000000000133 -8.8817841970012523e-15];  % mm
smiData.RigidTransform(9).angle = 2.0943951023931948;  % rad
smiData.RigidTransform(9).axis = [0.57735026918962562 -0.57735026918962618 0.57735026918962562];
smiData.RigidTransform(9).ID = 'B[Anello:1:-:Perno:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(10).translation = [2.8768654125599312e-14 49.999999999999957 -2.6644680322434643e-14];  % mm
smiData.RigidTransform(10).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(10).axis = [0.57735026918962551 -0.57735026918962618 0.57735026918962551];
smiData.RigidTransform(10).ID = 'F[Anello:1:-:Perno:2]';

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(11).translation = [-17.29559689426598 -0.91194967194548215 0];  % mm
smiData.RigidTransform(11).angle = 0;  % rad
smiData.RigidTransform(11).axis = [0 0 0];
smiData.RigidTransform(11).ID = 'RootGround[Base:1]';


%============= Solid =============%
%Center of Mass (CoM) %Moments of Inertia (MoI) %Product of Inertia (PoI)

%Initialize the Solid structure array by filling in null values.
smiData.Solid(4).mass = 0.0;
smiData.Solid(4).CoM = [0.0 0.0 0.0];
smiData.Solid(4).MoI = [0.0 0.0 0.0];
smiData.Solid(4).PoI = [0.0 0.0 0.0];
smiData.Solid(4).color = [0.0 0.0 0.0];
smiData.Solid(4).opacity = 0.0;
smiData.Solid(4).ID = '';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(1).mass = 0.22996814210510785;  % kg
smiData.Solid(1).CoM = [2.1989091600115006e-11 0 8.1267124940488227];  % mm
smiData.Solid(1).MoI = [197.59955299816477 690.46339710638222 845.6764698098707];  % kg*mm^2
smiData.Solid(1).PoI = [0 -1.3552878820800156e-10 -1.0713847586885094e-10];  % kg*mm^2
smiData.Solid(1).color = [0.74901960784313726 0.74901960784313726 0.74901960784313726];
smiData.Solid(1).opacity = 1;
smiData.Solid(1).ID = 'Base.ipt_{1F461F11-416F-F494-7EAD-E8826F507B9F}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(2).mass = 0.010053096491487768;  % kg
smiData.Solid(2).CoM = [8.3654419139402923e-10 25.000000000000004 0];  % mm
smiData.Solid(2).MoI = [2.2552446149625722 0.32169906681974519 2.255244656643741];  % kg*mm^2
smiData.Solid(2).PoI = [0 0 0];  % kg*mm^2
smiData.Solid(2).color = [0.74901960784313726 0.74901960784313726 0.74901960784313726];
smiData.Solid(2).opacity = 1;
smiData.Solid(2).ID = 'Perno.ipt_{40D9D788-4D0A-DB73-A037-5985C77F8DED}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(3).mass = 0.07995752280681051;  % kg
smiData.Solid(3).CoM = [1.6823215836391396e-10 10 0];  % mm
smiData.Solid(3).MoI = [6.085904450160001 232.92084556584896 232.16544263614298];  % kg*mm^2
smiData.Solid(3).PoI = [0 6.8212102632993534e-14 0];  % kg*mm^2
smiData.Solid(3).color = [0.74901960784313726 0.74901960784313726 0.74901960784313726];
smiData.Solid(3).opacity = 1;
smiData.Solid(3).ID = 'Pendolo.ipt_{19A0FA3E-4BC2-D7BB-397F-B991B68041EF}';

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(4).mass = 1.144373780654278;  % kg
smiData.Solid(4).CoM = [-3.5736231983156973e-08 2.5000000000000004 -6.2090092220905189e-15];  % mm
smiData.Solid(4).MoI = [989.90063115511282 1975.03240468894 989.89999761988679];  % kg*mm^2
smiData.Solid(4).PoI = [0 -2.8421709427864801e-12 0];  % kg*mm^2
smiData.Solid(4).color = [0.74901960784313726 0.74901960784313726 0.74901960784313726];
smiData.Solid(4).opacity = 1;
smiData.Solid(4).ID = 'Anello.ipt_{05ED31FA-4D50-3296-E90C-F484BB382E20}';


%============= Joint =============%
%X Revolute Primitive (Rx) %Y Revolute Primitive (Ry) %Z Revolute Primitive (Rz)
%X Prismatic Primitive (Px) %Y Prismatic Primitive (Py) %Z Prismatic Primitive (Pz) %Spherical Primitive (S)
%Constant Velocity Primitive (CV) %Lead Screw Primitive (LS)
%Position Target (Pos)

%Initialize the PlanarJoint structure array by filling in null values.
smiData.PlanarJoint(1).Rz.Pos = 0.0;
smiData.PlanarJoint(1).Px.Pos = 0.0;
smiData.PlanarJoint(1).Py.Pos = 0.0;
smiData.PlanarJoint(1).ID = '';

smiData.PlanarJoint(1).Rz.Pos = 0;  % deg
smiData.PlanarJoint(1).Px.Pos = 0;  % mm
smiData.PlanarJoint(1).Py.Pos = 0;  % mm
smiData.PlanarJoint(1).ID = '[Base:1:-:]';


%Initialize the RevoluteJoint structure array by filling in null values.
smiData.RevoluteJoint(4).Rz.Pos = 0.0;
smiData.RevoluteJoint(4).ID = '';

smiData.RevoluteJoint(1).Rz.Pos = 1.6563332079562368e-13;  % deg
smiData.RevoluteJoint(1).ID = '[Pendolo:1:-:Base:1]';

smiData.RevoluteJoint(2).Rz.Pos = angolo;  % deg
smiData.RevoluteJoint(2).ID = '[Perno:1:-:Base:1]';

smiData.RevoluteJoint(3).Rz.Pos = -6.7394745408815011e-14;  % deg
smiData.RevoluteJoint(3).ID = '[Perno:2:-:Pendolo:1]';

smiData.RevoluteJoint(4).Rz.Pos = 2.3305024752416401e-13;  % deg
smiData.RevoluteJoint(4).ID = '[Anello:1:-:Perno:2]';
