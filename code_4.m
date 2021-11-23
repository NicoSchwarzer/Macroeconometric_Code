%%%%%%%%%%%%%%%%%%%
%% Code 4 script %%
%%%%%%%%%%%%%%%%%%%


%% 1

A = [0.5, 0, 0; 
    0.1, 0.1, 0.3;
    0, 0.2, 0.3];

% eigenvalues
eig(A)

% nice - 3 different from 0 - no singular matrix




%% 3  rotation matrix / orthogonal matrix 

% symbolic variable

syms x
expand((x-2)^2)


theta = sym("theta");

R = [cos(theta) -sin(theta);
     sin(theta) cos(theta)];
 
R'*R;

% nochmal im booklet gucken :D


%% 2 

% show that vec(D*E*F) =kron(F' , D) * vec(E)

dim = randi([1 10],1 ,4);

% creating symbolic matrices 

D = sym('d', [dim(1) dim(2)])
E = sym('e', [dim(2) dim(3)]);
F = sym('f', [dim(3) dim(4)]);

DEF = D*E*F;
vec_DEF = DEF(:);

isequal(expand(vec_DEF), expand( kron(transpose(F),D)*E(:)))


%% 4 Cholesky


SIGu = [2.25  0 0;
        0  1  0.5;
        0  0.5  0.74];
    
P = chol(SIGu, "lower");

SIGeps_sqrt = diag(P);
SIGeps = diag(SIGeps_sqrt.^2);

% A\B for A*x = B
% A/B for x*B = A

W = P/diag(SIGeps_sqrt);

isequal(SIGu, W*SIGeps*W'); %nice 1



%% 3 %%

% -> 3 will be an exam question!



%% 5 %%

% loading in data 

opts = spreadsheetImportOptions("NumVariables", 3);

% Specify sheet and range
opts.Sheet = "ThreeVariableVAR";
opts.DataRange = "A2:C214";

% Specify column names and types
opts.VariableNames = ["drgdp", "irate", "infl"];
opts.VariableTypes = ["double", "double", "double"];

% Import the data
data = readtable("C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data\data.xlsx", opts, "UseExcel", false);

data1 = table2array(data);

% visualiziing the data % 

figure('name', 'Figure for 4.5');
plot(data1(:,1),"b", 'LineWidth',2.0, 'Linestyle', '-');
hold on;
plot(data1(:,2),"r", 'LineWidth',2.0, 'Linestyle', '-');
hold on;
plot(data1(:,3),"g", 'LineWidth',2.0, 'Linestyle', '-');
hold on;
title('Adding title here');
set(gca,'xticklabel',[]);
% nice legend formatting
legend({'drgd','interest rate','inflation'},'Location','northeast','NumColumns',1);



data(1,:)



% calling the function % 

%cd 'C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Ex'

VAR_2_1 = VARReducedForm(data1,2,0.05);
VAR_2_1.A_hat


% calling the more professional function - better!
opt.cont = 1;

VAR_2_2 = VARReducedForm_2(data1,2,opt);
VAR_2_2.A


% can also take external functions 




%% 7 - exam question %%

% m = lag order 

% the estimated variance sigma_u might differ depending on the time peroid
% used for estimation. 

%%% 7.1
% Should the time period vary, then the differences in the estimated
% sigma_u might be due to the specific structure/idiosynchracies present in
% one of the time periods used for calculating it and not arise from the difference 
% in the lag order.


%%% 7.2 
% The first part of the equation of the information criteria is used to
% judge the residual covariance independent of the lag order. The second
% part takes care of the lag order. If the OLS estimate is used for the
% information criteria, then the first part would also be affected by the
% lag order. Especially in the case of large lag orders, the OLS estimate is highly influenced 
% by m. 


%%% 7.3

% Finite sample case

In this case, all IC benefit from a small residual variance-covariance matrix. The smallwer the latter,
the smaller the determinant and the log of it. The differences 
arise in the second part of the equations. More precisely, the effect of a difference in sample size 
differs. 


The term before o(m) of the SIC is larger than that of the AIC for all T > exp(2) ( = 7.3891), 
which is a quite samll sampel size for empirical analysis. In this case, minimizing the SIC 
is more influenced by the latter term and eill thusly depend more on keeping m small. 

Similarly, the term before o(m) of the HQC is is larger than that of the AIC for all T >
exp(exp(1)) ( = 15.1543), which again is a quite small sample size. 

Still, the term before o(m) of the HQC is smallwe than that of the AIC for all ln(T) > 2 * ln(ln(T)) =
T > exp(2) + ln(T), so for all T > 10. Again, a samlpe size above ten is the standard for epirircal analysis. 
exp(2) + log(10)

Hence, for all realistic sample sizes, a minimization of the SIC is more influenced by a small m 
than is the HQC than the AIC. 


% Asymptotoc properties 

In th limimt, the latter parts are 0. Envoking the continuous mapping theorem, 
one can see that the logs of the determinants of the estimated covariance matrices 
converge to their true counterparts.

The findings from the fininte smaple size case also apply to the rates of convergence. 
AIC will converge faster than HQC, which will converge faster than the SIC.



%%% 7.4 

% Reading in data 


opts = spreadsheetImportOptions("NumVariables", 3);

% Specify sheet and range
opts.Sheet = "ThreeVariableVAR";
opts.DataRange = "A2:C214";

% Specify column names and types
opts.VariableNames = ["drgdp", "irate", "infl"];
opts.VariableTypes = ["double", "double", "double"];

% Import the data
data = readtable("C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data\data.xlsx", opts, "UseExcel", false);

% converge to auseable array
data = table2array(data);

% retrieving numbwe of series
K = size(data,2);

% I shall for all lag orders of intereest (1-4) estimate a VAR model,
% retrieve the important parameters and compute the IC

% I  shall include a constant in the model 
opt.const = 1

% init empty vectors to be filled
AICs = ones(4,1);
SICs =  ones(4,1);
HQCs = ones(4,1);

for m = 1:4

    % effective sample size 
    T_eff = T - m;

    % performing VAR regression
    output_var = VARReducedForm(data ,m ,opt);

    % computing ICs
    first_part = log(det(output_var.SigmaML));
    phi = m*K^2+K;

    AICs(m,1) = first_part + 2/T_eff * phi;
    SICs(m,1) = first_part + log(T_eff)/T_eff * phi;
    HQCs(m,1) = first_part + 2*log(log(T_eff))/T_eff * phi;
    
    
end

% Showing outputs 

Lag_Order = (1:4)';
table(AICs, SICs, HQCs, Lag_Order)

mi_AIC = find(AICs == min(AICs));
mi_SIC = find(SICs == min(SICs));
mi_HQC = find(HQCs == min(HQCs));

fprintf('When deciding based on the AIC, the best lag order is %d.\n',mi_AIC);
fprintf('When deciding based on the SIC, the best lag order is %d.\n',mi_SIC);
fprintf('When deciding based on the HQC, the best lag order is %d.\n',mi_HQC);





