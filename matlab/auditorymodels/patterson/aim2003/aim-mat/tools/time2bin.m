% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/01/17 16:57:45 $
% $Revision: 1.3 $

function res=time2bin(time,samplerate)
% gibt das Bin zur�ck, bei dem diese Zeit w�re
% Zeit immer in Sekunden
% Samplerate immer in Bins pro Sekunde (96 kHz)

res=time*samplerate;

res=round(res); % rundungsfehler!!!