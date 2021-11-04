% for 3.3
function [loglik] = LogLikLP(x,y,p,c)
% Preparing a max liklihood estimation for laplace distributed residuals


%p = 1
%c = 1
%y = (1:20)'


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
abs_uhat = abs(uhat); 


% Log-Likl (conditional)
loglik = log(0.5)*(T-p) -  sum(abs_uhat);

if isnan(loglik) || isinf(loglik) || ~ isreal(loglik)
    loglik = -1e-10;
end


end

