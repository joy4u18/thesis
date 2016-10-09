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
% $Date: 2003/01/17 16:57:44 $
% $Revision: 1.3 $

function ampscale=filterbandamp(fre,amp,fc,df1,bw,df2)
% usage: ampscale=filterbandamp(fre,amp,fc,df1,bw,df2)
% given a frequency and its associated amplitude, and the defining properties of
% a bandpass filter (cf. Krumbholz et al (2000), JASA 108, 1170-1180, Fig.3)
% this function returns the amplitude of the frequency component after it has
% passed through the filter. The reurned amplitude should be used to SCALE the
% amplitude of the given frequency component.
% fre       frequency in Hz
% amp       amplitude 
% fc        lower cutoff frequency
% df1       lower spectral ramp width
% bw        bandwidth (of plateau)
% df2       upper spectral ramp
%
% David Smith (16/05/02)

if (fre<(fc-df1)) | (fre>(fc+bw+df2))
    ampscale=0; %ignore everything outside passband
elseif fre<=fc  %lower spectral ramp
    ampscale=max(cos((fc-fre)*pi/(2*df1)),0);   %quarter-cycle of cosine function
elseif fre<=fc+bw    %flat part of filter
    ampscale=1; 
else        %upper spectral ramp
    ampscale=max(cos((fre-(fc+bw))*pi/(2*df2)),0);
end