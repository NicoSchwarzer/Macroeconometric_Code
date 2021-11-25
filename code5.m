%%%%%%%%%%%%
%% Code 5 %%
%%%%%%%%%%%%

opts = spreadsheetImportOptions("NumVariables", 1);

% Specify sheet and range
opts.Sheet = "ThreeVariableVAR";
opts.DataRange = "C2:C214";

% Specify column names and types
opts.VariableNames = "infl";
opts.VariableTypes = "double";

% Import the data
data = readtable("C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data\data.xlsx", opts, "UseExcel", false);


%
data = table2array(data);


T = size(data,1);

X = [ones(T,1) lagmatrix(data,1:2)];

X = X(3:T,:);
y = data(3:T,1);


B0 = zeros(3,1); % prior for coefficients
sigma0 = eye(3); % prior covarince 

%priors for for precision 1/sigma^2
s0 = 1; % variance parameter
v0 = 0.1; % scale

nreps = 210; % gibbs iterations
nburn = 150; %burning - keeping last 70
sigma2 = 1; % init sigma^2
out1 = zeros(nreps,3); % storing for coefficients draws 
out2 = zeros(nreps,1); % storing for sigma_2


for jj=1:nreps
    
    % B conditional on sigma^2 from N
    
    M = inv(inv(sigma0) + 1/sigma2*(X'*X)) * (inv(sigma0)*B0 + 1/sigma2 * X'*y); 
    V = inv(inv(sigma0) + 1/sigma2*(X'*X));
    
    B = mvnrnd(M,V);
    % Check for stability
    %check = -1;
    %while check < 0
    %        B = mvnrnd(M,V);
    %        A = [B(2) B(3);
    %            1      0  ];
    %        ee = max(abs(eig(A)));
    %        if ee < 1
    %            check = 1;
    %        end
    %end
    
    % Sample 1/sigma_^2 conditional on B  form Gamma distribution 
    s1 = s0 + T;
    v1 = v0 + (y-X*B')'*(y-X*B');
    
    shape = s1/2;
    scale = 1/(v1/2); % scale ^-1 because of inverse gamma ? 
    sigma2inv = gamrnd(shape, scale,1,1);
    sigma2 = 1/sigma2inv;
    

    % Save drwans once burnin phase is passed!
    
    out1(jj,1:3) = B;
    out2(jj,1) = sigma2;
    
end 


out1 = out1(151:end,:);
out2 = out2(151:end,:);

%plotting 

subplot(2,2,1);
histogram(out1(:,1),50);title("Constant");
subplot(2,2,2);
histogram(out1(:,2),50);title("Lag 1");
subplot(2,2,3);
histogram(out1(:,3),50);title("Lag 2");
subplot(2,2,4);
histogram(out2(:,1),50);title("sigma2");


%%%%%%%%%
%% 5.4 %%
%%%%%%%%%




%%%%%%%%%
%% 5.5 %%
%%%%%%%%%


opts = spreadsheetImportOptions("NumVariables", 3);

% Specify sheet and range
opts.Sheet = "ThreeVariableVAR";
opts.DataRange = "A2:C214";

% Specify column names and types
opts.VariableNames = ["drgdp", "irate", "infl"];
opts.VariableTypes = ["double", "double", "double"];

% Import the data
data1 = readtable("C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data\data.xlsx", opts, "UseExcel", false);

data = table2array(data1);
Y = data;


%% PRELIMINARIES
% Define specification of the VAR model
const = 1;              % 0: no constant, 1: constant, 2: constant and linear trend
p = 2;                  % Number of lags on dependent variables

% Define Minnesota prior for BVAR model
hyperparams(1) = 0.5;   % tightness parameter for Minnesota prior on lags of own variable
hyperparams(2) = 0.5;   % tightness parameter for Minnesota prior on lags of other variable
hyperparams(3) = 1;     % tightness of prior on exogenous variables, i.e. constant term, trends, etc


size(data);

% Gibbs-related preliminaries
nsave = 102;          % Final number of draws to keep
nburn = 60;          % Draws to discard (burn-in)
ntot = nsave+nburn;     % Total number of draws
it_print = 10;        % Print on the screen every "it_print"-th iteration

%% DATA HANDLING
% Load monthly US data on FFR, govt bond yield, unemployment and inflation
Yraw = data; %'Yraw' is a matrix with T rows by K columns 
[Traw,K] = size(Yraw);                       % Get initial dimensions of dependent variable
Ylag = lagmatrix(Yraw,1:p);                  % Generate lagged Y matrix. This will be part of the Z matrix
% Now define matrix Z which has all the R.H.S. variables (constant, lags of
% the dependent variable and exogenous regressors/dummies), also get rid of NA observations
if const == 0
    Z = transpose(Ylag(p+1:Traw,:));  
elseif const == 1
    Z = transpose([ones(Traw-p,1) Ylag(p+1:Traw,:)]);
elseif const == 2
    Z = transpose([ones(Traw-p,1) transpose((p+1):Traw) Ylag(p+1:Traw,:)]);
end
Y = transpose(Yraw(p+1:Traw,:)); % Dependent variable in i-th equation, get rid of NA observations
[totcoeff,T] = size(Z);          % Get size of final matrix Z
ZZt = Z*Z';                      % auxiliary matrix product

%% PRIOR SPECIFICATION
% Get standard specification of Minnesota Normal-Inverse-Wishard Prior
[alpha_prior, V_prior, inv_V_prior, v_prior, S_prior, inv_S_prior] = BVARMinnesotaPrior(Yraw,const,p,hyperparams);




%% INITIALIZATION for SIGMA
A_OLS = (Y*Z')/ZZt;                                 % Get OLS estimators
alpha_OLS = A_OLS(:);                               % Vectorize
resid_OLS = Y - A_OLS*Z;                            % Compute OLS residuals
SIGMA_OLS = (resid_OLS*resid_OLS')./(T-K*p-const);  % OLS estimator for covariance matrix

% Initialize Bayesian posterior parameters using OLS values
alpha = alpha_OLS; % This is the first draw from the posterior of alpha 
A = A_OLS;         % This is the first draw from the posterior of A
SIGMA = SIGMA_OLS; % This is the single draw from the posterior of SIGMA

%% START GIBBS SAMPLING
A_draws = zeros(nsave,K,totcoeff); % Storage space for posterior draws
SIGMA_draws = zeros(nsave,K,K);    % Storage space for posterior draws

for irep = 1:ntot

    
    %Posterior of alpha|SIGMA,Y ~ N(alpha_post,V_post)
    invSIGMA = inv(SIGMA);    
    V_post = (inv_V_prior+kron(ZZt,invSIGMA))\eye(size(inv_V_prior,1)); % V1
    alpha_post = V_post*(inv_V_prior*alpha_prior + kron(Z,invSIGMA)*Y(:)); % alpha 1
    
    % check for stability of the VAR coefficients
    check=-1;
    while check<0        
        alpha = alpha_post + chol(V_post)'*randn(K*(const+K*p),1); % Draw of alpha
        A = reshape(alpha,K,const+K*p);                            % Draw of A
        Acomp = [A(:,2:end); eye(K*(p-1)) zeros(K*(p-1),K)];       % Companion matrix
        if (max(abs(eig(Acomp)))>1)==0                             % Check Eigenvalue of Companion matrix
            check = 1;
        end
    end
    
    % Posterior of SIGMA|alpha,Y ~ invWishard(inv(S_post),v_post)
    v_post = T + v_prior;
    resid_irep = Y - A*Z;
    S_post = S_prior + resid_irep*resid_irep';
    SIGMA = inv(wishrnd(inv(S_post),v_post));   % Draw of SIGMA

    % Store results if burn-in phase is passed
    if irep > nburn               
        A_draws(irep-nburn,:,:) = A;         % Store A
        SIGMA_draws(irep-nburn,:,:) = SIGMA; % Store SIGMA
    end
       
end


%% INFERENCE ON POSTERIOR DRAWS AND COMPARISON WITH OLS
VAR_OLS = VARReducedForm(Yraw,p);

SIGMA_mean = squeeze(mean(SIGMA_draws,1)) % Posterior mean of SIGMA
se_A    = squeeze(std(A_draws,1))     % Posterior std error of A
LOWER_A = squeeze(prctile(A_draws,5,1)) % Posterior lower percentile
UPPER_A = squeeze(prctile(A_draws,95,1)) % Posterior upper percentile

    
    
    