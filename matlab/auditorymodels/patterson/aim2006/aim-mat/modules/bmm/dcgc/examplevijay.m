min_fre= 100;
max_fre=6e3;
nr_points=100;

log_fres=distributelogarithmic(min_fre,max_fre,nr_points);

erb_fres=Frs;
erb_vals=randn(1,100);

method='cubic';
% for i=1:nr_points
%     log_fre=log_fres(i);
new_vals=interp1(erb_fres,erb_vals,log_fres,method);


% end


