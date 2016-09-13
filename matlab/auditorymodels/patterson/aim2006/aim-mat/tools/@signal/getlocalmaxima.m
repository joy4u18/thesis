% method of class @signal
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function [t,h]=getlocalmaxima(sig)
% returns the height and the locations of all local maxima in the signal

[maxpos,minpos,maxs,mins]=getminmax(sig);

h=maxs;
t=maxpos;
