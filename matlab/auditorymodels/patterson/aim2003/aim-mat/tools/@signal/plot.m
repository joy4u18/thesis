% method of class @signal
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/06/11 10:45:20 $
% $Revision: 1.10 $

function rethandle=plot(sig,border,stil)
% usage: handle=plot(sig,border,stil)
% plots the class signal. This plot works a little bit different from usual.
% Parameter can either be: plot(signal,stil) or plot(signal,border) or plot(signal,border,stil)
% the border can consist of times and y-value or only the times that should be plotted (in seconeds!)

if nargin<3
    stil='b-';
end

sr=getsr(sig);
durationbin=size(sig.werte,1);
duration=durationbin/sr;
if nargin<2
    t1=1;
    t2=durationbin;
    border=[t1 t2 min(sig.werte(t1:t2)) max(sig.werte(t1:t2))];
end

if isstruct(border) || isempty(border)
    options=border;
    t1=1;
    t2=durationbin;
    border=[t1 t2 min(sig.werte(t1:t2)) max(sig.werte(t1:t2))];
else
    options=[];
    if ischar(border)
        stil=border;
        t1=1;
        t2=durationbin;
        border=[t1 t2 min(sig.werte(t1:t2)) max(sig.werte(t1:t2))];
    else
        if nargin <2
            t1=1;
            t2=durationbin;
            border=[t1 t2 min(sig.werte(t1:t2)) max(sig.werte(t1:t2))];
        else
            t1=border(1);
            t2=border(2);
            x1=time2bin(sig,t1);
            x2=time2bin(sig,t2);
            nr=size(border,2);
            if nr==2    % wenn nur die x-Werte angegeben werden
                border=[x1 x2 min(sig.werte(x1+1:x2)) max(sig.werte(x1+1:x2))];
            else
                border(1)=x1;
                border(2)=x2;
            end
        end
    end
end

if ~isfield(options,'is_log');
    is_log=0;
else
    is_log=options.is_log;
end

if isfield(options,'minimum_time');
    border(1)=time2bin(sig,options.minimum_time);
    minimum_time=options.minimum_time;
else
    minimum_time=bin2time(sig,border(1));
end

if isfield(options,'maximum_time');
    border(2)=time2bin(sig,options.maximum_time);
    maximum_time=options.maximum_time;
else
    maximum_time=bin2time(sig,border(2));
end


% if the time scale is reversed (time from left to right)
if isfield(options,'time_reversed');
    time_reversed=options.time_reversed;
else
    time_reversed=0;
end

start_time=getminimumtime(sig);

min_x_screen=border(1);   % einer wird abgezogen damit wir bei Null beginnen, nicht beim ersten bin, was bl�de aussieht
max_x_screen=border(2);
minshowy=border(3);
maxy=border(4);

xvals=getxvalues(sig);
% if we are dealing with milliseconds (very often), then the units are in
% ms as well
if strfind(sig.unit_x,'(ms)')>0
    multiplier=1000;
else
    multiplier=1;
end


xvals=xvals.*multiplier;
yvals=getvalues(sig);

% this is the plotting command:
handle=plot(xvals,yvals,stil);

if time_reversed
    set(gca,'XDir','reverse')   % turn them around, because the higher values shell end on the right
else
    set(gca,'XDir','normal')   % normale ausrichtung
end

if is_log
    set(gca,'XScale','log')
    t=minimum_time*multiplier;
    tix=[t 2*t 4*t 8*t 16*t 32*t 64*t 128*t 256*t 512*t 1024*t];
    if ~isempty(sig.x_tick_labels)
        ti=sig.x_tick_labels;
        set(gca,'XTicklabel',ti);
    end
    set(gca,'XTick',tix);
else % its linear
    set(gca,'XScale','linear')
end

miny=border(3);
maxy=border(4);
y=[miny maxy];
if miny==maxy
    maxy=miny+1;
    miny=miny-1;
end
axis([minimum_time*multiplier maximum_time*multiplier miny*1.05 maxy*1.05]);



xlabel(sig.unit_x);
ylabel(sig.unit_y);
title(sig.name,'Interpreter','none');

if nargout==1
    rethandle=handle;
end

return
