% method of class @signal
% function sig=generatedampsinus(sig,carfre,modfre,amplitude,halflife)
%   INPUT VALUES:
%       sig: original @signal with length and samplerate
%       carfre: carrier frequency (Hz) [1000]
%       modfre: modulation frequency (Hz) [100]
%       amplitude: [1]
%       halflife: time for the envelope envelope to decrease exponentielly
%       to 1/2
%
%
%   RETURN VALUE:
%       sig:  @signal
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org



function sig=generatedampsinus(sig,carfre,modfre,amplitude,halflife,jitter)
% generates a damped sinusoid, that is a carrier pure tone modulated with a
% exponentially decreasing envelope.
% sig is the signal
% carfre is the carrier frequency of the pure tone
% modfre is the modulation frequency (in Hz)
% amplitude is the final amplitude
% halflife is the time in seconds, in which the envelope drops to its half value
% if halflife is 'gamma', instead a gammaenvelope is used

% jitter is how regular the pulses are (0-1) 1=100%
% if jitter is 'repeat', only one pulse is generated and repeated


if nargin < 6
    jitter=0;
end
if nargin < 5
    halflife=0.01;
end
if nargin < 4
    amplitude=1;
end

if nargin < 3
    modfre=100;
end
if nargin < 2
    carfre=1000;
end




if isequal(halflife,'gamma') &&  isequal(jitter,'repeat')
    % code for Tom's 2010 MSc project
    
    % generate only one period and repeat it n times
    sr=getsr(sig);
    periodlen=1/modfre;
    oneperiod=signal(periodlen,sr);
    
    sinus=generatesinus(oneperiod,carfre,amplitude,0);
    
    % calculate envelope and mult both
    envelope=oneperiod;
    t=[0:1/sr:periodlen-1/sr]*500*(500/getnrpoints(envelope));
    env=power(t,4).*exp(-2*pi*t/2);
    env=env./max(env);
    envelope=setvalues(envelope,env);
    envelope=envelope/max(envelope)*amplitude;
    envelope=setstarttime(envelope,0);
    
    % set the envelope and the amplitude
    oneperiod=sinus*envelope;
    
    % repeat for the right number of repeats
    nr_repeats=round(getlength(sig)/getlength(envelope));
    fsig=oneperiod;
    
    if nr_repeats>1
        for i=1:nr_repeats-1
            fsig=append(fsig,oneperiod);
        end
    end
    
    sig=fsig;
    
    sig=setname(sig,sprintf('damped sinusoid %4.2f kHz, Modulation=%4.1f Hz, gamma envelope',carfre/1000,modfre));
    
    %     figure(1)
    %     plot(env)
    
    return
end


















sinus=generatesinus(sig,carfre,amplitude,0);

% calculate envelope and mult both
envelope=sig;

time_const=halflife/0.69314718;

env_vals=getvalues(envelope);
sr=getsr(envelope);
reprate=1/modfre;


sig_len=getlength(sig);
% when regular, all modulataions are at the same time:
if jitter==0
    pulse_times=0:reprate:sig_len;
else
    nr_pulses=ceil(sig_len/reprate);
    modulation_period=1/modfre;
    pulse_times(1)=0;
    for n = 2:nr_pulses
        jittering=(rand-0.5*jitter)*modulation_period;
        pulse_times(n) = pulse_times(n-1) + modulation_period+jittering;
    end
end



% oldval=0;
% corr=exp(1/sr/time_const);
% t=0;
next_pulse=pulse_times(1);
pulse_counter=1;

% for i=1:getnrpoints(envelope);
%     oldval=oldval/corr;
%     t=t+1/sr;
%     if t>next_pulse
%         oldval=1;
%         pulse_counter=pulse_counter+1;
%         if length(pulse_times)>=pulse_counter
%             next_pulse=pulse_times(pulse_counter);
%         else
%             next_pulse=inf;
%         end
%     end
%     env_vals(i)= oldval;
% end

% onsettimeconstant
%
t=[0:1/sr:reprate-1/sr]*500;
env=power(t,4).*exp(-2*pi*t/2);
env=env./max(env);

% e=linspace(env(length(env)-l),0,l+1);
% env(length(env)-l:end)=e;

%  e=linspace(1,0,l+1);
% env(length(env)-l:end)=env(length(env)-l:end).*e.*e;

t=0;
ct=1;
for i=1:getnrpoints(envelope);
    t=t+1/sr;
    ct=ct+1;
    if t>next_pulse
        ct=1;
        pulse_counter=pulse_counter+1;
        if length(pulse_times)>=pulse_counter
            next_pulse=pulse_times(pulse_counter);
        else
            next_pulse=inf;
        end
    end
    if ct>length(env)
        env_vals(i)= 0;
    else
        env_vals(i)= env(ct);
    end
end



%
% onsettime=0;
% for i=1:getnrpoints(envelope);
%     t=t+1/sr;
%
% %     env_vals(i)= exp(-(time)/time_const);
%     env_vals(i)= power(t,onsettime)*exp(-(t)/time_const);
%     t=mod(t,reprate);
%
% end
envelope=setvalues(envelope,env_vals);
envelope=envelope/max(envelope)*amplitude;
envelope=setstarttime(envelope,0);

% set the envelope and the amplitude
sig=sinus*envelope;

sig=setname(sig,sprintf('damped sinusoid %4.2f kHz, Modulation=%4.1f Hz, halflife=%4.1f ms',carfre/1000,modfre,halflife*1000));

% plot(sig)
















%
%
%
% % from here on old code, might not work!
%
% sinus=generatesinus(sig,carfre,amplitude,0);
%
% % calculate envelope and mult both
% envelope=sig;
%
% time_const=halflife/0.69314718;
%
% env_vals=getvalues(envelope);
% sr=getsr(envelope);
% reprate=1/modfre;
%
%
% sig_len=getlength(sig);
% % when regular, all modulataions are at the same time:
% if jitter==0
%     pulse_times=0:reprate:sig_len;
% else
%     nr_pulses=ceil(sig_len/reprate);
%     modulation_period=1/modfre;
%     pulse_times(1)=0;
%     for n = 2:nr_pulses
%         jittering=(rand-0.5*jitter)*modulation_period;
%         pulse_times(n) = pulse_times(n-1) + modulation_period+jittering;
%     end
% end
%
%
%
% % oldval=0;
% % corr=exp(1/sr/time_const);
% % t=0;
% next_pulse=pulse_times(1);
% pulse_counter=1;
%
% % for i=1:getnrpoints(envelope);
% %     oldval=oldval/corr;
% %     t=t+1/sr;
% %     if t>next_pulse
% %         oldval=1;
% %         pulse_counter=pulse_counter+1;
% %         if length(pulse_times)>=pulse_counter
% %             next_pulse=pulse_times(pulse_counter);
% %         else
% %             next_pulse=inf;
% %         end
% %     end
% %     env_vals(i)= oldval;
% % end
%
% % onsettimeconstant
% %
% t=[0:1/sr:reprate-1/sr]*500;
% env=power(t,4).*exp(-2*pi*t/2);
% env=env./max(env);
%
% % e=linspace(env(length(env)-l),0,l+1);
% % env(length(env)-l:end)=e;
%
% %  e=linspace(1,0,l+1);
% % env(length(env)-l:end)=env(length(env)-l:end).*e.*e;
%
% t=0;
% ct=1;
% for i=1:getnrpoints(envelope);
%     t=t+1/sr;
%     ct=ct+1;
%     if t>next_pulse
%         ct=1;
%         pulse_counter=pulse_counter+1;
%         if length(pulse_times)>=pulse_counter
%             next_pulse=pulse_times(pulse_counter);
%         else
%             next_pulse=inf;
%         end
%     end
%     if ct>length(env)
%         env_vals(i)= 0;
%     else
%         env_vals(i)= env(ct);
%     end
% end
%
%
%
% %
% % onsettime=0;
% % for i=1:getnrpoints(envelope);
% %     t=t+1/sr;
% %
% % %     env_vals(i)= exp(-(time)/time_const);
% %     env_vals(i)= power(t,onsettime)*exp(-(t)/time_const);
% %     t=mod(t,reprate);
% %
% % end
% envelope=setvalues(envelope,env_vals);
% envelope=envelope/max(envelope)*amplitude;
% envelope=setstarttime(envelope,0);
%
% % set the envelope and the amplitude
% sig=sinus*envelope;
%
% sig=setname(sig,sprintf('damped sinusoid %4.2f kHz, Modulation=%4.1f Hz, halflife=%4.1f ms',carfre/1000,modfre,halflife*1000));
%
% % plot(sig)