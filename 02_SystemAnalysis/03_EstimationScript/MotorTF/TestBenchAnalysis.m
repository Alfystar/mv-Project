% ####################################################################
% Analisi funzione di trasferimento motore progetto, con disco inerziale
% 
% Il seguente script � fatto per stimare, nel caso del nostro motore,
% l'inerzia di un eventuale disco attaccato.
% Inoltre, si vedr� il rapporto segnale rumore (SNR) dell'encoder
% 
% Filippo Badalamenti
% ####################################################################

%%
clc 
clear variables
format shortEng

%%

data_noBolts = importdata('SpeedData/testBench/test_0BulFree_10ms.dat','\t'); 
data_4Bolts = importdata('SpeedData/testBench/test_4Bul_10ms.dat','\t'); 
data_8Bolts = importdata('SpeedData/testBench/test_8Bul_10ms.dat','\t'); 
data_12Bolts = importdata('SpeedData/testBench/test_12Bul_10ms.dat','\t'); 
data_16Bolts = importdata('SpeedData/testBench/test_16Bul_10ms.dat','\t'); 

data_b_tot = struct('No_Bolts',data_noBolts.data,'Bolts4',data_4Bolts.data,...
                    'Bolts8',data_8Bolts.data,'Bolts12',data_12Bolts.data,...
                    'Bolts16',data_16Bolts.data);



%% 10ms sampling & Normalization

timeWanted = 0.01; % time sampling in seconds (-> 10ms)
ocr4a = 156; % value from the timer of Arduino
Ts = ocr4a*0.064*0.001; % Arduino normalization
Fs = 1/Ts;
step2rad = 64/(2*pi); % STEPs/rad

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

%% Estimation

tf_s = struct('tf_noB',NaN,'tf_4B',NaN,'tf_8B',NaN,... % all TFs are saved
                'tf_12B',NaN,'tf_16B',NaN);            % here
field_tf =fieldnames(tf_s);            
for i = 1:len_field
    in = data_b_tot.(field{i})(:,1);
    out = data_b_tot.(field{i})(:,3);
    data = iddata(out, in, Ts);
    tf_s.(field_tf{i}) = tfest(data, 1, 0);
end

%% Inertia and friction calculation

torque = 0.2941995; % N/m, 3 kg/cm on datasheet, at stall
N = 621/64; % gear reduction ratio

J_noB = torque/tf_s.tf_noB.Numerator;
D_noB = torque/tf_s.tf_noB.Denominator(2);

% di questo,vedere gli stessi valori sopra, e usare 
% la formula Jtot = J_noB + J_*B/(N^2)
% for i = 2:len_field
%     in = data_b_tot.(field{i})(:,1);
%     out = data_b_tot.(field{i})(:,3);
%     data = iddata(out, in, Ts);
%     tf_s.(field_tf{i}) = tfest(data, 1, 0);
% end




