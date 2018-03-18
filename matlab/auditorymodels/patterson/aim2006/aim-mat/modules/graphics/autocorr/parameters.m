% parameter file for 'aim-mat'
% 
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/02/17 12:31:05 $
% $Revision: 1.1 $
%%%%%%%%%%%%%
% the parameters for the graphics.
% They are independent from the module parameters

autocorr.minimum_time=0.000;
autocorr.maximum_time=0.035;
autocorr.is_log=0;
autocorr.time_reversed=0;
autocorr.display_time=0;
autocorr.time_profile_scale=1;

autocorr.plotstyle='surf'; 
autocorr.colormap='default';    % changed this for PLOS BIO vj2017
autocorr.colorbar='off';
autocorr.viewpoint=[0 90];
autocorr.camlight=[50,30;0,90]; 
autocorr.lighting='phong';
autocorr.shiftcolormap=0.0; 