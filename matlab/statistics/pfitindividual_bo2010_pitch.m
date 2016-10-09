% Description : Non Parametric fit of the INDIVIDUAL Percentage of correct response from the study of Schenkman and Nilson (2010,2011) as a function of Pitch Strength
%             : The script also computes the threshold value of Loudness for which the Percentage of correct response is in between 0.73 and 0.75
% Author      : Vijay Kiran Gidla (joy4u18@gmail.com)


clc;
clear all;
close all;

%% Load individual p(c) from the excel file

Bo2010_results=xlsread('res_expt1_conf_anechoic.xls','SDT+arcsinpc');

pc_5_conf=round(Bo2010_results(1:6:end,6).*56);
pc_5_conf=reshape(pc_5_conf,6,20)';
pc_5_anec=round(Bo2010_results(2:6:end,6).*56);
pc_5_anec=reshape(pc_5_anec,6,20)';
pc_50_conf=round(Bo2010_results(3:6:end,6).*56);
pc_50_conf=reshape(pc_50_conf,6,20)';
pc_50_anec=round(Bo2010_results(4:6:end,6).*56);
pc_50_anec=reshape(pc_50_anec,6,20)';
pc_500_conf=round(Bo2010_results(5:6:end,6).*56);
pc_500_conf=reshape(pc_500_conf,6,20)';
pc_500_anec=round(Bo2010_results(6:6:end,6).*56);
pc_500_anec=reshape(pc_500_anec,6,20)';
PC_AC=[pc_5_anec;pc_50_anec;pc_500_anec;pc_5_conf;pc_50_conf;pc_500_conf];
%% Pitch strength from aim
%  Anechoic
Pitch_strength_mean_A_005_mean=[2.54 1.06 0.395 0.395 0.395 0.395];
Pitch_strength_mean_A_050_mean=[4.17   1.67 0.46 0.46 0.46 0.46];
Pitch_strength_mean_A_500_mean=[4.75 2.44 0.74 0.74 0.74 0.74];
%  Conference
Pitch_strength_mean_C_005_mean=[9.65 2.43 0.85 0.79 0.79 0.79];
Pitch_strength_mean_C_050_mean=[6.59 2.22 0.54 0.54 0.54 0.54];
Pitch_strength_mean_C_500_mean=[7.74 2.91 1.35 0.87 0.87 0.87];

PS_AC=[Pitch_strength_mean_A_005_mean;Pitch_strength_mean_A_050_mean;Pitch_strength_mean_A_500_mean;Pitch_strength_mean_C_005_mean;...
    Pitch_strength_mean_C_050_mean;Pitch_strength_mean_C_500_mean];

% Lecture
Pitch_strength_mean_L_005_mean=[0.29  0.28];
Pitch_strength_mean_L_500_mean=[1.36 1.42];
PS_L=[Pitch_strength_mean_L_005_mean;Pitch_strength_mean_L_500_mean];
%% Plot of the DATA

m=[56 56 56  56 56 56]';
j=1;
for i=1:size(PS_AC,1)
    
    
    x=PS_AC(i,:)';		% Manually change the loudness data for different conditions
    x=flipud(x);        % This to ensure that we have incresing stimuli
    
    for j=j:j+19
    r=PC_AC(j,:)';		% Manually change the sighted or the blind P(c) response        
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
%             bwd_min=min(abs(temp));    %VJ2015
%         end

        bwd_max = max( x ) - min( x );
		
%         if(bwd_min == bwd_max)
%             bwd_min=1;    %VJ 2015
%         end

% Switch between cross-validated or bootstrap by manually uncommenting the corresponding lines
        bwd = bandwidth_cross_validation( r, m, x, [ bwd_min, bwd_max ],'logit',guessing,lapsing,2,1,'normpdf',100,1e-6);               
%         bwd= bandwidth_bootstrap(r, m, x, [ bwd_min, bwd_max ],30,[],'logit',guessing,lapsing,2,1,'normpdf',100,1e-6);
        
        
        hhh(:,i)=bwd;
%         hhh_1(:,i)=bwd;
        bwd = bwd(3); % choose the third estimate, which is based on cross-validated deviance
       
        
        pfit = locglmfit( xfit, r, m, x, bwd,'logit',guessing,lapsing,2,1,'normpdf',100,1e-6);
        plot( xfit, pfit, 'b','linewidth',2 );  % Plot the fitted curve
        
        z_2(j)=mean(xfit(pfit>0.73&pfit<0.75));
        
%         h1=legend('Mean proportion of correct','logisitc fit','Local linear fit');
%         set(h1,'location','best');
        xlabel('Pitch strength (autocorrelation index)');
        ylabel('Proportion of correct responses');
        
    else
        
        h1=legend('Mean proportion of correct','logistic fit');
        set(h1,'location','best');
        xlabel('Loudness (sones)');
        ylabel('Proportion of correct responses');
    end
    end
    
    j=j+1;
end
figure;
plot(z_2(1:20),'-s');
grid on;
xlabel('Particpant ID');
ylabel('Pitch strength Threshold (autocorrelation index)');
set(gca,'XTick',1:20);
set(gca,'XLim',[1 20]);
hold on;
plot(z_2(21:40),'-s');
plot(z_2(41:60),'-s');
plot(z_2(61:80),'-s');
plot(z_2(81:100),'-s');
plot(z_2(101:120),'-s');
legend('Anechoic 5ms','Anechoic 50ms','Anechoic 500ms','Conference 5ms','Conference 50ms','Conference 500ms','location','best');
dummy=reshape(z_2,20,6);
xlswrite('PT',dummy);
