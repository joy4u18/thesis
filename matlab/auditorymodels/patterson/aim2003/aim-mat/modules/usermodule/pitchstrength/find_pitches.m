% function [pitchstrength, dominant_time] = find_pitches(profile, , a_priori, fqp_fq)
%
%   To analyse the time interval profile of the auditory image
%
%   INPUT VALUES:
%  
%   RETURN VALUE:
%

% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/07/17 10:56:16 $
% $Revision: 1.5 $
function result = find_pitches(profile,options)
% different ways to define the pitch strength:
% 1: the absolute height of the highest peak
% 2: the ration of the highest peak divided by the width at a certain point (given
%     by the parameter height_to_width_ratio
% 3: the height of the highest peak divided by the hight of the peak just one to 
%     the right. This measurement is very successfull in the ramped/damped stimuli
% 
% 4: Further we want to know all these values at a fixed point called target_frequency
%     and in the range given by allowed_frequency_deviation in %
%     
% 5: We are also interested in the frequency value of the highest peak, because
%     we hope, that this is finally the pitch.
%     
% 6: for the dual profile model, we also give back two more values concerning similar
%     properties for the spectral profile. Here, the pitch strenght is defined as the 
%     height of the highest peak divided by the range that is given in two parameters 
%     (usually 20% to 80% of the maximum)


plot_switch =0;

if nargin < 2
    options=[];
end
% 

% peaks must be higher then this of the maximum to be recognised
ps_threshold=0.1;   
height_width_ratio=options.ps_options.height_width_ratio;	% height of peak, where the width is measured


% preliminary return values.
% height of the highest peak
result.free.highest_peak_hight=0;
result.free.highest_peak_frequency=0;
% hight to width ratio
result.free.height_width_ratio=0;
% highest peak divided by next highest
result.free.neigbouring_ratio=0;

% now all these at a fixed frequency:
result.fixed.highest_peak_hight=0;
result.fixed.highest_peak_frequency=0;
result.fixed.height_width_ratio=0;
result.fixed.neigbouring_ratio=0;

% other things useful for plotting
result.smoothed_signal=[];
result.peaks = [];


% now start the show

% change the scaling to logarithm, before doing anything else:
log_profile=logsigx(profile,0.001,0.035);
result.smoothed_signal=log_profile;

current_lowpass_frequency=options.ps_options.low_pass_frequency;
smooth_sig=lowpass(log_profile,current_lowpass_frequency);
envpeaks = PeakPicker(smooth_sig);

if isempty(envpeaks) % only, when there is no signal
    return
end

% translate times back to times:
for i=1:length(envpeaks) % construct all maxima
    envpeaks{i}.t=1/x2fre(smooth_sig,envpeaks{i}.x);
end


% nr1: highest peak value
% find the highest peak and its frequency
% sort all for the highest first!
sortenvpeaks=sortstruct(envpeaks,'y');
result.free.highest_peak_frequency=1/sortenvpeaks{1}.t;
result.free.highest_peak_hight=sortenvpeaks{1}.y;


% nr 2: height to width of highest peak
for i=1:length(sortenvpeaks) % construct all maxima
    where=bin2time(smooth_sig,sortenvpeaks{i}.x);
    [dummy,height,breit,where_widths]=qvalue(smooth_sig,where,height_width_ratio);
    width=time2bin(smooth_sig,breit);
    if width>0
        sortenvpeaks{i}.height_width_ratio=height/width;
    else
        sortenvpeaks{i}.height_width_ratio=0;
    end
    sortenvpeaks{i}.width=width;
    sortenvpeaks{i}.where_widths=where_widths;
    sortenvpeaks{i}.peak_base_height_y=height*(1-height_width_ratio);
end
% and return the results
result.free.height_width_ratio=sortenvpeaks{1}.height_width_ratio;


% nr 3: height of highest / right neigbour (right when time is towards
% left, sorry)
for i=1:length(sortenvpeaks) % construct all maxima
    left=sortenvpeaks{i}.left;
    if isfield(left,'y') && left.y>0
        sortenvpeaks{i}.neigbouring_ratio=result.free.highest_peak_hight/left.y;
    else
        sortenvpeaks{i}.neigbouring_ratio=0;
    end
end
result.free.neigbouring_ratio=sortenvpeaks{1}.neigbouring_ratio;


target_frequency=options.ps_options.target_frequency;
% now find all values for the fixed pitch strengh in target_frequency
if target_frequency>0 % only, when wanted
    min_fre=target_frequency/options.ps_options.allowed_frequency_deviation;
    max_fre=target_frequency*options.ps_options.allowed_frequency_deviation;
    
    for i=1:length(sortenvpeaks) % look through all peaks, which one we need
        fre_peak=1/sortenvpeaks{i}.t;
        if fre_peak > min_fre && fre_peak < max_fre
            % we assume for the moment, that we only have one allowed here
            % nr 1: height
            result.fixed.highest_peak_frequency=fre_peak;
            result.fixed.highest_peak_hight=sortenvpeaks{i}.y;
            result.fixed.height_width_ratio=sortenvpeaks{i}.height_width_ratio;
            result.fixed.neigbouring_ratio=sortenvpeaks{i}.neigbouring_ratio;
        end
    end
end

result.peaks =sortenvpeaks;


if plot_switch
    figure(2134)
    clf
    hold on
    plot(log_profile,'b')
    plot(smooth_sig,'g')
    for i=1:length(sortenvpeaks)
        time=sortenvpeaks{i}.t;
        x=sortenvpeaks{i}.x;
        y=sortenvpeaks{i}.y;
        plot(x,y,'Marker','o','Markerfacecolor','g','MarkeredgeColor','g','MarkerSize',2);
        time_left=sortenvpeaks{i}.left.t;
        x_left=sortenvpeaks{i}.left.x;
        y_left=sortenvpeaks{i}.left.y;
        time_right=sortenvpeaks{i}.right.t;
        x_right=sortenvpeaks{i}.right.x;
        y_right=sortenvpeaks{i}.right.y;
        plot(x_left,y_left,'Marker','o','Markerfacecolor','r','MarkeredgeColor','r','MarkerSize',2);
        plot(x_right,y_right,'Marker','o','Markerfacecolor','r','MarkeredgeColor','r','MarkerSize',2);
    end
    current_time=options.current_time*1000;
    y=get(gca,'ylim');
    y=y(2);
    text(700,y,sprintf('%3.0f ms',current_time),'verticalalignment','top');
    
    for i=1:length(sortenvpeaks)
        height_width_ratio=sortenvpeaks{i}.height_width_ratio;
        if i <4
            line([sortenvpeaks{i}.x sortenvpeaks{i}.x],[sortenvpeaks{i}.y sortenvpeaks{i}.y*(1-height_width_ratio)],'Color','r');
            line([sortenvpeaks{i}.where_widths(1) sortenvpeaks{i}.where_widths(2)],[sortenvpeaks{i}.y*(1-height_width_ratio) sortenvpeaks{i}.y*(1-height_width_ratio)],'Color','r');
            x=sortenvpeaks{i}.x;
            fre=1/sortenvpeaks{i}.t;
            y=sortenvpeaks{i}.y;
            text(x,y*1.05,sprintf('%3.0fHz: %2.2f',fre,height_width_ratio),'HorizontalAlignment','center');
        end
    end
end


return





% kucke, ob sich das erste Maxima �berlappt. Falls ja, nochmal
% berechnen mit niedriger Lowpass frequenz
% nr_peaks=length(envpeaks);
% 	if 	nr_peaks==1
% 		peak_found=1;
% 		continue
% 	end
% 	xleft=envpeaks{1}.where_widths(1);
% 	xright=envpeaks{1}.where_widths(2);
% 	for i=2:nr_peaks %
% 		xnull=envpeaks{i}.x;
% 		if xnull < xleft  && xnull > xright
% 			peak_found=0;
% 			current_lowpass_frequency=current_lowpass_frequency/2;
% 			if current_lowpass_frequency<62.5
% 				return
% 			end
% 			break
% 		end
% 		% wenn noch hier, dann ist alles ok
% 		peak_found=1;
% 	end
% end


% reduce the peaks to the relevant ones:
% through out all with pitchstrength smaller then threshold
% count=1;
% min_ps=ps_threshold*envpeaks{1}.pitchstrength;
% for i=1:length(envpeaks)
%     if envpeaks{i}.pitchstrength>min_ps
%         rpeaks{count}=envpeaks{i};
%         count=count+1;
%     end
% end


% % final result for the full set
% result.final_pitchstrength=rpeaks{1}.pitchstrength;
% result.final_dominant_frequency=rpeaks{1}.fre;
% result.final_dominant_time=rpeaks{1}.t;
% result.smoothed_signal=smooth_sig;
% result.peaks=rpeaks;
% % return

% Neuberechnung der Pitchstrength f�r peaks, die das Kriterium der 
% H�he zu Breite nicht erf�llen
for i=1:length(rpeaks) % construct all maxima
    where=bin2time(smooth_sig,rpeaks{i}.x);
    [dummy,height,breit,where_widths]=qvalue(smooth_sig,where,heighttowidthminimum);
    width=time2bin(smooth_sig,breit);
    
    xleft=where_widths(2);
    xright=where_widths(1);
    left_peak=rpeaks{i}.left;
    right_peak=rpeaks{i}.right;
    
    
    xnull=rpeaks{i}.x;
    if xleft<left_peak.x || xright>right_peak.x
        t_xnull=bin2time(smooth_sig,xnull);
        [val,height,breit,widthvals,base_peak_y]=qvalue2(smooth_sig,t_xnull);
        width=time2bin(smooth_sig,breit);
        if width>0
            rpeaks{i}.pitchstrength=height/width;
        else
            rpeaks{i}.pitchstrength=0;
        end
        rpeaks{i}.where_widths=time2bin(smooth_sig,widthvals);
        rpeaks{i}.width=width;
        rpeaks{i}.peak_base_height_y=base_peak_y;
    end
end

% sort again all for the highest first!
% rpeaks=sortstruct(rpeaks,'pitchstrength');

return








%%%%%%  look for octave relationships
% 
% 
for i=1:length(rpeaks) % construct all maxima
    % look, if the octave of the pitch is also present.
    fre=rpeaks{i}.fre;
    has_octave=0;
    for j=1:length(rpeaks)
        oct_fre=rpeaks{j}.fre;
        % is the octave there?
        if oct_fre > (2-octave_variability)*fre && oct_fre < (2+octave_variability)*fre
            rpeaks{i}.has_octave=oct_fre;
            rpeaks{i}.octave_peak_nr=j;
            
            % add the pss
            % 			rpeaks{j}.pitchstrength=rpeaks{i}.pitchstrength+rpeaks{j}.pitchstrength;
            
            ps_real=rpeaks{j}.pitchstrength;
            ps_oct=rpeaks{i}.pitchstrength;
            hight_oct=rpeaks{j}.y;
            hight_real=rpeaks{i}.y;
            
            % 			if ps_oct>ps_real && hight_oct > hight_real
            % 				rpeaks{i}.pitchstrength=ps_real-1;	% artificially drop down
            % 			end
            
            has_octave=1;
            break
        end
        if ~has_octave
            rpeaks{i}.has_octave=0;
            rpeaks{i}.octave_peak_nr=0;
        end
    end
end

if plot_switch
    figure(2134)
    clf
    hold on
    plot(log_profile,'b')
    plot(smooth_sig,'g')
    for i=1:length(rpeaks)
        time=rpeaks{i}.t;
        x=rpeaks{i}.x;
        y=rpeaks{i}.y;
        plot(x,y,'Marker','o','Markerfacecolor','g','MarkeredgeColor','g','MarkerSize',2);
        time_left=rpeaks{i}.left.t;
        x_left=rpeaks{i}.left.x;
        y_left=rpeaks{i}.left.y;
        time_right=rpeaks{i}.right.t;
        x_right=rpeaks{i}.right.x;
        y_right=rpeaks{i}.right.y;
        plot(x_left,y_left,'Marker','o','Markerfacecolor','r','MarkeredgeColor','r','MarkerSize',2);
        plot(x_right,y_right,'Marker','o','Markerfacecolor','r','MarkeredgeColor','r','MarkerSize',2);
    end
    current_time=options.current_time*1000;
    y=get(gca,'ylim');
    y=y(2);
    text(700,y,sprintf('%3.0f ms',current_time),'verticalalignment','top');
    
    for i=1:length(rpeaks)
        pitchstrength=rpeaks{i}.pitchstrength;
        if i <10
            line([rpeaks{i}.x rpeaks{i}.x],[rpeaks{i}.y rpeaks{i}.peak_base_height_y],'Color','m');
            line([rpeaks{i}.where_widths(1) rpeaks{i}.where_widths(2)],[rpeaks{i}.peak_base_height_y rpeaks{i}.peak_base_height_y],'Color','m');
            x=rpeaks{i}.x;
            fre=rpeaks{i}.fre;
            y=rpeaks{i}.y;
            text(x,y*1.05,sprintf('%3.0fHz: %2.2f',fre,pitchstrength),'HorizontalAlignment','center');
        end
    end
end
if plot_switch==1
    for i=1:length(rpeaks)
        x=rpeaks{i}.x;
        y=rpeaks{i}.y;
        plot(x,y,'Marker','o','Markerfacecolor','g','MarkeredgeColor','g','MarkerSize',6);
        
        % plot the octaves as green lines
        octave=rpeaks{i}.has_octave;
        fre=rpeaks{i}.fre;
        if octave>0
            oct_nr=rpeaks{i}.octave_peak_nr;
            oct_fre=rpeaks{oct_nr}.fre;
            
            x=rpeaks{i}.x;
            oct_x=rpeaks{oct_nr}.x;
            y=rpeaks{i}.y;
            oct_y=rpeaks{oct_nr}.y;
            line([x oct_x],[y oct_y],'Color','g','LineStyle','--');
        end
    end
end

% rpeaks=sortstruct(rpeaks,'pitchstrength');
rpeaks=sortstruct(rpeaks,'y');

% final result for the full set
result.final_pitchstrength=rpeaks{1}.pitchstrength;
result.final_dominant_frequency=rpeaks{1}.fre;
result.final_dominant_time=rpeaks{1}.t;
result.smoothed_signal=smooth_sig;
result.peaks=rpeaks;




function fre=x2fre(sig,x)
t_log = bin2time(sig,x);
t=f2f(t_log,0,0.035,0.001,0.035,'linlog');
fre=1/t;
