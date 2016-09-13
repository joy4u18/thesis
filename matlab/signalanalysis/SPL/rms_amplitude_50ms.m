% Description : The script loads the .wav files in the desired directory and printts the SPL level in a latex table format
%             : The script is explicitly for 50ms signals  only
% Note        : The script requires latexTable.m (downloaded from matlab file exchange) to be in the matlab path. 
%             : One should manually change the names of the captions manulally in the latex Table
% Author      : Vijay Kiran Gidla (joy4u18@gmail.com)
%-------------------------NOTE---------------------------------------------%
%--Change to the folder where the .wav files are present and run the code--%
%--------------------------------------------------------------------------%


%%
clc;
clear all;
close all;
%%  Locating and Initialzing the names for the .wav files
cd('D:\D\sp4\Thesisfiles\MATLAB\RECORDINGS\Exactduration_callibration\conference\50ms\right_ear')

wavfile=dir('*.wav');          % To read the .wav files in the directory
T_count=0;                     % Setting the counters
T_count1=0;
%%
for i=1:length(wavfile)
    wavname=wavfile(i).name;      % Reading the wavefile names
    
    T_count=T_count+1;
    
    [T_input, T_fs]= audioread(wavname);
    
    T_input=T_input(1:T_fs*0.050);
    
    T_amp(1,T_count)=20*log10(rms(T_input)/(20e-6));
    
    if (T_count==10)
        T_count=0;
        T_count1=T_count1+1;
        T_meanamp(T_count1,1)=mean(T_amp);
        T_outputamp(T_count1,:)=T_amp; %#ok<SAGROW>
        T_amp=0;
    end
    
end

%%

if (size(T_outputamp,1)==8)
    
         
    %% Tabulate in the latex table format
    
    latexinput.data=[T_outputamp T_meanamp];
    latexinput.tableColLabels = {'Ver1','Ver2','Ver3','Ver4','Ver5','Ver6','Ver7','Ver8','Ver9','Ver10','Mean'};
    latexinput.tableRowLabels={'NoObject1','NoObject2','Object50cm','Object100cm','Object200cm','Object300cm','Object400cm','Object500cm'};
    latexinput.dataFormat = {'%.3f'};
    latexinput.dataNanString = '-';
    latexinput.tableColumnAlignment = 'c';
    latexinput.tableBorders = 1;
    latexinput.tableCaption = 'RMS amplitude values of 10 versions for the right ear recordings in the conference chamber with  50ms duration signal';
    latexinput.tableLabel = 'RMS_conference_50ms_right';
    latexinput.makeCompleteLatexDocument = 0;
    latexoutput=latexTable(latexinput);
    
    %----For mean rms amp
    
    % latexinput.data=T_meanamp;
    % latexinput.tableColLabels = {'Mean RMS amplitude'};
    % latexinput.tableRowLabels={'NoObject1','NoObject2','Object50cm','Object100cm','Object200cm','Object300cm','Object400cm','Object500cm'};
    % latexinput.dataFormat = {'%.3f'};
    % latexinput.dataNanString = '-';
    % latexinput.tableColumnAlignment = 'c';
    % latexinput.tableBorders = 1;
    % latexinput.tableCaption = 'Mean of the RMS amplitude values of  10 versions for the right ear recordings in the conference chamber with  50ms duration signal';
    % latexinput.tableLabel = 'RMS_mean_conference_50ms_right';
    % latexinput.makeCompleteLatexDocument = 0;
    % latexoutput=latexTable(latexinput);
    
else
    
    %Tabulate in the latex table format
    
    latexinput.data=[T_outputamp T_meanamp];
    latexinput.tableColLabels = {'Ver1','Ver2','Ver3','Ver4','Ver5','Ver6','Ver7','Ver8','Ver9','Ver10','Mean'};
    latexinput.tableRowLabels={'NoObject1','Object100cm','Object150cm'};
    latexinput.dataFormat = {'%.3f'};
    latexinput.dataNanString = '-';
    latexinput.tableColumnAlignment = 'c';
    latexinput.tableBorders = 1;
    latexinput.tableCaption = 'RMS amplitude values of 10 versions for the right ear recordings in the conference chamber with  50ms duration signal';
    latexinput.tableLabel = 'RMS_conference_50ms_right';
    latexinput.makeCompleteLatexDocument = 0;
    latexoutput=latexTable(latexinput);
    
    %----For mean rms amp
    
    % latexinput.data=T_meanamp;
    % latexinput.tableColLabels = {'Mean RMS amplitude'};
    % latexinput.tableRowLabels={'NoObject','Object100cm','Object150cm'};
    % latexinput.dataFormat = {'%.3f'};
    % latexinput.dataNanString = '-';
    % latexinput.tableColumnAlignment = 'c';
    % latexinput.tableBorders = 1;
    % latexinput.tableCaption = 'Mean of the RMS amplitude values of  10 versions for the right ear recordings in the conference chamber with  50ms duration signal';
    % latexinput.tableLabel = 'RMS_mean_conference_50ms_right';
    % latexinput.makeCompleteLatexDocument = 0;
    % latexoutput=latexTable(latexinput);
    
    
end


