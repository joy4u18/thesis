% parameter file for 'aim-mat'
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


% (this is for testtign vj2014) ..

%%%%%%%%%%%%%
% sai
% hidden parameters
ac2003.generatingfunction= 'gen_ti2003_mit_autocor' ; 
                                                     
ac2003.displayname='time integration stabilized auditory image on several sources';
ac2003.revision='$Revision: 585 $';

% parameters relevant for the calculation of this module
ac2003.criterion='change_weights'; % can be 'integrate_erbs','change_weights'
% relevant for all criterions:
ac2003.mindelay=0.0005;
ac2003.maxdelay=0.035;
ac2003.buffer_memory_decay=0.03;
ac2003.frames_per_second=200;

ac2003.weight_threshold=0.0; 	% when strobe weight drops under this threshold, forget it!
ac2003.do_normalize=1; % yes, strobes are normalized to a weight of 1
ac2003.do_times_nap_height=0; % no, nap height is not multiplied per default
ac2003.do_adjust_weights=1;	% yep, the weights are changed by the following parameter
ac2003.strobe_weight_alpha=0.5; % the factor by which the strobe weight decreases
ac2003.delay_weight_change=0.5; % change the weights after this time


ac2003.do_click_reduction=0;
ac2003.click_reduction_sai='click_frame.mat';

ac2003.dual_output=0;


