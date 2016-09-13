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
% $Date: 2003/01/17 16:57:43 $
% $Revision: 1.3 $

function [t,h]=getlocalmaxima(sig)
% returns the height and the locations of all local maxima in the signal

[maxpos,minpos,maxs,mins]=getminmax(sig);

h=maxs;
t=maxpos;
