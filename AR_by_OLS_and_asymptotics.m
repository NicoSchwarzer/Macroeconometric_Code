function[OLS] = ARpOLS(y,p,c,a)


    T = size(y,1); % sample size
    Y = lagmatrix(y,1:p);  % really nice
    T_eff = T - p; %effective sample size 
    
    if c == 1
        Y = [ ones(T) Y];
    elseif c == 2
        Y = [ones(T,1) transpose(1:T) Y];
    end 
    
    Y = Y((p+1):end,:); % removing nans
    y = y((p+1):end);
    
    
    % OLS
    YYinv = inv(Y*Y);
    theta_hat = YYinv * Y'*y;
    
    % predcited values & residuals
    yhat = Y * theta_hat;
    u_hat = y- yhat;
    
    
    % Variance of error term
    var_uhat = uhat'*uhat / (T_eff-p-c) ; % size - # regressors - constant (1 or 2)
    sig_uhat = sqrt(var_uhat);
    
    % Variance 
    var_thetahat = var_uhat * (YYin)); % cov matrix
    sig_thetahat = sqrt(diag(var_thetahat)); % SE of coefficients 
    
    % t-stat
    tstat = thetahat./sig_thetahat; % under assumption that Ho -> that == 0
    tcrit = tinv(a/2, T_eff-p-c); crit_value 
    pval = tpdf(tstat, T_eff-p-c);
    
    % confidence interval 
    lower = theta_hat - sig_thetahat.* tcrit;
    upper = theta_hat + sig_thetahat.* tcrit;
    conf_int = [lower upper];
    
    % Output structure 
    OLS.T_eff = T_eff;
    OLS.thetahat = theta_hat;
    OLS.sig_uhat = sig_uhat;
    OLS.sig_thetahhat = sig_thetahat;
    OLS.tstat = tstat;
    OLS.pvalues = pval;
    OLS.ci = conf_inv;
    OLS.resid = uhat;
    
    
    
end







