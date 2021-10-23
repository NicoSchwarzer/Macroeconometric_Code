%%%%%%%%%
%% 1.4 %%
%%%%%%%%%

clearvars; clc; close all;

cd 'C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data'



%% Norway GDP

opts = spreadsheetImportOptions("NumVariables", 2);

% Specify sheet and range
opts.Sheet = "FRED Graph";
opts.DataRange = "A12:B185";

% Specify column names and types
opts.VariableNames = ["CLVMNACSCAB1GQNO", "RealGrossDomesticProductForNorwayMillionsOfChained2010NationalC"];
opts.VariableTypes = ["datetime", "double"];

% Specify variable properties
opts = setvaropts(opts, "CLVMNACSCAB1GQNO", "InputFormat", "");

% Import the data
NorwayGDP = readtable("C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data\NorwayGDP.xls", opts, "UseExcel", false);

NorwayGDP_quartlery = groupsummary(NorwayGDP,"CLVMNACSCAB1GQNO","quarter","mean")

dates = table2array(NorwayGDP_quartlery(:,1));
gdp = table2array(NorwayGDP_quartlery(:,3));

gdp_log = log(gdp(2:end) ./ gdp(1:end-1) );



% plotting GDP Groth 
figure('name', 'GDP Growth');
plot(dates(1:end-1), gdp_log, "b", 'LineWidth',2.0, 'Linestyle', '-');
%legend('Log GDP Growth');
title('GDP growth (% - quarterly)');
xticks(dates(1:10:size(dates))); 
%[dates(1) dates(10) dates(20) dates(30) dates(40) dates(50) dates(60) dates(70) dates(80)]);
xtickangle(45);



%% Unempoyment rate 


opts = spreadsheetImportOptions("NumVariables", 2);

% Specify sheet and range
opts.Sheet = "FRED Graph";
opts.DataRange = "A12:B332";

% Specify column names and types
opts.VariableNames = ["LMUNRRTTNOM156N", "RegisteredUnemploymentRateForNorwayPercentMonthlyNotSeasonallyA"];
opts.VariableTypes = ["datetime", "double"];

% Specify variable properties
opts = setvaropts(opts, "LMUNRRTTNOM156N", "InputFormat", "");

% Import the data
NorwayUnemploymentRate = readtable("C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data\NorwayUnemploymentRate.xls", opts, "UseExcel", false);

dates = table2array(NorwayUnemploymentRate(:,1));
un_emp = table2array(NorwayUnemploymentRate(:,2));

figure('name', 'Unemployment rate');
plot(dates(1:end), un_emp, "b", 'LineWidth',2.0, 'Linestyle', '-');
%legend('Log GDP Growth');
title('Unemployment rate (monthly)');
xticks(dates(1:10:size(dates))); 
%[dates(1) dates(10) dates(20) dates(30) dates(40) dates(50) dates(60) dates(70) dates(80)]);
xtickangle(90);


%% interest rates

opts = spreadsheetImportOptions("NumVariables", 2);

% Specify sheet and range
opts.Sheet = "FRED Graph";
opts.DataRange = "A12:B523";

% Specify column names and types
opts.VariableNames = ["IR3TIB01NOM156N", "MonthOr90dayRatesAndYieldsInterbankRatesForNorwayPercentMonthly"];
opts.VariableTypes = ["datetime", "double"];

% Specify variable properties
opts = setvaropts(opts, "IR3TIB01NOM156N", "InputFormat", "");

% Import the data
NorwayInterestRate3m = readtable("C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data\NorwayInterestRate3m.xls", opts, "UseExcel", false);

% next importing %

opts = spreadsheetImportOptions("NumVariables", 2);

% Specify sheet and range
opts.Sheet = "FRED Graph";
opts.DataRange = "A12:B452";

% Specify column names and types
opts.VariableNames = ["IRLTLT01NOM156N", "LongTermGovernmentBondYields10yearMainIncludingBenchmarkForNorw"];
opts.VariableTypes = ["datetime", "double"];

% Specify variable properties
opts = setvaropts(opts, "IRLTLT01NOM156N", "InputFormat", "");

% Import the data
NorwayInterestRate10yrs = readtable("C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data\NorwayInterestRate10yrs.xls", opts, "UseExcel", false);

% plotting

aa = innerjoin(NorwayInterestRate3m,NorwayInterestRate10yrs,'LeftKeys',1,'RightKeys',1)

dates = table2array(aa(:,1));
a_10yrs = table2array(aa(:,2));
a_3m = table2array(aa(:,3));

figure('name', 'Interest rates');
plot(dates(1:end), a_3m, "b", 'LineWidth',2.0, 'Linestyle', '-');
hold on;
plot(dates(1:end), a_10yrs, "red", 'LineWidth',2.0, 'Linestyle', '-');
legend('Interbank rate (3-month)', 'Long-term Govt bond (10yrs)');
title('interest rates (monthly)');
xticks(dates(1:20:size(dates))); 
%[dates(1) dates(10) dates(20) dates(30) dates(40) dates(50) dates(60) dates(70) dates(80)]);
xtickangle(90);



%% Oslo Stock exchange 

opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["time", "OSEBXGR", "volume"];
opts.VariableTypes = ["datetime", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "time", "InputFormat", "yyyy-MM-dd HH:mm");

% Import the data
NorwayOSEBXGR = readtable("C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data\NorwayOSEBXGR.csv", opts);

aa = NorwayOSEBXGR(:,1:2)
%NorwayOSEBXGR_daily = groupsummary(aa, 'time',"daily","mean");

dates = table2array(aa(:,1));
ex = table2array(aa(:,2));

figure('name', 'Oslo Stock Exchange (index - daily)');
plot(dates, ex, "b", 'LineWidth',2.0, 'Linestyle', '-');
title('Oslo Stock Exchange (index - daily)');
xticks(dates(1:200:size(dates))); 
%[dates(1) dates(10) dates(20) dates(30) dates(40) dates(50) dates(60) dates(70) dates(80)]);
xtickangle(45);


%% Population 

opts = spreadsheetImportOptions("NumVariables", 2);

% Specify sheet and range
opts.Sheet = "FRED Graph";
opts.DataRange = "A12:B72";

% Specify column names and types
opts.VariableNames = ["POPTOTNOA647NWDB", "PopulationTotalForNorwayPersonsAnnualNotSeasonallyAdjusted"];
opts.VariableTypes = ["datetime", "double"];

% Specify variable properties
opts = setvaropts(opts, "POPTOTNOA647NWDB", "InputFormat", "");

% Import the data
NorwayPopulation = readtable("C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data\NorwayPopulation.xls", opts, "UseExcel", false);

dates = table2array(NorwayPopulation(:,1));
pop = table2array(NorwayPopulation(:,2))./1000000;

%POPTOTNOA647NWDB 
%PopulationTotalForNorwayPersonsAnnualNotSeasonallyAdjusted

figure('name', 'Population');
plot(dates, pop, "b", 'LineWidth',2.0, 'Linestyle', '-');
title('Population (millions - yearly)');
xticks(dates(1:10:size(dates))); 
%[dates(1) dates(10) dates(20) dates(30) dates(40) dates(50) dates(60) dates(70) dates(80)]);
%xtickangle(45);


%% Real house prices 

opts = spreadsheetImportOptions("NumVariables", 2);

% Specify sheet and range
opts.Sheet = "Composite house price indices";
opts.DataRange = "A15:B216";

% Specify column names and types
opts.VariableNames = ["Year", "TotalbreakAdjusted1997"];
opts.VariableTypes = ["double", "double"];

% Import the data
NorwayRealHousePricesS1 = readtable("C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data\NorwayRealHousePrices.xlsx", opts, "UseExcel", false);

dates = table2array(NorwayRealHousePricesS1(:,1));
prices = table2array(NorwayRealHousePricesS1(:,2))./1000;

figure('name', 'Real house prices');
plot(dates, prices, "b", 'LineWidth',2.0, 'Linestyle', '-');
title('Real house prices (in thousand, index - yearly)');
xticks(dates(1:50:size(dates))); 


