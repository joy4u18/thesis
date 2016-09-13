% Description : The script loads the .wav files from a directory and plots the mean spectral centroid of 10 versions with desired frame and overlap time.
% Note        : Uncomment the commented section to plot the spectral centroid for individual versions with a small modification in the remaining code
%             : Manually comment 22 and uncomment the 26 line for recordings in lecture room
% Author      : Vijay Kiran Gidla (joy4u18@gmail.com)

%%

clc
clear all;
close all;

%%
%%  Locating and Initialzing the names for the .wav files
cd('D:\D\sp4\Thesisfiles\MATLAB\RECORDINGS\Exactduration_callibration\conference\500ms\left_ear')

wavfile=dir('*.wav');          % To read the .wav files in the directory
T_count=1;                     % Setting the counters
T_count1=1;

color=hsv(10);

ti={'NoObject rec1';'NoObject rec2';'Object at 50cm';...
    'Object at 100cm';'Object at 200cm';'Object at 300cm'; ...
    'Object at 400cm';'Object at 500cm'};

% ti={'NoObject';'Object at 100cm';'Object at 150cm'};


T_mean_sc=0;



for j=1:length(wavfile)
    
    wavname=wavfile(j).name;      % Reading the wavefile names
    
    T_count=T_count+1;
    
    [T_input, T_fs]= audioread(wavname);
    
    T_frametime=32e-3;
    T_overlaptime=10e-3;
    T_framelength=round(T_frametime*T_fs);
    T_overlaplength=round(T_overlaptime*T_fs);
    T_framecount=0;
    NFFT = 2^nextpow2(T_framelength);                                               % Next power of 2.
    T_f = T_fs/2*linspace(0,1,NFFT/2+1)';                                           % Frequency axis.
    
    
    
    for i=1:T_overlaplength: length(T_input)-T_framelength
        
        T_framecount=T_framecount+1;
        
        T_y=fft(T_input(i:i+T_framelength-1),NFFT)/T_framecount;
        
        T_buffer(:,T_framecount)=abs(T_y(1:NFFT/2+1));
        
    end
    
    T_spectralcentroid=sum((repmat(T_f,1,T_framecount).*T_buffer))./sum(T_buffer); % Spec centroid
    
    %     subplot(4,2,T_count1)
    %     subplot(2,2,T_count1)
    %     plot((0:T_framecount-1)*(T_overlaptime), T_spectralcentroid,'linewidth',2,'color',color(T_count-1,:));
    %     axis([0 (T_framecount-1)*T_overlaptime 0 T_fs/4])
    %     hold on; grid on ;    
    %     xlabel('Time(sec)');
    %     ylabel('Frequency (Hz)');
    
    T_mean_sc = T_mean_sc + T_spectralcentroid;
    
    if (T_count>10)
        
        T_mean_sc= T_mean_sc./10;
        
        subplot(4,2,T_count1)
        plot((0:T_framecount-1)*(T_overlaptime), T_mean_sc,'linewidth',2);
        axis([0 (T_framecount-1)*T_overlaptime 0 T_fs/4])
        hold on; grid on ;        
        xlabel('Time(sec)');
        ylabel('Frequency (Hz)');
        
        T_mean_sc=0;
        
        T_count=1;
        title(['Mean of the spectral centroid over 10 recordings for ' ti{T_count1}]);
        T_count1=T_count1+1;
                
    end    
end
%%