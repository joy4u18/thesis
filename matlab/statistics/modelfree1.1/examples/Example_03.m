clear, load examples/03_Carcagno;
figure; plot( x, r ./ m, 'k.'); axis([1.85 4.45 0.2 1.02]); axis square;

degpol = 1; % Degree of the polynomial
guessing = 1/3; % guessing rate
lapsing = 0; % lapsing rate
b = binomfit_lims( r, m, x, degpol, 'probit', guessing, lapsing );
numxfit = 199; % Number of new points to be generated minus 1
xfit = [min(x):(max(x)-min(x))/numxfit:max( x ) ]';
% Plot the fitted curve
pfit = binomval_lims( b, xfit, 'probit', guessing, lapsing );
hold on, plot( xfit, pfit, 'k' );


initK = 2; % Initial power parameter in Weibull/reverse Weibull model
[ b, K ] = binom_weib( r, m, x, degpol, initK, guessing, lapsing );
% Plot the fitted curve
pfit = binomval_lims( b, xfit, 'weibull', guessing, lapsing, K );
hold on, plot( xfit, pfit, 'r' );



[ b, K ] = binom_revweib( r, m, x, degpol, initK, guessing, lapsing );
% Plot the fitted curve
pfit = binomval_lims( b, xfit, 'revweibull', guessing, lapsing, K );
hold on, plot( xfit, pfit, 'g' );

bwd_min = min( diff( x ) );
bwd_max = max( x ) - min( x );
bwd = bandwidth_cross_validation( r, m, x, [ bwd_min, bwd_max ] );
% Plot the fitted curve
bwd = bwd(3); % choose the third estimate, which is based on cross-validated deviance
pfit = locglmfit( xfit, r, m, x, bwd );
hold on, plot( xfit, pfit, 'b' );