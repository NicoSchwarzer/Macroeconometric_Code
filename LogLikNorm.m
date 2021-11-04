% for 3.2.2

function [loglik] = LogLikNorm(x,y,p,c)




x = randn(p+c+1,1);

theta = x(1:(c+p)); % as it contains that 
sig_u = x(c+p+1); % last value - SE


T = size(y,1); % sample size

% lagged values
Y = lagmatrix(y,1:p); % matrix with lagged variables

if c == 1
    Y = [ ones(T,1) Y];
elseif c == 2
    Y = [ones(T,1) transpose(1:T) Y];
end 

% get rid of first p  values 
Y = Y((p+1):end,:);
y = y((p+1):end);

%residuals
uhat = y - Y*theta;
uu = uhat'*uhat; 


% Log-Likl (conditional)
loglik = -log(2*pi)*(T-p)/2 - log(sig_u^2)*(T-p)/2 - uu / (2*sig_u^2);

if isnan(loglik) || isinf(loglik) || ~ isreal(loglik)
    loglik = -1e-10;
end

end % end of function

