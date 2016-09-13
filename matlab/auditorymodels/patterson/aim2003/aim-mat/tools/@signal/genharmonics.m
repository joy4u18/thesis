% method of class @signal
% function sig=genharmonicstim(sig,varargin)
%   INPUT VALUES:
%       sig: @signal with length and samplerate 
%       varargin must have several parameters:
%       fundamental (default 128) = periodicity
%       min_fre (128) = lowest possible frequency
%       max_fre     (10000) = highest possible frequency
%
% 		envelope of amplitudes
%		either
%       filterprop ([256,256,1024,512]) = fc, df1, bandwidth, df2 (in Hz)
%       default values: fc=3500;
%						df1=256; 
%                       bandwidth=1024;
%                       df2=512;
%		the amplitdes can also be given by cf and two slopes for
%		higher and lower frequencies:
%					eg 'cf',1000,'lowslope',25,'highslope',38
% 			the highest and lowest possible allowed harmonic are given
% 			in either case by giving 'lowestharmonic' and
% 			'highestharmonic' (default value: 1 and inf)
%
%       type =              which type   (default none) 
%                           filtered, 
%                           decreaseoddamplitude, 
%                           decreaseoddphase
%                           shiftallcomponents
%                           mistunedharmonic
%							decrease_amplitude_linear
%       changeby = value, that the odd harmonics shall vary (degree or dB or whatever)
%       phases must be in degrees!
%   RETURN VALUE:
%       sig:  @signal 
%
% examples:	
% create a stimulus with certain filtercharacteristic with random
% phase, and every second harmonic reduced by an amount
% tone(i)=genharmonics(sig,'fundamental',chroma,...
% 		'filterprop',[toneheight,handles.df1,handles.bw,handles.df2],...
% 		'phase','random',...
% 		'type','decreaseoddamplitude',...
% 		'changeby',octheight...
% 	);
% 

% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/09/19 09:32:22 $
% $Revision: 1.12 $

function sig=genharmonics(sig,varargin)

if mod(nargin,2)==0
    disp('odd number of parameters - please input a full set of parameters and arguments');
    return;
end
str_fundamental=getargument(varargin,'fundamental');
str_type=getargument(varargin,'type');
str_harmnr=getargument(varargin,'harmonicnumber');
str_changeby=getargument(varargin,'changeby');
str_filterprop=getargument(varargin,'filterprop');
str_fc=getargument(varargin,'fc');
str_lowslope=getargument(varargin,'lowslope');
str_highslope=getargument(varargin,'highslope');
str_lowestharmonic=getargument(varargin,'lowestharmonic');
str_highestharmonic=getargument(varargin,'highestharmonic');
str_bw=getargument(varargin,'bw');
str_phase=getargument(varargin,'phase');
str_min_fre=getargument(varargin,'min_fre');
str_max_fre=getargument(varargin,'max_fre');

% defaultvalues:
if strcmp(str_filterprop,'')
	if strcmp(str_changeby,'')   
		str_filterprop{1}=[256,256,1024,512];
		fc=256;
		df1=256;
		bandwidth=1024;
		df2=512;
	else
		min_fre=str_min_fre{1};
		max_fre=str_max_fre{1};
		df1=1;
		df2=1;
		fc=min_fre;
		bandwidth=max_fre-min_fre;
	end
else
	%eval(sprintf('filterprop=%s;',str_filterprop{1}));
	fc=str_filterprop{1}(1);
	df1=str_filterprop{1}(2);
	bandwidth=str_filterprop{1}(3);
	df2=str_filterprop{1}(4);
end
if strcmp(str_changeby,'')   
else
	if isnumeric(str_changeby{1})
		changeby=str_changeby{1};
	else
		eval(sprintf('changeby=%f;',str_changeby{1}));
	end
end

% different method of defining envelope: center frequency is the
% highest point, highslope and lowslope define the amplitude on both
% sides for each harmonic
if ~strcmp(str_lowslope,'') && ~strcmp(str_highslope,'')
	lowslope=str_lowslope{1};
	highslope=str_highslope{1};
	calculate_amplitude_with_slopes=1;
	
	% test with 
	% plot(powerspectrum(genharmonics(signal(0.1,16000),'fc',2000,'lowslope',30,'highslope',40,'fundamental',250)))
else
	calculate_amplitude_with_slopes=0;
end

if strcmp(str_type,'')    
    str_type{1}='';
    type='';
else
    type=str_type{1};
end

if strcmp(str_phase,'')
	setphase='cosine';
else
    setphase=str_phase{1};
end

if strcmp(str_fundamental,'') 
    str_fundamental{1}='128';
    fundamental=128;
else
	if isnumeric(str_fundamental{1})
		fundamental=str_fundamental{1};
	else
	    eval(sprintf('fundamental=%s;',str_fundamental{1}));
	end
end

if strcmp(str_lowestharmonic,'') 
    lowestharmonic=1;
else
	if isnumeric(str_lowestharmonic{1})
		lowestharmonic=str_lowestharmonic{1};
	else
	    eval(sprintf('lowestharmonic=%s;',lowestharmonic{1}));
	end
end
if strcmp(str_highestharmonic,'') 
    highestharmonic=inf;
else
	if isnumeric(str_highestharmonic{1})
		highestharmonic=str_highestharmonic{1};
	else
	    eval(sprintf('highestharmonic=%s;',highestharmonic{1}));
	end
end

if strcmp(str_fc,'') 
else
	if isnumeric(str_fc{1})
		fc=str_fc{1};
	else
		eval(sprintf('fc=%s;',str_fc{1}));
	end
end

if strcmp(str_bw,'') 
else
	if isnumeric(str_bw{1})
		bandwidth=str_bw{1};
	else
	    eval(sprintf('bandwidth=%s;',str_bw{1}));
	end
end

samplerate=sig.samplerate;
length=getlength(sig);


% begin!

max_fre=fc+bandwidth+df2;
min_fre=fc-df1;
if (min_fre<0)  %squeese df1 to go from 0 to fc
    df1=df1-abs(min_fre);
%     disp('df1 was reduced')
end

if fundamental > max_fre
    disp('error: genharmonics: fundamental must be smaller then highest frequency');
    return;
end

s=signal(length,samplerate);
if max_fre>1000
	s=setname(s,sprintf('Harmonic Signal - f0=%4.1f Hz, type: %s (from %2.2f kHz to %2.2f kHz)',fundamental,type,min_fre/1000,max_fre/1000));
else
	s=setname(s,sprintf('Harmonic Signal - f0=%4.1f Hz, type: %s  (from %3.0 Hz to %3.0f Hz)',fundamental,type,min_fre,max_fre));
end

if calculate_amplitude_with_slopes
	s=setname(s,sprintf('Harmonic Signal - modfre=%4.1f Hz, type: %s  (cf: %2.2f kHz, low slope: %3.0f dB/oct, high slope %3.0f dB/oct)',fundamental,type,fc/1000,lowslope,highslope));
end

% in case of sloped amplitudes, we dont want a limit on harmonics
if calculate_amplitude_with_slopes
	max_fre=getsr(sig)/2;
	min_fre=0;
end
	
% if limit of harmonics is explicitly given
if ~strcmp(str_highestharmonic,'') 
	max_fre=highestharmonic*fundamental;
end
if ~strcmp(str_lowestharmonic,'') 
	min_fre=lowestharmonic*fundamental;
end
	
fre=fundamental;
count_partials=1;
while fre <= max_fre
    if fre >= min_fre
        temp=signal(length,samplerate);
        amplitude=1;
        phase=0;
        offset=0;
        if strcmp(type,'mistunedharmonic') % in %
            eval(sprintf('nr=%s;',str_harmnr{1}));
            if count_partials==nr
                offset=fundamental*changeby/100;
                amplitude=1;
                phase=0;
            end     
        end
        if strcmp(type,'shiftallcomponents')   % in Hz
            offset=changeby;
            amplitude=1;
            phase=0;
        end
        if strcmp(type,'decreaseoddphase')
            % phase must be given in degree!
            if mod(count_partials,2)==1
                amplitude=1;
                phase=changeby;
            end
        end

		if strcmp(type,'decrease_amplitude_linear')
			% the amount must be given in changeby!
            amplitude=1*power(10,(-changeby*count_partials)/20);
        end

        ampscale=filterbandamp(fre+offset,amplitude,fc,df1,bandwidth,df2);
        amplitude=amplitude*ampscale;


		% stattdessen mit Slopes:
		if calculate_amplitude_with_slopes
			% calculate the distance from cf (in octaves) 
			% and from this the attenuation
			distance=log2(fre/fc);
			if distance >= 0
				atten=distance*highslope;
			else
				atten=-distance*lowslope;
			end
            amplitude=1*power(10,-atten/20);
		end

        if strcmp(type,'decreaseoddamplitude')
            if mod(count_partials,2)==1
                amplitude=amplitude*power(10,changeby/20);
            end
        end
        if strcmp(type,'decreaseevenamplitude')
            if mod(count_partials,2)==0
                amplitude=amplitude*power(10,changeby/20);
            end
        end
		
        % degree2rad
		if strcmp(setphase,'random')
			piphase=rand(1)*2*pi+pi;
		else
			piphase=phase*(pi/180)+pi/2;
		end
        temp=generatesinus(temp,fre+offset,amplitude,piphase);   %CPH signal
        s=s+temp;
    end
    fre=fre+fundamental;
    count_partials=count_partials+1;
end

sig=s;
