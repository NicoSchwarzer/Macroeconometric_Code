function[OLS] = VARReducedForm(y,p,a)

    num_series = size(y,2); % number of series 
    T = size(y,1); % sample size
    T_eff = T - p;
    
    % creating Y Matrix % 
    
    % first element in big Y matrix outside of loop! - then to be appended
    Y = y((p+1),:)';
    
    for i = (p+2):size(y,1)
        y_i = y((i),:)';
        Y = [Y y_i];
    end
    % corect dimension!
    
    % creating Z matrix %
    
    % first element in big Z matrix outside of loop! - then to be appended
    Z =  [1; y(p,:)'; y((p-1),:)'];
        
    for i = (p+1):(size(y,1)-1)
        Z_i = [1; y(i,:)'; y((i-1),:)'];
        Z = [Z Z_i];
    end
    
    
    % computing parameters via OLS % 
    ZZ_inv = inv(Z*transpose(Z))
    
    if num_series * p + 1 == size(ZZ_inv,1)
        disp("Matching dimensions for zz inv")
    end
    
    % A hat
    A_hat = Y*transpose(Z)*ZZ_inv;
    
    
    % predcited values & residuals
    Y_hat = A_hat * Z;
    U_hat = Y - Y_hat;
    
    % (Estimated) Variance of error term
    sigma_hat_u = U_hat*transpose(U_hat) / (T_eff-1-(num_series*p)) ; % num_series*p = Kp 
    se_hat_u = sqrt(diag(sigma_hat_u));
    
    % Variance of series
    var_A_hat =  kron(ZZ_inv, sigma_hat_u); 
    se_A_hat = sqrt(diag(var_A_hat)); % SE of coefficients 
    
    % t-stat
    tstat = A_hat(:)./se_A_hat; % under assumption that Ho -> that == 0
    tcrit = tinv(a/2, T_eff-1-(num_series*p)); %crit_value of student's t-distribution 
    pval = tpdf(tstat, T_eff-1-(num_series*p));
    
    % confidence interval 
    lower = A_hat(:) - se_A_hat.* tcrit;
    upper = A_hat(:) + se_A_hat.* tcrit;
    conf_int = [lower upper];
    
    % Output structure 
    OLS.T_eff = T_eff;
    OLS.A_hat = A_hat;
    OLS.A_hat_vec = A_hat(:);
    OLS.sigma_hat_u = sigma_hat_u;
    OLS.se_hat_u = se_hat_u;
    OLS.tstat = tstat;
    OLS.pvalues = pval;
    OLS.ci = conf_int;
    OLS.resid = U_hat;
    
    
end







