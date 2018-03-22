clc;
clearvars;
close all;
%%

%%
%%  Locating and Initialzing the names for the .wav files
T_d=500;
cLow = -180;
cHigh = 0;
cd('C:\Users\joy4u\OneDrive\Joy\Research\Thesis\RECORDINGS\Exactduration_callibration\lecture\500ms\left_ear')

wavfile=dir('*.wav');          % To read the .wav files in the directory
T_count=1;                     % Setting the counters
T_count1=1;



% ti={'NoObject rec1';'NoObject rec2';'Object at 50cm';...
%     'Object at 100cm';'Object at 200cm';'Object at 300cm'; ...
%     'Object at 400cm';'Object at 500cm'};

% ti={'A','B','C','D','E','F','G','H'};


% ti={'NoObject';'Object at 100cm';'Object at 150cm'};
 ti={'A','B','C'};

T_mean_sc=0;



for j=1:length(wavfile)
    
    wavname=wavfile(j).name;      % Reading the wavefile names
    
%     hs=subplot(4,2,T_count1);
    hs=subplot(2,2,T_count1);
    T_count=T_count+1;
    
    [T_input, T_fs]= audioread(wavname);
    
    T_frametime=32e-3;
    T_overlaptime=16e-3;
    T_framelength=round(T_frametime*T_fs);
    T_overlaplength=round(T_overlaptime*T_fs);
    NFFT = 4096;
   
    spectrogram(T_input(1:round(((T_d+450)*T_fs*1e-3))),T_framelength,T_overlaplength,NFFT,T_fs,'yaxis')
    caxis([cLow cHigh]);
    colormap jet;
    colorbar off;
    
    set(gca,'FontName','Arial');
%     ht = text(hs,380+T_d,28,ti{1,T_count1},'FontWeight','bold','FontSize',12,'FontName','Arial');   
    ht = text(hs,380+T_d,25,ti{1,T_count1},'FontWeight','bold','FontSize',12,'FontName','Arial');   
    if (T_count>10)
    T_count=1;    
    T_count1 = T_count1+1;
    try
%     hs=subplot(4,2,T_count1);
    hs=subplot(2,2,T_count1);
    catch err
    warning(err.message);    
    end
    end
    
  
end
%%

%%
hf=gcf;
hf.Position(3)=800;
hf.Position(4)=600;
hf.Position(1)=10;
hf.Position(2)=10;
