clc;
clearvars;
close all;
%%  Locating and Initialzing the names for the .wav files

T_d=5;
cLow = -180;
cHigh = 0;
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
    T_count =1;
    
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
        %     if(T_room ==1)
        %         ht = text(hs,380+T_d,28,ti{1,T_count1},'FontWeight','bold','FontSize',12,'FontName','Arial');
        %     else
        %         ht = text(hs,380+T_d,25,ti{1,T_count1},'FontWeight','bold','FontSize',12,'FontName','Arial');
        %     end
        
        if(T_room<3 && T_noobjectcount > 0) % this is to discard the first no object
            T_noobjectcount = T_noobjectcount -1;
            if (T_count>20)
                T_count=1;
                try
                    if(T_room ==1)
                        T_acounter = T_acounter+1;
                        if(T_acounter == T_ccounter)
                            break;
                        end
                        hs=subplot(3,3,T_acounter);
                    elseif(T_room == 2)
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
                try
                    if(T_room ==1)
                        T_acounter = T_acounter+1;
                        T_count = -9; % this is to retrive object at 200  and discard 100 in the plot
                        if(T_acounter == T_ccounter)
                            break;
                        end
                        hs=subplot(3,3,T_acounter);
                    elseif(T_room == 2)
                        T_ccounter = T_ccounter+1;
                        T_count = -9; % this is to retrive object at 200  and discard 100 in the plot
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
