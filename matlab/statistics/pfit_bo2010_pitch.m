% Description : Non Parametric fit of the Percentage of correct response from the study of Schenkman and Nilson (2010,2011) as a function of Pitch Strength
%             : The script also computes the threshold value of Pitch Strength for which the Percentage of correct response is in between 0.73 and 0.75
% Author      : Vijay Kiran Gidla (joy4u18@gmail.com)

clc;
clear all;
close all;

%% DATA

%% Blind percentage of correct

%Conference

bpc_5_conf=round(([9.71 9.18 5.4 5.15 5.2 4.96]./10)*56);
bpc_50_conf=round(([9.83 9.4 6.19 4.88 4.74 4.89]./10)*56);
bpc_500_conf=round(([9.71 9.98 8.94 4.68 5.23 4.7]./10)*56);

%Anechoic

bpc_5_anc=round(([9.79 8.81 5.14 4.39 4.78 5.04]./10)*56);
bpc_50_anc=round(([9.65 9.75 4.98 4.73 4.73 4.71]./10)*56);
bpc_500_anc=round(([9.67 9.94 5.18 4.98 5.56 5.08]./10)*56);

B_AC=[bpc_5_anc;bpc_50_anc;bpc_500_anc;bpc_5_conf;bpc_50_conf;bpc_500_conf];


% Lecture room

bpc_5_lec=round([0.6101 0.5373 ]*56);
% bpc_5_2c_lec=round([0.6607 0.5923]*56);
% bpc_5_4c_lec=round([0.6161 0.5759]*56);
% bpc_5_8c_lec=round([0.7188 0.6101]*56);
% bpc_5_16c_lec=round([0.7470 0.6315]*56);
% bpc_5_32c_lec=round([0.7560 0.6533]*56);
% bpc_5_64c_lec=round([0.7664 0.5391]*56);
bpc_500_lec=round([0.8080 0.5893]*56);

B_L=[bpc_5_lec; bpc_500_lec];


%%  Sighted Percentage of correct


%Conference


spc_5_conf=round(([8.48 7.65 5.86 4.95 4.74 4.8]./10)*56);
spc_50_conf=round(([9.39 8.18 5.81 4.89 4.75 5.08]./10)*56);
spc_500_conf=round(([9.67 9.85 7.12 4.96 4.98 4.98]./10)*56);

%Anechoic

spc_5_anc=round(([9.05 8.15 5.32 4.5 4.75 5.19]./10)*56);
spc_50_anc=round(([9.35 9.23 5.4 5.18 5 4.62]./10)*56);
spc_500_anc=round(([9.74 9.8 4.86 4.78 4.61 4.67]./10)*56);


S_AC=[spc_5_anc; spc_50_anc; spc_500_anc ; spc_5_conf ; spc_50_conf ; spc_500_conf];

% Lecture room

spc_5_lec=round([0.5508]*56);
% spc_5_2c_lec=round([0.5137]*56);
% spc_5_4c_lec=round([0.5467]*56);
% spc_5_8c_lec=round([0.5707]*56);
% spc_5_16c_lec=round([0.6174]*56);
% spc_5_32c_lec=round([0.6921]*56);
% spc_5_64c_lec=round([0.6456]*56);
spc_500_lec=round([0.6209]*56);

S_L=[spc_5_lec; spc_500_lec];




%% Plot of the DATA
%%  Anechoic
Pitch_strength_mean_A_005_mean=[2.54 1.06 0.395 0.395 0.395 0.395];

Pitch_strength_mean_A_050_mean=[4.17   1.67 0.46 0.46 0.46 0.46];

Pitch_strength_mean_A_500_mean=[4.75 2.44 0.74 0.74 0.74 0.74];



%%  Conference

Pitch_strength_mean_C_005_mean=[9.65 2.43 0.85 0.79 0.79 0.79];

Pitch_strength_mean_C_050_mean=[6.59 2.22 0.54 0.54 0.54 0.54];

Pitch_strength_mean_C_500_mean=[7.74 2.91 1.35 0.87 0.87 0.87];


PS_AC=[Pitch_strength_mean_A_005_mean;Pitch_strength_mean_A_050_mean;Pitch_strength_mean_A_500_mean;Pitch_strength_mean_C_005_mean;...
    Pitch_strength_mean_C_050_mean;Pitch_strength_mean_C_500_mean];

%% Lecture

Pitch_strength_mean_L_005_mean=[0.29  0.28];


Pitch_strength_mean_L_500_mean=[1.36 1.42];

PS_L=[Pitch_strength_mean_L_005_mean;Pitch_strength_mean_L_500_mean];

%% Plot of the DATA


m=[56 56 56  56 56 56]';
% m=m(1:3);							% VJ2015 : I did not analyse the recordings at 300 to 500 cm for pitch as they did not contain anay information so wanted to fit 3 values but later realized that this does not make any difference

% x=[100 150]';
% m=[56 56]';

for i=1:size(B_AC,1)
    
    
    x=PS_AC(i,:)';
%     x=x(1:3);
    
    r=S_AC(i,:)';
%     r=r(1:3);
    
    x=flipud(x);
    r=flipud(r);
    
    
    
    figure(i);
    plot( x, r ./ m, 'ro');
    axis([min(x) max(x) 0.2 1.2]);
    axis square;
    hold on;
    grid on;
    
    numxfit = 499;                                  % Number of new points to be generated minus 1
    xfit = [min(x):(max(x)-min(x))/numxfit:max( x ) ]';
    
    %% LSfit
    
    if(length(x)>2)
        
        guessing=0;
        lapsing=0;
        
        temp=diff(x);
        bwd_min = min(temp(temp>0));
		
        %         if(isempty(bwd_min))
        %             bwd_min=min(abs(temp));    %VJ 2015
        %         end
		
        bwd_max = max( x ) - min( x );
		
        %         if(bwd_min == bwd_max)
        %             bwd_min=1;                 %VJ2015
        %         end
		
% Switch between cross-validated or bootstrap by manually uncommenting the corresponding lines
        bwd = bandwidth_cross_validation( r, m, x, [ bwd_min, bwd_max ],'logit',guessing,lapsing,2,1,'normpdf',100,1e-6);        
%          bwd= bandwidth_bootstrap(r, m, x, [ bwd_min, bwd_max ],30,[],'logit',guessing,lapsing,2,1,'normpdf',100,1e-6);
      
     	hhh(:,i)=bwd;
        bwd = bwd(3); % choose the third estimate, which is based on cross-validated deviance
        pfit = locglmfit( xfit, r, m, x, bwd,'logit',guessing,lapsing,2,1,'normpdf',100,1e-6);
        plot( xfit, pfit, 'b','linewidth',2 );  % Plot the fitted curve
        
         z_2(i)=mean(xfit(pfit>0.73&pfit<0.75));

        
        %         h1=legend('Mean proportion of correct','logisitc fit','Local linear fit');
        %         set(h1,'location','best');
        xlabel('Pitch strength (autocorrelation index)');
        ylabel('Proportion of correct responses');
        
    else
        
        h1=legend('Mean proportion of correct','logistic fit');
        set(h1,'location','best');
        xlabel('Pitch strength (autocorrelation index)');
        ylabel('Proportion of correct responses');
    end
    
end

sprintf('%.2f ',z_2)
