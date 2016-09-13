% generating function for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% Christoph Lindner
% $Date: 2003/07/17 10:56:16 $
% $Revision: 1.5 $

function displaypitchstrength(sai,options,frame_number)
show_time = 0;


% ?????? per Definition ????
minimum_time_interval=0.1;  % in ms
maximum_time_interval=32;

ti_result=options.handles.data.usermodule{frame_number}.ti_result;
f_result=options.handles.data.usermodule{frame_number}.f_result;

fq_sum = f_result.smoothed_signal;
int_sum = ti_result.smoothed_signal;
cla;
hold on

% TIP
tip=getvalues(int_sum);
% the tip is in the form of a logarithmic signal, it must therfore be
% transformed back to linear:

tip_x = bin2time(int_sum, 1:length(tip));  % Get the times
tip_x = tip_x((tip_x>=(minimum_time_interval/1000)) & tip_x<=(maximum_time_interval/1000));  
tip = tip(time2bin(int_sum,tip_x(1)):time2bin(int_sum,tip_x(end)));
% tip_x is in ms. Change to Hz
tip_x = 1./tip_x;
% plot(tip_x, tip, 'b');

% plot the smoothed interval profile, from which the pitch was derived
smoothed_signal=ti_result.smoothed_signal;
if ~isempty(smoothed_signal)
	smoothed_signal=linsigx(smoothed_signal); % change the logarithmic signal back to linear
	% smoothed_signal=reverse(smoothed_signal);
	smoothval=getvalues(smoothed_signal);
	s_x = bin2time(smoothed_signal, 1:length(smoothval));  % Get the times
	s_x = s_x((s_x>=(minimum_time_interval/1000)) & s_x<=(maximum_time_interval/1000));  
	
	smoothval=smoothval(time2bin(smoothed_signal,s_x(1)):time2bin(smoothed_signal,s_x(end)));
%     s_x=f2f(s_x,0,0.035,0.0001,0.035);
    s_x=(s_x+0.0001); %??????????
 	s_x=s_x*1.01; %??????????
	s_x=1./s_x;
	plot(s_x,smoothval,'b');
end

set(gca,'XScale','log');    

xlabel('Frequency [Hz]');
set(gca, 'YAxisLocation','right');
pks = [];

nr_labels = 8;
ti=50*power(2,[0:nr_labels]);
for i=1:length(pks)
    ti = ti((ti>(pks(i)+pks(i)*0.1))|(ti<pks(i)-pks(i)*0.1));
end
ti = [ti round(pks)];
ti = sort(ti);
set(gca,'XTick', ti);
set(gca, 'XLim',[1000/maximum_time_interval sai{frame_number}.channel_center_fq(end)])
set(options.handles.checkbox6, 'Value',0);
set(options.handles.checkbox7, 'Value',0);


% if there is a target frequency, then plot this one also!
target_frequency=options.target_frequency;
% at least three possibilities: take the hight:
pitchstrength=ti_result.free.highest_peak_hight;
dominant_frequency_found= ti_result.free.highest_peak_frequency;


peaks=ti_result.peaks;
if length(peaks)>1
% 	for ii=1:length(peaks)
	for ii=1:1
		fre=1/peaks{ii}.t;
		yval=peaks{ii}.y;
% 		ps=peaks{ii}.pitchstrength;
		ps=peaks{ii}.y;
		if ii==1
			plot(fre,yval,'Marker','o','Markerfacecolor','b','MarkeredgeColor','b','MarkerSize',10);
			text(fre,yval*1.03,sprintf('%3.0f Hz: %4.2f ',fre,ps),'VerticalAlignment','bottom','HorizontalAlignment','center','color','b','Fontsize',6);
		else
			plot(fre,yval,'Marker','o','Markerfacecolor','g','MarkeredgeColor','w','MarkerSize',5);
			text(fre,yval*1.05,sprintf('%3.0f Hz: %4.2f ',fre,ps),'VerticalAlignment','bottom','HorizontalAlignment','center','color','g','Fontsize',8);
		end
		y=peaks{ii}.y;
		ypeak=peaks{ii}.peak_base_height_y;
		
		fre_left=x2fre(ti_result.smoothed_signal,peaks{ii}.where_widths(1));
		fre_right=x2fre(ti_result.smoothed_signal,peaks{ii}.where_widths(2));
		
		line([fre fre],[y ypeak],'color','m');
		line([fre_left fre_right],[ypeak ypeak],'color','m');
	end
end

if target_frequency>0 % search only at one special frequency
	found_fre=ti_result.fixed.highest_peak_frequency;
	if found_fre>0
		yval=gettimevalue(smoothed_signal,1/found_fre);
	else 
		yval=0;
	end
	plot(found_fre,yval,'Marker','o','Markerfacecolor','y','MarkeredgeColor','w','MarkerSize',5);
	
	found_ps=ti_result.fixed.highest_peak_hight;
	plot(found_fre,yval,'Marker','o','Markerfacecolor','g','MarkeredgeColor','w','MarkerSize',10);
	text(found_fre/1.1,yval*1.01, ['Pitchstrength at fixed ' num2str(round(found_fre)) 'Hz: ' num2str(fround(found_ps,2)) ],'VerticalAlignment','bottom','HorizontalAlignment','right','color','g','Fontsize',12);
	bordery=get(gca,'Ylim');
	line([target_frequency target_frequency],[bordery(1) bordery(2)],'color','g')
    min_fre=target_frequency/options.allowed_frequency_deviation;
    max_fre=target_frequency*options.allowed_frequency_deviation;
	line([min_fre min_fre],[bordery(1) bordery(2)],'color','g')
	line([max_fre max_fre],[bordery(1) bordery(2)],'color','g')
end

% maxy=sai{end}.ti_resultlt.peaks{1}.y;
maxy=max(int_sum);
set(gca,'Ylim',[0,maxy*1.1]);


% plot the frequency profile

%Plot both profiles into one figure
% FQP
fqp = getvalues(fq_sum)';
% fqp = fqp /1000;
plot(sai{frame_number}.channel_center_fq, fqp,'r');

peaks=f_result.peaks;
if length(peaks)>1
% 	for ii=1:length(peaks)
	for ii=1:1
		fre=1/peaks{ii}.t;
		yval=peaks{ii}.y;
% 		ps=peaks{ii}.pitchstrength;
		ps=peaks{ii}.y;
		if ii==1
			plot(fre,yval,'Marker','o','Markerfacecolor','r','MarkeredgeColor','r','MarkerSize',10);
			text(fre,yval*1.03,sprintf('%3.0f Hz: %4.2f ',fre,ps),'VerticalAlignment','bottom','HorizontalAlignment','center','color','r','Fontsize',6);
		else
			plot(fre,yval,'Marker','o','Markerfacecolor','g','MarkeredgeColor','w','MarkerSize',5);
			text(fre,yval*1.03,sprintf('%3.0f Hz: %4.2f ',fre,ps),'VerticalAlignment','bottom','HorizontalAlignment','center','color','g','Fontsize',8);
		end
	end
end
hold off


return

function fre=x2fre(sig,x)
	t_log = bin2time(sig,x);
	t=f2f(t_log,0,0.035,0.001,0.035,'linlog');
	fre=1/t;
