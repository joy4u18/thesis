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
%% Plot of the DATA based on the flag

TPlot = 1;

TPc80to90 = 0; % if this is set to zero  73 to 75% is chosen
IndexNan =[];
IndexError=[];
m=[56 56 56  56 56 56]';
j=1;
for i=1:size(SHP_AC,1)    
    x=SHP_AC(i,:)';		% Manually change the pitch data for different conditions
    x=flipud(x);        % This to ensure that we have incresing stimuli    
    
    for j=j:j+19
        r=PC_AC(j,:)';		% Manually change the sighted or the blind P(c) response
        r=flipud(r);       
        if(TPlot==1)
        figure(j);
        plot( x, r ./ m, 's');
        axis([min(x) max(x) 0.2 1.2]);
        axis square;
        hold on;
        grid on;
        end
        numxfit = 1999;      % Number of new points to be generated minus 1
        xfit = [min(x):(max(x)-min(x))/numxfit:max( x ) ]';        
        %% LSfit        
        if(length(x)>2)            
            guessing=0;
            lapsing=0;
            temp=diff(x);
            bwd_min = min(temp(temp>0));            
            if(isempty(bwd_min))
                bwd_min=min(abs(temp));    %VJ2015
            end            
            bwd_max = max( x ) - min( x );            
            if(bwd_min == bwd_max)
                bwd_min=1;    %VJ 2015
            end            
            % Switch between cross-validated or bootstrap by manually uncommenting the corresponding lines
            bwd = bandwidth_cross_validation( r, m, x, [ bwd_min, bwd_max ],'logit',guessing,lapsing,2,1,'normpdf',100,1e-6);
            %bwd= bandwidth_bootstrap(r, m, x, [ bwd_min, bwd_max ],30,[],'logit',guessing,lapsing,2,1,'normpdf',100,1e-6);            
            hhh(:,i)=bwd;            
            bwd = bwd(3); % choose the third estimate, which is based on cross-validated deviance
            pfit = locglmfit( xfit, r, m, x, bwd,'logit',guessing,lapsing,2,1,'normpdf',100,1e-6);
            if(TPlot ==1)
            plot( xfit, pfit, 'b','linewidth',2 );  % Plot the fitted curve
            xlabel('Loudness (sones)');
            ylabel('Proportion of correct responses');
            end
            
            % Find the value at 80 to 90 % p(c)
            if(TPc80to90==1)
            try                
            Sthd(j,1)=mean(xfit(pfit>0.8&pfit<0.9));
            if(isnan(Sthd(j,1)))
            Sthd(j,1) = x(end);    
            IndexNan = [IndexNan j]; % save the subject index who performed bad
            end
            catch err
            Sthd(j,1)=x(end);    
            IndexError = [IndexError j]; % save the subject index who performed bad 
            end
            else
            try                
            Sthd(j,1)=mean(xfit(pfit>=0.73&pfit<=0.76));
            if(isnan(Sthd(j,1)))
            Sthd(j,1)=mean(xfit(pfit>=0.73&pfit<=0.76));                
            end
            if(isnan(Sthd(j,1)))    
            Sthd(j,1) = x(end);    
            IndexNan = [IndexNan j]; % save the subject index who performed bad
            end
            catch err
            Sthd(j,1)=x(end);    
            IndexError = [IndexError j]; % save the subject index who performed bad 
            end    
            end
                
            %                                    
        else            
            if(TPlot==1)
            xlabel('Loudness (sones)');
            ylabel('Proportion of correct responses');
            end
        end
    end
    
    j=j+1;
end

%%
if(TPc80to90==1)
xlswrite('SthdIndividual',Sthd,'80to90')
xlswrite('SthdIndividual',IndexNan,'80to90INan')
else
xlswrite('SthdIndividual',Sthd,'73to75')    
xlswrite('SthdIndividual',IndexNan,'73to75INan')
end