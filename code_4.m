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

D = sym('d', [dim(1) dim(2)]);
E = sym('e', [dim(2) dim(3)]);
F = sym('f', [dim(3) dim(4)]);

DEF = D*E*F;
vec_DEF = DEF(:);

isequal(expand(vec_DEF), expand( kron(transpose(F),D)*E(:)))


%% 4 

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
data1 = readtable("C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Data\data.xlsx", opts, "UseExcel", false);

data1 = table2array(data1);

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



% calling the function % 

%cd 'C:\Users\Nico\Documents\Uni\3. Sem\QuantM\Ex'

VARReducedForm(data1,2,0.05)




