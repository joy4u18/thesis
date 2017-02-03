% Description : Parametric and Non Parametric fit of the INDIVIDUAL Percentage of correct response from the study of Schenkman and Nilson (2010,2011) as a function of distance
%             : The script also computes the threshold value of distance for which the Percentage of correct response is in between 0.73 and 0.75
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

%% Plot of the DATA

x=([50 100 200 300 400 500])';		% Distance 
m=[56 56 56  56 56 56]';			% Total trails at each distance


for i=1:size(PC_AC,1)

    
r=PC_AC(i,:)';

figure(i);
plot( x, r ./ m, 'ro');
axis([min(x) max(x) 0.2 1.2]); 
axis square;
hold on;
grid on;
%% Gaussian Fit
degpol = 1;                                    % Degree of the polynomial
guessing =0.5;                                 % Guessing rate
lapsing = 0.01;                                % Lapsing rate
b = binomfit_lims( r, m, x, degpol,'weibull', guessing, lapsing,2 );
numxfit = 499;                                 % Number of new points to be generated minus 1
xfit = [min(x):(max(x)-min(x))/numxfit:max( x ) ]';
pfit = binomval_lims( b, xfit, 'weibull', guessing, lapsing,2 );
plot( xfit, pfit, 'k' ,'linewidth',2);         % Plot the fitted curve

z_1(i)=mean(xfit(pfit>0.73&pfit<0.75));
%% Locfit

guessing=0;
lapsing=0;
    
temp=diff(x);
bwd_min = min(temp(temp>0));
bwd_max = max( x ) - min( x );


% Switch between cross-validated or bootstrap by manually uncommenting the corresponding lines
bwd = bandwidth_cross_validation( r, m, x, [ bwd_min, bwd_max ],'logit',guessing,lapsing,2,1,'normpdf',100,1e-6); 
% bwd= bandwidth_bootstrap(r, m, x, [ bwd_min, bwd_max ],30,[],'logit',guessing,lapsing,2,1,'normpdf',100,1e-6);
hhh(:,i)=bwd; % Debugging purpose 


bwd = bwd(3); % choose the third estimate, which is based on cross-validated deviance
pfit = locglmfit( xfit, r, m, x, bwd,'logit',guessing,lapsing,2,1,'normpdf',100,1e-6);
plot( xfit, pfit, 'b','linewidth',2 );  % Plot the fitted curve

thd(i)=mean(xfit(pfit>0.73&pfit<0.75));

h1=legend('proportion of correct','Weibull fit','Local linear fit');
set(h1,'location','best');
xlabel('Distance from the object (cm)');
ylabel('Proportion of correct responses');


end

%%
% figure;
% plot(thd(1:20),'-s');
% grid on;
% xlabel('Particpant ID');
% ylabel('Distance Threshold (cm)');
% set(gca,'XTick',1:20);
% set(gca,'XLim',[1 20]);
% hold on;
% plot(thd(21:40),'-s');
% plot(thd(41:60),'-s');
% plot(thd(61:80),'-s');
% plot(thd(81:100),'-s');
% plot(thd(101:120),'-s');
% legend('Anechoic 5ms','Anechoic 50ms','Anechoic 500ms','Conference 5ms','Conference 50ms','Conference 500ms','location','best');
% dummy=reshape(thd,20,6);
% xlswrite('DT',dummy);
