% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function sig=generatefromspiketrain(sig,st)

vals=zeros(size(getvalues(sig)));
times=time2bin(sig,st);

maxval=length(vals);
selecttimes=times(find(times>0 & times<maxval));
% sig=addtimevalue(sig,selecttimes,1);
vals(round(selecttimes))=vals(round(selecttimes))+1;

sig=setvalues(sig,vals);
