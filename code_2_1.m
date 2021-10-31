%%%%%%%%%
%% 2.1 %%
%%%%%%%%%

clearvars; clc; close all;


%% 2.1.2

vec_all_draws = randn(10000,1);

means_init = 10:10000;
range_all = 1:10000;

%
for i = 1:10000
    sample = randsample(vec_all_draws,i);
    mean_ = mean(sample);
    means_init(i) = mean_;
end


% plotting 

figure('name', 'LLN');
plot(range_all, means_init, 'b');

%% 2.1.2 for an AR(1)

% simulating  AR(1)
rng(1);

y = ones(10000,1);
y(1) = 0;

eps = randn(10000,1);
phi = 0.9; % just randomly
 
for i = 2:length(eps)
    y(i) = phi * y(i-1) + eps(i);
end


for i = 1:10000
    sample = randsample(y,i);
    mean_ = mean(sample);
    means_init(i) = mean_;
end

figure('name', 'LLN for AR 1');
plot(range_all, means_init, 'b');
title('LLN for stationary AR(1)');
xlabel('Sample size');
ylabel('Mean of respective sample');







