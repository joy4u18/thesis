% method of class @frame
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/06/27 16:05:26 $
% $Revision: 1.16 $

function handlestr=plot(current_frame,options,ax)


if nargin < 3
    ax=gca;
end
if nargin < 2
    options=[];
end

% options.plotstyle='surf';

% extra options from aimmodules?
if isfield(options,'extra_options');
	has_extra_options=1;	% in this case, jump at the end to a fucntion that makes colors
else
	has_extra_options=0;	% no extras in colors
end	

% weather of not the plotting is linear
if ~isfield(options,'is_log');
    is_log=0;
else
    is_log=options.is_log;
end

% the viewpoint in azimuth and elevation look help for view!
if ~isfield(options,'viewpoint');
    viewpoint=[0 90];
else
    viewpoint=options.viewpoint;
end

% which plot type, usually: waterfall, other: surf
if ~isfield(options,'plotstyle');
    plotstyle='waterfall';
else
    plotstyle=options.plotstyle;
end

% if waterfall, the plotcolor can be more complicated
if ~isfield(options,'plotcolor');
    has_specified_color=0;
else
    plotcolor=options.plotcolor;
    has_specified_color=1;
end

% if positive time is to the right or to the left
if isfield(options,'time_reversed');
    time_reversed=options.time_reversed;
else
    time_reversed=0;
end

% for compatibility.
if isfield(options,'minimum_time');
	options.minimum_time_interval=options.minimum_time;
end
if isfield(options,'maximum_time');
	options.maximum_time_interval=options.maximum_time;
end
if ~isfield(options,'minimum_time_interval');
    if is_log
        minimum_time_interval=0.001;
    else
        minimum_time_interval=getminimumtime(current_frame);
    end
else
    minimum_time_interval=options.minimum_time_interval;
end


if ~isfield(options,'maximum_time_interval');
%     maximum_time_interval=0.035;
    maximum_time_interval=getmaximumtime(current_frame);
else
    maximum_time_interval=options.maximum_time_interval;
end


if ~isfield(options,'has_x_axis');
    has_x_axis=1;
else
    has_x_axis=options.has_x_axis;
end

if ~isfield(options,'has_y_axis');
    has_y_axis=1;
else
    has_y_axis=options.has_y_axis;
end



current_frame_values=getvalues(current_frame);
nr_channels=getnrchannels(current_frame);
sr=getsr(current_frame);

% prevent a matlab plotting-bug for empty matrices
if max(max(current_frame_values))==0 && min(min(current_frame_values)) == 0       
    current_frame_values(1,400)=0.001;    
end

% length=getlength(current_frame);
start_time=getminimumtime(current_frame);

if start_time < 0 % these are frames read in from ams! they start with negative times. Therefore we turn around the start and stoptime
% 	temp=-maximum_time_interval;
% 	maximum_time_interval=-minimum_time_interval;
% 	minimum_time_interval=temp;
% 	time_reversed=1-time_reversed;
%  	current_frame=reverse(current_frame);
% % 	max_time=getmaximumtime(current_frame);
% 	fr=getpart(current_frame,start_time,0);
% 	start_time=0;
% 	current_frame=setstarttime(current_frame,0);
end

if is_log
    min_x_screen=1; % im logarithmischen Fall muss ich die ersten Punkte mitnehmen, damit ich sie plotten kann!
    max_x_screen=round(abs((maximum_time_interval-start_time)*sr)); % thats the first point we want to see on the screen
else
    min_x_screen=round(abs((minimum_time_interval-start_time+1/sr)*sr)); % thats the first point we want to see on the screen
    max_x_screen=round(abs((maximum_time_interval-start_time)*sr)); % thats the first point we want to see on the screen
end

if max_x_screen>getnrpoints(current_frame)
    max_x_screen=getnrpoints(current_frame);
    maximum_time_interval=(max_x_screen/sr)+start_time;
end

step=1;
if isequal(plotstyle,'surf')
    step=1;
elseif isequal(plotstyle,'waterfall')
    oldunit2=get(ax,'Units');
    set(ax,'Units','Pixel');
    pos=get(ax,'Position');
    breite=pos(3)/2;
    step=round((max_x_screen-min_x_screen)/breite);
    % step=1;
    if step<1 || nr_channels==1
        step=1;
    end
    set(ax,'Units',oldunit2);
    
    if min_x_screen>2
        current_frame_values(:,1:min_x_screen-1)=0;
    end
end


cvals=current_frame_values(:,min_x_screen:step:max_x_screen);
if nr_channels==1
	handle=plot(ax,cvals);
	ylabel('');
	%     set(ax,'YTick',[]);
else
	if strcmp(plotstyle,'surf')
% 		handle=surf(ax,cvals,'LineStyle','none');
		handle=surf(ax,cvals,'LineStyle','none');
%     	view(ax,viewpoint);
    	view(ax,[0 90]);
	else
		handle=waterfall(ax,cvals);    % do the plotting!
		% this is a very important trick: If we plot it from directly above ([0 80])
		% then white lines appear on the screen. To get rid of them, we have to
		% tilt the waterfall just marginally:
% 		if min(min(cvals))<0
% 			view(ax,[viewpoint(1)-0.01 viewpoint(2)]);
% 		else
    	view(ax,[-0.01 80]);
% 			view(ax,viewpoint);
% 		end	
	end
	grid off;
end

if time_reversed
    set(ax,'XDir','reverse')   % turn them around, because the higher values shell end on the right
else
    set(ax,'XDir','normal')   % normale ausrichtung
end        
if is_log
    min_x_screen=round(abs((minimum_time_interval-start_time+1/sr)*sr)); % thats the first point we want to see on the screen
	if nr_channels==1
        set(ax,'xlim',[min_x_screen max_x_screen ])
        set(ax,'ylim',[0 1])
%         axis([ 0 1]);
    else
        if max_x_screen == min_x_screen 
           max_x_screen = min_x_screen  +1;
        end
        set(ax,'xlim',[min_x_screen max_x_screen])
        set(ax,'ylim',[1 nr_channels])
        set(ax,'zlim',[0 50])
        
%         axis([ min_x_screen max_x_screen 1 nr_channels 0 50]);
    end
    set(ax,'XScale','log')
    t=minimum_time_interval;
    ti=[t 2*t 4*t 8*t 16*t 32*t 64*t];
    tix=(ti)*sr;  % there shell be the tix
%     tix(1)=tix(1)+1;
    ti=(ti*1000);
    ti=fround(ti,2);
else % its not logarithmic!
    set(ax,'XScale','linear')
    nrx=size(cvals,2);
    if nr_channels==1
        miny=min(cvals);
        maxy=max(cvals);
        set(ax,'xlim',[1 nrx])
        set(ax,'ylim',[miny*1.3 maxy*1.3])
%         axis([ 1 nrx miny*1.3 maxy*1.3]);
    else
        set(ax,'xlim',[1 nrx])
        set(ax,'ylim',[1 nr_channels ])
        set(ax,'zlim',[0 1])
        
%         axis([ 1 nrx 1 nr_channels 0 1]);
    end
    nr_labels=8;
    tix=1:(nrx-1)/nr_labels:nrx;
    xstep=(maximum_time_interval-minimum_time_interval)*1000/(nr_labels);   %works from -35 to 5
    ti=([minimum_time_interval*1000:xstep:maximum_time_interval*1000+1]);
    ti=fround(ti,1);
    %     text(min_x_screen*1.5,-scale_summe/5,'Time (ms)');    % this is at a nice position
end

if has_x_axis
    if max(tix)>1
        set(ax,'XTick',tix);
        set(ax,'XTickLabel',ti);
    end
else
    set(ax,'xtick',[]); % we dont want any z-Ticks!
end % axis    

if has_y_axis && nr_channels>1
    % make y-Ticks
    nr_labels=8;
    ystep=(nr_channels-1)/(nr_labels-1);
    tiy=1:ystep:nr_channels;
    ti=(current_frame.centerfrequencies(floor(tiy))/1000);
    ti=round(ti*10)/10;
    set(ax,'YTick',tiy);
    set(ax,'YTickLabel',ti);
    
%     if has_x_axis
%         if is_log
%             text(min_x_screen*1.9,-2,current_frame.x_axis_label);    % this is at a nice position
%         else
%             text(120,-2,current_frame.x_axis_label);    % this is at a nice position
%         end    
%     end
elseif nr_channels>1
    set(ax,'ytick',[]); % we dont want any z-Ticks!
end

set(ax,'ztick',[]); % we dont want any z-Ticks!


if strcmp(plotstyle,'surf')
	% which colormap should be used in case of a surf-plot
	if ~isfield(options,'colormap');
		clrmap=zeros(64,3);
	else
		clrmap=options.colormap;
	end
	
	% shift the colormap
	
	% set the chosen colormap
	colormap(clrmap);
	% set the color limits so that it shows all colors
	set(ax,'CLimMode','manual');
	
	colmin=0;
	colmax=max(max(cvals));
	diff=colmax-colmin;
	
% 	if ~isfield(options,'shiftcolormap');
% 		shiftcolormap=0.8;
% 	else
% 		shiftcolormap=options.shiftcolormap;
% 	end
% 	colmin=colmax-2*shiftcolormap*diff;
% 	if colmax==colmin
% 		colmax=colmin+0.001;
% 	end
	
% 	set(ax,'CLim',[colmin colmax]);
	
% 	% colorbar is 1:256
% 	% actual spectrogram dynamic range is orig_dr
% 	% new spectrogram dynamic range is new_dr
% 	orig_dr = clrmap;
% 	diff_dr = new_dr - orig_dr;
% 	cmapIndices_per_dB = 256./diff(orig_dr);  % a constant
% 	diff_clim = diff_dr .* cmapIndices_per_dB;
% 	cbar_clim = [1 256] + diff_clim;
% % 	set(himage_cbar,'cdatamapping','scaled');  % do during creation
% 	set(ax,'clim',cbar_clim);
	
	
	
% 	view(ax,viewpoint);
	
    % fancy graphics, takes time
%     shading interp
% 	if isfield(options,'camlight');
% 		% can be 'left','right' or a vector of [az el]
% 		if isnumeric(options.camlight)
% 			for i=1:size(options.camlight,1)
% 				eval(sprintf('lightangle(%f,%f);',options.camlight(i,1),options.camlight(i,2)));
% 			end
% 		else
% 			eval(sprintf('camlight(''%s'',''infinite'');',options.camlight));
% 		end
% 	end
% 	
% 	material default % looks best other options: dull, metal, shiny
% 	
% 	% 
% 	if isfield(options,'lighting');
% 		eval(sprintf('lighting %s',options.lighting));
% 	end

	% wheather or not there should be a colorbar
	% can be 'off', 'vertical, 'horizontal'
	if isfield(options,'colorbar');
		if ~strcmp(options.colorbar,'off')
			colorbar(options.colorbar);
		end
	end
	
else % boring waterfall plot
	if has_specified_color==1
		if plotcolor=='k'
			clrmap(:,:)=0;
		elseif plotcolor=='r'
			clrmap(:,1)=0;
		elseif plotcolor=='c'
			clrmap(:,2)=0;
		elseif plotcolor=='g'
			clrmap(:,3)=0;
		end
	else
		% if nothing is set, then set everything is set to black
		clrmap=white;
		clrmap(:,:)=0;
		colormap(clrmap);
	end
end


% if is_log
% 	x=300;y=nr_channels*1.1;
% else
%     x=300;y=nr_channels*1.1;
% end
% text(x,y,current_frame.text);    % this is at a nice position

% if isfield(options,'display_time')
% 	if options.display_time==1
% 		time=getcurrentframestarttime(current_frame);
% 		time=fround(time*1000,0);
% 		str=num2str(time);
% 		text(x,y,[str ' ms']);    % this is at a nice position
% 	end
% end

if has_extra_options==1;	% in this case, jump at the end to a fucntion that makes colors

% 	cool_frame_plot_colors(current_frame,handle,options.extra_options);

end

% set(ax,'XDir',olddir)
% set(ax,'XScale',oldscale);

if nargout==1
    handlestr=handle;
end
