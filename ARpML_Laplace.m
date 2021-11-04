function [ML] = ARpML_Laplace(y,p,c,a)

% function to maximise log-likelohood function
% under the asumotion of laplace-distributed normal 
% -> i.e. MIN of negative log-likelihood!
% Using fminun (gradient based search) 

% function handle
f = @(x) -1*LogLikLP(x,y,p,c); % one input: x

% minimization
x0 = randn(p+c+1,1);
[x,fval,exitflag,output,grad,hessian] = fminunc(f, x0); % f = function, x0 = starting values

end

%thetatilde = x(1:p+c); %estimated coefficients 
%sigutilde = x(end);

%V = inv(hessian); % no minus needed here since already minimizing
%sig = sqrt(diag(V));
%sig_thetatilde = sig(1+p+c);
%T_eff = T-p;
%logl = -fval;
%tstat = thetatilde./sig_thetatilde; 
%tcrit = tinv(a/2, T_eff - p - c); % from t-dist
%pval = tpdf(tstat, T_eff-p-c);

%end

