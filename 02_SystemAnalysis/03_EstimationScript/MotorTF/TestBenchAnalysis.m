% ####################################################################
% Analisi funzione di trasferimento motore progetto, con disco inerziale
% 
% Il seguente script è fatto per stimare, nel caso del nostro motore,
% l'inerzia di un eventuale disco attaccato.
% 
% Filippo Badalamenti
% ####################################################################

%%
clc 
clear variables
format shortEng

%%

data_noBolts = importTest('SpeedData/testBench/test_0BulFree_10ms.dat'); 
data_4Bolts = importTest('SpeedData/testBench/test_4Bul_10ms.dat'); 
data_8Bolts = importTest('SpeedData/testBench/test_8Bul_10ms.dat'); 
data_12Bolts = importTest('SpeedData/testBench/test_12Bul_10ms.dat'); 
data_16Bolts = importTest('SpeedData/testBench/test_16Bul_10ms.dat'); 

data_b_tot = struct('No_Bolts',table2array(data_noBolts),...
    'Bolts4',table2array(data_4Bolts),'Bolts8',table2array(data_8Bolts),...
    'Bolts12',table2array(data_12Bolts),'Bolts16',table2array(data_16Bolts));



%% 10ms sampling & Normalization

Ts = data_b_tot.No_Bolts(2,5);
Fs = 1/Ts;
step2rad = 621/(2*pi); % STEPs/rad

% noi abbiamo 1000rpm alla ruota! non all'encoder!

field = fieldnames(data_b_tot);
len_field = length(field);

for i=1:len_field
    data_b_tot.(field{i})(:,3) = data_b_tot.(field{i})(:,3)/(Ts*step2rad); % rad/s
    data_b_tot.(field{i})(:,1) = data_b_tot.(field{i})(:,1)/255; % PWM in percentage
    data_b_tot.(field{i})(:,4) = data_b_tot.(field{i})(:,4)/(Ts*step2rad); % rad/s
end

%% Plotting all rising-time with different inertias

t = 0:Ts:(length(data_b_tot.No_Bolts(:,3))-1)*Ts;
colors = ['r','g','b','k','c'];
bolts = [0 4 8 12 16];

figure(1)
clf('reset')

for i = 1:len_field
    func = data_b_tot.(field{i})(:,3);
    plot(t, func, colors(i));
    hold on 
    grid on
end
xlabel('Time (s)'); ylabel('Speed (rad/s)');
legend ('No Bolts','4 Bolts','8 Bolts','12 Bolts','16 Bolts')
title('Evolution of system over time')

%% Estimation

tf_s = struct('tf_noB',NaN,'tf_4B',NaN,'tf_8B',NaN,... % all TFs are saved
                'tf_12B',NaN,'tf_16B',NaN);            % here
field_tf =fieldnames(tf_s);

est_prec = zeros(1, len_field);

for i = 1:len_field
    in = data_b_tot.(field{i})(:,1);
    out = data_b_tot.(field{i})(:,3);
    data = iddata(out, in, Ts);
    tf_s.(field_tf{i}) = tfest(data, 1, 0);
    est_prec(i) = tf_s.(field_tf{i}).Report.Fit.FitPercent;
end

figure(2)
clf('reset')

plot(bolts, est_prec, 'r', 'Marker', '*','MarkerEdgeColor','b');
grid on; xlabel('Bolts'); ylabel('FitPercent (%)');
title('Estimation variation with different flywheels')



%% Inertia and friction calculation
% https://www.aliexpress.com/i/4000228621475.html

torque = 0.01; % kg*m, 1kg*cm ca. on datasheet, at load.
N = 621/64; % gear reduction ratio

J_noB = torque/tf_s.tf_noB.Numerator;
D_noB = torque/tf_s.tf_noB.Denominator(2);

J_tot_s = zeros(1, len_field);
D_tot_s = zeros(1, len_field);

for i = 1:len_field
    J_tot_s(i) = torque/tf_s.(field_tf{i}).Numerator;
    D_tot_s(i) = J_tot_s(i)*tf_s.(field_tf{i}).Denominator(2);
end

% di questo,vedere gli stessi valori sopra, e usare 
% la formula Jtot = J_noB + J_*B/(N^2)

J_d_s = zeros(1, len_field);
D_d_s = zeros(1, len_field);

for i = 1:len_field
    J_d_s(i) = (J_tot_s(i) - J_tot_s(1))*(N^2);
    D_d_s(i) = (D_tot_s(i) - D_tot_s(1))*(N^2);
end

% %% Results

figure(3)
clf('reset')

plot (bolts, D_d_s, 'r', 'Marker', '*','MarkerEdgeColor','b');
grid on; xlabel('Bolts'); ylabel('Friction (kg*m^2/s)');
title('Friction variation with different flywheels')

figure(4)
clf('reset')

plot (bolts, D_tot_s, 'r', 'Marker', '*','MarkerEdgeColor','b');
grid on; xlabel('Bolts'); ylabel('Friction (kg*m^2/s)');
title('Total friction with different flywheels')

figure(5)
clf('reset')

theor_in = [0, 73.36, 129.02, 185.58, 240.34]/(10^6);

plot (bolts, J_d_s, 'r', 'Marker', '*','MarkerEdgeColor','b');
grid on; hold on; xlabel('Bolts'); ylabel('Inertia (kg*m^2)');
plot (bolts, theor_in, 'g', 'Marker', '*','MarkerEdgeColor','b');
legend('J_{measured}','J_{theoretical}')
title('Inertial variation with different flywheels')