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
% $Date: 2003/07/17 10:56:16 $
% $Revision: 1.2 $

function filtered_sig=bandpass(sig,lowfrequency,highfrequency,stopbandwidth_low,stopbandwidth_high,ripple,stopbandatten)
% hack for an phase true bandpassfilter with cutoff at frequency
% used is a ButterworthFilter
% this is all crap, but it does not work properly otherwise. 

grafix=0;

if nargin < 6
    stopbandatten=60; % in dB - how many dB the signal is reduced in the stopband at least
end
if nargin < 5
    ripple=3; % in dB = ripple in the passband
end


% I dont understand enough to make it work with a butterwort filer.
% easy solution: first perform a lowpass, then a highpass filter...
% sorry, Thanks for any help!
if grafix
	figure(23534)
	plot(powerspectrum(sig),[100,getsr(sig)/2],'b')
	hold on
end

filtered_sig_low=lowpass(sig,highfrequency,highfrequency+stopbandwidth_high,ripple,stopbandatten);

if grafix
	figure(23534)
	plot(powerspectrum(filtered_sig_low),[100,getsr(filtered_sig_low)/2],'r')
end


filtered_sig=highpass(filtered_sig_low,lowfrequency,lowfrequency-stopbandwidth_low,ripple,stopbandatten);
if grafix
	figure(23534)
	plot(powerspectrum(filtered_sig),[100,getsr(filtered_sig_low)/2],'g')
end


return


% if nargin < 4
%     ripple=1; % in dB = ripple in the passband
% end
% if nargin <3
%     stopband=frequency*2; % eine Oktave dr�ber
% end

ripple=3;

nyquist=getsr(sig)/2;
% fre_low=2;
% fre_high=frequency;

Wpass=[lowfrequency highfrequency]/nyquist;
Wstop=[lowfrequency-stopbandwidth highfrequency+stopbandwidth]/nyquist;
[n,Wn] = buttord(Wpass,Wstop,ripple,stopbandatten);
% [n,Wn] = buttord(fre_high/nyquist,(fre_high+stopband)/nyquist,ripple,stopbandatten);
% Berechne den IIR-Filter
[b,a] = butter(n,Wn);

% zum testen:
freqz(b,a,128,getsr(sig))

vals=sig.werte';

% fill the part behind the signal and in front of the signal with
% values
% firstval=vals(1);
% lastval=vals(end);
% nr_vals=length(vals);
% vals=[ones(1,nr_vals)*firstval vals ones(1,nr_vals)*lastval];

plot(vals)
hold on

nvals = filter(b,a,vals);
% nvals = filtfilt(b,a,vals);
% extract the values back 
% nvals=nvals(nr_vals+1:2*nr_vals);

plot(nvals,'r')

% filtered_sig=0;
% return

filtered_sig=sig;	% a copy of the old one
newname=sprintf('Bandpass filterd (%3.2fkHz - %3.2fkHz) Signal: %s',lowfrequency/1000,highfrequency/1000,getname(sig));
filtered_sig=setname(filtered_sig,newname);
filtered_sig.werte=nvals';

% figure(235423)
% plot(sig);
% hold on
% plot(filtered_sig,'g');
% s=0;