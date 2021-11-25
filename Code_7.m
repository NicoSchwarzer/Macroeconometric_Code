%%%%%%%%%%%%%
%% Code  7 %%
%%%%%%%%%%%%%




%% 7.1 


opts = spreadsheetImportOptions("NumVariables", 3);

% Specify sheet and range
opts.Sheet = "USOil";
opts.DataRange = "A2:C163";

% Specify column names and types
opts.VariableNames = ["drpoil", "infl", "drgdp"];
opts.VariableTypes = ["double", "double", "double"];

% Import the data
dataS3 = readtable("C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data\data.xlsx", opts, "UseExcel", false);

% oli, inflation ,gdp in that order !!

data = table2array(dataS3);


nlag = 4;
opt.const = 1;
VAR = VARReducedForm(data ,nlag ,opt);

% Strcutural identification 

B0_inv = chol(VAR.SigmaOLS, 'lower');

opt.nlag = nlag;
opt.IRFcumsum=[1 1 1];
opt.varnames = {'Real price in Oil', 'GDP Deflator', 'Real GDP'};
opt.epsnames = {'Change in OilPrice', 'eps2', 'eps3'};
IRFpoint = IRFs(VAR.Acomp, B0_inv, opt);




