% Description : The script loads the .wav file and plots the shor time autocorrelation function with desired frame and overlap time.
% Author      : Vijay Kiran Gidla (joy4u18@gmail.com)


%%
clc;
clear all;
close all;

%%
% [T_input, T_fs]=audioread('C:\Users\joy4u\OneDrive\Thesis\RECORDINGS\Exactduration_callibration\anechoic\5ms\Left_ear\ED_o_100_A005_01_left.wav');
[T_input, T_fs]=audioread('C:\Users\joy4u\OneDrive\Thesis\RECORDINGS\Exactduration_callibration\anechoic\500ms\Left_ear\ED_o_100_A500_01_left.wav');

T_frametime=32e-3;
T_overlaptime=32e-3;
T_framelength=T_frametime*T_fs;
T_framelength=round(T_framelength);
T_overlaplength=round(T_overlaptime*T_fs);
T_framecount=0;
T_fm=(T_fs/2).*linspace(0,1,(2^nextpow2(T_framelength)/2)+1);
T_factor=5;
%% For plotting
cc={'r','m','g','b','k'};
s=sprintf('32ms frame at %dms time instant*', (T_frametime:T_overlaptime:(T_overlaptime*T_factor)+T_frametime)*1e3);
c = regexp(s, '*', 'split');
c ={'A','B','C','D','E','F'};
figure;
hold on 

%% Actual computation
for i=1:T_overlaplength: (T_overlaplength*T_factor)+1  
    
    T_framecount=T_framecount+1;
    
    T_buffer(T_framecount,:)=T_input(i:i+T_framelength-1);
    
    [T_ac(T_framecount,:), T_lag(T_framecount,:)]=xcorr(T_buffer(T_framecount,:));
    

hs=subplot(3,2,T_framecount);
plot(T_lag(T_framecount,T_framelength:end),T_ac(T_framecount,T_framelength:end),'linewidth',2);
grid on;
                   
% axis([0 T_lag(end) -10 10]);
axis([0 T_lag(end) -50 50]);
% hl=legend(c{1,T_framecount});
% hl.Box='off';
% t1 = text(hs,1300,6,c{1,T_framecount},'FontWeight','bold','FontSize',12,'FontName','Arial');
t1 = text(hs,1300,30,c{1,T_framecount},'FontWeight','bold','FontSize',12,'FontName','Arial');
xlabel('Lag');
ylabel('ACF Index');
                   
                   
end
%%
hf=gcf;
hf.Position(3)=700;
hf.Position(4)=600;
hf.Position(1)=10;
hf.Position(2)=10;


