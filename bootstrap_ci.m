function [BOOT] = bootstrap_ci(T, burning,c, phi, choose_method)

%%% Function to return bootstrap confidence interval of an artificial AR(1) process
%%% and compare that to the asymptotic confidence interval 

%%% Input parameters 
%%% 1) T - length of created AR(1)
%%% 2) c - c parameter for created AR(1)
%%% 3) phi - phi parameter for created AR(1)
%%% 4) choose_method - if set to 1 -> empirical bootstrap / if set to 2 -> parametric


rng(1);

%T = 100;
u = exprnd(1,T+burning,1) - 1; % exponential distribution / exp subtracted

burning = 1000; % number of obs to discard

% True data from AR(1)
y = nan(T,1);
y(1) = c/(1-phi);

for t = 2:(T+burning)
    y(t) = c + phi * y(t-1) + u(t);
end
y = y(burning + 1:end);


% OLS and t-stat 

results_ols = ARpOLS(y,1,1,0.05);
t_stat = results_ols.tstat;
uhat = results_ols.resid;
B = 10000;
taustar = nan(B,1);


for b=1:B
    % draw with replacement 
    if  choose_method == 1
        ustar = datasample(uhat, length(uhat), 'Replace', true); % of same length but with replacement!
    else
        ustar = randn(size(uhat,1), 1).*results_ols.sig_uhat; % scaling by estimate of SE!
    end  
    chat = results_ols.thetahat(1);
    phihat = results_ols.thetahat(2);
    
    ystar = nan(T,1);
    ystar(1) = y(1);
    
    for t = 2:T
        % generate artifical time series AR(1)
        ystar(t) = chat + phihat*ystar(t-1) + ustar(t-1,1);
    end
    OLSstar = ARpOLS(ystar, 1,1,0.05);
    taustar(b) = ( OLSstar.thetahat(2) - results_ols.thetahat(2) ) / OLSstar.sig_thetahhat(2) ;
end

taustar = sort(taustar); % sorting the vector 
lower = results_ols.thetahat(2) - taustar( (1-(0.05/2)) * 1000) * OLSstar.sig_thetahhat(2);
upper = results_ols.thetahat(2) + taustar( (1-(0.05/2)) * 1000) * OLSstar.sig_thetahhat(2);

z = norminv(1-0.05/2,0,1);
Lower_Asymp = results_ols.thetahat(2) - z * OLSstar.sig_thetahhat(2);
Upper_Asymp = results_ols.thetahat(2) + z * OLSstar.sig_thetahhat(2);


BOOT.lower_boot = lower;
BOOT.upper_boot = upper;
BOOT.lower_asymp = Lower_Asymp;
BOOT.upper_asymp = Upper_Asymp;

end

