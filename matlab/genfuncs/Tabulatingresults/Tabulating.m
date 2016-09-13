%-------- THE SCRIPT EXPLICITLY ASSUMES THAT THE .MAT FILES  WERE ALREADY GENERATED USING THE PSYSOUND3 GUI FOR ALL ROOM CONDITIONS-----%
% Description : The script loads the LoudnessMGB and Sharpness  .mat file results generated from  Psysound3 and tabulates them in to latex table format
% Note        : The loudness or sharpness names should be changed manually at required lines for Loudness and sharpness results respectively
%             : LoudnessMGB (glasberg and moore) was used for loudness and LoudnessCF (Fletcher) was used for sharpness analysis 
% Author      : Vijay Kiran Gidla (joy4u18@gmail.com)

%%

clc;
clear all;
close all;
%%
T_count1=1;
T_count2=1;

T_directory='D:\D\sp4\Thesisfiles\MATLAB\AUDITORY MODELS\psysound3-2\trunk\Thesis\Results\lecture\Loudness_MGB\5ms_64';

T_folders=dir(T_directory);

T_subdircheck=[T_folders(:).isdir];
nameFolds = {T_folders(T_subdircheck).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

for i=1:length(nameFolds)
    
    T_subdirectory=sprintf('%s',[T_directory '\'  char(nameFolds(i))]);
    cd(T_subdirectory);
    
    T_subfolders=dir(T_subdirectory);
    T_subsubdircheck=[T_subfolders(:).isdir];
    nameSubFolds = {T_subfolders(T_subsubdircheck).name}';
    nameSubFolds(ismember(nameSubFolds,{'.','..'})) = [];
    
    
    for j=1:length(nameSubFolds)
        if strcmpi(nameSubFolds(j),'LoudnessMGB')  % 'LoudnessCF' 
            
       
            
            T_subsubdirectory = sprintf('%s',[T_subdirectory '\'  char(nameSubFolds(j))]);
            cd(T_subsubdirectory);
            
            T_matfiles=dir('*.mat');
            
       
            
            for k=1:length(T_matfiles)
                
                if (size(T_matfiles,1)<4)
                    T_set=1;
                end
                
                
                T_matfilenames=T_matfiles(k).name;
                
                
                if (strcmpi(T_matfilenames,'Short0x2DtermLoudness.mat')) %'Sharpness.mat'
                    
                    
                    if(T_count2==11)
                        T_count2=1;
                        T_count1=T_count1+1;
                    end
                    
                    load(T_matfilenames);
                    T_loudness(T_count1,T_count2)=(dataObjS.DataObj.max);
%                     T_sharpness(T_count1,T_count2)=(dataObjS.DataObj.median);
                    T_filename(T_count1,T_count2)=cellstr(dataObjS.AnalyserObj.filename);
                    
                    T_count2=T_count2+1;
                    
                    
                    
                    
                end
                
                
                
            end
            
        end
        
    end
    
end



%%
% 
T_mean_loudness=mean(T_loudness,2);

% T_mean_sharpness=mean(T_sharpness,2);

%% Tabulate in the latex table format

latexinput.data=([T_loudness T_mean_loudness]);
% latexinput.data=([T_sharpness T_mean_sharpness]);
latexinput.tableColLabels = {'Ver1','Ver2','Ver3','Ver4','Ver5','Ver6','Ver7','Ver8','Ver9','Ver10','Mean'};
if(size(T_loudness,1)==3)
% if(size(T_sharpness,1)==3)    
latexinput.tableRowLabels={'NoObjectrec1','Object100cm','Object150cm'};    
else
latexinput.tableRowLabels={'NoObjectrec1','NoObjectrec2','Object50cm','Object100cm','Object200cm','Object300cm','Object400cm','Object500cm'};
end
latexinput.dataFormat = {'%.3f'};
latexinput.dataNanString = '-';
latexinput.tableColumnAlignment = 'c';
latexinput.tableBorders = 1;
% latexinput.tableCaption = 'Median of the sharpness in acums of 10 versions for the  recordings in the lecture room with  5ms_64 duration signal.  The last column indicates the mean over the 10 versions.';
% latexinput.tableLabel = 'Sharpness_median_lecture_5ms_64';
latexinput.tableCaption = 'Maximum of the Short Term Loudness in sones of 10 versions for the  recordings in the lecture room with  5ms_64 duration signal.  The last column indicates the mean over the 10 versions.';
latexinput.tableLabel = 'STL_max_lecture_5ms_64';

latexinput.makeCompleteLatexDocument = 0;
latexoutput=latexTable(latexinput);