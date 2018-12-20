% Description : The script prints the mean of the maximum short time loudness over 10 version in latex table format 
% Author      : Vijay Kiran Gidla (joy4u18@gmail.com)
clc;
clear all;
close all;
%%  Anechoic
STL_A_005_mean=[13.357 13.296 20.674 20.194 14.404 13.347 13.379 13.420];

STL_A_050_mean=[40.090 40.023 63.672 52.307 40.320 40.292 40.213 40.089];

STL_A_500_mean=[48.137 48.082 76.143 62.159 48.353 48.377  48.187 48.131];



%%  Conference

STL_C_005_mean=[19.320 19.376 26.707 24.377 21.537 19.651 19.975 19.529 ];

STL_C_050_mean=[44.999 45.072 69.607 55.682 47.619 45.135 45.249 45.041];

STL_C_500_mean=[52.444 52.487 78.659 63.574 54.580 52.387 52.569 52.502];

%% Lecture

STL_L_005_mean=[15.497 17.160 16.179];


STL_L_500_mean=[52.013 54.712 52.466];

%%

five_ac=[STL_A_005_mean' STL_C_005_mean'];
five_l=STL_L_005_mean';
fifty_ac=[STL_A_050_mean' STL_C_050_mean'];
fivehundred_ac=[STL_A_500_mean' STL_C_500_mean'];
fivehundred_l =STL_L_500_mean';

five_round_ac= round(five_ac,1);
five_round_l= round(five_l,1);
fifty_round_ac= round(fifty_ac,1);
fivehundred_round_ac= round(fivehundred_ac,1);
fivehundred_round_l= round(fivehundred_l,1);

xlswrite('Ldns1.xls',[reshape(five_round_ac(:),16,1); ...
    five_round_l; reshape(fifty_round_ac,16,1); ...
    reshape(fivehundred_round_ac,16,1);fivehundred_round_l]);

%%
distance_ac = [0.01 0.01 50 100 200 300 400 500];
distance_l = [0.01 100 150];

figure;
subplot(2,2,1);
plotLoudnessMean(distance_ac,five_round_ac,distance_l,five_round_l);
subplot(2,2,2);
plotLoudnessMean(distance_ac,fifty_round_ac);
subplot(2,2,3);
plotLoudnessMean(distance_ac,fivehundred_round_ac,distance_l,fivehundred_round_l);




%%
function plotLoudnessMean(D1,L1,D2,L2)
% D1 = Anec Conf distance
% L1 = Anec Conf Loudness
% D2 = Lec distance
% L2 = Lec Loudness

plot(D1,L1,'--o',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerEdgeColor','b')
hold on
grid on 

try
plot(D2,L2,'--o',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerEdgeColor','b')
xlabel('Distance (cm)');
h=gca;
h.XTick=[0:50:500];
ylabel('Loudness (sones)');
legend('Anechoic Room','Conference Room','Lecture Room');
catch err
display( err.message);
xlabel('Distance (cm)');
h=gca;
h.XTick=[0:50:500];
ylabel('Loudness (sones)');
legend('Anechoic Room','Conference Room');
end
    
end














