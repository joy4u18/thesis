% method of class @signal
% function sig=expand(sig,newlength,[value])
%
% makes the signal longer (or shorter) by appending values with the value value
% if time is negative, then expand it to the front by filling the first time with value
%
%   INPUT VALUES:
%       sig: original @signal
%       newlength: the new length of the signal
%       value: value, with wich the new part is filled [0]
% 
%   RETURN VALUE:
%       time: time, when signal is bigger 0 for first time
%
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/01/17 16:57:42 $
% $Revision: 1.3 $

function sig=expand(a,newlength,value)

lenalt=getlength(a);
sig=a; % erst mal eine Kopie des Signals
sr=getsr(a);
if newlength < 0 % aha, l�nger machen mit vorne auff�llen
    lenneu=lenalt-newlength;    % denn die newlength ist ja negativ
    temp=a.werte;

    start=time2bin(a,-newlength);
    stop=time2bin(a,lenneu);
    
    neuevals=ones(1,stop)*value;% erst alle mit den gew�nschten Werten belegen
    bla=time2bin(a,lenalt);
    neuevals(start+1:stop)=temp(1:bla); % dann mit dem alten Signal �berschreiben

    sig.werte(1:stop)=neuevals(1:stop);
    
else % positive neue L�nge
    if lenalt>=newlength    %nothing to do
        return;
    end
    start=time2bin(a,lenalt);
    stop=time2bin(a,newlength);
    sig.werte(start:stop)=value;
end

 