% Description : The script prints the mean of the maximum short time loudness over 10 version in latex table format 
% Author      : Vijay Kiran Gidla (joy4u18@gmail.com)
clc;
clear all;
close all;
%%  Anechoic
STL_A_005_mean=[13.357 13.296 20.674 20.194 NaN 14.404 13.347 13.379 13.420];

STL_A_050_mean=[40.090 40.023 63.672 52.307 NaN 40.320 40.292 40.213 40.089];

STL_A_500_mean=[48.137 48.082 76.143 62.159 NaN 48.353 48.377  48.187 48.131];



%%  Conference

STL_C_005_mean=[19.320 19.376 26.707 24.377 NaN 21.537 19.651 19.975 19.529 ];

STL_C_050_mean=[44.999 45.072 69.607 55.682 NaN 47.619 45.135 45.249 45.041];

STL_C_500_mean=[52.444 52.487 78.659 63.574 NaN 54.580 52.387 52.569 52.502];

%% Lecture

STL_L_005_mean=[15.497 NaN NaN 17.160 16.179 NaN NaN NaN NaN];


STL_L_500_mean=[52.013 NaN NaN 54.712 52.466 NaN NaN NaN NaN];

%%

five=[STL_A_005_mean' STL_C_005_mean' STL_L_005_mean'];
fifty=[STL_A_050_mean' STL_C_050_mean' nan(1,9)'];
fivehundred=[STL_A_500_mean' STL_C_500_mean' STL_L_500_mean'];

five_round= round(five,1);
fifty_round= round(fifty,1);
fivehundred_round= round(fivehundred,1);

xlswrite('L_5.xls',five_round);
xlswrite('L_50.xls',fifty_round);
xlswrite('L_500.xls',fivehundred_round);

latexinput.data=(fifty);
latexinput.tableColLabels = {'Anechoic','Conference','Lecture'};
latexinput.tableRowLabels={'NoObjectrec1','NoObjectrec2','Object50cm','Object100cm','Object150cm','Object200cm','Object300cm','Object400cm','Object500cm'};
latexinput.dataFormat = {'%.3f'};
latexinput.dataNanString = '-';
latexinput.tableColumnAlignment = 'c';
latexinput.tableBorders = 1;
latexinput.tableCaption = 'Mean of the maximum of the Short Term Loudness in sones of 10 versions for the  recordings in the lecture room with  50ms duration signal.';
latexinput.tableLabel = 'STL_mean_50ms';
latexinput.makeCompleteLatexDocument = 0;
latexoutput=latexTable(latexinput);















