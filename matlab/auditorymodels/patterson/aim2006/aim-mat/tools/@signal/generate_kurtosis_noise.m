% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function [sig,x_pdf,y_pdf]=generate_kurtosis_noise(sig,kurtosis_wanted)
% generate a signal with a given kurtosis 

% do we want to see anything?
grafix=0;

v=get(sig);
% variance_wanted=get(params,'Variance');
% skwednes=get(params,'Skewedness');




% change the kurtosis input to something meaningful
% these values are measured for different inputs of x
% if raw value for "Kurtosis" is inputted as:
input_kurt=[1 0.95 0.9 0.85 .8 .7 .6 .5 .4 .3 .25 .2 .15 .125 0.1 ];
% then the Kurtosis will be:
output_kurt=[-.05 0.04 0.13 0.26 .4 .7 1.12 1.72 2.58 4 5.11 6.87 9.6 11.8 15];

% to input the real Kurtosis, we need to turn these values around:
% and find the "input" value for a given Kurtosis:
kurtosis=interp1(output_kurt,input_kurt,kurtosis_wanted);

% % and the same for the variance. changing the variance does not change the
% % kurtosis
% input_var=0:15;
% output_var=[0.97 .68 .53 .43 .35 .3 .27 .24 .22 .2 .18 .17 .15 .14 .13 .12];
% variance=interp1(output_var,input_var,variance_wanted);

variance=1;



if grafix
    figure(3)
    clf
    hold on
end

nr_points=2000;

stepx=10/nr_points;
% generate the pdf 
x=-5:stepx:5;

p_pdf=pdf('Normal',x,0,1);
p_pdf=p_pdf/max(p_pdf);

% p_cdf=cumsum(p_pdf);
% p_cdf=p_cdf/max(p_cdf);
% if grafix
%      plot(x,p_pdf,'b.');hold on
% end

% scale along x to change the variance:
y=p_pdf;


new_x=x*variance;
ny=interp1(new_x,y,x);
ny(isnan(ny))=0;

x_pdf=x; % save for plotting
y_pdf=ny;

% % and the change in y to modify the Kurtosis
% 
% generate random numbers by reversing the cdf
new_cdf=cumsum(ny); %calculate the pdf:
new_cdf=new_cdf/max(new_cdf); % and normalise

for i=1:nr_points/2-1
%     dx=abs(x(nr_points/2-i));
    dy=abs(0.5-new_cdf(i));
    ndy=power((2*dy),kurtosis);
    new_cdf(i)=0.5-ndy/2;
    new_cdf(nr_points-i)=0.5+ndy/2;
end


if grafix
    
    old_cdf=cumsum(y);
    old_cdf=old_cdf/max(old_cdf); % and normalise
    
    plot(x,old_cdf,'-b.');
    plot(x,new_cdf,'-r.'); hold on
    legend({'cumulative normal distribution';'modfied cdf'},2);
end


serachy=1/nr_points:1/nr_points:1;
rev_cdf=zeros(1,nr_points-1);



for i=1:nr_points-1
    rev_cdf(i)=find(new_cdf>serachy(i),1,'first');
end

% clf
% plot(rev_cdf,'r.'); 

r=round(rand(length(v),1)*(nr_points-1)+0.5);

rev_p=rev_cdf(r);

% clf
% hist(rev_p,100)


% and normalise to the right output range
rev_p=(rev_p-nr_points/2)/nr_points*10;

% return
% v=random('norm',0,sqrt(variance),length(v),1);


sig=set(sig,rev_p');

