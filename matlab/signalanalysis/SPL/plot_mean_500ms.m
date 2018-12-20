% Description : The script prints the mean SPL levels for 500ms signal durarions obatined using rms_amplitude_500ms.m files in to a latex table format
% Note        : The script requires latexTable.m (downloaded from matlab file exchange) to be in the matlab path. 
%             : One should manually change the names of the captions manulally in the latex Table
% Author      : Vijay Kiran Gidla (joy4u18@gmail.com)
%%
clc;
clearvars;
close all;


%% Professor Bo Schenkman (2010)
T_anc_500_mean_left   =[77.1534   77.5924   85.1818   81.8774   77.0972   76.9754   77.0513   76.9872]';
T_anc_500_mean_right  =[77.8657   77.3739   88.2156   82.5503   78.0437   78.2114   77.9858   78.0329]';
T_conf_500_mean_left  =[79.0034   78.9930   87.5388   82.8272   79.5978   78.9263   79.0157   79.0090]';
T_conf_500_mean_right =[78.8165   78.8239   87.4570   82.3766   79.4812   78.8977   78.8603   78.7983]';

%% Professor Bo Schenkman (2011)
T_lec_500_mean_left  =[79.1653   79.5940   79.4123]';
T_lec_500_mean_right =[79.5770   81.5449   79.6811]';

%%
distance = [0.01 0.01 50 100 200 300 400 500];
T_input=[T_anc_500_mean_left T_anc_500_mean_right T_conf_500_mean_left T_conf_500_mean_right];

figure
plot(distance,T_input,'--o',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerEdgeColor','b')
hold on

distance = [0.01 100 150];
T_input=[T_lec_500_mean_left T_lec_500_mean_right];
plot(distance,T_input,'--o',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerEdgeColor','b')
xlabel('Distance (cm)');
h=gca;
h.XTick=[0:50:500];
ylabel('SPL(dBA)');

legend('Anechoic Left Ear','Anechoic Right Ear','Conference Left Ear','Conference Right Ear',...
    'Lecture Left Ear','Lecture Right Ear');


