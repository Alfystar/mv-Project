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
