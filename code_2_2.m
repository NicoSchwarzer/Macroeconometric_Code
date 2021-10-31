%%%%%%%%%
%% 2.2 %%
%%%%%%%%%

%clearvars; clc; close all;


B = 5000; % different realizations
T = 10000; % length of series
c = 3;
phi = 0.8;
mu = c / (1-phi);
sig_eps = 0.5;
Y = ones(T,B);

% computing distributions
for b  = 1:B
    epsi = sig_eps * randn(T,1);
    for t = 2:T
        Y(t,b) = c + phi*Y(t-1,b) + epsi(t);
    end
end

muhat = mean(Y); % for all 5000
std_Y = sig_eps/(1-phi);

% standardization
ZT = sqrt(T).*(muhat-mu)./std_Y;
x = -5:0.1:5;

figure('name', 'CLT');
histogram(ZT, 'Normalization', 'pdf');
hold on;
plot(x, normpdf(x));
hold off;




