% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003-2008, University of Cambridge, Medical Research Council 
% Maintained by Tom Walters (tcw24@cam.ac.uk), written by Stefan Bleeck (stefan@bleeck.de)
% http://www.pdn.cam.ac.uk/cnbh/aim2006
% $Date: 2008-06-10 18:00:16 +0100 (Tue, 10 Jun 2008) $
% $Revision: 585 $

function combi=slidereditcontrol_set_rawslidervalue(combi,value)
% set the slider value e.g. by using the slider
% a slidereditcontrol consists of a slider and an edit object, that are 
% related. When one value changes, the other also changes.
% The combination has the following variables:
% sliderhandle - the handle of the slider control
% edithandle - the handle of the edit control
% minvalue - the minimum value allowed
% maxvalue - the maximum allowed value
% (current_value - the current value)
% is_log - whether the slider reponds logarithmically
% editscaler - a number, that is multiplied to the edit control (to make ms of secs)
% nreditdigits - the number of digits in the edit control

% the slider gets the raw value back:
set(combi.sliderhandle,'Value',value);

% the real value must be translated
if combi.is_log==1
	realval=f2f(value,0,1,combi.minvalue,combi.maxvalue,'linlog');
else
	realval=f2f(value,0,1,combi.minvalue,combi.maxvalue,'linlin');
end
realval=max(realval,combi.minvalue);
realval=min(realval,combi.maxvalue);

editval=realval*combi.editscaler;
editval=fround(editval,combi.nreditdigits);
set(combi.edithandle,'String',num2str(editval));

combi.current_value=realval;