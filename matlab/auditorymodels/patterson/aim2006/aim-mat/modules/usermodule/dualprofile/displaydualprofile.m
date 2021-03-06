% generating function for 'aim-mat'
%
%   INPUT VALUES:
%
%   RETURN VALUE:
%
%
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site:
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function displaydualprofile(sai,options,frame_number,ax)
if nargin<4
    hs=subplot(2,2,1);   % for plos one article vj2017
    ax=hs;
%     ax=gca;
end

% hs=subplot(2,2,3);   % for plos one article vj2017
% ax=hs;


% Test if the frame_number is available
if length(sai)<frame_number
    % no its not
    return
end
if ~(isfield(sai{frame_number}, 'interval_sum') & isfield(sai{frame_number}, 'frequency_sum'))
    return
end

% ?????? per Definition ????
minimum_time_interval=options.minimum_time_interval;  % in ms
maximum_time_interval=options.maximum_time_interval;
nr_labels = options.nr_labels;

% Normalize the profiles
fq_sum = sai{frame_number}.frequency_sum;
int_sum = sai{frame_number}.interval_sum;
if (getnrpoints(fq_sum)~=0)
    int_sum = int_sum/getnrpoints(fq_sum);
% int_sum = 3*(int_sum/getnrpoints(fq_sum));  % VJ2015 used this to visulaize ACF in a better way.
end
if (getnrpoints(int_sum)~=0)
    fq_sum = (fq_sum/getnrpoints(int_sum)) ;%*options.scalefactor; % *1.7 (VJ2015 removed the scalefactor)
end


cla;
%Plot both profiles into one figure
% frequency profile
fqp = getvalues(fq_sum)';
% fwidth=plot(ax,sai{frame_number}.channel_center_fq, fqp,'r');  % VJ2015 commented to remove freq sum
fwidth=plot(ax,sai{frame_number}.channel_center_fq, fqp,'b--');  % plos one 2017
hold on

% time interval profile
tip=getvalues(int_sum);
tip_x = bin2time(sai{frame_number}.interval_sum, 1:length(tip));            % Get the times
tip_x = tip_x((tip_x>=(minimum_time_interval/1000)) & tip_x<=(maximum_time_interval/1000));
tip = tip(time2bin(sai{frame_number}.interval_sum,tip_x(1)):time2bin(sai{frame_number}.interval_sum,tip_x(end)));

% tip_x is in ms. Change to Hz
tip_x = 1./tip_x;  % VJ2015 Commented to plot only the delay of the ACF (autocorrelation)
twidth=plot(tip_x, tip, 'b');

set(ax,'XScale','log');

% set(ax,'xscale','linear') % VJ2015 orginal one is log

% Now lable it !
xlabel('Frequency [Hz]');
% xlabel('Delay (sec)');     % VJ 2015 for only ACF
ylabel('Scaled autocorrelation index');  % VJ 2014
set(ax, 'YAxisLocation','right'); % VJ 2015 commented to visulaize only ACF
ti=50*power(2,[0:nr_labels]); % VJ 2015 commented to visulaize only ACF
set(ax,'XTick', ti);  % VJ2015 commented to visulaize only ACF ( next line also)
set(ax, 'XLim',[1000/maximum_time_interval sai{frame_number}.channel_center_fq(end)])
set(options.handles.checkbox6, 'Value',0);
set(options.handles.checkbox7, 'Value',0);
hold off

% VJ2014
% axis([0 6000 get(gca,'yLim')]);   % 0.0035 for ACF  get(gca,'xlim') VJ 2014
% axis([0 0.01 get(gca,'yLim')]); % VJ 2015 for only ACF
grid on;
set(fwidth,'linewidth',1.5');  % VJ2015 commented to remove freq sum from the plot
set(twidth,'linewidth',1.5');
% legend('Sum of ACF over time delay','Sum of ACF over frequency','location','best');
hl=legend('Spectral profile','Temporal profile','location','best');
hl.FontWeight='bold';
hl.FontSize=8;
hl.FontName='Arial';

%%

%% Used this for plos one publication vj2017
hf=gcf;
hf.Position(3)=700;
hf.Position(4)=600;
hf.Position(1)=10;
hf.Position(2)=10;


hs.FontSize=7;
hs.XLabel.FontSize=10;
hs.YLabel.FontSize=10;
hs.FontName='Arial';

% t1 = text(hs,4000,0.05,'A','FontWeight','bold','FontSize',12,'FontName','Arial');
% t1 = text(hs,4000,0.1,'A','FontWeight','bold','FontSize',12,'FontName','Arial');

% t1 = text(hs,4000,0.25,'B','FontWeight','bold','FontSize',12,'FontName','Arial');
% t1 = text(hs,4000,0.5,'B','FontWeight','bold','FontSize',12,'FontName','Arial');

% t1 = text(hs,4000,0.125,'C','FontWeight','bold','FontSize',12,'FontName','Arial');
% t1 = text(hs,4000,0.25,'C','FontWeight','bold','FontSize',12,'FontName','Arial');

% t1 = text(hs,4000,0.05,'D','FontWeight','bold','FontSize',12,'FontName','Arial');
% t1 = text(hs,4000,0.1,'D','FontWeight','bold','FontSize',12,'FontName','Arial');

% 100cm object
% x = [0.19 0.21]; 
% y = [0.22 0.18];
% ha=annotation('textarrow',x,y,'String','PEAK');
% 200 cm object
% x = [0.62 0.63]; 
% y = [0.20 0.16];
% ha=annotation('textarrow',x,y,'String','PEAK');
% ha.FontName='Arial';
% ha.FontWeight='bold';
% ha.FontSize=8;
return








