clear, load examples/07_Baker;
figure; plot( x, r ./ m, 'k.'); axis([-0.15 8.15 -0.05 1.05]); axis square; 


%%

degpol = 1; % Degree of the polynomial
b = binomfit_lims( r, m, x, degpol, 'probit' );
numxfit = 199; % Number of new points to be generated minus 1
xfit = [min(x):(max(x)-min(x))/numxfit:max( x ) ]';
% Plot the fitted curve
pfit = binomval_lims( b, xfit, 'probit' );
hold on, plot( xfit, pfit, 'k' );

%%

[ b, K ] = binom_weib( r, m, x );
guessing = 0; % guessing rate
lapsing = 0; % lapsing rate
% Plot the fitted curve
pfit = binomval_lims( b, xfit, 'weibull', guessing, lapsing, K );
hold on, plot( xfit, pfit, 'r' );

%%

[ b, K ] = binom_revweib( r, m, x, 1, 5 );
% Plot the fitted curve
pfit = binomval_lims( b, xfit, 'revweibull', guessing, lapsing, K );
hold on, plot( xfit, pfit, 'g' );

%%

bwd_min = min( diff( x ) );
bwd_max = max( x ) - min( x );
bwd = bandwidth_cross_validation( r, m, x, [ bwd_min, bwd_max ] );
% Plot the fitted curve
bwd = bwd(3); % choose the third estimate, which is based on cross-validated deviance
pfit = locglmfit( xfit, r, m, x, bwd );
hold on, plot( xfit, pfit, 'b' );

h1=legend('Results','Guassian Model','weibull','revweibull','non-parametric');
set(h1,'location','best');
xlabel('Gap Duration in ms');
ylabel('Proportion of correct responses');