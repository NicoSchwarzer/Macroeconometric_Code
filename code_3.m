%% Code 3 Script %%

%% Code 3.1 Calling the function 

AR4data;

OLS_AR4 = ARpOLS(AR4data, 4,1,0.05)
OLS_AR4.tstat
%nice !

%% Code 3.2 Calling the function 

ARpML(AR4data, 4,1,0.05)


%function LogLikNorm

%% Code 3.3 Calling the function 

% importing data 

opts = delimitedTextImportOptions("NumVariables", 1);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = "laplace";
opts.VariableTypes = "double";

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
LaPlace = readtable("C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data\LaPlace.txt", opts);

LaPlace = table2array(LaPlace);


ARpML_Laplace(LaPlace, 4,1,0.05)


%% Code 3.4 

load('AR4.mat');

nlag_AIC = IC(AR4data, 1,8,'AIC');
nlag_SIC = IC(AR4data, 1,8,'SIC');
nlag_HQC = IC(AR4data, 1,8,'HQC');



%% Code 3.5 

% loading in data 

opts = spreadsheetImportOptions("NumVariables", 3);

% Specify sheet and range
opts.Sheet = "gnpdeflator";
opts.DataRange = "A1:C212";

% Specify column names and types
opts.VariableNames = ["VarName1", "VarName2", "VarName3"];
opts.VariableTypes = ["double", "double", "double"];

% Import the data
gnpdeflator = readtable("C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data\gnpdeflator.xlsx", opts, "UseExcel", false);

% creating inflation series

gdp = gnpdeflator.VarName3;
inflation_series = log( gdp(2:end)./gdp(1:(end-1)) );

% getting optimal lag with AIC 
nlag_AIC = IC(inflation_series, 1,8,'AIC'); % 5 :D 

% estimating results
h = 15;

results_AR1 = ARpOLS(inflation_series,1,1,0.05);
resids_AR1 = results_AR1.resid;

corr_AR1_res = ones(h,1);

for i = 1:h
    corr_AR1_res(i) = corr(resids_AR1(1:(end-i)), resids_AR1((i+1):end));
end

stat_AR_1 = size(resids_AR1, 1) * sum (corr_AR1_res'* corr_AR1_res);


% %
results_AR5 = ARpOLS(inflation_series,5,1,0.05);
resids_AR5 = results_AR5.resid;

corr_AR5_res = ones(h,1);

for i = 1:h
    corr_AR5_res(i) = corr(resids_AR5(1:(end-i)), resids_AR5((i+1):end));
end

stat_AR_5 = size(resids_AR5, 1) * sum (corr_AR5_res'* corr_AR5_res);


% crititcal vlaues for chi-sqaured distribution 

% for AR(1)
crit_val_chi2_AR1 = chi2inv(0.95, 10 - 1);
crit_val_chi2_AR1 > stat_AR_1

% residual autocrrelation present


% for AR(5)
crit_val_chi2_AR5 = crit_val_chi2_AR1;
crit_val_chi2_AR5 > stat_AR_5

% no residual autocrrelation present




%% Code 3.6


% empirical bootstrap 
res_bootstrap_empirical =  bootstrap_ci(100, 1000,1, 0.8, 1);
table([res_bootstrap_empirical.lower_boot; res_bootstrap_empirical.lower_asymp], [res_bootstrap_empirical.upper_boot; res_bootstrap_empirical.upper_asymp],'RowNames',{'Asymptotic' 'Bootstrap'}, 'VariableNames', {'Lower' 'Upper'})

% parametric bootstrap based on normal distribution of residuals 
bootstrap_para =  bootstrap_ci(100, 1000,1, 0.8, 2);
table([bootstrap_para.lower_boot; bootstrap_para.lower_asymp], [bootstrap_para.upper_boot; bootstrap_para.upper_asymp],'RowNames',{'Asymptotic' 'Bootstrap'}, 'VariableNames', {'Lower' 'Upper'})






















