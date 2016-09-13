% method of class @signal
% savewave(sig,name[,ramp])
%   INPUT VALUES:
%  		name : name of the resulting sound file
% 		ramp: if given, then the signal is ramped with a linear ramp with
% 		that duration
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/06/11 10:27:46 $
% $Revision: 1.6 $

function savewave(sig,name,ramp)
% does some things, to make a nice sound out of it

if nargin < 3
    ramp=0.0;	% default ramp is off
end
if nargin < 2
    name='just saved';
end



sig=rampamplitude(sig,ramp);
sig=scaletomaxvalue(sig,0.999);
if isempty(strfind(name,'.wav'))
    name=sprintf('%s.wav',name);
end

if fopen(name,'w')==-1
	disp(sprintf('can''t write file ''%s'', is file open in CoolEdit? If so please close!',name));
	error('file open in CoolEdit... Cant write');
else
	writetowavefile(sig,name);
end
