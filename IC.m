function [nlag] = IC(y,c,p,crit)

% function for calculating and comparing Info-Criteria

T = size(y,1);
T_eff = T -p;



% Regression matrices
Y = lagmatrix(y,1:p);
YMAX = lagmatrix(y,1:20);
y = y((p+1):T);


if c == 1
    YMAX = [ ones(T,1) YMAX];
elseif c == 2
    YMAX = [ones(T,1) transpose(1:T) YMAX];
end 

YMAX = YMAX((p+1):T,:);

infocrit = ones(p,1);

% Running large loops

for pp = 1:p
    n = c + pp;
    Y = YMAX(:,(1:n));
    
    thetahat = (Y'*Y)\(Y'*y);
    uhat = y-Y*thetahat;
    sigmau2 = uhat'*uhat/T_eff; % ML estimate of variance of errors 
    
    if strcmp(crit, 'AIC')
        infocrit(pp,1) = log(sigmau2) + 2/T_eff * n ;
    elseif  strcmp(crit, 'SIC')
        infocrit(pp,1) = log(sigmau2) + log(T_eff)/T_eff + n;
    elseif strcmp(crit, 'HQC')
        infocrit(pp,1) = log(sigmau2) + 2* log(log(T_eff))/T_eff*n;
    end
end 



% Store results and find min value of icS 
results = [transpose(1:p) infocrit];
nlag = find(infocrit == min(infocrit));

% Displaying results 
fprintf('****************************************************\n');
fprintf('*** OPTIMAL ENDOGENOUS LAGS FROM %s INF CRITERIA ***\n', c);
fprintf('****************************************************\n');
disp(array2table(results, 'VariableNames',{'Lag',crit}));

end

