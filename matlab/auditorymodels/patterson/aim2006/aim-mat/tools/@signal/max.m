% method of class @signal
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function [m,x]=max(sig)
% returns the maximum value of the signal

val=getdata(sig);
[m,x]=max(val);
x=bin2time(sig,x-1);
