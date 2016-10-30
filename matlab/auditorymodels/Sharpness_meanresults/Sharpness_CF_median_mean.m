% Description : The script prints the mean of the median shapness over 10 version in latex table format 
% Author      : Vijay Kiran Gidla (joy4u18@gmail.com)

clc;
clear all;
close all;
%%  Anechoic
Sharpness_CF_median_A_005_mean=[1.888 1.900 2.052 2.138 NaN 1.921 1.906 1.891 1.889];

Sharpness_CF_median_A_050_mean=[1.889 1.901 2.068 2.141 NaN 1.912 1.904 1.874 1.881];

Sharpness_CF_median_A_500_mean=[1.861 1.882 2.116 2.119 NaN 1.892 1.858 1.831 1.835];



%%  Conference

Sharpness_CF_median_C_005_mean=[1.9720    1.9830    2.0320    2.0320 NaN 2.003    2.009    1.982    1.986];

Sharpness_CF_median_C_050_mean=[1.8930    1.8940    1.9640    1.9500 NaN 1.9360    1.9140    1.9170    1.8880];

Sharpness_CF_median_C_500_mean=[1.9350    1.9380    2.0950    2.0430  NaN 1.9670    1.9500    1.9490    1.9410];

%% Lecture

Sharpness_CF_median_L_005_mean=[1.8490 NaN NaN 1.7780    1.8340 NaN NaN NaN NaN];


Sharpness_CF_median_L_500_mean=[2.0720 NaN NaN 2.2000    2.1100 NaN NaN NaN NaN];

%%

five=[Sharpness_CF_median_A_005_mean' Sharpness_CF_median_C_005_mean' Sharpness_CF_median_L_005_mean'];
fifty=[Sharpness_CF_median_A_050_mean' Sharpness_CF_median_C_050_mean' nan(1,9)'];
fivehundred=[Sharpness_CF_median_A_500_mean' Sharpness_CF_median_C_500_mean' Sharpness_CF_median_L_500_mean'];


five_round= round(five,2);
fifty_round= round(fifty,2);
fivehundred_round= round(fivehundred,2);

xlswrite('S_5.xls',five_round);
xlswrite('S_50.xls',fifty_round);
xlswrite('S_500.xls',fivehundred_round);

latexinput.data=(fivehundred);
latexinput.tableColLabels = {'Anechoic','Conference','Lecture'};
latexinput.tableRowLabels={'NoObjectrec1','NoObjectrec2','Object50cm','Object100cm','Object150cm','Object200cm','Object300cm','Object400cm','Object500cm'};
latexinput.dataFormat = {'%.3f'};
latexinput.dataNanString = '-';
latexinput.tableColumnAlignment = 'c';
latexinput.tableBorders = 1;
latexinput.tableCaption = 'Mean of the median of the sharpness in accums of 10 versions for the  recordings in anechoic, conference and the lecture room with  500ms duration signal.';
latexinput.tableLabel = 'Sharpness_CF_median_mean_500ms';
latexinput.makeCompleteLatexDocument = 0;
latexoutput=latexTable(latexinput);















