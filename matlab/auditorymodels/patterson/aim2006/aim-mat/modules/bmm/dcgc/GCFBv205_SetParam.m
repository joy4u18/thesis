%
%       Setting Default Parameter for GCFBv2
%	Version 2.05
%       Toshio IRINO
%       Created:   31 Aug 2004
%       Modified:  9  Nov 2004  
%       Modified:  31 May 2005
%       Modified:  1  July 2005
%       Modified:  8  July 2005  (bug fix in b2)
%       Modified:  13 July 2005  ( GCparam.LvlEst.frat = 1.08)
%       Modified:  14 July 2005  ( adding GCparam.LvlEst.RefdB, Pwr, Weight)
%       Modified:  16 July 2005  ( GCparam.LvlEst.LctERB = 1.5)
%
% function GCparam = GCFBv2_SetParam(GCparam)
%      INPUT:  GCparam:  Your preset gammachirp parameters
%                  GCparam.fs:     Sampling rate          (48000)
%                  GCparam.NumCh:  Number of Channels     (75)
%                  GCparam.FRange: Frequency Range of GCFB [100 6000]
%                           specifying asymptotic freq. of passive GC (Fr1)
%        
%      OUTPUT: GCparam: GCparam values
%
%  Patterson, R.D., Unoki, M. and Irino, T. :  JASA, Vol.114,pp.1529-1542,2003.
%
function GCparam = GCFBv2_SetParam(GCparam)

%%%% Handling Input Parameters %%%%%
if isfield(GCparam,'fs') == 0, GCparam.fs = [];  end;
if length(GCparam.fs) == 0,  
        GCparam.fs  = 48000; 
end;
% if isfield(GCparam,'OutMidCrct') == 0,  GCparam.OutMidCrct = [];   end;
% if length(GCparam.OutMidCrct) == 0, 
% 	GCparam.OutMidCrct  = 'ELC';
% end;
GCparam.OutMidCrct = [];
%%% if no OutMidCrct is not necessary, specify GCparam.OutMidCrct = 'no'; 
%%
if isfield(GCparam,'NumCh') == 0,  GCparam.NumCh = [];   end;
if length(GCparam.NumCh) == 0, 
	GCparam.NumCh  = 75;
end;
if isfield(GCparam,'FRange') == 0,  GCparam.FRange = [];   end;
if length(GCparam.FRange) == 0, 
	GCparam.FRange  = [100 6000];
end;

%%%%% Gammachirp  parameters %%%
if isfield(GCparam,'n') == 0,  GCparam.n = [];   end;
if length(GCparam.n) == 0, 
         GCparam.n = 4;                 % default gammatone & gammachirp
end;

%%% convention 

if isfield(GCparam,'b1') == 0,  GCparam.b1 = [];   end;
if length(GCparam.b1) == 0, 
         GCparam.b1 = [1.81];     % scalar: frequency independent
end;
if isfield(GCparam,'c1') == 0,  GCparam.c1 = [];   end;
if length(GCparam.c1) == 0, 
         GCparam.c1 = [-2.96];    % scalar: frequency independet   
end;

if isfield(GCparam,'frat') == 0,  GCparam.frat = [];   end;
if length(GCparam.frat) == 0, 
         GCparam.frat = [0.233, 0; 0.0050, 0];                 
end;

if isfield(GCparam,'b2') == 0,  GCparam.b2 = [];   end;
if length(GCparam.b2) == 0, 
        %  GCparam.b2 = [2.01, 0; 0,0];   % no level-dependency bug
        GCparam.b2 = [2.17, 0; 0,0];   % no level-dependency  (8 Jul 05)
end;
if isfield(GCparam,'c2') == 0,  GCparam.c2 = [];   end;
if length(GCparam.c2) == 0, 
  % GCparam.c2 = [2.20, 0; 0,0]; %v203: no level-dependency; no freq-dependency
  % GCparam.c2 = [1.98, 0; 0.0088, 0];  % == v203
  % GCparam.c2 = [2.0, 0; 0.010, 0];   % no freq-dependecy: level-dependent
                                     % for simplicity v204
  %  GCparam.c2 = [2.0, 0; 0.030, 0];  % 26 May 05 (NG! since Pc == mean value) 
  % GCparam.c2 = [2.1, 0; 0.010, 0];  % 27 May 05 (1 dB worse than 2.0 0.010 )
  % GCparam.c2 = [2.0, 0; 0.015, 0];  % 31 May 05 (much worse than 2.0 0.010 )
  % GCparam.c2 = [2.0, 0; 0.007, 0];  % 1 Jun 05 (OK! almost the same as 1st draft)
  GCparam.c2 = [2.20, 0; 0, 0];   %  3 Jun 05 . It is good!
end;
if isfield(GCparam,'Ctrl') == 0,  GCparam.Ctrl = [];   end;
if length(GCparam.Ctrl) == 0, 
	GCparam.Ctrl  = 'fix';
end;

if isfield(GCparam,'GainCmpnstdB') == 0,  GCparam.GainCmpnstdB = [];   end;
if length(GCparam.GainCmpnstdB) == 0, 
	GCparam.GainCmpnstdB  = -1;  % in dB. when LvlEst.c2==2.2, 1 July 2005
end;


%%%%%%% Parameters for level estimation %%%%%%%%%

if exist('GCparam.PpgcRef') == 1,
  disp('The parameter "GCparam.PpgcRef" is obsolete.');
  error('Please change it to GCparam.LvlRefdB.'); 
end;

if isfield(GCparam,'LvlRefdB') == 0,  GCparam.LvlRefdB = [];   end;
if length(GCparam.LvlRefdB) == 0, 
         GCparam.LvlRefdB = 50;  % reference Ppgc level for normalization
end;

if isfield(GCparam,'LvlEst') == 0,  GCparam.LvlEst = [];   end;

if isfield(GCparam.LvlEst,'LctERB') == 0,  GCparam.LvlEst.LctERB = [];   end;
if length(GCparam.LvlEst.LctERB) == 0, 
       GCparam.LvlEst.LctERB = 1.0;  
      % Location of Level Estimation pGC relative to the signal pGC in ERB
      % see testGC_LctERB.m for fitting result. 10 Sept 2004
       GCparam.LvlEst.LctERB = 1.5;   % 16 July 05
end;


if isfield(GCparam.LvlEst,'DecayHL') == 0, GCparam.LvlEst.DecayHL=[]; end;
if length(GCparam.LvlEst.DecayHL) == 0,
        %%% GCparam.LvlEst.DecayHL = 1; % half life in ms,  Mar 2005
        GCparam.LvlEst.DecayHL = 0.5; % 18 July 2005
        %%% Original name was PpgcEstExpHL
        %%% Interesting findings on 12 Jul 04 
        %%% GCparam.PpgcEstExpHL = 2;  % seems to produce distortion product
        %%% GCparam.PpgcEstExpHL = 5;  % original value without any info.
        %%% Resonable value:
        %%% GCparam.LvlEst.DecayHL = 1; % It is the best in the forward masking
end;

if isfield(GCparam.LvlEst,'b2') == 0, GCparam.LvlEst.b2=[]; end;
if length(GCparam.LvlEst.b2) == 0,
     % GCparam.LvlEst.b2 = 1.5;
     % GCparam.LvlEst.b2 = 2.01;          % = b2 bug!
     GCparam.LvlEst.b2 = GCparam.b2(1,1); % = b2   8 July 2005
end;

if isfield(GCparam.LvlEst,'c2') == 0, GCparam.LvlEst.c2=[]; end;
if length(GCparam.LvlEst.c2) == 0,
     % GCparam.LvlEst.c2 = 2.7;
     % GCparam.LvlEst.c2 = 2.20;  % = c2
     GCparam.LvlEst.c2 = GCparam.c2(1,1); % = c2
end;

if isfield(GCparam.LvlEst,'frat') == 0, GCparam.LvlEst.frat=[]; end;
if length(GCparam.LvlEst.frat) == 0,
    % GCparam.LvlEst.frat = 1.1;  %  when b=2.01 & c=2.20
    GCparam.LvlEst.frat = 1.08;   %  peak of cGC ~= 0 dB (b2=2.17 & c2=2.20)
end;

if isfield(GCparam.LvlEst,'RMStoSPLdB')==0, GCparam.LvlEst.RMStoSPLdB=[]; end;
if length(GCparam.LvlEst.RMStoSPLdB) == 0,
    GCparam.LvlEst.RMStoSPLdB = 30;   %  1 rms == 30 dB SPL for Meddis IHC
end;

if isfield(GCparam.LvlEst,'Weight')==0, GCparam.LvlEst.Weight=[]; end;
if length(GCparam.LvlEst.Weight) ==0,
    GCparam.LvlEst.Weight = 0.5;  
end;

if isfield(GCparam.LvlEst,'RefdB')==0, GCparam.LvlEst.RefdB=[]; end;
if length(GCparam.LvlEst.RefdB) < 2,
    GCparam.LvlEst.RefdB = 50;  % 50 dB SPL
end;

if isfield(GCparam.LvlEst,'Pwr')==0, GCparam.LvlEst.Pwr=[]; end;
if length(GCparam.LvlEst.Pwr) < 2,
    GCparam.LvlEst.Pwr = [ 1.5, 0.5 ];  % Weight for pGC & cGC 
end;

%%%%%%%%%%%

