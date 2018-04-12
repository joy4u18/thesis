% Description : The script loads the .wav files from a directory and plots the mean spectral centroid of 10 versions with desired frame and overlap time.
% Note        : Uncomment the commented section to plot the spectral centroid for individual versions with a small modification in the remaining code
%             : Manually comment 22 and uncomment the 26 line for recordings in conference room
% Author      : Vijay Kiran Gidla (joy4u18@gmail.com)

%%

clc;
clearvars;
close all;

T_d=500;
roomnames = {'anechoic','conference','lecture'};
ti={'A','B','C','D','E','F','G','H', 'I'};

T_acounter=1;
T_ccounter=4;
T_lcounter=7;
for roomindex = 1:3
    
    String = string(roomnames(roomindex));
    if(String == 'anechoic')
        T_room = 1;
        T_noobjectcount = 20;
    elseif (String == 'conference')
        T_room = 2;
        T_noobjectcount = 20;
    else
        T_room = 3;
    end
    
    cd(['C:\Users\joy4u\OneDrive\Joy\Research\Thesis\RECORDINGS\Exactduration_callibration\' char(String) '\' char(string(T_d)) 'ms\left_ear'])
    
    wavfile=dir('*.wav');          % To read the .wav files in the directory
    T_count =1;  % This is the plotting count
    T_meancount = 1; % this is the mean count
    sumsc  = 0;
    
    for j=1:length(wavfile)
        
        wavname=wavfile(j).name;      % Reading the wavefile names
        if(T_room==1)
            hs=subplot(3,3,T_acounter);
        elseif(T_room==2)
            hs=subplot(3,3,T_ccounter);
        else
            hs=subplot(3,3,T_lcounter);
        end
        
        T_count=T_count+1;
        T_meancount = T_meancount +1;
        
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
        
        sumsc = sumsc + T_spectralcentroid;
        
   
        
        
        
                
        
        
        if(T_room<3 && T_noobjectcount > 0) % this is to discard the first no object
            T_noobjectcount = T_noobjectcount -1;
            if (T_count>20)
                T_count=1;
                
                plot((0:T_framecount-1)*(T_overlaptime), sumsc./10,'linewidth',2);
%                 axis([0 (T_framecount-1)*T_overlaptime 0 T_fs/4])
                axis([0 0.9 0 T_fs/4]) % changed the axis scaling to be consistent in all figures
                set(gca,'YTick',[0 3e3 6e3 9e3]);
                set(gca,'FontName','Arial');
                hold on; grid on ;
                xlabel('Time (sec)');
                ylabel('Frequency (Hz)');
                
                
                try
                    if(T_room ==1)
                        ht = text(hs,0.8,9000,ti{1,T_acounter},'FontWeight','bold','FontSize',12,'FontName','Arial');
                        T_acounter = T_acounter+1;
                        if(T_acounter == T_ccounter)
                            break;
                        end
                        hs=subplot(3,3,T_acounter);
                    elseif(T_room == 2)
                        ht = text(hs,0.8,9000,ti{1,T_ccounter},'FontWeight','bold','FontSize',12,'FontName','Arial');
                        T_ccounter = T_ccounter+1;
                        if(T_ccounter == T_lcounter)
                            break;
                        end
                        hs=subplot(3,3,T_ccounter);
                    else
                        T_lcounter = T_lcounter+1;
                        hs=subplot(3,3,T_lcounter);
                    end
                catch err
                    warning(err.message);
                end
            end
        else
            if (T_count>10)
                T_count=1;
                
                plot((0:T_framecount-1)*(T_overlaptime), sumsc./10,'linewidth',2);
                axis([0 0.9 0 T_fs/4]) % changed the axis scaling to be consistent in all figures
                set(gca,'YTick',[0 3e3 6e3 9e3]);
                set(gca,'FontName','Arial');
                hold on; grid on ;
                xlabel('Time (sec)');
                ylabel('Frequency (Hz)');
                
                
                try
                    if(T_room ==1)
                        ht = text(hs,0.8,9000,ti{1,T_acounter},'FontWeight','bold','FontSize',12,'FontName','Arial');
                        T_acounter = T_acounter+1;
                        T_count = -9; % this is to retrive object at 200  and discard 100 in the plot
                        if(T_acounter == T_ccounter)
                            break;
                        end
                        hs=subplot(3,3,T_acounter);
                    elseif(T_room == 2)
                        ht = text(hs,0.8,9000,ti{1,T_ccounter},'FontWeight','bold','FontSize',12,'FontName','Arial');
                        T_ccounter = T_ccounter+1;
                        T_count = -9; % this is to retrive object at 200  and discard 100 in the plot
                        if(T_ccounter == T_lcounter)
                            break;
                        end
                        hs=subplot(3,3,T_ccounter);
                    else
                        ht = text(hs,0.8,9000,ti{1,T_lcounter},'FontWeight','bold','FontSize',12,'FontName','Arial');
                        T_lcounter = T_lcounter+1;
                        hs=subplot(3,3,T_lcounter);
                    end
                catch err
                    warning(err.message);
                end
            end
        end
        
        if(T_meancount>10)        % To ensure that we only plot the mean of 10 recording at a condition    
        sumsc=0;  
        T_meancount = 1;
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