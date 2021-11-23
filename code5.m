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



