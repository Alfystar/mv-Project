% ####################################################################
% Analisi funzione di trasferimento motore progetto, con disco inerziale
% 
% Il seguente script è fatto per analizzare la lettura degli encoder al e
% le la sua prestazione con un diverso tempo di campionamento
% ####################################################################


clc 
clear variables
format shortEng


en_2ms = importTest('SpeedData/testBench/test0-255_2ms.dat'); 
en_4ms = importTest('SpeedData/testBench/test0-255_4ms.dat'); 
en_6ms = importTest('SpeedData/testBench/test0-255_6ms.dat'); 
en_8ms = importTest('SpeedData/testBench/test0-255_8ms.dat'); 
en_10ms = importTest('SpeedData/testBench/test0-255_10ms.dat'); 
en_12ms = importTest('SpeedData/testBench/test0-255_12ms.dat'); 
en_14ms = importTest('SpeedData/testBench/test0-255_14ms.dat'); 


enData = struct('en_2ms',en_2ms,'en_4ms',en_4ms,...
                    'en_6ms',en_6ms,'en_8ms',en_8ms,...
                    'en_10ms',en_10ms,'en_12ms',en_12ms,...
                    'en_14ms',en_14ms);
                
colors = {'r','g','b','k','c','m','r-'};

figure(1)
clf
plot(en_2ms.Time, en_2ms.mVel, 'r');
hold on
grid on
plot(en_4ms.Time, en_4ms.mVel, 'g');
plot(en_6ms.Time, en_6ms.mVel, 'b');
plot(en_8ms.Time, en_8ms.mVel, 'k');
plot(en_10ms.Time, en_10ms.mVel, 'c');
plot(en_12ms.Time, en_12ms.mVel, 'm');
plot(en_14ms.Time, en_14ms.mVel, 'Color','1.00,0.41,0.16');


xlabel('Sample time (s)'); ylabel('Rad/sec Read')
legend('Test_{2ms}','Test_{4ms}','Test_{6ms}','Test_{8ms}',...
    'Test_{10ms}','Test_{12ms}','Test_{14ms}');

figure(2)
step2rad = 621/(2*pi); % STEPs/rad
clf
plot(en_2ms.Time, en_2ms.mVel/en_2ms.Time(2)*step2rad, 'r');
hold on
grid on
plot(en_4ms.Time, en_4ms.mVel/en_4ms.Time(2)*step2rad, 'g');
plot(en_6ms.Time, en_6ms.mVel/en_6ms.Time(2)*step2rad, 'b');
plot(en_8ms.Time, en_8ms.mVel/en_8ms.Time(2)*step2rad, 'k');
plot(en_10ms.Time, en_10ms.mVel/en_10ms.Time(2)*step2rad, 'c');
plot(en_12ms.Time, en_12ms.mVel/en_12ms.Time(2)*step2rad, 'm');
plot(en_14ms.Time, en_14ms.mVel/en_14ms.Time(2)*step2rad, 'Color','1.00,0.41,0.16');


xlabel('Sample time (s)'); ylabel('Encoder Speed Normalize')
legend('Test_{2ms}','Test_{4ms}','Test_{6ms}','Test_{8ms}',...
    'Test_{10ms}','Test_{12ms}','Test_{14ms}')

figure(3)

% maxSpeeds_xMs = cell(7,1);
maxSpeedsMean_xMs = zeros(1,7);
times_xs = [en_2ms.Time(2) en_4ms.Time(2) en_6ms.Time(2) en_8ms.Time(2) en_10ms.Time(2) en_12ms.Time(2) en_14ms.Time(2)];

maxSpeeds_xMs(1,:) = {en_2ms.mVel(159:553)/ en_2ms.Time(2)*step2rad};
maxSpeeds_xMs(2,:) = {(en_4ms.mVel(49:288)/ en_4ms.Time(2)*step2rad)};
maxSpeeds_xMs(3,:) = {en_6ms.mVel(38:197)/ en_6ms.Time(2)*step2rad};
maxSpeeds_xMs(4,:) = {en_8ms.mVel(30:152)/ en_8ms.Time(2)*step2rad};
maxSpeeds_xMs(5,:) = {en_10ms.mVel(31:114)/ en_10ms.Time(2)*step2rad};
maxSpeeds_xMs(6,:) = {en_12ms.mVel(27:115)/ en_12ms.Time(2)*step2rad};
maxSpeeds_xMs(7,:) = {en_14ms.mVel(22:107)/ en_14ms.Time(2)*step2rad};

for k=1:7
    maxSpeedsMean_xMs(k) = mean(maxSpeeds_xMs{k});
end

figure(3)
clf
plot(times_xs, maxSpeedsMean_xMs, 'r', 'Marker', '*','MarkerEdgeColor','b')
grid on
xlabel('Sample time (s)'); ylabel('Rad/sec mean')
legend('Speed_{max}')

figure(4)
clf
fftMaxSpeed = maxSpeeds_xMs;

for k=1:7
    fft_Test_f = fft(fftMaxSpeed{k}-maxSpeedsMean_xMs(k),200);
    
    Fs = 1/times_xs(k);
    len = length(fft_Test_f);
    
    P2 = abs(fft_Test_f/len);
    P1 = P2(1:len/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(len/2))/len;
    
    plot(f,P1)
    grid on
    hold on
end
% fft_Test_f = fft(maxSpeedsMean_xMs(1));

% 
% plot(f,P1,'b')
% grid on
% legend('V(f)')
legend('Test_{2ms}','Test_{4ms}','Test_{6ms}','Test_{8ms}',...
    'Test_{10ms}','Test_{12ms}','Test_{14ms}')
title('Encoder rumor at step input')
xlabel('f(Hz)')
ylabel('|V(f)|')
