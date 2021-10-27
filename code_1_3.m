%%%%%%%%%
%% 1.3 %%
%%%%%%%%%


cd 'C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Ex\EX1'



%% 3.1 %%

% GDP, Unemplyoyment, groth rate, consumption, investment, oil prices,
% energy prices, credit, debt, interest rates, house prices, stock prices


%% 3.2 %%

% ECB: monetary ecnonomics, financial stability
% World Bank: global real economic indicators, development data
% Eurostat: EU Data Center (other stat offices)
% Datastream: blah
% FRED: really nice data source
% Labour offices: BAA, etc.
% Congressional budget Office for US fiscal data
% OurWorldinData (good place to start)
% DB Nomics: Aggregator of economic data sources




%% 3.4 %%
clearvars; clc; close all;

% reading in 
data_3_3 = readtable("NorwayGDP.xls");
disp(data_3_3);

data_3_3.Properties.VariableNames = {'Dats', 'Real GDP Norway - 2010  chained'};
gdp_raw =  table2array(data_3_3(:,2));
dates_raw =  table2array(data_3_3(:,1));


% GDP Growth 
ending = size(gdp_raw,1);
ending_2 = ending -1;

gdp_growth = ( gdp_raw(2:ending,1) - gdp_raw(1:ending_2,1) ) ./ gdp_raw(1:ending_2,1);
gdp_log = log(gdp_raw(2:end) ./ gdp_raw(1:end-1) );

% plotting GDP Groth 
figure('name', 'GDP Growth');
plot(dates_raw(1:end-1), gdp_log, "b", 'LineWidth',2.0, 'Linestyle', '--');
legend('Log GDP Growth');
title('Plot of GDP Growth');


% Histogram 
% two plots side by side 
figure('name','Histogram');
subplot(1,2,1); % last argument: in which plot to draw in!
histfit(gdp_log, 10, 'normal');
title('10 bins');

subplot(1,2,2);
subplot(1,2,1); % last argument: in which plot to draw in!
histfit(gdp_log, 30, 'normal');
title('30 bins');

sgtitle('big title'); % title for all plots!

% IMP: This is enough for exams!


%normplot
figure('name', 'qqplot');
normplot(gdp_log); %cheching if data caeme from normal dist

% boxplot
figure('name', 'boxxplot');
boxplot(gdp_log);

% mean etc.
gdp_mean = mean(gdp_log);
gdp_std = std(gdp_log);


%% Ex 5.  %%


% via if loop

select_sample = 0;

for i = 0:2
    
    if select_sample == 0
        sample_start = 1;
        sample_end = size(gdp_raw);
    elseif select_sample == 1
         sample_start = find(dates_raw == '01-Jan-1980'); 
         sample_end = find(dates_raw == '01-Oct-2012');
    else
        sample_start = find(dates_raw == '01-Jan-1980'); 
        sample_end = find(dates_raw == '01-Oct-2012');
    end

    gdp_log_1 = log(gdp_raw((sample_start+1):sample_end) ./ gdp_raw(sample_start:(sample_end-1)) );

    % plotting GDP Groth 
    figure('name', 'GDP Growth');
    plot(dates_raw(sample_start:(sample_end-1)), gdp_log_1, "b", 'LineWidth',2.0, 'Linestyle', '--');
    legend('Log GDP Growth');
    title('Plot of GDP Growth 1980-2012');

end

   



% homework: plot figures!
