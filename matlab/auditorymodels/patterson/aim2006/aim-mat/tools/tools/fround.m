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

function num=fround(num,nr)
% usage: num=round(num,nr)
% rounds the number num to nr relevant decimal places

ex=10^nr;

num=round(num*ex)/ex;