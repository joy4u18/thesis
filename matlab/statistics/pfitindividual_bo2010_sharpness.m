% Description : Non Parametric fit of the INDIVIDUAL Percentage of correct response from the study of Schenkman and Nilson (2010,2011) as a function of Sharpness
%             : The script also computes the threshold value of Sharpness for which the Percentage of correct response is in between 0.73 and 0.75
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

% PC_AC=[pc_500_anec(2,:);pc_500_anec(3,:);pc_500_anec(6,:)];

% PC_AC=[pc_500_anec(2,:);pc_500_anec(6,:)];
%% Sharpness values
%  Anechoic
Sharpness_CF_mean_A_005_mean=[2.052 2.138 1.921 1.906 1.891 1.889];
Sharpness_CF_mean_A_050_mean=[2.068 2.141 1.912 1.904 1.874 1.881];
Sharpness_CF_mean_A_500_mean=[2.116 2.119 1.892 1.858 1.831 1.835];
%  Conference
Sharpness_CF_mean_C_005_mean=[2.0320    2.0320 2.003    2.009    1.982    1.986];
Sharpness_CF_mean_C_050_mean=[1.9640    1.9500 1.9360    1.9140    1.9170    1.8880];
Sharpness_CF_mean_C_500_mean=[2.0950    2.0430  1.9670    1.9500    1.9490    1.9410];

SHP_AC=[Sharpness_CF_mean_A_005_mean;Sharpness_CF_mean_A_050_mean;Sharpness_CF_mean_A_500_mean;Sharpness_CF_mean_C_005_mean;...
    Sharpness_CF_mean_C_050_mean;Sharpness_CF_mean_C_500_mean];

% SHP_AC=[Sharpness_CF_mean_A_500_mean], % for plos 2018

% Lecture

Sharpness_CF_mean_L_005_mean=[1.7780    1.8340];
Sharpness_CF_mean_L_500_mean=[2.2000    2.1100];
SHP_L=[Sharpness_CF_mean_L_005_mean;Sharpness_CF_mean_L_500_mean];
%% Plot of the DATA

m=[56 56 56  56 56 56]';
j=1;
for i=1:size(SHP_AC,1)
    
    
    x=SHP_AC(i,:)';		% Manually change the loudness data for different conditions
    x=flipud(x);        % This to ensure that we have incresing stimuli
    
%     for j=j:j+1    % for plos 2018
% %     for j=j:j+2  % for plos 2017
    for j=j:j+19
    r=PC_AC(j,:)';		% Manually change the sighted or the blind P(c) response        
    r=flipud(r);
    
%     subplot(1,2,j);  % for plot 2018
    figure;
%     plot( x, r ./ m, 's','linewidth',2);
    plot( x, r ./ m, 'bo');   % plos one 2017
    
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
%         z_2(j,:)=xfit(pfit==0.69);
        
        
        hf=gcf;
hf.Position(3)=800;
hf.Position(4)=600;
hf.Position(1)=10;
hf.Position(2)=10;


hs=gca;
hs.FontSize=10;
hs.FontName='Arial';

        
        h1=legend('proportion of correct','Local linear fit');
        h1.FontName='Arial';
        h1.FontWeight='bold';
        h1.FontSize=10;
%         set(h1,'location','best');
        xlabel('Sharpness (accums)');
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
% figure;
% plot(z_2(1:20),'-s');
% grid on;
% xlabel('Particpant ID');
% ylabel('Sharpness Threshold(accums)');
% set(gca,'XTick',1:20);
% set(gca,'XLim',[1 20]);
% hold on;
% plot(z_2(21:40),'-s');
% plot(z_2(41:60),'-s');
% plot(z_2(61:80),'-s');
% plot(z_2(81:100),'-s');
% plot(z_2(101:120),'-s');
% legend('Anechoic 5ms','Anechoic 50ms','Anechoic 500ms','Conference 5ms','Conference 50ms','Conference 500ms','location','best');
% dummy=reshape(z_2,20,6);
% xlswrite('ST',dummy);
